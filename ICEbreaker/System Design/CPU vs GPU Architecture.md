---
title: CPU vs GPU Architecture
source: "[[System Design]]"
tags:
  - system-design
created: 2026-07-07
status: solved
---

## Problem Statement

Describe CPU and GPU architecture and how it ties into data management or performance.

## One Line Summary

CPU = low latency, few powerful cores
GPU = high throughput, thousands of simple cores

---

## CPU
- Few powerful cores (4-64)
- Large caches per core
- Optimized for latency
- Branch prediction, out-of-order execution
- Control-heavy design

## GPU
- Thousands of simple CUDA cores grouped into SMs
- SIMT — 32 threads (warp) execute same instruction
- Latency hidden via warp switching not caching
- High memory bandwidth (GDDR6/HBM)
- Tensor Cores for matrix ops

---

## Key Tradeoffs

### Latency hiding vs avoidance
- CPU → avoids latency via caching
- GPU → hides latency by swapping warps

### Memory access
- GPU needs coalesced access — uncoalesced = 10-30x slower
- CPU more forgiving due to large caches

### PCIe Bottleneck
- Data must transfer CPU→GPU over PCIe
- Often the real bottleneck not compute
- Fix: minimize transfers, pinned memory, CUDA streams

### Task Suitability
- CPU → sequential, branch-heavy, low latency
- GPU → data parallel, same op across large dataset

---

## What Interviewers Want to Hear
- Heterogeneous systems — CPU orchestrates, GPU computes
- Real example: ML training loop — CPU data loading
  can bottleneck GPU if not prefetching
- Wrong architecture for workload = slower despite raw FLOPS
