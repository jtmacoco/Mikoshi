---
title: Week 3 — Allocators
source: "[[Contracts]]"
tags:
  - contract
created: 2026-07-19
status: on-contract
---

| Day       | Task (≈30 min)                                                                                                                                                                          |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | **Arena/bump allocator**: `arena_init(buf, size)`, `arena_alloc(n)` (just bump a pointer, aligned to 8), `arena_reset()`.                                                               |
| Tue       | **Fixed-size pool allocator**: pre-carve a buffer into N equal slots, keep a free list of slots, `pool_alloc`/`pool_free` in O(1). (This is the idea behind the kernel slab allocator.) |
| Wed       | **Free-list allocator, part 1**: block header struct (`size`, `next`), `my_malloc` that first-fit searches a free list over a static buffer.                                            |
| Thu       | **Free-list allocator, part 2**: `my_free` that returns blocks to the list; coalesce adjacent free blocks.                                                                              |
| Fri       | Add block splitting (don't hand out a 4 KB block for a 16-byte request). Write a stress test: random alloc/free loop, assert no corruption.                                             |
| Sat (lab) | Replace the static buffer with real memory from `mmap(NULL, ..., MAP_ANONYMOUS)`. You now have a toy malloc. Run your stress test under ASan.                                           |
| Sun       | Rest / catch-up.                                                                                                                                                                        |
# Monday

## Solution
