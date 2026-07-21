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


## Progress Log

- 2026-07-20: Contract initialized

## Notes


