---
title: C
source: "[[Linux Kernel Contribution]]"
tags:
  - linux
created: 2026-07-04
status: completed
---

| Day       | Task (≈30 min)                                                                                                                                                                                                                           |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Set/clear/toggle/test a bit at position n. Count set bits three ways: naive loop, Kernighan's `n & (n-1)` trick, lookup table.                                                                                                           |
| Tue       | Check power-of-two, round up to next power of two, reverse the bits of a `uint32_t`.                                                                                                                                                     |
| Wed       | Write alignment macros: `ALIGN_UP(x, a)`, `ALIGN_DOWN(x, a)`, `IS_ALIGNED(x, a)` (assume `a` is a power of two). These appear constantly in kernel code.                                                                                 |
| Thu       | Implement a **bitmap**: `bitmap_set(map, n)`, `bitmap_clear`, `bitmap_test`, `bitmap_find_first_zero` over a `uint64_t` array. (The kernel tracks free pages this way.)                                                                  |
| Fri       | Write a function that hexdumps the raw bytes of _any_ value (`float`, `struct`, pointer). Use it to: detect endianness, see struct padding, look at IEEE-754 float layout.                                                               |
| Sat (lab) | Skim [`include/linux/bitops.h`](https://github.com/torvalds/linux/blob/master/include/linux/bitops.h) and `include/linux/bitmap.h`. Use `offsetof`/`sizeof` to inspect padding in a struct you define, then reorder fields to shrink it. |
| Sun       | Rest / catch-up.                                                                                                                                                                                                                         |

---
# Monday

## Solution
```C 
#include <stdio.h>

unsigned char bitCount[256];
void buildTable(){
	for (int i = 0; i < 256; i++){
		bitCount[i] = (i&1) + bitCount[i/2];
	}
}
int countSetBits(unsigned int x){
	return bitCount[x & 0xFF] +
           bitCount[(x >> 8) & 0xFF] +
           bitCount[(x >> 16) & 0xFF] +
           bitCount[(x >> 24) & 0xFF];
}

int main(){

	//Toggle a bit's
	//00011
	//00100 (mask)
	int x = 3;
	int n = 2;
	x = x | (1 << n);
	printf("%d\n",x);

	//Invert the mask
	// 00111 (7)
	// 00100  (mask)
	x = x ^ (1 << n);
	printf("%d\n",x);

	/*
	 * Count set of bit's (loop)
	 * i = 0
	 * x >> 0   →   00000111   (unchanged, shifting by 0 does nothing)
	 * & 1      →   00000001   →  1
	 * i = 1
	 *
	 * x >> 1   →   00000011   (everything slid right by 1, the rightmost 1 falls off)
	 * & 1      →   00000001   →  1
	 * 
	 * And so on 
	*/
	
	int count = 0;
	x = 8;
	for(int i = 0; i < 32; i++){
		if((x>>i) & 1) count++;
	}
	printf("count: %d\n",count);

	/*
	 * Kernighan trick
	 * The trick is n & (n-1) it clears the right most set bit
	 * Basically clears the least significant set bit of n
	*/
	int num = x;
	count = 0;
	while(num){
		num&=(num-1);
		count++;

	}
	printf("kernighan trick count: %d\n",count);

	buildTable();
	unsigned int test = 7;
	printf("table: %d\n",countSetBits(test));

	//GCC compiler fastest in practice
	//stand's for population count
	printf("pop_count: %d\n", __builtin_popcount(test));
	return 0;
}

```

[Kernighan Trick](https://medium.com/@wizzywooz/brian-kernighans-algorithm-c65d796a7112)

### CountSetBits

```
byte 3   byte 2   byte 1   byte 0
00000000 00000000 00000000 00000111   (this is x = 7)
```

`x & 0FF` is just eight 1-bits so `11111111` this is basically masking trick so

```
00000000 00000000 00000000 00000111   (x)
00000000 00000000 00000000 11111111   (0xFF)
-----------------------------------
00000000 00000000 00000000 00000111   (= 7)

```

Rest should be able to figure out if not practice it by hand again

---
# Tuesday

## Solution
```c
#include <stdio.h>
#include <stdint.h>
/*
 * Revers order so 110 would be 011
 */
uint32_t reverse_bits(uint32_t n){
	uint32_t result = 0;
	for (int i = 0; i < 32; i++){
		result <<= 1;
		result |= (n & 1);
		n >>= 1;
	}
	return result;
}
uint32_t reverse_bits_efficient(uint32_t n){

}
//A number is a **power of two** if it has exactly one `1` bit in binary
int powerTwo(int n){
	int x = n & (n-1);
	if (x == 0)
		return 1;
	else
		return 0;
}
uint32_t roundPower(uint32_t n){
	//1001(9)
	//1000(8)
	//0001
	/*
	int pt = n & (n-1);
	while (pt > 0){
		n+=1;
		pt = n & (n-1);
	}
	return n;
	*/

	/*
	 * so uint32_t is 32 bits so we know this is a fixed size
	 * the intuition is to push all of the 1's to the right side
	 * so we can add 1 to the binary which will push it to the next
	 * power of 2.
	*/
	n--;
	n |= n>>1;
	n |= n>>2;
	n |= n>>4;
	n |= n>>8;
	n |= n>>16;
	n++;
	return n;
}
int main(){
	int x = 8;
	uint32_t n = 0x80000000;
	printf("is power of two of %d: %d\n",x,powerTwo(x));
	printf("round power up of %d: %d\n",x,roundPower(x));
	printf("reverse bits of %d: %d\n", n, reverse_bits(n));
	return 0;
}

```

### Rounding Power Walk Through
```c
n = 19            = 00000000 00000000 00000000 00010011

n--;              // n = 18 = 00010010
                  // (subtracting 1 first ensures that if n is
                  //  already a power of 2, e.g. 16, we don't
                  //  accidentally round up to the next one)

n |= n>>1;        // n>>1 = 00001001
                  // n    = 00010010 | 00001001 = 00011011  (27)

n |= n>>2;        // n>>2 = 00000110
                  // n    = 00011011 | 00000110 = 00011111  (31)

n |= n>>4;        // n>>4 = 00000001
                  // n    = 00011111 | 00000001 = 00011111  (31, unchanged)

n |= n>>8;        // n>>8 = 0
                  // n    = 00011111 | 0 = 00011111  (31, unchanged)

n |= n>>16;       // n>>16 = 0
                  // n     = 00011111  (31, unchanged)

n++;              // n = 32
return n;         // 32 = 2^5, the next power of 2 >= 19
```

>[!important] why this works
>-  each `n |= n >> k` step "smears" the highest set bit downward - irst by 1, then 2, then 4, then 8, then 16 — so that after all the shifts, every bit at or below the original highest set bit becomes a 1. This gives you $2^{m-1}$ 
>-  **So basically this ensures that starting from the most significant bit that every bit after that is a 1**

**Smearing**:  Once you find the **leftmost (highest) 1 bit**, you turn every bit to its right into a 1 as well — filling in a solid run of 1s from that point down to bit 0.

---
# Wednesday 
## Solution

```c
#include <stdio.h>
#include <stdlib.h>

#define IS_ALIGNED(x,a) (((x) & ((a)-1))==0)
#define ALIGN_DOWN(x,a) ((x)&(~((a)-1)))
#define ALIGN_UP(x,a) ((( (a) - 1 )+ (x) )&(~((a)-1)))


int main(int argc, char **argv){
	if (argc < 2){
		printf("USAGE: a, x\n");
		return 1;
	}
	int a = atoi(argv[1]);
	int x = atoi(argv[2]);
	int is_aligned= IS_ALIGNED(x, a);
	int align_down= ALIGN_DOWN(x, a);
	int align_up = ALIGN_UP(x, a);
	printf("IS ALIGNED %d \n",is_aligned);
	printf("ALIGN DOWN %d \n",align_down);
	printf("ALIGN UP %d \n",align_up);
	return 0;
}
```

### Core idea

For a power of two `a = 2^n`, a number is a multiple of `a` **only if its bottom `n` bits are 0**.

Example: `a = 8` → bottom 3 bits must be `000`.

- `24` = `011000`  aligned
- `20` = `010100`  not aligned

### The magic mask: `a - 1`

- `a = 8` → `a - 1 = 7 = 000111`
- This is **1's in exactly the low n bits, 0 elsewhere**
- `~(a-1)` flips it → **0's in the low n bits, 1's elsewhere** → used to _clear_ those bits

### IS_ALIGNED(x, a)

**Checks:** are the low bits of `x` already 0?

```c
#define IS_ALIGNED(x,a) (((x) & ((a)-1)) == 0)
```

- `x & (a-1)` keeps only the low n bits of `x`
- if that's `0` → aligned

---

### ALIGN_DOWN(x, a)

**Does:** clear the low bits → rounds down to nearest multiple of `a`

```c
#define ALIGN_DOWN(x,a) ((x) & ~((a)-1))
```

- masking always "drops" you to the floor tile below (or stays if already on one)

---

### ALIGN_UP(x, a)

**Does:** same as ALIGN_DOWN, but nudge `x` up first so it lands on the _next_ boundary instead

```c
#define ALIGN_UP(x,a) (((x) + ((a)-1)) & ~((a)-1))
```

- add `a-1` first = "just enough" to push an unaligned value past the next boundary
- **but not enough** to push an already-aligned value further (since its low bits are already 0)

---
### Quick mental model

| Macro        | Like...           |
| ------------ | ----------------- |
| `IS_ALIGNED` | "is remainder 0?" |
| `ALIGN_DOWN` | `floor()`         |
| `ALIGN_UP`   | `ceil()`          |
###  Watch Out For 

Always wrap params in parens inside the macro (`(x)`, `(a)`), or passing an expression (like `y+1`) can silently break the math.

---
# Thursday 
## Solution

```c
#include <stdio.h>
#include <stdint.h>
#define BITS_PER_WORD 64
void bitmap_set(uint64_t *map, int n){
	map[n/BITS_PER_WORD] |= 1ULL << (n%BITS_PER_WORD);
}
//01000
//10111
void bitmap_clear(uint64_t *map, int n){
	map[n/BITS_PER_WORD] &= ~(1ULL << (n % BITS_PER_WORD));
}
//01000
//01000
//bitmap_test just reads the value of one bit — it doesn't change anything, unlike set and clear. It answers the question: "is bit n currently 1 or 0?"
int bitmap_test(uint64_t *map, int n){
	return map[n/BITS_PER_WORD] >> (n % BITS_PER_WORD) & 1ULL;//not int 1 would also work
}
//01000
//
long bitmap_find_first_zero(uint64_t *map, int n){
	for(int i = 0; i < n; i++){
		for (int b = 0; b < BITS_PER_WORD; b++){
			if(!((map[i] >> b) & 1ULL)){
				return i * BITS_PER_WORD + b;
			}
		}
	}
	return -1;
}

int main(){
	uint64_t map[1024];
	for (int i = 0; i < 1024; i++){
		map[i] = 0;
	}
	bitmap_set(map, 0); //mark page 0 as used
	bitmap_set(map, 2); //mark page 0 as used
	bitmap_set(map, 130); //mark page 0 as used
	printf("%d\n", bitmap_test(map, 1));
	printf("%d\n", bitmap_test(map, 5));
	long free_page = bitmap_find_first_zero(map,1024);
	printf("Find free page: %ld\n", free_page);
	return 0;
}
```

## What is a bitmap?

- A bitmap is just a way to represent things 
- Typically used in graphics and OS development where bit maps represent used pages
- So it's a long row of 0's and 1's where each position (bit) is a yes or no for one thing
- Kernel programming use it to represent pages of memory `0` = free `1` = used

## Solution Notes

- `BITS_PER_WORD` is not about page size
	- It describes the container using for storage in this case `uint64_t`
	
### What each thing represents

- **Page** = a chunk of physical memory (4KB) This is real world thing tracking
- **Bit** = one yes/no flag representing one page's status. One bit per page not related to the page's actual byte size at all
- **Word** (`map[0]`,`map[1]`, ...) = a storage container that holds 64 of these bits at once 
### Concrete Example

If `BITS_PER_WORD = 64` and you have `map[1024]`:

- Total bits available = `1024 * 64 = 65,536`
- That means you can track **65,536 pages**, each represented by exactly 1 bit
- Page `n`'s bit lives at `map[n / 64]`, bit position `n % 64`
- Have 1024 words

### bitmap_set

- Shift's 1 over by the specific bit position given
- Use `1ULL` since this guarantee's 64 bits 

### bitmap_clear

- Does the same thing as set but takes the & with ~ since anything that is a 1 will remain an 1 and this clears a specific bi'ts position 
Ex:

Same setup: pretend `BITS_PER_WORD = 8` for a small, easy-to-see example.

```
word = 0b01011100
```

Bit positions (from the right, starting at 0):

```
position:  7  6  5  4  3  2  1  0
bit:       0  1  0  1  1  1  0  0
```

**Calling `bitmap_clear(map, 2)`**

c

```c
map[0] &= ~(1ULL << 2);
```

Step 1 — build the mask (`1` shifted into position 2):

```
mask:   00000100
```

Step 2 — invert the mask (`~mask`) — flip every bit, so position 2 is the _only_ 0, everything else is 1:

```
~mask:  11111011
```

Step 3 — AND the original word with `~mask`:

```
  01011100
& 11111011
= 01011000
```

**Result: `0b01011000`** → bit 2 is now `0` (cleared). Every other bit is untouched — compare `01011100` → `01011000`, only position 2 changed.


**Why `~mask` works — the key idea**

- The mask has a single `1` at the target position, `0` everywhere else.
- Inverting it flips that: now it's `0` at the target position, `1` everywhere else.
- AND-ing with this means: "force the target position to 0 (since anything AND 0 is 0), and leave every other bit as-is (since anything AND 1 stays the same)."

### bitmap_test

- bitmap_test just reads the value of one bit — it doesn't change anything, unlike set and clear. It answers the question: "is bit n currently 1 or 0?"
- This performs the **shift first** then the `&`
- So it' shifting the page by the number of bits for a specific bit position then &'ing it with 1 to check to see if that value is a 1 or 0.
Ex:
`word = 0b01011100`

```
position:  7  6  5  4  3  2  1  0
bit:       0  1  0  1  1  1  0  0
```

Calling `bitmap_test(map, 2)`

`return (map[0] >> 2) & 1ULL;`

Step 1 — shift right by 2 (slide everything toward position 0):

```
before:  01011100
after:   00010111   <- original bit 2 is now sitting at position 0
```

Step 2 — mask with `1` (keep only position 0, zero out the rest):

```
00010111
&
00000001
=
00000001
```

**Result: `1`** → bit 2 was set (used).

**Takeaway**

> `bitmap_test(map, n)` = shift the word right by `n` (drag the bit you care about down to position 0), then `& 1` to read just that bottom bit. Result is `1` if that page is used, `0` if it's free
> 
### bitmap_find_first_zero

- Loop through entire map so each word and check if it has been set to a 1 so if it's in use basically

**`bitmap_find_first_zero` — 8-bit Example**

Same small setup: `BITS_PER_WORD = 8`, and let's use two words this time so you can see the loop cross from one word to the next.

```
map[0] = 0b11111111   (all 8 pages in this word are used)
map[1] = 0b00001011   (pages 0,1,3 used; page 2 is free)
```

Bit positions in `map[1]` (from the right, starting at 0):

```
position:  7  6  5  4  3  2  1  0
bit:       0  0  0  0  1  0  1  1
```

**Walking through the function**

c

```c
long bitmap_find_first_zero(uint64_t *map, int n){
	for(int i = 0; i < n; i++){
		for (int b = 0; b < BITS_PER_WORD; b++){
			if(!((map[i] >> b) & 1ULL)){
				return i * BITS_PER_WORD + b;
			}
		}
	}
	return -1;
}
```

**Outer loop, `i = 0`** — checking `map[0] = 0b11111111`

Inner loop tries `b = 0` through `b = 7`. At every single position, the bit is `1`, so `!((...) & 1ULL)` is `!1` = `false` each time. The inner loop finishes without ever returning — `map[0]` has no free bits at all.

**Outer loop, `i = 1`** — checking `map[1] = 0b00001011`

- `b=0`: shift by 0 → `00001011` → `&1` → `1` → not zero, keep going
- `b=1`: shift by 1 → `00000101` → `&1` → `1` → not zero, keep going
- `b=2`: shift by 2 → `00000010` → `&1` → `0` → **zero found!**

Return value: `i * BITS_PER_WORD + b = 1 * 8 + 2 = 10`

**Result: `10`**

That's the overall bit index counting across both words: `map[0]` covers positions 0–7 (all used), and `map[1]` covers positions 8–15 — bit 2 _within_ `map[1]` is overall position `8 + 2 = 10`, which is the first free page across the whole bitmap.

**Takeaway**

> `bitmap_find_first_zero` scans word by word (outer loop), and bit by bit within each word (inner loop), always checking lowest index first. The moment it finds a `0` bit, it converts the (word, position) pair back into one overall page number with `i * BITS_PER_WORD + b`, and returns immediately — it does not need to finish scanning once it finds a hit.

---
# Friday

## Solution

```c
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

const unsigned char * hexdump(const void *ptr, size_t size){
	const unsigned char *bytes = (unsigned char *)ptr;
	for (size_t i = 0; i < size; i++){
		printf("%02x ", bytes[i]);
	}
	printf("\n");
	return bytes;
}

int main(){
	// --- Endianness check ---
	uint32_t endian_val = 1;
	const unsigned char *ebytes = hexdump(&endian_val, sizeof(endian_val));
	if (ebytes[0] == 1) {
		printf("Little Endian\n");
	} else {
		printf("Big Endian\n");
	}

	printf("\n");

	// --- IEEE-754 float decode ---
	float val = 1.0f;
	const unsigned char *bytes = hexdump(&val, sizeof(val));
	uint32_t as_int = (bytes[3] << 24) | (bytes[2] << 16) | (bytes[1] << 8) | bytes[0];
	uint32_t sign_bit = (as_int >> 31) & 1;
	uint32_t exponent  = (as_int >> 23) & 0xFF;
	uint32_t mantissa  = as_int & 0x7FFFFF;

	printf("as int: %u\n", as_int);
	printf("sign_bit: %u\n", sign_bit);
	printf("exponent: %u (unbiased: %d)\n", exponent, (int)exponent - 127);
	printf("mantissa: %u\n", mantissa);

	return 0;
}

```

- The mistake I made was casting each individual val as different types i.e `float`, `int`, etc.. 
- Need to using `uint32_t`
- Endianness is about byte order — how a multi-byte value's bytes get arranged in memory addresses. It applies to any multi-byte type equally (`int`, `float`, `uint32_t`, pointers, struct fields) and doesn't care what the bits mean.
- IEEE-754 is about bit meaning — once you have the bytes in the correct logical order, how those bits are carved up into sign/exponent/mantissa to represent a real number. It doesn't care what order the bytes were physically stored in — that's why the first step of decoding a float was always "reassemble into as_int correctly, accounting for endianness" before doing any bit-splitting
- **IEEE-754**: 1 Sign Bit, 8 Exponent Bits, 23 Mantissa bits, 32 total bits
