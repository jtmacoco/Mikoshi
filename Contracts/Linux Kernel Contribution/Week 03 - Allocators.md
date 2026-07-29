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

- CPU read memory in fixed size chunks (8 byte chunks on a 64 bit machine)
- Reason for offset is to prevent fetching multiple chunks
- Ex: Here's a concrete way to think about it: CPUs read memory in fixed-size chunks (say, 8-byte chunks on a 64-bit machine) — like reading a book one full line at a time, not one character at a time. If a `double` (8 bytes) starts at address 3, then those 8 bytes span _across_ two different 8-byte chunks (bytes 3–7 are in one chunk, bytes 8–10 are in the next chunk)
- `buffer` is a fixed anchor. "how far into the buffer have I already used" it doesn't change

### arena_alloc
- Takes in a `n` where n is how much memory a person want's to allocate
- We use this offset to help with the fixed chunk size as this rounds up to the nearest multiple if 8 (like week 2)
- Then move the buffer over by that offset
- **`a->offset += n;`** — advance the offset so the _next_ allocation starts after this one.

Ex:
```
total mem: 16
prev offset: 3 (someone allocated char[3] prior)
offset = 3+7 = 10
0000 1010 (10 in binary)
0000 1000 (~7 in binary)
--------------------------
0000 1000 (8)

offset = 8
output = 8
offset = 8+8 = 16
```


```c
#include <stdio.h>
typedef struct Arena{
	char *buffer;
	size_t size;
	size_t offset;

}Arena;
void arena_init(Arena *a, char *buf, size_t size){
	a->buffer = buf;
	a->size = size;
	a->offset = 0;
}

void arena_reset(Arena *a){
	a->offset = 0;
}
//0+7
//7  = 0000 0111
//~7 = 1111 1000   (every single bit flipped, not just the last 4)
//(offset + 7) & (~7) = 0000 0000
void *arena_alloc(Arena *a,size_t n){
	a->offset = (a->offset + 7) & ~7;//simiar to week 2 problems
	void *output;
	output = a->buffer + a->offset;
	a->offset+=n;
	return output;
}

int main(){
    Arena a;
    char buffer[1024];
    arena_init(&a, buffer, 1024);

    printf("buffer base = %p, size = %zu, offset = %zu\n\n",
           (void *)a.buffer, a.size, a.offset);

    char *p1 = (char *)arena_alloc(&a, 3);
    char *p2 = (char *)arena_alloc(&a, 5);
    char *p3 = (char *)arena_alloc(&a, 1);

    printf("\np1=%p p2=%p p3=%p\n", (void *)p1, (void *)p2, (void *)p3);
    printf("p2 - p1 = %ld (should be >= 3, rounded up to multiple of 8)\n", p2 - p1);
    printf("p3 - p2 = %ld\n", p3 - p2);

    arena_reset(&a);
    printf("\nafter reset: offset = %zu (should be 0)\n", a.offset);

    return 0;
}
```

**p1 = arena_alloc(3):**

- offset starts at 0 → `(0+7) & ~7 = 0` (already aligned)
- p1 = buffer + 0 = `0x7ffe88d36d60` ✓
- offset becomes 0 + 3 = 3

**p2 = arena_alloc(5):**

- offset is 3 → `(3+7) & ~7 = 10 & ~7 = 8`
- p2 = buffer + 8 = `0x7ffe88d36d68` ✓ (matches: `d60 + 8 = d68`)
- offset becomes 8 + 5 = 13

**p3 = arena_alloc(1):**

- offset is 13 → `(13+7) & ~7 = 20 & ~7 = 16`
- p3 = buffer + 16 = `0x7ffe88d36d70` ✓ (matches: `d60 + 16 = d70`)
- offset becomes 16 + 1 = 17

```c title=output
buffer base = 0x7ffe88d36d60, size = 1024, offset = 0


p1=0x7ffe88d36d60 p2=0x7ffe88d36d68 p3=0x7ffe88d36d70
p2 - p1 = 8 (should be >= 3, rounded up to multiple of 8)
p3 - p2 = 8

after reset: offset = 0 (should be 0)
```


---
# Tuesday

