---
title: Cuda Dev Progress
source: "[[Cuda Dev]]"
tags: [ripperdoc, jacked-in]
created: 2026-10-25
---

# Progress

## About me
<!-- Fill this in once, or leave it blank and the tutor will ask on the first session. -->
- C/C++ experience: comfortable overall; weak on templates. Has written Makefiles but adapts old ones rather than writing from scratch.
- GPU / parallel programming experience: prior projects in CUDA (most), OpenMP, MPI; simple GLSL shaders.
- Goals: job optimizing ML models with CUDA (NVIDIA ideal; AMD or other chip/ML-perf companies too). Emphasize ML kernels, profiling, interview-style reasoning.
- Session style: ~1 hour, may stop early. Tutor should keep progress.md current at natural stopping points (after each step/quiz), so an abrupt stop loses nothing.

## Environment
<!-- The tutor fills this in on the first session. -->
- GPU(s): 1× NVIDIA GeForce RTX 3060 (GA106, Ampere), 12 GB GDDR6, 28 SMs, 3584 FP32 lanes
- Compute capability: sm_86
- CUDA toolkit / driver: CUDA 13.4 (nvcc V13.4.92), driver 615.71.09, host g++ 16.2.1
- Peak memory bandwidth: spec 360 GB/s (192-bit × 15 Gbps), measured ___ GB/s (to be measured in Level 3 copy-kernel exercise)
- Peak throughput (spec, computed at 1777 MHz boost): FP32 12.7 TFLOP/s; FP16 tensor ~51 TFLOP/s dense (FP16 accum), ~25 TFLOP/s (FP32 accum, GeForce half rate). Max SM clock reported 2130 MHz, so real clocks may run higher than boost spec.
- Interconnect: PCIe 4.0 x16 (~32 GB/s theoretical per direction), single GPU, no NVLink
- Tools: compute-sanitizer [x] ncu [x] nsys [x] cuda-gdb [x] MPI [x] (mpirun) Slurm [ ]
- Where I run: local Arch Linux desktop (Hyprland); GPU also drives the display, so desktop apps (Firefox, etc.) share it. Close heavy GPU apps before benchmarking.

## Current level
Level 1: Foundations. 01-saxpy core passes review at 91.9% of peak BW (2026-11-20); block-size sweep in progress. Placement check (2026-11-08) showed gaps in the performance model: coalescing, occupancy, roofline math, and when shared memory helps. Plan: fast pass through Level 1 (SAXPY with roofline target), then Level 2 (transpose ladder), then Level 3. Move quickly where things click.

## Weak spots
- Roofline / back-of-envelope: couldn't count bytes/FLOPs or compute AI and ideal time for SAXPY (Q4). Core interview skill.
- Memory coalescing: didn't spot `threadIdx.x` mapped to row (strided access) in a 2D kernel (Q1).
- When shared memory helps: suggested tiling for a no-reuse elementwise kernel; missed that the blur benefits (Q1 follow-up).
- Occupancy calculation: couldn't work out blocks/SM from regs, smem, threads (Q2).
- Grid sizing and bounds checks: missed truncating `width/16` grid (Q1) and `in[i]` out of bounds (Q3).

## Concept tracker
Rating: 1 = can't do it without help, 2 = shaky, 3 = OK with docs, 4 = solid, 5 = could teach it.

| Concept | Level | Rating | Last practiced | Last tested | Notes |
|---|---|---|---|---|---|
| Grid sizing (ceil-div) & bounds checks | 1 | 2 | 2026-11-20 | 2026-11-08 | Missed truncating grid (Q1) and OOB `in[i]` in last block (Q3). 01-saxpy: derived ceil-div after level-1 hint, wrote guard unprompted; fuzzy on *why* the -1 [[grid-sizing]] |
| Error checking (launch + sync) | 1 | 2 | – | 2026-11-08 | Didn't flag missing checks in Q1 |
| 2D indexing (x → contiguous dim) | 2 | 1 | – | 2026-11-08 | Mapped row from threadIdx.x went unnoticed (Q1) |
| Memory coalescing | 2 | 1 | 2026-11-20 | 2026-11-08 | Q1. 01-saxpy: 1D idx coalesced correctly (trivial case, not yet 2D) |
| When shared memory helps (data reuse) | 2 | 1 | – | 2026-11-08 | Proposed smem for elementwise; missed blur (Q1 follow-up) |
| Warps / SIMT / divergence | 3 | 2 | – | 2026-11-08 | Warp definition right; didn't explain divergence (Q5) |
| Occupancy & its limiters | 3 | 1 | 2026-11-20 | 2026-11-08 | Couldn't compute (Q2). 01-saxpy sweep: knew 16-block cap limits tpb=32, but couldn't turn it into occupancy %; re-explained min-over-limits method (help level 2) [[occupancy]] |
| Roofline / arithmetic intensity | 3 | 1 | 2026-11-20 | 2026-11-08 | Couldn't compute for SAXPY (Q4). 01-saxpy: got 12 B/elem right, slipped 10× on total (16.08 GB vs 1.61), needed "show me" for time = bytes / BW [[roofline]] |
| __syncthreads placement | 4 | 2 | – | 2026-11-08 | Spotted sync-in-branch; missed sync after smem load (Q3) |

## Performance records
Best result per kernel. % of peak is against the bound named in the exercise README.

| Kernel | Exercise | Best time | Throughput | % of peak | vs library | Date |
|---|---|---|---|---|---|---|
| SAXPY (naive, 256 tpb) | 01-saxpy | 4.868 ms | 330.9 GB/s | 91.9% BW | – | 2026-11-20 |

## Mistakes to revisit
Specific mistakes and misconceptions. Mark `[x]` when resolved (two correct quiz answers).
- [ ] 2026-11-08, placement Q1: thought shared memory speeds up any kernel → it only helps when global data is reused (blur, transpose, GEMM), not elementwise ops
- [ ] 2026-11-08, placement Q1: didn't notice `row = ...threadIdx.x` in row-major 2D kernel → threadIdx.x must index the contiguous (column) dimension for coalescing
- [ ] 2026-11-08, placement Q1: missed `grid(width/16, ...)` truncation → use `(width + 15) / 16` plus in-kernel bounds check
- [ ] 2026-11-08, placement Q2: couldn't compute occupancy → blocks/SM = min over threads, regs, smem(+1 KB reserved), block slots
- [ ] 2026-11-08, placement Q3: missed `__syncthreads()` between smem load and first tree step; missed OOB `in[i]` → pad with identity
- [ ] 2026-11-08, placement Q4: couldn't do roofline math → bytes/elem, FLOPs/elem, AI vs ridge (35 FLOP/B on 3060), time = bytes / BW
- [ ] 2026-11-20, 01-saxpy prediction: 12 B × 1.34e8 written as 16.08 GB (10× off) → 1.61 GB; sanity-check exponent (1e1 × 1e8 = 1e9 = GB)
- [ ] 2026-11-20, 01-saxpy prediction: didn't know ideal time formula → memory-bound: time = total bytes / peak BW (1.61e9 / 360e9 = 4.47 ms)
- [ ] 2026-11-08, placement Q5: didn't explain warp divergence → different paths within a warp are serialized (masked lanes); cost ~ sum of both paths

## Quiz log
| Date | Topic | Score | Missed concepts |
|---|---|---|---|
| 2026-11-08 | Placement (L1–L4) | 1/5 (2 partial, 3 wrong) | coalescing, smem reuse, grid sizing, occupancy, roofline, sync after load, divergence |

## Session log
<!-- The tutor adds an entry here at the end of each session. Newest first. -->
### 2026-11-20: Gigs/01-saxpy (in progress)
- Status: core done, passes review (0 critical/major); stretch goals open
- Highest help level: 5 ("show me") for roofline ideal-time calc; level 1 for ceil-div
- Performance: 4.868 ms, 330.9 GB/s (91.9%) vs target ≥306 GB/s ✓
- Got comfortable with: memory-bound call; 12 B/elem; global index + bounds guard written unprompted; ceil-div after one hint
- Struggled with: power-of-ten slip on total bytes; ideal time formula; "% of peak" row filled with total bytes (1.61 GB)
- Review findings: critical 0, major 0, minor 1 (int index overflows past 2³¹ elements), style 1 (stale TODO comments)
- Notes written: [[grid-sizing]], [[roofline]], [[occupancy]]
- Next: **resume mid-sweep.** User predicted tpb=32 is slower (16-block cap) ✓. Worked tpb=32 → 33% occupancy for them; user still owes occupancy for tpb=64, 256, 1024 (1024: only 1 block fits) + prediction of whether ⅓ occupancy → ⅓ bandwidth. Then run the sweep, fill README results table, then Level 2 transpose
### 2026-11-08: setup + placement check (Gigs/01-saxpy assigned)
- Status: done (session); `Gigs/01-saxpy` not started
- Did: environment check recorded; About me filled; 5-question placement quiz (1/5) → placed at Level 1; created `Gigs/01-saxpy/`; exercises now live in `Gigs/` (CLAUDE.md updated)
- Highest help level: n/a (quiz; full worked answers given for Q2 occupancy and Q4 roofline after "I don't know")
- Performance: –
- Got comfortable with: warp = 32 threads executing together; sync inside divergent branch is a bug
- Struggled with: roofline math, occupancy calc, coalescing in 2D, when smem helps (see Mistakes)
- Review findings: –
- Next: start next session by offering a quick quiz on roofline + coalescing (just explained) or going straight into the exercise. **`Gigs/01-saxpy/` is set up but not started** (harness verified: builds, stub fails with "invalid argument" at the cudaGetLastError() check). Next session: user fills the README prediction table, writes kernel + launch config, then `make run`/`make check`/`make profile`. Target ≥306 GB/s (85% of 360). After that: Level 2 transpose ladder.
