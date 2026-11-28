---
title: Occupancy
source: "[[Cuda Dev Notes]]"
aliases: [blocks per SM, resident warps, occupancy limiters]
tags: [cuda, hpc, ripperdoc, level-3, architecture]
level: 3
status: learning
arch: all (limits below are sm_86)
created: 2026-11-20
updated: 2026-11-21
related: ["[[grid-sizing]]", "[[roofline]]", "[[littles-law]]"]
sources: [CUDA C++ Programming Guide §Compute Capabilities (table), Best Practices Guide §Occupancy, CUDA Occupancy Calculator]
---

# Occupancy

## Summary
Occupancy is how many threads are resident on an SM, compared with the most it can hold. More resident warps give the SM more work to switch to while others wait on memory, which hides latency. Several resources limit it, and **the tightest one wins**.

> **Analogy:** a parking garage with **16 spaces** (block slots) and room for **1536 people** (threads). If each car holds only 32 people, the 16 spaces fill with just 512 people inside, and the garage is a third full even though no spaces are left.

## Hardware view: RTX 3060 limits (sm_86, per SM)
| Resource | Limit |
|---|---|
| Block slots | 16 |
| Threads | 1536 (48 warps) |
| Registers | 65,536 |
| Shared memory | up to 100 KB (+1 KB reserved per block) |

## How to compute it
```
blocks/SM = min( 16,
                 1536 / tpb,
                 65536 / (regs_per_thread × tpb),
                 smem_per_SM / (smem_per_block + 1 KB) )   ← round each DOWN

occupancy = blocks/SM × tpb / 1536
```
Get regs/thread from `make ptxas` (or `-Xptxas -v`), and smem from your kernel.

**Worked, SAXPY with tpb = 32** (10 regs, 0 smem, so only the first two limits matter):
```
min(16, 1536/32 = 48) = 16 blocks → 16 × 32 = 512 threads → 512/1536 = 33%
```

## In the profiler
`ncu` **Occupancy** section: *Theoretical* vs *Achieved* occupancy, plus "Block Limit Registers / Shared Mem / Warps / SM" to show which limit won.

## Pitfalls
- Higher occupancy isn't always faster. You only need *enough* warps to hide latency, and register-heavy kernels (GEMM) often run best at low occupancy.
- For memory-bound kernels, warps aren't there for math. They keep enough **loads in flight** to hide DRAM latency ([[littles-law]]): bytes in flight = BW × latency (≈ 6.4 KB/SM on the 3060). 01-saxpy: tpb 32 (16 warps) lost about 20%, and 64+ leveled off.
- Forgetting to round down. A block can't be partly resident.
- Limits differ by architecture (e.g. sm_80 has 2048 threads/SM and 32 block slots), so check the table for your GPU.

## Check yourself
> [!question]- tpb = 128, 40 regs/thread, 0 smem. Blocks/SM, occupancy, and the limiter?
> Slots 16; threads 1536/128 = 12; regs 65536/(40×128) = 12.8 → 12. min = **12** blocks → 1536 threads = **100%**. Threads and registers tie.

## 01-saxpy sweep (2026-11-21, min times)
| tpb | blocks/SM | occupancy | limiter | GB/s |
|---|---|---|---|---|
| 32 | 16 | 33% | block slots | 266 |
| 64 | 16 | 67% | block slots | 334 |
| 256 | 6 | 100% | threads | 336 |
| 1024 | 1 | 67% | threads (1.5 → 1) | 326 |

Past about 67%, extra occupancy didn't help: enough loads were already in flight ([[littles-law]]).
