**Source**: [[Linux Kernel Contribution]]
**Tags**: #linux #on-contract
**Description**: Week two notes on bit map solutions

|Day|Task (≈30 min)|
|---|---|
|Mon|Set/clear/toggle/test a bit at position n. Count set bits three ways: naive loop, Kernighan's `n & (n-1)` trick, lookup table.|
|Tue|Check power-of-two, round up to next power of two, reverse the bits of a `uint32_t`.|
|Wed|Write alignment macros: `ALIGN_UP(x, a)`, `ALIGN_DOWN(x, a)`, `IS_ALIGNED(x, a)` (assume `a` is a power of two). These appear constantly in kernel code.|
|Thu|Implement a **bitmap**: `bitmap_set(map, n)`, `bitmap_clear`, `bitmap_test`, `bitmap_find_first_zero` over a `uint64_t` array. (The kernel tracks free pages this way.)|
|Fri|Write a function that hexdumps the raw bytes of _any_ value (`float`, `struct`, pointer). Use it to: detect endianness, see struct padding, look at IEEE-754 float layout.|
|Sat (lab)|Skim [`include/linux/bitops.h`](https://github.com/torvalds/linux/blob/master/include/linux/bitops.h) and `include/linux/bitmap.h`. Use `offsetof`/`sizeof` to inspect padding in a struct you define, then reorder fields to shrink it.|
|Sun|Rest / catch-up.|

