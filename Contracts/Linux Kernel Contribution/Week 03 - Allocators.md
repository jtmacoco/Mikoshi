---
title: Week 3 — Allocators
source: "[[Contracts]]"
tags:
  - contract
created: 2026-07-19
status: completed
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

# Wednesday

## Solution

```c
#include <stdio.h>

#define POOL_SIZE 1024
static char memory_pool[POOL_SIZE];


typedef struct block_header{
	struct block_header *next;
	size_t size;
} block_header;

block_header *free_list;
void init(void){
	free_list = (block_header *)memory_pool;
	free_list->size = POOL_SIZE - sizeof(block_header);
	free_list->next = NULL;
}
void *my_malloc(size_t n){
	block_header *cur  = free_list;
	block_header *prev = NULL;
	size_t needed = sizeof(block_header) + 1;
	while (cur){
		if(cur->size >= n+needed){
			block_header *new_free = (block_header *)((char *)(cur+1)+n);//calculate the address
			new_free->size = cur->size - n - sizeof(block_header);//calculate how much memory left over,
			new_free->next = cur->next;
			if (prev == NULL) free_list=new_free;
			else prev->next = new_free;

			return (void *)(cur+1);
		}
		else{
			prev = cur;
			cur = cur->next;
		}
	}
	return NULL;
}
int main(){
	init();
	int *test = my_malloc(sizeof(int)*4);
	test[0] = 2;
	printf("Free List Allocator\n");
	printf("test: %d\n",test[0]);
}
```

- `cur->size` describes how many bytes there are right and with that we can calculate the address space
- Currently shrinks the address space doesn't create any new blocks
- `block_header *new_free = (block_header *)((char *)(cur+1)+n)` calculates the address

### Example

**Step 0: After `init()`**

```
free_list -> [Header @ 1000: size=1008, next=NULL]
```

One block. Usable space is bytes `1016`–`2023`.

**Step 1: First call — `my_malloc(8)`**

```c
cur = free_list;      // cur = 1000
prev = NULL;
```

Check: `cur->size (1008) >= 8 + 17` → true, split.

```c
new_free = (cur+1) + 8 = 1016 + 8 = 1024
new_free->size = 1008 - 8 - 16 = 984
new_free->next = cur->next = NULL       // Block A's next was NULL, so this stays NULL
free_list = new_free;                   // since prev == NULL
return (cur+1) = 1016;                  // caller gets 8 bytes at 1016
```

**State after call 1:**

```
[old header, orphaned][8 bytes: given to caller][new header @1024: size=984, next=NULL]
    @1000                  @1016                        @1024

free_list -> [Header @1024: size=984, next=NULL]
```

Still just **one block in the free list** — it just moved from address `1000` to `1024`, and shrank. Nothing points to `1000` anymore; that memory is "spoken for" by the caller.

**Step 2: Second call — `my_malloc(8)` again**

```c
cur = free_list;      // cur = 1024
prev = NULL;
```

Check: `cur->size (984) >= 8 + 17` → true, split again.

```c
new_free = (cur+1) + 8 = (1024+16) + 8 = 1048
new_free->size = 984 - 8 - 16 = 960
new_free->next = cur->next = NULL      // again, was NULL
free_list = new_free;                  // prev == NULL again
return (cur+1) = 1040;                 // caller gets 8 bytes at 1040
```

**State after call 2:**

```
free_list -> [Header @1048: size=960, next=NULL]
```

Still one block! It keeps sliding forward and shrinking, because every call so far has been splitting off from the _front_ of the list, and `next` has stayed `NULL` the whole time since there was never a second block to link to.

**So when would you actually get a real 2+ block list, where `cur->next` is non-`NULL`?**

That requires **freeing** memory (which sounds like part 2 of your assignment) — e.g., if you `my_free()` the block from call 1 (the 8 bytes at `1016`), that freed chunk gets _inserted back_ into the free list, typically at the front:

```c
freed_block->next = free_list;   // freed_block now points at whatever the head currently is
free_list = freed_block;         // and becomes the new head
```

_That's_ the moment `next` becomes non-`NULL` for the first time — because now there are genuinely two separate free regions (the newly-freed 8-byte chunk, and the big remaining pool), linked together.

So to be accurate: with only `my_malloc`/splitting and no `my_free` yet, your free list will actually always stay at exactly **one block** (just sliding and shrinking) — my earlier "Block A / Block B" example was really describing what happens _after_ freeing gets added. Does that make sense — that splitting alone doesn't grow the list, only freeing (re-inserting freed nodes) does?

### How Prev works

lose, but let's untangle one part — "new_free" isn't "the block we're going to malloc," it's the _opposite_: it's the **leftover free space** after we take memory out for the malloc. Let's trace `prev` concretely using the two-block list you just built.

**Recall the state after `my_free(a)`:**

```
free_list (1000) -> [Block1: size=16, next=1032] -> [Block2: size=976, next=NULL] -> NULL
```

**Now call `my_malloc(500)`** — too big for Block1 (16 bytes), so first-fit has to walk past it to Block2.

```c
cur = free_list;   // cur = 1000 (Block1)
prev = NULL;
```

**Iteration 1:** `cur->size (16) >= 500 + needed`? No. So:

```c
prev = cur;        // prev = 1000  (remembering Block1, since we're passing over it)
cur = cur->next;   // cur = 1032   (move to Block2)
```

**Iteration 2:** `cur->size (976) >= 500 + needed`? Yes — found our fit. Now `cur = 1032` (Block2) is the block we're allocating from, and `prev = 1000` (Block1) is the block _right before it in the list_.

Here's the key thing `prev` is for: **Block1's `next` field currently says `1032`** (pointing at Block2). We're about to replace Block2 with a _smaller_ free block (`new_free`) at some new address — say `1032 + 500 + 16 = 1548`. If nothing updates Block1's `next`, Block1 would still say `next = 1032` — pointing at a stale address that's about to become part of the _allocated_ region, not a free block anymore. That would corrupt the list.

So:

```c
new_free = (cur+1) + 500 = ...;   // = 1548, the LEFTOVER free space, not the malloc'd part
new_free->size = 976 - 500 - 16;
new_free->next = cur->next;        // = Block2's old next, which was NULL
```

And now the relinking — this is where `prev` gets used:

```c
if (prev == NULL) free_list = new_free;
else prev->next = new_free;        // prev = Block1, so: Block1->next = 1548
```

Since `prev` is `1000` (not `NULL`), we take the `else` branch: **Block1's `next` field gets updated from `1032` to `1548`** — pointing at the new leftover free block instead of the stale, now-allocated address.

**Result:**

```
free_list (1000) -> [Block1: size=16, next=1548] -> [new_free @1548: size=460, next=NULL] -> NULL
```

**So to correct your phrasing:** `prev` isn't about "the block we're going to malloc" — `cur` is that block (the one satisfying the request). `prev` is simply "whichever block came _right before `cur`_ in the chain" (or `NULL` if `cur` was the head). Its whole job is: after `cur` gets consumed/split, `prev` is the thing whose `next` field needs to be _redirected_ — either to `new_free` (the leftover piece), or to `cur->next` (if `cur` is fully consumed with no split) — so the chain doesn't end up pointing at stale/invalid addresses.

"Attaching the chain" — yes, that's a good way to put it, as long as we're precise about _what's_ getting reattached to _what_.

Think of the free list as a physical chain of blocks linked by pointers. When you remove/shrink a link in the middle of that chain (`cur`), the link _before_ it (`prev`) is the one holding onto it — so if you don't update `prev`'s grip, it's left holding onto something that's no longer valid (either fully allocated now, or replaced by a smaller leftover piece at a different address).

So `prev->next = new_free` is literally: **"detach `prev` from `cur`, and reattach it to `new_free` instead."** The chain has to stay unbroken — every node needs to correctly point at whatever the _actual next free block_ is, otherwise a future `my_malloc` walking the list would either miss a valid free block, or worse, get send off to a bad address.

One more precision, since it matters: `prev` is only relevant when `cur` **isn't** the head of the list. If `cur` _is_ the head (`prev == NULL`), there's no `prev` link to reattach — instead you update `free_list` itself, since that's the thing "holding onto" `cur` in that case. That's the whole reason for the `if/else`:

```c
if (prev == NULL) free_list = new_free;   // cur was the head — the list's front pointer needs updating
else prev->next = new_free;                // cur was mid-chain — the block before it needs updating
```

Both branches are doing the same conceptual thing — "make whatever was pointing at `cur` now point at `new_free` instead" — just via two different variables, depending on whether that "whatever" is the global `free_list` pointer or another block's `next` field.

# Thursday

## Solution

```c
#include <stdio.h>

#define POOL_SIZE 1024
static char memory_pool[POOL_SIZE];


typedef struct block_header{
	struct block_header *next;
	size_t size;
} block_header;

block_header *free_list;
void init(void){
	free_list = (block_header *)memory_pool;
	free_list->size = POOL_SIZE - sizeof(block_header);
	free_list->next = NULL;
}
void *my_malloc(size_t n){
	block_header *cur  = free_list;
	block_header *prev = NULL;
	size_t needed = sizeof(block_header) + 1;
	while (cur){
		if(cur->size >= n+needed){
			block_header *new_free = (block_header *)((char *)(cur+1)+n);//calculate the address
			new_free->size = cur->size - n - sizeof(block_header);//calculate how much memory left over, ur->size describes how many bytes there are right and with that we can calculate the address space?
			new_free->next = cur->next;
			if (prev == NULL) free_list=new_free;
			else prev->next = new_free;

			cur->size = n;
			return (void *)(cur+1);
		}
		else{
			prev = cur;
			cur = cur->next;
		}
	}
	return NULL;
}
void my_free(void *ptr){
	block_header *bh = (block_header *)ptr-1;//-1 since currently points one over in malloc
	bh->next = free_list;//bh->next, set the next value to what ever free list is
	free_list = bh;//set free_list to bh
	//bh->free_list

}
int main(){
	init();
	int *test = my_malloc(sizeof(int)*4);
	test[0] = 2;
	printf("Free List Allocator\n");
	printf("test: %d\n",test[0]);
}
```

- `my_free` recovers the original header address from the pointer the caller has. If `a` points to `1016` (the malloc'd data), the header is always exactly `sizeof(block_header)` bytes before it — `1016 - 16 = 1000`. This works via `(block_header*)ptr - 1`, where `-1` in pointer arithmetic on a `block_header*` automatically means "-sizeof(block_header) bytes," not "-1 byte" — that's just how pointer arithmetic scales by type. This walk-back distance is _always_ one header's size, regardless of how big `n` was — it's not related to the malloc'd size at all. Once we have `bh` (= 1000), we insert it at the front of the free list: `bh->next = free_list` makes it point at whatever was previously the head (Block2 @ 1032), then `free_list = bh` makes it the new head.

### Example

**State right before `my_free(a)` runs** (continuing the trace from before):

```
addr 1000-1015: header (orphaned — nothing points to it right now)
addr 1016-1031: a's 16 bytes (still allocated, caller has this pointer)
addr 1032-1047: header, size=976, next=NULL   <- free_list points HERE
addr 1048-2023: 976 bytes of free usable space
```

So right now, `free_list = 1032`. This is a **header**, not raw data — it has a `size` field and a `next` field.

**Now `my_free(a)` runs:**


```c
bh = (block_header*)a - 1;   // bh = 1016 - 16 = 1000
bh->next = free_list;         // bh->next = 1032
free_list = bh;                // free_list = 1000
```

Let's be precise about that middle line: `bh->next = free_list` doesn't mean "bh points at 16 bytes of usable data" — it means the `next` _field_ inside the header at `1000` now stores the value `1032`, which is the **address of another header**. That's it — one pointer field getting one address written into it.

**State after `my_free(a)`:**

```
free_list = 1000

[Header @1000: size=16, next=1032] -> [Header @1032: size=976, next=NULL] -> NULL
        ^ freed block                      ^ the block that was never touched
```

So to directly answer your question: **yes, you now have two blocks in the list** — but not because freeing "created" a new block out of nowhere. It's because:

- The block at `1032` (976 bytes) existed the whole time, untouched since Step 1's split.
- The block at `1000` (16 bytes) is the _same block `a` was allocated from_ — it's just being _returned_ to the list, not newly made.

Both were always distinct regions of memory (`1000`-`1015`+data vs `1032`-`1047`+data) — freeing just re-attached the first one back into the chain via its `next` pointer, so now walking `free_list` visits two separate headers instead of one.
# Friday

- Already done block splitting in Thursday so look there
## Solution
```c
#include <stdio.h>

#define POOL_SIZE 1024
static char memory_pool[POOL_SIZE];


typedef struct block_header{
	struct block_header *next;
	size_t size;
} block_header;

block_header *free_list;
void init(void){
	free_list = (block_header *)memory_pool;
	free_list->size = POOL_SIZE - sizeof(block_header);
	free_list->next = NULL;
}
void *my_malloc(size_t n){
	block_header *cur  = free_list;
	block_header *prev = NULL;
	size_t needed = sizeof(block_header) + 1;
	while (cur){
		if(cur->size >= n+needed){
			block_header *new_free = (block_header *)((char *)(cur+1)+n);//calculate the address
			new_free->size = cur->size - n - sizeof(block_header);//calculate how much memory left over, ur->size describes how many bytes there are right and with that we can calculate the address space?
			new_free->next = cur->next;
			if (prev == NULL) free_list=new_free;
			else prev->next = new_free;

			cur->size = n;
			return (void *)(cur+1);
		}
		else if(cur->size >= n){
			// not enough for a leftover block, but the whole block fits n
			// just hand out the whole block (a little internal fragmentation)
			if (prev == NULL) free_list = cur->next;
			else prev->next = cur->next;
			return (void *)(cur+1);
		}
		else{
			prev = cur;
			cur = cur->next;
		}
	}
	return NULL;
}
void my_free(void *ptr){
	block_header *bh = (block_header *)ptr-1;//-1 since currently points one over in malloc
	bh->next = free_list;//bh->next, set the next value to what ever free list is
	free_list = bh;//set free_list to bh
	//bh->free_list

}
int main(){
	init();
	int *test = my_malloc(sizeof(int)*4);
	test[0] = 2;
	printf("Free List Allocator\n");
	printf("test: %d\n",test[0]);
}

```
- The change is on lines 33 with the else if statement
- Basically if there is room for the requested bytes in the block but not enough room for the header still allocate the memory since there is enough room
# Saturday
## Solution
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>

#define POOL_SIZE 1024
#define NUM_PTRS 50
static char memory_pool[POOL_SIZE];


typedef struct block_header{
	struct block_header *next;
	size_t size;
} block_header;

block_header *free_list;
void init(void){
	free_list = mmap(NULL,POOL_SIZE,PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (free_list == MAP_FAILED){
		perror("mmap");
		exit(1);
	}
	free_list->size = POOL_SIZE - sizeof(block_header);
	free_list->next = NULL;
}
void *my_malloc(size_t n){
	block_header *cur  = free_list;
	block_header *prev = NULL;
	size_t needed = sizeof(block_header) + 1;
	while (cur){
		if(cur->size >= n+needed){
			block_header *new_free = (block_header *)((char *)(cur+1)+n);//calculate the address
			new_free->size = cur->size - n - sizeof(block_header);//calculate how much memory left over, ur->size describes how many bytes there are right and with that we can calculate the address space?
			new_free->next = cur->next;
			if (prev == NULL) free_list=new_free;
			else prev->next = new_free;

			cur->size = n;
			return (void *)(cur+1);
		}
		else if(cur->size >= n){
			// not enough for a leftover block, but the whole block fits n
			// just hand out the whole block (a little internal fragmentation)
			if (prev == NULL) free_list = cur->next;
			else prev->next = cur->next;
			return (void *)(cur+1);
		}
		else{
			prev = cur;
			cur = cur->next;
		}
	}
	return NULL;
}
void my_free(void *ptr){
	block_header *bh = (block_header *)ptr-1;//-1 since currently points one over in malloc
	bh->next = free_list;//bh->next, set the next value to what ever free list is
	free_list = bh;//set free_list to bh
	//bh->free_list

}
int main(){
    init();
    srand(time(NULL));

    void *ptrs[NUM_PTRS] = {0};
    size_t sizes[NUM_PTRS] = {0};

    printf("Free List Allocator Stress Test\n");

    for (int round = 0; round < 200; round++){
        int i = rand() % NUM_PTRS;

        if (ptrs[i] == NULL){
            // allocate a random size
            size_t n = (rand() % 40) + 1;
            void *p = my_malloc(n);
            if (p){
                memset(p, 0xAA, n);      // fill it, so ASan/overflow shows up on next block
                ptrs[i] = p;
                sizes[i] = n;
            }
            // p == NULL is expected sometimes (pool exhausted/fragmented) — not a bug by itself
        } else {
            // verify the fill pattern is intact before freeing (catches corruption)
            unsigned char *bytes = (unsigned char *)ptrs[i];
            for (size_t k = 0; k < sizes[i]; k++){
                if (bytes[k] != 0xAA){
                    printf("CORRUPTION at ptrs[%d], byte %zu\n", i, k);
                }
            }
            my_free(ptrs[i]);
            ptrs[i] = NULL;
        }
    }

    // free anything still outstanding
    for (int i = 0; i < NUM_PTRS; i++){
        if (ptrs[i]) my_free(ptrs[i]);
    }

    printf("Stress test complete\n");
    return 0;
}
```

- Simple stress test
- `mmap` is a system call that gets memory basically
- `mmap` is like fundamental way programmers grab memory from the oss 
- Your process doesn't inherently "own" a big blob of RAM. Instead, it has a _virtual address space_, and different regions of that space get mapped to actual physical memory (or files) by the kernel. `mmap` is how you ask the kernel to create one of these mappings.
- `mmap` happens at run time