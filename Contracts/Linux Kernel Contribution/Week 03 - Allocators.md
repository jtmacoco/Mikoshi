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

## Solution

- Void Pointer is used since no arithmetic is done
- Void pointer handle raw memory block
- Void pointers can't be de-referenced need double pointer stuff

```c
#include <stddef.h>
#include <stdio.h>
typedef struct pool{
	void *buffer;
	void *free_list;

	size_t slot_size;
	size_t cap;
} pool;

void init(pool *p, void *buffer, size_t slot_size, size_t n){
	p->buffer    = buffer;
	p->slot_size = slot_size;
	p->cap       = n;

	char *base = (char *)buffer;//grabs base address basically so say 1000
	for (size_t i = 0; i < n-1; ++i){
		void **slot = (void **)(base + i * slot_size);
		*slot= base + (i+1)*slot_size;
	}
	void **last = (void **)(base+(n-1)*slot_size);//computes the last spot of the buffer and put's the terminator aka null
	*last = NULL;
	p->free_list = buffer;
}

void *pool_alloc(pool *p){
	if (!p->free_list)return NULL;
	void *slot = p->free_list;
	p->free_list = *(void **)slot;
	return slot;
}
void pool_free(pool *p, void *slot){
	*(void **)slot = p->free_list;
	p->free_list=slot;
}
 
void print_free_list(pool *p) {
    printf("free_list chain: ");
    void *cur = p->free_list;
    if (!cur) { printf("(empty)\n"); return; }
    while (cur) {
        printf("%ld", (long)((char *)cur - (char *)p->buffer) / (long)p->slot_size);
        void *next = *(void **)cur;
        if (next) printf(" -> ");
        cur = next;
    }
    printf("\n");
}

int main(void) {
    const size_t SLOT_SIZE = 16;
    const size_t N         = 4;
 
    char buffer[SLOT_SIZE * N];
    pool pool;
    init(&pool, buffer, SLOT_SIZE, N);
 
    printf("=== after pool_init ===\n");
    printf("buffer starts at %p\n", (void *)buffer);
    print_free_list(&pool);
    printf("\n");
 
    printf("=== allocating 4 slots (should drain the pool) ===\n");
    void *slots[4];
    for (int i = 0; i < 4; i++) {
        slots[i] = pool_alloc(&pool);
        printf("pool_alloc() -> slot %ld (addr %p)\n",
               ((char *)slots[i] - buffer) / SLOT_SIZE, slots[i]);
        print_free_list(&pool);
    }
    printf("\n");
 
    printf("=== pool should now be exhausted ===\n");
    void *extra = pool_alloc(&pool);
    printf("pool_alloc() when empty -> %p (expect (nil))\n\n", extra);
 
    printf("=== writing data into allocated slots ===\n");
    for (int i = 0; i < 4; i++) {
        snprintf((char *)slots[i], SLOT_SIZE, "hi %d", i);
        printf("slot %d now holds string: \"%s\"\n", i, (char *)slots[i]);
    }
    printf("\n");
 
    printf("=== freeing slot 1, then slot 3 (LIFO push order) ===\n");
    pool_free(&pool, slots[1]);
    print_free_list(&pool);
    pool_free(&pool, slots[3]);
    print_free_list(&pool);
    printf("\n");
 
    printf("=== allocating again: should hand back slot 3, then slot 1 ===\n");
    void *a = pool_alloc(&pool);
    printf("pool_alloc() -> slot %ld\n", ((char *)a - buffer) / SLOT_SIZE);
    print_free_list(&pool);
    void *b = pool_alloc(&pool);
    printf("pool_alloc() -> slot %ld\n", ((char *)b - buffer) / SLOT_SIZE);
    print_free_list(&pool);
 
    return 0;
}
```

### Init

- So we loop through `n-1` since we would write out of bounds with `*slot= base + (i+1)*slot_size;`
- Then we use `last` to calculate the address of the final slot in the buffer, and place the `NULL` terminator there so we know when we've run out of free slots.

>[!important] Trick
>The trick here is we are storing the next free slot in the current slot so `slot[0]` first 8 bytes would be the address of `slot[1]`


### pool_alloc

- Here the trick is in the double pointer which moves the free_list pointer
- the double pointer doesn't _do_ the moving by itself, it's what **makes the read legal** (since you can't dereference `void*`). The actual "moving" is the assignment `p->free_list = ...` — the double-pointer cast is what lets you get the value to assign.
- `p->free_list = *(void **)slot;` This basically needs the double pointer due to the void pointer since we can't de-reference a void pointer.
- The moving is basically saying treat slot as an address so say slot was 1000 treat this as a memory address. When we then set `p->free` we are setting it to the value that address 1000 holds which is the next free slot

### pool_free
- Does the exact reverse
- go to the address `slot` holds, and write `p->free_list`'s value there." `slot` is being used purely as a **destination address** here — it tells us _where_ to write, not _what_ to write. The thing actually being written is `p->free_list`'s current value.
- writes the current `free_list` value into the freed slot's first 8 bytes
- Then points `free_list` back at the slot

## Walk Through

**Setup:** say `slot_size = 16` bytes, `n = 4` slots, and the buffer starts at address `1000` (I'll use round decimal addresses instead of real hex, just to keep it readable).

So the raw memory looks like this before we touch it — one undivided 64-byte blob:

```
address:  1000                                              1064
          [................. 64 bytes, uninitialized .................]
```

We're mentally slicing it into 4 chunks of 16 bytes:

```
Slot 0: addresses 1000–1015
Slot 1: addresses 1016–1031
Slot 2: addresses 1032–1047
Slot 3: addresses 1048–1063
```

Nothing has _physically_ changed yet — "carving" just means we're about to write specific values into specific spots to create a linked list that lives inside this memory.

**Now trace the loop.** `base = 1000`. Loop runs for `i = 0, 1, 2` (since `n-1 = 3`, i.e. it stops one short of the last slot — more on that below).

**i = 0:**


```c
void **slot = (void **)(base + 0 * 16);   // slot = address 1000
*slot = base + 1 * 16;                     // write 1016 into address 1000
```

This means: "at address 1000, store the number 1016." So the first 8 bytes of Slot 0 now literally _contain the address of Slot 1_.

**i = 1:**

```c
void **slot = (void **)(base + 1 * 16);   // slot = address 1016
*slot = base + 2 * 16;                     // write 1032 into address 1016
```

First 8 bytes of Slot 1 now contain `1032` — the address of Slot 2.

**i = 2:**

```c
void **slot = (void **)(base + 2 * 16);   // slot = address 1032
*slot = base + 3 * 16;                     // write 1048 into address 1032
```

First 8 bytes of Slot 2 now contain `1048` — the address of Slot 3.

**After the loop**, we handle the last slot separately:

```c
void **last = (void **)(base + 3 * 16);   // last = address 1048 (Slot 3)
*last = NULL;                              // write NULL into address 1048
```

Slot 3's first 8 bytes contain `NULL` — "no next slot," it's the end of the chain.

**Picture of memory now:**

```
Slot 0 (1000-1015):  [ 1016 | ...unused... ]
Slot 1 (1016-1031):  [ 1032 | ...unused... ]
Slot 2 (1032-1047):  [ 1048 | ...unused... ]
Slot 3 (1048-1063):  [ NULL | ...unused... ]
```

Each slot's first 8 bytes hold _the address of the next free slot_. That's the entire free list — it's not a separate data structure sitting elsewhere, it's threaded directly through the bytes of the free memory itself. That's the "clever trick" of this design: since a free slot's contents are meaningless (nobody's using that memory yet), we're allowed to scribble a pointer into it.

Finally:

```c
p->free_list = buffer;  // = 1000
```

So `free_list` points at Slot 0 — the head of the chain.

**Why loop to `n-1` and handle the last one separately?** Because each iteration writes "pointer to _next_ slot," and slot 3 has no next slot — it needs to terminate the list with `NULL` instead of pointing off the end of the buffer into garbage memory. If the loop ran the full `n` times, `i=3` would try to compute `base + 4*16 = 1064`, which is one slot past the buffer's actual end — an address you don't own.