---
title: 01 SAXPY
source: "[[Cuda Dev]]"
tags: [cuda, level-1, exercise]
level: 1
status: done
created: 2026-11-08
---

# 01 · SAXPY

## Spec
Compute, in place on the GPU:

```
y[i] = a * x[i] + y[i]      for 0 <= i < n
```

- `x`, `y`: `float` (FP32), already on the device
- `a = 2.5f`
- Benchmark size **n = 2²⁷ + 13 = 134,217,741**. The `+13` is deliberate. The harness also tests n = 1, 31, 256, 257 and 1,000,003, so every edge case has to work.

You write two things in `kernel.cu`:
1. the body of `saxpy`
2. `threads_per_block` and `num_blocks` in `launch_saxpy`

Don't edit `main.cu`. It's the test and benchmark harness.

## Concepts exercised
- Global thread index: `blockIdx`, `blockDim`, `threadIdx`
- **Grid sizing with a ceiling divide, plus a bounds check** (a weak spot from the placement check)
- **Coalesced access**: consecutive threads touch consecutive addresses (a weak spot)
- Launch error checking (read how `main.cu` does it)
- **Roofline estimate before measuring** (a weak spot)

## Before you code: predict
Fill these in *first*, then compare them with the measurement.

|                                                       | Your prediction       |
| ----------------------------------------------------- | --------------------- |
| Bound (memory / compute / latency)?                   | memory                |
| Expected time (ms)                                    | 4.47 ms               |
| Expected % of peak bandwidth                          | 1.61 gb               |
| Does block size (64 vs 256 vs 1024) matter much? Why? | No since memory bound |

## Performance target (the math)

> [!note]- Open after predicting
>
>  | Quantity | Per element | Total (n ≈ 1.342 × 10⁸) |
>  |---|---|---|
>  | Bytes: read `x`, read `y`, write `y` | 12 B | **1.611 GB** |
>  | FLOPs: 1 multiply + 1 add | 2 | 0.268 GFLOP |
>  | Arithmetic intensity | 2 / 12 = **0.167 FLOP/B** | 
>
> - Ridge point on the RTX 3060: 12.7 TFLOP/s ÷ 360 GB/s ≈ **35 FLOP/B**. SAXPY sits about 200× to the left of it, so it's **memory-bound**.
> - Each array is about 512 MB, far bigger than the 3 MB L2, so every byte really does go to DRAM.
> - Ideal time: 1.611 GB ÷ 360 GB/s = **4.47 ms**.
> - **Target: ≥ 85% of peak, which is ≥ 306 GB/s, or about 5.3 ms or less.** Real GDDR6 rarely gets above about 90% of spec.

## Build & run
```bash
make            # build
make run        # edge-case tests + benchmark (also writes test_output.txt)
make check      # compute-sanitizer memcheck: run this before trusting a PASS
make ptxas      # registers per thread
make profile    # ncu: Speed of Light, memory, launch stats, occupancy
```
If `ncu` reports `ERR_NVGPUCTRPERM`, tell me. Profiling needs access to the performance counters, and I'll walk you through enabling it. It needs root, so I won't change it without asking.

Right now `kernel.cu` launches with 0 threads. Run `make run` once before you change anything, and look at the error message and *which line* of `main.cu` catches it. Errors like this are common.

## Stretch goals
1. **Block size sweep:** try 32, 64, 128, 256, 512 and 1024 threads per block, and record the times. Explain what you see.
2. **Grid-stride loop:** launch a fixed grid (say `k × numSMs` blocks) and have each thread loop over elements. Is it faster, slower, or the same? Why might you want it anyway?
3. **`float4` vectorized loads:** each thread handles 4 elements with one 16-byte load. Handle the leftover tail, since n isn't a multiple of 4. Check the effect with `ncu`: look at memory throughput and at instructions issued.
4. Add `const __restrict__` to the pointer parameters. Does `make ptxas` or the timing change?

## Results
| Version                 | Block size | Time (ms)         | GB/s                  | % of 360 GB/s | Notes                                                |
| ----------------------- | ---------- | ----------------- | --------------------- | ------------- | ---------------------------------------------------- |
| v1 naive, 1 elem/thread | 256        | 4.868             | 330.9                 | 91.9%         | 10 regs, 0 spills, memcheck clean. Target met (≥306) |
| sweep (2026-11-21)      | 32         | 6.125 (min 6.058) | 263.0 (min-based 266) | 73.0%         | 33% occ; only clearly slower size                    |
| sweep                   | 64         | 5.165 (min 4.817) | 311.8 (334)           | 86.6%         | 67% occ                                              |
| sweep                   | 128        | 5.815 (min 4.786) | 277.0 (337)           | 76.9%         | 100% occ; median noisy                               |
| sweep                   | 256        | 5.663 (min 4.789) | 284.4 (336)           | 79.0%         | 100% occ; median noisy (was 4.868 on 11-20)          |
| sweep                   | 512        | 5.798 (min 4.885) | 277.8 (330)           | 77.2%         | 100% occ; median noisy                               |
| sweep                   | 1024       | 5.304 (min 4.940) | 303.6 (326)           | 84.3%         | 67% occ                                              |
