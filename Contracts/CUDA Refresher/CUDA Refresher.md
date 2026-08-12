---
title: CUDA Refresher
source: "[[SYSTEM MANIFEST]]"
tags:
  - moc
  - "#on-contract"
created: 2026-07-20
---

## Overview

Review CUDA programming

## CUDA Refresher: 3-Week Schedule

**Why 3 weeks, not 16:** you already have real CUDA depth (GPT-2 inference engine with custom kernels + KV caching, N-body sim with CUDA/OpenMP). This isn't re-learning — it's shaking the rust off before jumping into `ggml-cuda`. Speed matters more than coverage here: if a day feels trivial, that's the signal it's working, not a reason to add more.

**Format:** ~30 min weekdays, Saturday lab 45–75 min. Same slip policy as your kernel plan — if both schedules slip the same week, protect the kernel one.

**Rule for this refresher specifically:** write every kernel from memory first, only look things up when you get stuck. The goal is reactivating recall, not re-reading tutorials.

---

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

---

### Week 2 — Concurrency & the patterns your projects already use

_(This week also includes a small standalone mini-project — a GEMV-based power-iteration eigenvalue solver — folded into Thursday/Friday. It's deliberately different in shape from your matmul-heavy GPT-2 and N-body work: memory-bound rather than compute-bound, iterative rather than single-pass, and it gives the warp-shuffle reduction review something concrete to attach to instead of staying abstract. Small enough to finish in the two sessions, and a nice standalone artifact if you ever want a third project on the resume that isn't "another matmul.")_

| Day       | Task (≈30 min)                                                                                                                                                                                                                                                                                                                           |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | From memory: streams + `cudaMemcpyAsync`, overlapping a copy with a kernel launch.                                                                                                                                                                                                                                                       |
| Tue       | Re-read your **N-body sim** force-calculation kernel cold. Same exercise as Thursday last week — note what's fuzzy.                                                                                                                                                                                                                      |
| Wed       | Re-profile the N-body sim at a couple of particle counts (700 → 20k). Confirm scaling behavior still matches what you originally measured.                                                                                                                                                                                               |
| Thu       | **Mini-project, part 1:** power-iteration eigenvalue solver. Write a GEMV kernel (matrix-vector multiply), then the normalize step: dot product + norm via warp-shuffle reduction (`__shfl_down_sync`) — this is the warp-primitives review, just applied to something concrete instead of abstract.                                     |
| Fri       | **Mini-project, part 2:** wrap GEMV + normalize in a loop (repeated multiply-and-normalize converges to the dominant eigenvector/eigenvalue). Add a convergence check (stop when the eigenvalue estimate stops changing). Validate against NumPy's `eigh`/`eig` on a small test matrix.                                                  |
| Sat (lab) | Full Nsight Compute pass on your N-body force-calc kernel (occupancy, memory throughput, stall reasons — compute-bound vs memory-bound compared to your GPT-2 kernels), then a quick profile of Friday's power-iteration kernel too — small enough to be fast, but worth seeing whether the GEMV or the reduction dominates the runtime. |
| Sun       | Rest / catch-up.                                                                                                                                                                                                                                                                                                                         |

**Reference if stuck:** _Professional CUDA C Programming_ (Cheng, Grossman, McKercher) — the streams/concurrency chapter and the profiling/performance-tuning chapter are the most practical treatment of exactly this week's material, more implementation-focused than PMPP.

---

### Week 3 — Into `ggml-cuda`

| Day       | Task (≈30 min)                                                                                                                                                                                                                    |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Clone `llama.cpp`, build it, confirm it runs a model locally.                                                                                                                                                                     |
| Tue       | Open `ggml-cuda`'s quantization kernels (`Q4_0`/`Q8_0` dequant). You'll recognize the shape from your own quantization-adjacent work if you did any — if not, this is genuinely new, take it slow.                                |
| Wed       | Open the attention/KV-cache-related CUDA code. This is the part that should feel most familiar given your GPT-2 engine — actively compare their approach to yours line by line.                                                   |
| Thu       | Browse open issues labeled performance / good-first-issue. Shortlist 2-3 that overlap with what you just read (quantization or KV-cache/attention).                                                                               |
| Fri       | Pick one. Read every file it touches end to end.                                                                                                                                                                                  |
| Sat (lab) | Comment on the issue: your understanding of the problem, your proposed approach, and — worth stating explicitly — that you've built a from-scratch inference engine with KV caching, so the maintainer knows you're not guessing. |
| Sun       | Rest. You're back up to speed and have a concrete next target — this hands off directly into the contribution plan from before.                                                                                                   |

**Reference if stuck:** _CUDA C++ Best Practices Guide_ (NVIDIA, free, [docs.nvidia.com](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/)) — a practical checklist-style doc, good for a fast sanity check on a kernel you're about to submit upstream, faster to scan than a book chapter when you're mid-PR.

---

## Book quick-reference (skim relevant sections only, don't read cover to cover)

- **Programming Massively Parallel Processors**, Hwu/Kirk/El Hajj, 4th ed. — Ch. 4–6 for the architecture/memory/performance-considerations core; later application chapters (reduction, convolution, parallel patterns) are useful as pattern lookups, not required reading given your background.
- **Professional CUDA C Programming**, Cheng/Grossman/McKercher — strongest on streams, concurrency, and profiling workflow; the more "implementation cookbook" counterpart to PMPP's more theoretical treatment.
- **The CUDA Handbook**, Nicholas Wilt — deeper on the driver-level/memory-subsystem internals; worth a look later given your parallel interest in the firmware/driver side, since it sits closer to that boundary than either book above. Not needed for this refresher.
- **CUDA C++ Programming Guide** (NVIDIA, free online) — the canonical reference for anything you need to look up precisely (exact semantics of an intrinsic, memory model guarantees) rather than read narratively.

## All Notes

```dataview
LIST
FROM "Mikoshi/Contracts/CUDA Refresher"
SORT file.name ASC
```


