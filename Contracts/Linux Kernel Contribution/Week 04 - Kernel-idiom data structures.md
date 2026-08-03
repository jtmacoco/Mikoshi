---
title: Kernel-idiom data structures
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-02
status: on-contract
client:
deadline:
stack:
---

## Objective


| Day       | Task (≈30 min)                                                                                                                                                                                       |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Implement `container_of(ptr, type, member)` yourself using `offsetof`. Write a tiny demo proving it recovers the outer struct from a pointer to a member. **This is THE kernel idiom — don't skip.** |
| Tue       | Circular doubly linked list, kernel-style: the `struct list_head { *next, *prev }` is _embedded inside_ your data struct, not the other way around. Write `list_init`, `list_add`.                   |
| Wed       | Add `list_del`, `list_for_each`, and a `list_entry` macro built on your `container_of`.                                                                                                              |
| Thu       | **Ring buffer** (power-of-two size, head/tail indices, index with `& (size-1)`): `rb_put`, `rb_get`, full/empty detection.                                                                           |
| Fri       | Hash table with chaining, using your kernel-style list as the bucket chains.                                                                                                                         |
| Sat (lab) | Read [`include/linux/list.h`](https://github.com/torvalds/linux/blob/master/include/linux/list.h) top to bottom — you'll understand all of it now. Compare with yours.                               |
| Sun       | Rest / catch-up. Phase 1 done — you now write C the way the kernel does.                                                                                                                             |

## Stack / Tools


## Progress Log

- 2026-08-02: Contract initialized

## Notes


## Links

