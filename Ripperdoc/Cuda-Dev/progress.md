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
Level 1: Foundations. 01-saxpy passes review at 91.9% of peak BW; sweep done. Grid sizing now 3 (2026-11-24 quiz); error checking still 2, so one small Level 1 gig on error checking before Level 2 (transpose ladder).

## Weak spots
- Roofline / back-of-envelope: couldn't count bytes/FLOPs or compute AI and ideal time for SAXPY (Q4). Core interview skill.
- Memory coalescing: didn't spot `threadIdx.x` mapped to row (strided access) in a 2D kernel (Q1).
- When shared memory helps: suggested tiling for a no-reuse elementwise kernel; missed that the blur benefits (Q1 follow-up).
- Occupancy calculation: couldn't work out blocks/SM from regs, smem, threads (Q2).
- Error checking & async errors: 2026-11-24 quiz showed launch-vs-execution errors and locating them are unclear. Blocks leaving Level 1.

## Concept tracker
Rating: 1 = can't do it without help, 2 = shaky, 3 = OK with docs, 4 = solid, 5 = could teach it.

| Concept | Level | Rating | Last practiced | Last tested | Notes |
|---|---|---|---|---|---|
| Grid sizing (ceil-div) & bounds checks | 1 | 3 | 2026-11-20 | 2026-11-24 | Missed truncating grid (Q1) and OOB `in[i]` in last block (Q3). 01-saxpy: derived ceil-div after level-1 hint, wrote guard unprompted; fuzzy on *why* the -1. 2026-11-24 quiz: Q1 partial (right expr, no count, thought unguarded threads sit idle), Q3 correct (`<=` off-by-one, `n/256+1` extra block at n=1024) [[grid-sizing]] |
| Error checking (launch + sync) | 1 | 2 | – | 2026-11-24 | Didn't flag missing checks in Q1. 2026-11-24 quiz: Q2 partial (thought bad launch crashes; didn't know GetLastError vs sync), Q4 partial (knew memcpy wasn't the bug; couldn't name compute-sanitizer / sync-after-launch / CUDA_LAUNCH_BLOCKING to locate it) |
| Async launches & host-device sync | 1 | 2 | – | 2026-11-24 | Q4/Q5: said "threads not synced" for host-GPU wait; described `__syncthreads` (block) right but not `cudaDeviceSynchronize` (CPU waits for all prior GPU work); picked the right one for Q4 |
| 2D indexing (x → contiguous dim) | 2 | 1 | – | 2026-11-08 | Mapped row from threadIdx.x went unnoticed (Q1) |
| Memory coalescing | 2 | 1 | 2026-11-20 | 2026-11-08 | Q1. 01-saxpy: 1D idx coalesced correctly (trivial case, not yet 2D) |
| When shared memory helps (data reuse) | 2 | 1 | – | 2026-11-08 | Proposed smem for elementwise; missed blur (Q1 follow-up) |
| Warps / SIMT / divergence | 3 | 2 | – | 2026-11-08 | Warp definition right; didn't explain divergence (Q5) |
| Occupancy & its limiters | 3 | 2 | 2026-11-21 | 2026-11-08 | Couldn't compute (Q2). 01-saxpy sweep: knew 16-block cap limits tpb=32, but couldn't turn it into occupancy %; re-explained min-over-limits method (help level 2). 2026-11-21: computed tpb 64/256/1024 correctly unaided, incl. round-down for 1024 and seeing thread cap take over at 256 [[occupancy]] |
| Roofline / arithmetic intensity | 3 | 1 | 2026-11-20 | 2026-11-08 | Couldn't compute for SAXPY (Q4). 01-saxpy: got 12 B/elem right, slipped 10× on total (16.08 GB vs 1.61), needed "show me" for time = bytes / BW [[roofline]] |
| Little's law / latency hiding | 3 | 2 | 2026-11-21 | 2026-11-21 | Sweep: said warps needed "for computation" (partial); then named float4 as the ILP lever ✓ but called it "like quantization" ✗ [[littles-law]] |
| Vectorized loads (float4) vs quantization | 3 | 2 | 2026-11-21 | 2026-11-21 | Confused float4 (same bytes, wider loads) with quantization (fewer bytes) [[littles-law]] |
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
- [ ] 2026-11-08, placement Q1: missed `grid(width/16, ...)` truncation → use `(width + 15) / 16` plus in-kernel bounds check (1/2: correct in 2026-11-24 quiz Q3)
- [ ] 2026-11-08, placement Q2: couldn't compute occupancy → blocks/SM = min over threads, regs, smem(+1 KB reserved), block slots
- [ ] 2026-11-08, placement Q3: missed `__syncthreads()` between smem load and first tree step; missed OOB `in[i]` → pad with identity
- [ ] 2026-11-08, placement Q4: couldn't do roofline math → bytes/elem, FLOPs/elem, AI vs ridge (35 FLOP/B on 3060), time = bytes / BW
- [ ] 2026-11-20, 01-saxpy prediction: 12 B × 1.34e8 written as 16.08 GB (10× off) → 1.61 GB; sanity-check exponent (1e1 × 1e8 = 1e9 = GB)
- [ ] 2026-11-20, 01-saxpy prediction: didn't know ideal time formula → memory-bound: time = total bytes / peak BW (1.61e9 / 360e9 = 4.47 ms)
- [ ] 2026-11-21, 01-saxpy sweep: explained occupancy need as "threads to handle the computation" → for memory-bound kernels warps are needed to keep enough *loads in flight* to hide DRAM latency (Little's law: bytes in flight = BW × latency ≈ 180 KB on 3060, ~6.4 KB/SM)
- [ ] 2026-11-21, 01-saxpy follow-up: called float4 "like quantization" → float4 = same bytes in fewer, wider loads (more in flight); quantization = fewer bytes per value
- [ ] 2026-11-24, quiz Q1c: thought threads without an `i < n` guard sit idle → they run the body and read/write past the allocation (UB: often silent, can corrupt neighbours, sometimes illegal address)
- [ ] 2026-11-24, quiz Q2b: thought an invalid launch (2048 tpb) crashes → launch is rejected, kernel never runs, program continues and prints garbage silently
- [ ] 2026-11-24, quiz Q2c/Q4b: didn't know the two post-launch checks → `cudaGetLastError()` = launch/config errors (immediate); `cudaDeviceSynchronize()` = execution errors (async, e.g. illegal address)
- [ ] 2026-11-24, quiz Q4c: couldn't say how to find the real source of an error reported at `cudaMemcpy` → compute-sanitizer (line via -lineinfo), sync+check after each launch, `CUDA_LAUNCH_BLOCKING=1`; illegal access is sticky
- [ ] 2026-11-24, quiz Q4a/Q5: conflated thread sync with host-device sync → `__syncthreads` = threads of one block wait at a barrier; `cudaDeviceSynchronize` = CPU waits for all queued GPU work
- [ ] 2026-11-08, placement Q5: didn't explain warp divergence → different paths within a warp are serialized (masked lanes); cost ~ sum of both paths

## Quiz log
| Date | Topic | Score | Missed concepts |
|---|---|---|---|
| 2026-11-24 | Grid sizing + error checking (L1) | 1/5 (4 partial) | error checking (launch vs sync), locating async errors, unguarded-thread behavior, cudaDeviceSynchronize |
| 2026-11-08 | Placement (L1–L4) | 1/5 (2 partial, 3 wrong) | coalescing, smem reuse, grid sizing, occupancy, roofline, sync after load, divergence |

## Session log
<!-- The tutor adds an entry here at the end of each session. Newest first. -->
### 2026-11-24: quiz (grid sizing + error checking)
- Status: quiz done; session in progress
- Highest help level: n/a (quiz, no hints)
- Result: 1/5 correct, 4 partial. Grid sizing 2→3; error checking stays 2; new concept "async launches & host-device sync" at 2
- Got comfortable with: ceil-div expression and counts (follow-up n=1000/128 ✓), spotting `<=` off-by-one, 1024 tpb limit, compute-sanitizer as the OOB catcher
- Struggled with: what unguarded threads do; invalid launch fails silently (not a crash); GetLastError vs sync; locating an error reported at a later call
- Set up `Gigs/02-error-checking/` (not started; user will do it another session). Six planted-bug cases; user writes CUDA_CHECK in `check.cuh`, adds post-launch checks, locates bugs with memcheck/initcheck/CUDA_LAUNCH_BLOCKING, fixes. Tutor verified each bug behaves as intended (planted bugs are in `cases.cu`; read it before reviewing)
- Next: start `Gigs/02-error-checking/` (fill prediction table first). Pass + error checking ≥3 → Level 2 (matrix add, transpose ladder)
### 2026-11-21: Gigs/01-saxpy, block-size sweep
- Status: stretch 1 done; stretches 2–4 open
- Highest help level: 1 (occupancy rows done unaided after confirming 64)
- Performance: sweep by min time: 32 → 266 GB/s, 64–512 → 330–337 GB/s, 1024 → 326 GB/s. Medians noisy (display shares GPU)
- Got comfortable with: occupancy min-over-limits incl. round-down at 1024; predictions for 32 ("in between") and 1024 ("same") both right
- Struggled with: *why* memory-bound kernels need occupancy (said computation, not latency hiding / bytes in flight)
- Also: explained float4 (help level 2, demo kernel in scratchpad, not SAXPY); user hasn't used float4 before. Clarified float4 ≠ quantization
- Next session plan: (1) `/quiz` on grid sizing + error checking (both at 2; need ≥3 to leave Level 1). (2) Pass → new gig for Level 2 (matrix add, then transpose ladder). Still below 3 → small Level 1 variation gig targeting the weak one (e.g. error-checking/launch-failure gig). (3) float4 stretch is optional, user may do it anytime
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
