---
title: Coalescing
source: "[[Mikoshi/Netrunner/Cuda/Cuda|Cuda]]"
tags:
  - "#parallel"
  - cuda
  - memory
type: concept
created: 2026-07-07
---

## What is Coalescing

Memory coalescing is the GPUs ability to combine multiple memory accesses from threads in a warp into fewer, larger memory transactions, improving effective memory bandwidth. Refers to global memory not shared. It refers to how threads in a warp access **global memory**. 

## Core Idea

GPU global memory is accessed in chunks (32, 64, 128 bytes), not one byte/word at a time. When threads in a warp (32 threads that execute in lockstep) access memory, the hardware checks whether their addresses fall into the same chunks. If so, it services all 32 threads with one (or a few) memory transaction. If not it needs many separate transactions much slower

---

## Example / Usage

```c
// COALESCED: thread i accesses array[i]
__global__ void coalesced(float* array) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    array[idx] = idx * 2.0f;  // consecutive threads -> consecutive addresses
}

// UNCOALESCED: strided access
__global__ void strided(float* array, int stride) {
    int idx = (blockIdx.x * blockDim.x + threadIdx.x) * stride;
    array[idx] = idx * 2.0f;  // consecutive threads -> scattered addresses
}
```

In the coalesced example:

**Kernel 1 (coalesced):** Each thread's `idx` increases by exactly 1, and each element is 4 bytes, so consecutive threads land on addresses that are **only 4 bytes apart** — right next door to each other with **no gap**:

```
thread:   0    1    2    3    ...   31
idx:      0    1    2    3    ...   31
address:  0    4    8    12   ...   124
          |----|----|----|--- ... --|
          4B   4B   4B         (no gaps — back to back)
```

In the strided example:

**Kernel 2 (strided, stride=8):** Each thread's `idx` jumps by 8, so each thread's address jumps by `8 × 4 bytes = 32 bytes`. But each thread still only _touches_ 4 bytes at that address — so there's a **28-byte gap of untouched memory** between each thread's access:

```
thread:   0    1    2    3    ...
idx:      0    8    16   24   ...
address:  0    32   64   96   ...
          |4B|----28B gap----|4B|----28B gap----|4B|...
          (touched) (wasted)  (touched) (wasted)
```

---

## When to Use

Ask **Is this kernel memory bound**
- If `arithmetic intensity` (FLOPs per byte loaded) is low → coalescing is likely your biggest lever.
- If it's high → focus on occupancy, instruction-level parallelism, or reducing divergence instead; coalescing gains will be marginal.

- Moving a lot of data through global memory relative to compute done
- **Matrix/array operations** — transposes, strided slicing, column access of row-major data
- **Data structure design** — deciding AoS vs SoA before you write kernels touching particles/vertices/pixels
- **Reduction/scan kernels** — access pattern changes across iterations (e.g., halving stride each step)
- **Image/stencil operations** — accessing neighboring rows (row stride ≠ 1 element)
- **Sparse data / gather-scatter kernels** — indices computed at runtime, potentially random

---

## Watch Out For

- Be mindful of memory layouts





