---
title: Roofline and back-of-envelope estimates
source: "[[Cuda Dev]]"
aliases: [arithmetic intensity, ideal time, memory-bound, compute-bound]
tags: [cuda, hpc, ripperdoc, level-3, performance-model]
level: 3
status: learning
arch: all
created: 2026-11-20
updated: 2026-11-20
related: ["[[grid-sizing]]", "[[occupancy]]"]
sources: [Best Practices Guide §Performance Metrics, PMPP ch. 5, Williams et al. "Roofline" (2009)]
---

# Roofline and back-of-envelope estimates

## Summary
Before you measure, work out what *should* limit the kernel: moving bytes (memory-bound) or doing math (compute-bound). That gives you an ideal time to compare the measurement against.

> **Analogy:** a kitchen. Bandwidth is how fast groceries arrive and FLOP/s is how fast the chef cooks. SAXPY is "unwrap one item, do one thing": the chef mostly waits at the door, so delivery speed sets the time.

## The recipe (memorize this)
1. **Bytes per element:** count every global read and write × the size of the type.
2. **FLOPs per element:** count the math ops.
3. **Arithmetic intensity (AI)** = FLOPs / bytes.
4. **Compare with the ridge point** = peak FLOP/s ÷ peak BW. If AI is below the ridge, it's memory-bound; above it, compute-bound.
5. **Ideal time:** memory-bound is `total bytes / BW`; compute-bound is `total FLOPs / peak FLOP/s`.
6. **Realistic target:** DRAM gets about 85–90% of spec, so expect roughly ideal ÷ 0.85–0.9.

## Worked: SAXPY on RTX 3060 (01-saxpy)
```
y[i] = a*x[i] + y[i]      n ≈ 1.342 × 10⁸, float = 4 B

bytes/elem = read x + read y + write y = 3 × 4 = 12 B
FLOPs/elem = 1 mul + 1 add = 2
AI         = 2 / 12 ≈ 0.17 FLOP/B
ridge      = 12.7 TFLOP/s / 360 GB/s ≈ 35 FLOP/B   → about 200× below: memory-bound

total      = 12 × 1.342e8 = 1.61e9 B = 1.61 GB
ideal time = 1.61e9 / 360e9 = 4.47 ms
measured   = 4.87 ms → 330.9 GB/s = 91.9% of peak ✓
```

## Units sanity check
Add up the exponents: 12 B is about 10¹, times 10⁸ gives 10⁹, which is **GB**, not tens of GB. GB ÷ (GB/s) gives seconds, and × 1000 gives ms.

## In the profiler
`ncu` Speed of Light: **Memory Throughput %** near 90 with low **Compute (SM) %** confirms memory-bound. The Roofline section plots the kernel as a dot.

## Pitfalls
- Total bytes slipped by 10× (16.08 GB instead of 1.61 GB) in the 01-saxpy prediction.
- "% of peak" is a percentage (measured BW ÷ spec BW), not total bytes.
- A scalar kernel argument like `a` costs no memory traffic, so don't count it.
- If data fits in L2 (3 MB on the 3060), DRAM math overestimates the time.

## Check yourself
> [!question]- Vector add `c[i] = a[i] + b[i]`, float, n = 10⁸. Bound, and ideal time on the 3060?
> 12 B/elem, 1 FLOP, so AI = 0.083 and it's memory-bound. 12 × 10⁸ = 1.2 GB, and 1.2 / 360 = **3.33 ms**.
