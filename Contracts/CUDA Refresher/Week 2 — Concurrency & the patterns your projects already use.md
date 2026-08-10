---
title: Week 2 — Concurrency & the patterns your projects already use
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-02
status: on-contract
client: personal
deadline:
stack: cuda
---

## Objective

| Day       | Task (≈30 min)                                                                                                                                                                                                                                                                                                                           |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | From memory: streams + `cudaMemcpyAsync`, overlapping a copy with a kernel launch.                                                                                                                                                                                                                                                       |
| Tue       | Re-read your **N-body sim** force-calculation kernel cold. Same exercise as Thursday last week — note what's fuzzy.                                                                                                                                                                                                                      |
| Wed       | Re-profile the N-body sim at a couple of particle counts (700 → 20k). Confirm scaling behavior still matches what you originally measured.                                                                                                                                                                                               |
| Thu       | **Mini-project, part 1:** power-iteration eigenvalue solver. Write a GEMV kernel (matrix-vector multiply), then the normalize step: dot product + norm via warp-shuffle reduction (`__shfl_down_sync`) — this is the warp-primitives review, just applied to something concrete instead of abstract.                                     |
| Fri       | **Mini-project, part 2:** wrap GEMV + normalize in a loop (repeated multiply-and-normalize converges to the dominant eigenvector/eigenvalue). Add a convergence check (stop when the eigenvalue estimate stops changing). Validate against NumPy's `eigh`/`eig` on a small test matrix.]()                                               |
| Sat (lab) | Full Nsight Compute pass on your N-body force-calc kernel (occupancy, memory throughput, stall reasons — compute-bound vs memory-bound compared to your GPT-2 kernels), then a quick profile of Friday's power-iteration kernel too — small enough to be fast, but worth seeing whether the GEMV or the reduction dominates the runtime. |
| Sun       | Rest / catch-up.                                                                                                                                                                                                                                                                                                                         |


## Progress Log

- 2026-08-02: Contract initialized

# Monday

## Notes

- Each `d_x[i]`/`d_y[i]` pair holds one chunk's worth of device memory, and each stream is its own independent queue of operations. Because the copy and kernel launch calls are asynchronous, the CPU issues all the work for chunk 0, then immediately moves on to issue chunk 1's work, etc., without waiting for chunk 0 to actually finish. The _GPU_ then runs these queues concurrently where possible — e.g., chunk 1's H2D copy can happen on a copy engine while chunk 0's kernel is still running on the compute cores. That's the overlap.

it comes down to the fact that `h_x` and `h_y` are **one single big array holding all the data**, while `d_x[i]`/`d_y[i]` are **separate small arrays, one per chunk**.

Think about what's physically in memory:

```
h_x:  [ chunk0 data | chunk1 data | chunk2 data | ... | chunk7 data ]
       index 0                                          index N-1
```

It's one contiguous block of `N` floats. Chunk 0's data lives at indices `0` to `chunkSize-1`. Chunk 1's data lives at indices `chunkSize` to `2*chunkSize-1`. And so on. There's no separate variable for "chunk 1's host data" — it's just a _slice_ of `h_x`, identified by a starting position.

So when you compute:

```cpp
int offset = i * chunkSize;
```

for `i = 0`, offset is `0` → points at the start of `h_x`.  
for `i = 1`, offset is `chunkSize` → points at where chunk 1's data begins.  
for `i = 2`, offset is `2*chunkSize` → where chunk 2 begins.

And `h_x + offset` is just pointer arithmetic — it gives you the address of the _first element of chunk i_ within that one big array. Without the offset, every single chunk would copy from `h_x + 0`, i.e., you'd copy chunk 0's data eight times and never touch chunks 1 through 7.

**Now contrast with `d_x[i]`:** this is a completely separate `cudaMalloc`'d buffer, sized to hold exactly `chunkSize` floats — nothing more, nothing less. It's not a slice of some bigger device array; it's its own standalone allocation. So chunk `i`'s data starts at position 0 _within that buffer_, always. No offset needed, because there's nothing else sharing that memory.

The visual:

```c
h_x (one array, N elements):
[ chunk0 | chunk1 | chunk2 | ... ]
  ^offset=0  ^offset=chunkSize  ^offset=2*chunkSize

d_x[0] (its own array, chunkSize elements):  [ chunk0 data ]
d_x[1] (its own array, chunkSize elements):  [ chunk1 data ]
d_x[2] (its own array, chunkSize elements):  [ chunk2 data ]
```

So the offset exists purely to answer "where in the big array does this chunk's data live?" — and that question only applies to `h_x`/`h_y`, since `d_x[i]`/`d_y[i]` don't share space with anything else.

- so at index 0 this line `cudaMemcpyAsync(d_x[i], h_x + offset, chunkSize * sizeof(float), cudaMemcpyHostToDevice, streams[i]);` is saying from 0 to chunkSize so say 0-7 since chunkSize is 8 right

- **`numChunks`** = how many pieces you're splitting the work into = how many streams, how many `d_x[i]`/`d_y[i]` buffer pairs, how many loop iterations. It's the _count_ of chunks.
- **`chunkSize`** = how many elements live _inside_ each chunk = `N / numChunks`. It's the _size_ of each chunk.

So with `N = 67,108,864` and `numChunks = 8`, `chunkSize = 8,388,608` — you get 8 buffers in `d_x`/`d_y`, 8 streams, 8 loop iterations, and each iteration's kernel launch covers 8,388,608 elements (spread across ~32,768 blocks).

Quick mapping so it's fully pinned down:

|Variable|Meaning|Value here|
|---|---|---|
|`N`|total elements across everything|67,108,864|
|`numChunks`|number of pieces / streams / loop iterations|8|
|`chunkSize`|elements per piece|8,388,608|
|`d_x[i]`, `d_y[i]`|device buffer for chunk `i`, sized `chunkSize`|8 pairs total|
|`streams[i]`|stream that chunk `i`'s work runs on|8 streams total|
|`offset = i * chunkSize`|where chunk `i` starts inside the big `h_x`/`h_y` arrays|varies per `i`|

And the invariant that ties it together: `numChunks * chunkSize == N` (as long as `N` divides evenly by `numChunks` — worth a comment or `static_assert`/runtime check in real code, since integer division silently truncates if it doesn't divide evenly, and you'd quietly lose the last few elements).

>[!important] Important
>Streams don't hold data they only hold a **queue of operations** (copy, kernel launch, copy, etc.) that execute in order within that stream

## Solution
```c
#include <cuda.h>
#include <random>
__global__ void compute_kernel(float *x, float *y, int n) {
  int idx = blockDim.x * blockIdx.x + threadIdx.x;
  if (idx < n) {
    y[idx] = sqrtf(x[idx]) * sinf(x[idx]) + cosf(x[idx]);
  }
}
int main() {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<int> distrib(1, 100);

  const int N = 1 << 26;
  const int numChunks = 8;
  const int chunkSize = N / numChunks;

  float *h_x;
  float *h_y;
  cudaMallocHost((void **)&h_x, N * sizeof(float)); // pinned, page-locked
  cudaMallocHost((void **)&h_y, N * sizeof(float)); // pinned, page-locked
  for (int i = 0; i < N; i++) {
    h_x[i] = distrib(gen);
  }

  // create device arrays with size of chunks
  float *d_x[numChunks];
  float *d_y[numChunks];

  cudaStream_t streams[numChunks];

  for (int i = 0; i < numChunks; i++) {
    cudaMalloc((void **)&d_x[i], chunkSize * sizeof(float));
    cudaMalloc((void **)&d_y[i], chunkSize * sizeof(float));
    cudaStreamCreate(&streams[i]);
  }
  int threadsPerBlock = 256;
  int blocksPerGrid = (chunkSize + threadsPerBlock - 1) / threadsPerBlock;
  for (int i = 0; i < numChunks; i++) {
    int offset = i * chunkSize;

    cudaMemcpyAsync(d_x[i], h_x + offset, chunkSize * sizeof(float),
                    cudaMemcpyHostToDevice, streams[i]);
    compute_kernel<<<blocksPerGrid, threadsPerBlock>>>(d_x[i], d_y[i],
                                                       chunkSize);
    cudaMemcpyAsync(h_y + offset, d_y[i], chunkSize * sizeof(float),
                    cudaMemcpyDeviceToHost, streams[i]);
  }
  cudaDeviceSynchronize();
  // delete everything
  for (int i = 0; i < numChunks; i++) {
    cudaFree(d_x[i]);
    cudaFree(d_y[i]);
    cudaStreamDestroy(streams[i]);
  }
  cudaFreeHost(h_x);
  cudaFreeHost(h_y);

  return 0;
}
```

# Friday

why `block_reduce_sum` rather than `warpReduceSum`
- t becomes necessary the moment `blockDim.x > 32`. Say you launch `<<<1, 128>>>` — 4 warps:

```c
warp 0 (threads 0-31):   warpReduceSum -> lane 0 has warp 0's total
warp 1 (threads 32-63):  warpReduceSum -> thread 32 has warp 1's total
warp 2 (threads 64-95):  warpReduceSum -> thread 64 has warp 2's total
warp 3 (threads 96-127): warpReduceSum -> thread 96 has warp 3's total
```

Four separate totals, in four separate warps. `__shfl_down_sync` **cannot** combine them — the instruction is scoped to a warp by hardware, it physically cannot read a register in another warp. So if you called only `warpReduceSum` and then did `if (tid == 0) norm = sqrtf(local)`, thread 0 would take the square root of _warp 0's partial only_ — say the sum of the first quarter of the vector — and you'd normalize by a wrong, too-small norm. Silently wrong output, no crash.

`block_reduce_sum` fixes exactly this by adding the cross-warp hop:


```c
__device__ float block_reduce_sum(float val) {
    __shared__ float warp_sums[32];
    int lane = threadIdx.x % 32;
    int warp_id = threadIdx.x / 32;

    val = warp_reduce_sum(val);              // stage 1: within each warp
    if (lane == 0) warp_sums[warp_id] = val; // each warp posts its total
    __syncthreads();                          // now all warps' totals visible

    int num_warps = (blockDim.x + 31) / 32;
    val = (threadIdx.x < num_warps) ? warp_sums[lane] : 0.0f;
    if (warp_id == 0) val = warp_reduce_sum(val);  // stage 2: warp 0 combines
    return val;   // valid in thread 0 only
}
```

Shared memory is the _only_ channel warps have to communicate, so the pattern is forced: shuffle inside warps (fast, no sync), shared memory between warps (the sync point), shuffle once more to finish.

- So the sequence is:

1. Each thread computes its own partial → private registers, scattered
2. `warpReduceSum` funnels them → thread 0 has the total
3. `sqrtf` → thread 0 has the norm
4. **But phase 2 needs every thread to divide its slice by that norm** → shared memory + `__syncthreads()` to get it out to everyone
5. Each thread divides its own elements