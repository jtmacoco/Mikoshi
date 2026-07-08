---
title: CUDA Optimization
source: "[[System Design]]"
tags:
  - system-design
created: 2026-07-07
status: solved
---

## Problem Statement

How would you troubleshoot and optimize a CUDA application for maximum efficiency on NVIDIA GPUs?

## Steps
### 1. Profile First, Optimize seconds
- Nsight Systems - Timeline view of CPU/GPU activity, kernel launches, memory transfers, stream overlap. Use this to get the overall big picture bottleneck
	- Is the GPU even busy? are kernels serialized when they shouldn't be?
- Nsight Compute - Deep per kernel analysis: occupancy, memory throughput, warp stall reasons, instruction mix. use this once know which kernel to optimize
- nvprof/nvidia-smi for quick sanity checks, though nvprof is deprecated in favor for Nsight
### 2. Common Bottleneck Categories
#### Memory bound issues
- Check achieved vs theoretical memory bandwidth (Nsight Compute gives this directly)
- Look for uncoalesced global memory access - threads in a warp should touch contiguous addresses
- Check for excessive global memory traffic that could be cached in shared memory
- Watch for bank conflicts in shared memory access patterns 

### 3. Optimization Levers, Roughly in Order of Impact

1. **Algorithm-level changes** — reduce total work, better data structures. Biggest wins usually live here, not in micro-optimization.
2. **Memory access patterns** — coalescing, shared memory tiling, minimizing host-device transfers
3. **Occupancy tuning** — block size, register/shared memory pressure (use the CUDA Occupancy Calculator or `--ptxas-options=-v`)
4. **Overlap compute with transfer** — CUDA streams, pinned host memory, async copies
5. **Kernel fusion** — combine multiple small kernels to reduce launch overhead and intermediate memory writes
6. **Use libraries where possible** — cuBLAS, cuDNN, Thrust, CUB are usually better-tuned than hand-rolled kernels
7. **Mixed precision** — FP16/TF32/INT8 with Tensor Cores if the workload and hardware support it (huge gains on Volta+ GPUs)
8. **CUDA Graphs** — for workloads with many repeated small kernel launches, this cuts launch overhead significantly
### 4. Practical Workflow
```
1. Nsight Systems → identify the slow region (kernel, transfer, sync stall)
2. Nsight Compute → drill into that kernel's roofline position (memory-bound vs compute-bound)
3. Apply targeted fix based on the bound
4. Re-profile to confirm improvement (avoid regressions)
5. Repeat until diminishing returns or you hit a hardware ceiling
```
