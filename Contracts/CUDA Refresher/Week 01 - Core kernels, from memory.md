---
title: Week 01 - Core kernels, from memory
source: "[[Contracts]]"
tags:
  - contract
created: 2026-07-20
status: on-contract
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