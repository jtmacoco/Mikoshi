---
title: C
source: "[[Linux Kernel Contribution]]"
tags:
  - linux
created: 2026-07-04
status: on-contract
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
