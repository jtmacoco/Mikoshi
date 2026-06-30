**Source**: [[Linux Kernel Contribution]]
**Tags**: #linux #on-contract
**Description**: Week two notes on bit map solutions

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