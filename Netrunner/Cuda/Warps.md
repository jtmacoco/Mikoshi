---
title: Warps
source: "[[Cuda]]"
tags:
  - cuda
  - warp
type: concept
created: 2026-07-08
---
## What is a Warp

A warp is a group of 32 consecutive threads within a thread block that execute together on a Streaming Multiprocessor (SM). All threads in a warp run in lockstep — the same instruction is issued to all 32 threads on the same clock cycle (SIMT: Single Instruction, Multiple Threads).

- Thread blocks are split into warps by the hardware, not by you. Thread 0-31 = warp 0, 32-63 = warp 1, etc.
- The warp is the actual unit of scheduling and execution on the GPU — not the thread, and not the block.
- If your block size isn't a multiple of 32, the last warp is padded with inactive threads (wasted lanes).

---

## Example / Usage

```c
__global__ void addVectors(float* a, float* b, float* c, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        c[idx] = a[idx] + b[idx];
    }
}

// Launched with blockDim.x = 256
// -> each block contains 256 / 32 = 8 warps
addVectors<<<numBlocks, 256>>>(a, b, c, n);
```

Checking warp size / properties:
```c
cudaDeviceProp prop;
cudaGetDeviceProperties(&prop, 0);
printf("Warp size: %d\n", prop.warpSize); // almost always 32
```

---

## When to Use (i.e. when to *think* about warps)

- Choosing block sizes: pick multiples of 32 (e.g. 128, 256) to avoid wasted/idle lanes.
- Writing conditional code: be aware which threads take which branch (see divergence below).
- Optimizing memory access: coalesce global memory reads/writes across a warp so all 32 threads hit contiguous addresses in one transaction.
- Using warp-level primitives: `__shfl_sync`, `__ballot_sync`, `__any_sync`, `__all_sync` for fast intra-warp communication without shared memory.
- Reasoning about occupancy: SM schedulers issue instructions warp-by-warp, so occupancy is measured in warps per SM, not threads.

---

## Watch Out For

- **Warp divergence**: if threads in a warp take different branches of an `if/else`, the warp executes *both* paths serially (masking off inactive threads each time), then reconverges. This kills performance if divergence is frequent.
- **Uncoalesced memory access**: if the 32 threads in a warp access scattered/non-contiguous memory, it turns into many memory transactions instead of one — big slowdown.
- **Partial/tail warps**: block sizes not divisible by 32 waste lanes in the last warp of each block.
- **Implicit vs explicit sync**: pre-Volta, warps were implicitly synchronized ("warp-synchronous programming"). Since Volta (independent thread scheduling), threads in a warp can diverge and *not* automatically reconverge — always use the `_sync` intrinsics (`__shfl_sync`, `__syncwarp`, etc.) rather than assuming lockstep behavior.
- **Occupancy vs. warp count confusion**: more warps per SM isn't always better — it depends on register/shared memory pressure vs. latency hiding needs.