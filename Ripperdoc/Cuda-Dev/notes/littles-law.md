---
title: Little's law (latency hiding)
source: "[[Cuda Dev]]"
aliases: [bytes in flight, latency hiding, memory-level parallelism]
tags: [cuda, hpc, ripperdoc, level-3, performance-model]
level: 3
status: learning
arch: all (numbers below are RTX 3060, sm_86)
created: 2026-11-21
updated: 2026-11-21
related: ["[[occupancy]]", "[[roofline]]"]
sources: [Best Practices Guide §Occupancy / Hiding Latency, PMPP ch. 4–5, Volkov "Better performance at lower occupancy" (GTC 2010)]
---

# Little's law (latency hiding)

## Summary
To reach full bandwidth, enough data has to be **requested but not yet arrived** at every moment:

```
bytes in flight = bandwidth × latency
```

If you have less than that in flight, DRAM sits idle part of the time and you lose bandwidth, even when the kernel is memory-bound.

> **Analogy:** a conveyor belt that takes 500 ns from end to end. To deliver 360 GB/s out the far end, the belt must be about **180 KB full at all times**. Each warp drops a box on the belt and waits for it. Too few warps leave gaps in the belt, and gaps are lost bandwidth. Once the belt is full, more warps don't help.

## Hardware view: RTX 3060
```
360 GB/s × ~500 ns   ≈ 180 KB in flight (whole GPU)
180 KB / 28 SMs      ≈ 6.4 KB per SM
```
Latency is rough (about 400–600 ns for DRAM). Use the formula for order of magnitude, not exact predictions.

## Two ways to fill the belt
| Lever | How | Example |
|---|---|---|
| More warps (TLP) | Higher [[occupancy]] | tpb 32 → 64 in 01-saxpy |
| More bytes per warp (ILP) | Each thread issues several or wider independent loads | `float4` loads, or 4 elements per thread |

These trade against each other. A kernel at low occupancy can still saturate bandwidth if each thread keeps many loads in flight.

## Worked: 01-saxpy sweep
SAXPY puts about 256 B per warp in flight (128 B of `x` + 128 B of `y`).

| tpb | warps/SM | in flight/SM | measured (min) |
|---|---|---|---|
| 32 | 16 | ~4 KB ❌ | 266 GB/s |
| 64 | 32 | ~8 KB ✅ | 334 GB/s |
| 256 | 48 | ~12 KB ✅ | 336 GB/s |

## In the profiler
`ncu` warp state stats: a high **Stall Long Scoreboard** share means warps are waiting on global memory. If DRAM throughput % is also low, you don't have enough in flight.

## Pitfalls
- Thinking memory-bound kernels need warps "for computation". They need them to keep loads in flight (01-saxpy, 2026-11-21).
- Confusing `float4` with quantization. `float4` moves the **same** bytes in fewer, wider loads (more in flight per thread). Quantization moves **fewer** bytes (lower precision), which cuts total traffic.
- Loads only count as in flight together if they're **independent**. A load whose address depends on the previous load (pointer chasing) has to wait for it.

## Check yourself
> [!question]- A GPU has 1000 GB/s and ~600 ns latency. How many bytes must be in flight?
> 1000 × 10⁹ × 600 × 10⁻⁹ = **600 KB** across the whole GPU.
