---
title: Grid sizing (ceiling divide)
source: "[[Cuda Dev]]"
aliases: [ceil-div, num_blocks, bounds check]
tags: [cuda, hpc, ripperdoc, level-1, launch-config]
level: 1
status: learning
arch: all
created: 2026-11-20
updated: 2026-11-20
related: ["[[occupancy]]", "[[roofline]]"]
sources: [CUDA C++ Programming Guide §Thread Hierarchy, PMPP ch. 2]
---

# Grid sizing (ceiling divide)

## Summary
You need enough blocks to cover all `n` elements, even when `n` isn't a multiple of the block size. Plain integer division rounds **down** and drops the tail, so you round **up** and then guard the extra threads inside the kernel.

> **Analogy:** 10 people, cars that seat 4. `10 / 4 = 2` cars leaves 2 people on the curb. You need 3 cars, and the last one has 2 empty seats. Those empty seats are the threads that must do nothing.

## Hardware view
```
n = 10, tpb = 4
elements:  0 1 2 3 | 4 5 6 7 | 8 9 . .
           block 0 | block 1 | block 2   ← threads 10, 11 have no element
```

## Key APIs / syntax
- `num_blocks = (n + tpb - 1) / tpb` : integer ceiling divide
- `idx = blockIdx.x * blockDim.x + threadIdx.x` : global thread index
- `if (idx < n)` : the guard for the empty seats

## Why the `- 1`
Adding `tpb - 1` pushes any remainder of 1 or more up to the next whole number. A remainder of 0 doesn't move.

| n | tpb | `(n + tpb) / tpb` | `(n + tpb - 1) / tpb` |
|---|---|---|---|
| 8 | 4 | 12/4 = **3** ✗ extra empty block | 11/4 = **2** ✓ |
| 10 | 4 | 14/4 = 3 ✓ | 13/4 = **3** ✓ |

Without the `-1`, an exact fit gets one useless extra block.

## Pitfalls
- `n / tpb` truncates and silently skips the tail (placement Q1: `width/16`).
- Forgetting the `idx < n` guard reads and writes out of bounds in the last block. `compute-sanitizer` catches it.
- `idx` as `int` overflows past about 2.1 × 10⁹ elements. Use `size_t` for huge inputs (01-saxpy review, minor).

## Check yourself
> [!question]- n = 1000, tpb = 256. How many blocks, and how many idle threads?
> (1000 + 255) / 256 = 1255 / 256 = **4** blocks = 1024 threads, so **24** idle threads (all in block 3).
