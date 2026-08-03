---
title: Week 01 - Core kernels, from memory
source: "[[Contracts]]"
tags:
  - contract
created: 2026-07-20
status: completed
client: personal
deadline:
stack:
---

## Objective

Review Core kernels, from memory

### Week 1 — Core kernels, from memory

| Day       | Task (≈30 min)                                                                                                                                                                                                 |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | From memory: vector add with proper `CUDA_CHECK` error handling, `cudaEvent` timing. Confirm your toolchain still works (driver, `nvcc`, GPU access) before anything else.                                     |
| Tue       | From memory: shared-memory tiled matmul. Don't check your old repo unless truly stuck — if you're stuck on the tile-loading/`__syncthreads()` pattern specifically, that's the one thing worth re-reading.     |
| Wed       | From memory: parallel reduction with sequential addressing, then the warp-shuffle version (`__shfl_down_sync`).                                                                                                |
| Thu       | Re-open your **GPT-2 engine repo**. Re-read your own KV-cache kernel cold, as if reviewing someone else's PR. Write down anything that takes you more than 10 seconds to understand — that's your actual rust. |
| Fri       | Re-run your GPT-2 engine's benchmark against PyTorch to confirm the 1.3x number still holds on current drivers/toolkit. Fix anything broken.                                                                   |
| Sat (lab) | Run `compute-sanitizer` and Nsight Compute against your GPT-2 engine's core kernels again. Re-familiarize with reading occupancy and stall-reason output — this is the part that decays fastest from disuse.   |
| Sun       | Rest / catch-up.                                                                                                                                                                                               |

**Reference if stuck:** _Programming Massively Parallel Processors_ (Hwu, Kirk, El Hajj, 4th ed.) — Ch. 4 (compute architecture & scheduling) and Ch. 5 (memory architecture & data locality) are the fastest way back into _why_ tiling and coalescing work, if the mechanics come back but the reasoning feels fuzzy.


# Progress Log

- 2026-07-20: Contract initialized

# Monday

## Notes


- `cudaMalloc` uses this `void **` cast because it needs to allocate memory on the GPU otherwise it would use the same value on the host.
- `cudaMallo` allocates blocks of memory it doesn't care about the type
- `CUDA_CHECK` do-while(0) trick: it's not really a loop. It's a hack so a multi-line macro acts like **one single statement**, so it doesn't break if you use it inside an `if` without curly braces.

## Solution

```c
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>
#define CUDA_CHECK(expr_to_check)                                              \
  do {                                                                         \
    cudaError_t result = expr_to_check;                                        \
    if (result != cudaSuccess) {                                               \
      fprintf(stderr, "CUDA Runtime Error: %s:%i:%d = %s\n", __FILE__,         \
              __LINE__, result, cudaGetErrorString(result));                   \
    }                                                                          \
  } while (0)
void __global__ vector_add(const int *v1, const int *v2, int *g_odata, int n) {
  int idx = (blockDim.x * blockIdx.x) + threadIdx.x;
  if (idx < n) {
    g_odata[idx] = v1[idx] + v2[idx];
  }
}

int main() {
  int v1[4] = {1, 2, 3, 4};
  int v2[4] = {5, 6, 7, 8};
  int result[4];
  size_t size = sizeof(int) * 4;
  int *g1;
  int *g2;
  int *g_odata;

  // malloc space on gpu
  // CUDA_CHECK(cudaMalloc((void **)&g1, (size_t)1024 * 1024 * 1024 * 1024)); //
  // 1 TB breaks
  CUDA_CHECK(cudaMalloc((void **)&g1, size));
  cudaMalloc((void **)&g2, size);
  cudaMalloc((void **)&g_odata, size);

  // copy values from cpu to gpu
  cudaMemcpy(g1, v1, size, cudaMemcpyHostToDevice);
  cudaMemcpy(g2, v2, size, cudaMemcpyHostToDevice);

  // init threads and blocks
  int threadsPerBlock = 256;
  int numBlocks = (4 + threadsPerBlock - 1) / threadsPerBlock;

  cudaEvent_t start;
  cudaEvent_t end;
  cudaStream_t stream;

  cudaStreamCreate(&stream);
  cudaEventCreate(&start);
  cudaEventCreate(&end);

  cudaEventRecord(start, stream);
  vector_add<<<numBlocks, threadsPerBlock>>>(g1, g2, g_odata, 4);

  CUDA_CHECK(cudaGetLastError()); // checks if the kernel launch is accepted
  CUDA_CHECK(cudaEventRecord(end, stream));

  CUDA_CHECK(cudaDeviceSynchronize());

  cudaEventSynchronize(end);
  float time_passed;
  cudaEventElapsedTime(&time_passed, start, end);
  printf("time elapsed: %f\n", time_passed);

  // copy the result from the gpu to the cpu
  cudaMemcpy(result, g_odata, size, cudaMemcpyDeviceToHost);

  // clean up memory
  cudaFree(g1);
  cudaFree(g2);
  cudaFree(g_odata);
  CUDA_CHECK(cudaFree(g1));
  CUDA_CHECK(cudaFree(g2));
  CUDA_CHECK(cudaFree(g_odata));
  CUDA_CHECK(cudaEventDestroy(start));
  CUDA_CHECK(cudaEventDestroy(end));
  CUDA_CHECK(cudaStreamDestroy(stream));

  for (size_t i = 0; i < 4; ++i) {
    printf("%d ", result[i]);
  }
  printf("\n");
  return 0;
}

```

# Tuesday

## Notes

### The problem

To compute one output element `C[i][j]`, you need the **entire** row `i` of `A` and the **entire** column `j` of `B`, and you multiply-accumulate across all `N` elements: `C[i][j] = sum over k of A[i][k] * B[k][j]`.

Global memory (where `A` and `B` live) is slow to access. Shared memory (the `__shared__` arrays) is fast, but tiny — you can't fit a whole row of a huge matrix in it if `N` is, say, 10,000.

### The analogy

Imagine you're a librarian answering the question "how many books do these two authors have in common?" by cross-referencing two giant catalogs — but you only have a small desk (shared memory) and the catalogs are in a warehouse across the building (global memory).

You can't carry the whole catalog to your desk. So instead:

1. Walk to the warehouse, grab **one folder's worth** of pages from each catalog (a "tile"), bring it back to your desk.
2. Cross-reference just those pages, add whatever matches to your running tally (`value`).
3. Go back to the warehouse, grab the **next** folder's worth of pages.
4. Repeat until you've gone through the entire catalog, folder by folder.

Each "trip to the warehouse and back" is one **phase**. You never hold more than one folder at a time (bounded by `TILE_WIDTH`), but by the time you've done all the phases, you've covered the whole catalog (`N` elements) and your running tally is the final, complete answer.

### Mapping back to the code

- One "folder" = one tile of size `TILE_WIDTH`
- `phase` = which folder trip you're currently on
- `sh_A` / `sh_B` = your desk (shared memory) — only big enough for one folder at a time
- The loop over `phase` = making enough trips to eventually cover all `N` columns/rows
- `value +=` inside the loop = updating your running tally after each folder, instead of needing the whole catalog on your desk simultaneously

So the _reason_ the loop exists: you have `N` elements to multiply-and-sum for each output value, but shared memory can only hold `TILE_WIDTH` of them at once. The loop is just "keep bringing in fresh tiles and accumulating until you've covered all of `N`." Bigger `N` → more phases needed; that's exactly what `numPhases = ceil(N / TILE_WIDTH)` computes — "how many folder-trips does it take to get through the whole catalog?"

And the reason you bother with this instead of just reading straight from global memory every time: **every thread in the block reuses the same tile**. All `TILE_WIDTH` threads on your desk read from the same folder before you fetch the next one — so you did one "expensive trip to the warehouse" and got to use those pages many times, instead of every single thread making its own separate trip for every single value it needs. That's the actual performance win of shared-memory tiling

### Issue with indexing 

- A good way to catch this kind of bug yourself next time: for every shared-memory load, ask two separate questions — _"which matrix am I reading from, and what are **its** dimensions?"_ (that determines the bounds check) and _"what row/col do I want, and does my index expression put them in the right order for row-major layout (`row * numCols + col`)?"_ (that determines the indexing). Mixing up `i`/`j` and mixing up which matrix's dimension bounds which index are exactly the two failure modes you've hit across these attempts.
### CUDA expects flat array for matrix
Right — but let's be precise about _why_, because there are two different things called "2D array" in C and they behave very differently with CUDA.

### Static 2D arrays (`float A[3][5]`) — these are secretly already flat


```c
float A[3][5] = { {1,2,3,4,5}, {6,7,8,9,10}, {1,1,1,1,1} };
```

This is stored in memory as one contiguous block of 15 floats, row-major — literally the same bytes as `float A_flat[15] = {1,2,3,4,5,6,7,8,9,10,1,1,1,1,1};`. So you actually _can_ pass this to `cudaMemcpy` directly:

```c
cudaMemcpy(d_A, A, 15 * sizeof(float), cudaMemcpyHostToDevice); // works fine
```

`A` decays to a pointer to its first element, and since the data is contiguous, this just works. The "2D-ness" is purely a compile-time indexing convenience (`A[i][j]` = syntactic sugar for `*(A + i*5 + j)`) — the underlying memory layout is identical to a flat 1D array. That's why I said you can index into it as `A[i][j]` on the host, but the kernel still treats it as `A[i*N + j]`.

### Dynamic "2D arrays" (`float **A`) — these are NOT contiguous, and this is where it breaks


```c
float **A = malloc(3 * sizeof(float*));
for (int i = 0; i < 3; i++)
    A[i] = malloc(5 * sizeof(float));
```

This is an array of pointers, each pointing to a _separately allocated_ block. There's no guarantee those 3 blocks are adjacent in memory — they usually aren't. This is what genuinely can't be handed to CUDA as-is:

- `cudaMemcpy` can't copy it in one call — the outer array holds _host_ pointers, which are meaningless on the device.
- Even if you tried to copy each row separately, the device would end up with an array of _host_ addresses, not usable device addresses. You'd need to `cudaMalloc` each row separately, copy each row, then build a device-side array of device pointers, and copy _that_ over too. It's a real mess, and it also kills your indexing math (`A[i*N+j]`) since you'd need `A[i][j]` via pointer chasing, which is slow on the GPU besides.

This is why the standard approach — and what your kernel already assumes — is: always flatten to a single 1D buffer, use manual row-major indexing (`A[row*N + col]`), and `cudaMalloc`/`cudaMemcpy` that one flat buffer. It's simpler, it's what static 2D arrays already secretly are, and it avoids the pointer-of-pointers mess entirely.

So to directly answer: for `cudaMemcpy` purposes, `float A[3][5]` is already flat and works as-is — no manual flattening needed, you can pass it straight to `cudaMemcpy`. It's only `float**` (true dynamic 2D) that's incompatible and needs real work to handle.

## Solution

>[!danger] Go back
> Check the grid and block calculation again as to why that size I forgot

```c
#include <cuda.h>
#include <stdio.h>

#define TILE_WIDTH 16

void __global__ matmul(float *A, float *B, float *C, int M, int N, int K) {
  int by = blockIdx.y;
  int bx = blockIdx.x;

  int ty = threadIdx.y;
  int tx = threadIdx.x;

  int i = blockDim.y * by + ty;
  int j = blockDim.x * bx + tx;

  __shared__ float sh_A[TILE_WIDTH][TILE_WIDTH];
  __shared__ float sh_B[TILE_WIDTH][TILE_WIDTH];

  float value = 0;
  int numPhases = (N + TILE_WIDTH - 1) / TILE_WIDTH;
  // i = rowindex
  // Tile Number * Tile Width + tx = Col Index
  for (int phase = 0; phase < numPhases; phase++) {
    int aCol = phase * TILE_WIDTH + tx;
    int bRow = phase * TILE_WIDTH + ty;

    sh_A[ty][tx] = (i < M && aCol < N) ? A[i * N + aCol] : 0.0f;
    sh_B[ty][tx] =
        (bRow < N && j < K) ? B[bRow * K + j] : 0.0f; // double check indexing
    __syncthreads();

    for (int k = 0; k < TILE_WIDTH; k++) {
      value += sh_A[ty][k] * sh_B[k][tx];
    }
    __syncthreads();
  }
  if (i < M && j < K) {
    C[i * K + j] = value;
  }
}
int main() {
  int M = 3, N = 5, K = 3;
  float A_flat[15] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 1, 1, 1, 1};

  float B_flat[15] = {1, 0, 0, 0, 1, 0, 0, 0, 1, 2, 2, 2, 1, 1, 1};
  float result[9];

  float *gA_flat;
  float *gB_flat;
  float *gC;

  size_t size = 15 * sizeof(float);
  size_t output_size = 9 * sizeof(float);
  cudaMalloc((void **)&gA_flat, size);
  cudaMalloc((void **)&gB_flat, size);
  cudaMalloc((void **)&gC, output_size);

  cudaMemcpy(gA_flat, A_flat, size, cudaMemcpyHostToDevice);
  cudaMemcpy(gB_flat, B_flat, size, cudaMemcpyHostToDevice);
  int threadsPerBlock = 256;

  dim3 block(TILE_WIDTH, TILE_WIDTH);
  dim3 grid((K + TILE_WIDTH - 1) / TILE_WIDTH,
            (M + TILE_WIDTH - 1) / TILE_WIDTH);

  matmul<<<grid, block>>>(gA_flat, gB_flat, gC, M, N, K);
  cudaMemcpy(result, gC, output_size, cudaMemcpyDeviceToHost);

  for (int i = 0; i < M; i++) {
    for (int j = 0; j < K; j++)
      printf("%.1f ", result[i * K + j]);
    printf("\n");
  }

  cudaFree(gA_flat);
  cudaFree(gB_flat);
  cudaFree(gC);

  return 0;
}
```

# Wednesday

## Solution

```c
#include <cuda.h>
#include <stdio.h>
__device__ float warpSum(float var) {
  unsigned mask = 0xffffffff;
  for (int diff = warpSize / 2; diff > 0; diff /= 2) {
    var += __shfl_down_sync(mask, var, diff);
  }
  return var;
}
__global__ void warpSumKernel(float *in, float *out) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  float val = in[tid];
  float sum = warpSum(val);
  if (threadIdx.x % warpSize == 0) {
    out[tid / warpSize] = sum;
  }
}

int main() {
  const int N = 256;
  const int threadsPerBlock = 256;
  const int numBlocks = (N + threadsPerBlock - 1) / threadsPerBlock;
  const int WARP_SIZE = 32;
  const int numWarps = (N + WARP_SIZE - 1) / WARP_SIZE;
  float h_in[N];
  for (int i = 0; i < N; i++)
    h_in[i] = 1.0f; // test data
  float *d_in, *d_out;
  cudaMalloc((void **)&d_in, N * sizeof(float));
  cudaMalloc((void **)&d_out, numWarps * sizeof(float));
  cudaMemcpy(d_in, h_in, sizeof(float) * N, cudaMemcpyHostToDevice);
  warpSumKernel<<<numBlocks, threadsPerBlock>>>(d_in, d_out);
  float h_out[8]; // numWarps for N=256, threadsPerBlock=256 → 8 warps
  cudaMemcpy(h_out, d_out, numWarps * sizeof(float), cudaMemcpyDeviceToHost);

  for (int i = 0; i < numWarps; i++)
    printf("warp %d sum: %f\n", i, h_out[i]);

  return 0;
}
```

### **The mask**:

`0xffffffff` is used to tell which threads are participating in the `__shfl_down_sync` since a warp consist of 32 threads. The mask in binary is just 32 ones s so `11111111111111111111111111111111` which means all 32 lanes in this warp are active and taking part.

### The reduction loop

- Think of the 32 threads in a warp sitting in a row, each holding one number. Goal: add them all together, ending with lane 0 holding the total.
- `__shfl_down_sync(mask, var, diff)` means: "grab the value called `var` from the thread `diff` lanes _ahead_ of me, and hand it to me directly through a register — no shared memory needed."
- Walk through it with `diff` starting at 16:

	- Lane 0 grabs lane 16's value, adds it to its own.
	- Lane 1 grabs lane 17's value, adds it to its own.
	- ...
	- Lane 15 grabs lane 31's value, adds it to its own.
	- Lanes 16–31 also do a shuffle (grabbing from lanes 32–47, which don't exist) but their results don't matter anymore — we only care about lanes 0–15 going forward.
- Now `diff` becomes 8 (next iter):
	- Lane 0 grabs lane 8 (which already holds lane8+lane24's sum), adds it in.
	- Lane 1 grabs lane 9, etc.
- It's like a knockout bracket: round 1 pairs up 32 into 16 sums, round 2 pairs those into 8, and so on — except instead of writing to shared memory and syncing between rounds, `__shfl_down_sync` passes values directly register-to-register, which is why this is faster than the shared-memory version once you're down to a single warp.

- **Why `threadIdx.x % warpSize == 0`**
- Only lane 0 of each warp ends up with the meaningful total (every other lane also has _a_ value after the loop, but it's just a partial sum, not the full warp sum). So only thread 0, 32, 64, ... within each block actually writes to `out`.

### Interesting note about branches

As a hex value that's whatever those specific bits happen to pack into — not a clean "half the warp" pattern like `0x0000ffff` unless the data genuinely worked out that way.

**The key point: you don't write this mask by hand.** You can't know at compile time which lanes will pass `val > 0` — it depends on the actual data at runtime. That's exactly what `__activemask()` is for:

```c
if (val > 0) { unsigned mask = __activemask(); // asks hardware: "who's actually here right now?" sum += __shfl_down_sync(mask, val, diff); }
```

`__activemask()` is called _after_ the divergent branch, from inside it — so it returns precisely the bitmask of lanes that took this path, whatever that turned out to be. You're not constructing the mask from logic about the condition; you're asking the hardware to report which lanes are currently standing in the room with you.

So to directly answer "would you split it 16/16" — no, there's no deliberate splitting at all. The mask is a _report_ of an outcome (how many lanes happened to satisfy the branch), not a _plan_ you design (like "let's put half in each group").