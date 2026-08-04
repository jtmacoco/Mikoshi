---
title: Week 2 — Concurrency & the patterns your projects already use
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-02
status: on-contract
client: personal
deadline:
stack: C
---

## Objective

| Day       | Task (≈30 min)                                                                                                                                                                                                                                                                                                                           |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | From memory: streams + `cudaMemcpyAsync`, overlapping a copy with a kernel launch.                                                                                                                                                                                                                                                       |
| Tue       | Re-read your **N-body sim** force-calculation kernel cold. Same exercise as Thursday last week — note what's fuzzy.                                                                                                                                                                                                                      |
| Wed       | Re-profile the N-body sim at a couple of particle counts (700 → 20k). Confirm scaling behavior still matches what you originally measured.                                                                                                                                                                                               |
| Thu       | **Mini-project, part 1:** power-iteration eigenvalue solver. Write a GEMV kernel (matrix-vector multiply), then the normalize step: dot product + norm via warp-shuffle reduction (`__shfl_down_sync`) — this is the warp-primitives review, just applied to something concrete instead of abstract.                                     |
| Fri       | **Mini-project, part 2:** wrap GEMV + normalize in a loop (repeated multiply-and-normalize converges to the dominant eigenvector/eigenvalue). Add a convergence check (stop when the eigenvalue estimate stops changing). Validate against NumPy's `eigh`/`eig` on a small test matrix.                                                  |
| Sat (lab) | Full Nsight Compute pass on your N-body force-calc kernel (occupancy, memory throughput, stall reasons — compute-bound vs memory-bound compared to your GPT-2 kernels), then a quick profile of Friday's power-iteration kernel too — small enough to be fast, but worth seeing whether the GEMV or the reduction dominates the runtime. |
| Sun       | Rest / catch-up.                                                                                                                                                                                                                                                                                                                         |


## Stack / Tools


## Progress Log

- 2026-08-02: Contract initialized

## Notes


## Links

