---
title: Cuda-Matrix-Mult
source: "[[cuda]]"
tags:
  - cuda
  - matrix-multiplication
type: concept
created: 2026-08-24
---

## What is Cuda-Matrix-Mult

Matrix multiplication with cuda using tiles

---
>[!danger] Clean Up Notes
>Right now it's kind of a dump but helpful just need to organize and re-word

## Tiling Setup Visualization 

![[Cuda-Matrix-Mult-20260824220402943.svg]]

```html-embed
Mikoshi/Netrunner/Cuda/Cuda_Assets/matmul_tile_animation.html
800

```
- Issue with launching threads right now as will have memory issue with shared memory since more threads than the size of the tile block
- `tx` moves faster than `ty`

CUDA flattens a 2D (or 3D) block of threads into a single linear ID using this formula:

```
linear_id = tx + ty * blockDim.x
```

Notice `tx` is added **without** being multiplied by anything — it's the innermost, fastest-changing term. `ty` only changes once you've cycled through _all_ the `tx` values.

So for a 16×16 block, the linear thread order looks like:

```
tx: 0  1  2  3 ... 15   0  1  2  3 ... 15   0  1 ...
ty: 0  0  0  0 ...  0   1  1  1  1 ...  1   2  2 ...
```

`tx` sweeps 0→15 first, _then_ `ty` ticks up by 1 and `tx` starts over. This is just like counting: the "ones" digit (tx) changes every step, the "tens" digit (ty) changes only every 10 steps.

### Why this matters: warps

The GPU groups threads into **warps of 32 consecutive linear IDs**, and executes them together in lockstep. Since `tx` is the fastest-varying part of that linear ID, **consecutive threads in a warp differ in `tx`, with `ty` mostly constant** (for a 16-wide block, one warp = two full rows of `tx`, same `ty` pair, etc.).

That's _why_ coalescing works the way it does: if you make memory addresses depend on `tx` as the last/innermost term, consecutive threads in the same warp touch consecutive addresses — a coalesced access. If you built addresses around `ty` instead, consecutive threads in a warp would jump around in memory (large strides) — slow, uncoalesced access.

### One-line summary

`tx` moves faster because CUDA defines the thread block's linear ordering as `tx + ty * blockDim.x` — it's baked into the hardware/execution model, so `x` is always the innermost/fastest dimension, and warps are formed by grouping consecutive threads along that fast `x` axis.

**Loading phase:** each thread loads exactly _one_ element into shared memory, at its own `[ty][tx]` slot. Across all threads in the block, this collectively fills the _entire_ tile — thread (0,0) fills one corner, thread (0,1) fills the next, etc. After `__syncthreads()`, the full `TILE_WIDTH x TILE_WIDTH` tile is sitting in shared memory, populated by _all_ the threads working together.

**Compute phase:** now each thread reads across the _whole_ tile (varying `k`), not just its own loaded value. Thread `(ty, tx)` uses:

- `tiles_A[ty][k]` for all `k` — its own row, but every column, most of which were loaded by _other_ threads (the ones with `tx = k`, different `tx` from this thread, same `ty`)
- `tiles_B[k][tx]` for all `k` — its own column, but every row, loaded by threads with `ty = k`