---
title: Shared Memory
source: "[[Mikoshi/Netrunner/Cuda/Cuda|Cuda]]"
tags:
  - cuda
  - memory
type: concept
created: 2026-07-07
---

## What is Shared Memory

Shared memory is an on chip low latency memory pool that's allocated per block and **visible to every thread in that block**, but invisible to threads in other blocks. Think of it as a small, fast, programmer managed scratchpad (phsyically lives on the same SRAM as the L1 Cache)

---

## Example / Usage

```c
__global__ void kernel(float *data) {
    __shared__ float tile[256]; // one copy per block
    int tid = threadIdx.x;
    tile[tid] = data[blockIdx.x * 256 + tid];
    __syncthreads(); // wait for all threads in block to finish writing
    // now safely read tile[...] cooperatively
}
```




