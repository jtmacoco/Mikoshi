---
title: Kernighan Trick
source: "[[Bit Manipulation]]"
tags:
  - "#c"
  - "#bit-manipulation"
type: reference
created: 2026-07-05
---

## What is Kernighan Trick

Kernighan's trick repeatedly removes the least significant set of bit of an integer using `n &= (n-1`, allowing efficient operations on only the set bits. 

>[!tip] key idea
>When you subtract 1 from a binary number the rightmost 1 becomes a 0. so continuously doing this will count the number of 1's 

---

## Example / Usage

```c
int count = 0;
while (n) {
    n &= (n - 1);  // Remove the lowest set bit
    count++;
}
```

---

## When to Use

- Often used to count number of 1's in a binary representation of a number
- Count set bits
- Check if a number is power of two
- Iterate through all set bits of a bitmask effciently

---

## Watch Out For

1. `n` must eventually become 0
2.  Be careful with signed integers if `n` is negative, the bit pattern depends on two's complement representation, and the meaning of the bits may not be what you intend
3.  `n-1` changes only the lowest set bit

|         Value | b7  | b6  | b5  | b4  | b3  | b2  | b1  | b0  |
| ------------: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|           `n` |  1  |  0  |  1  |  1  |  0  |  0  |  0  |  0  |
|           `1` |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  1  |
|       `n - 1` |  1  |  0  |  1  |  0  |  1  |  1  |  1  |  1  |
| `n & (n - 1)` |  1  |  0  |  1  |  0  |  0  |  0  |  0  |  0  |
4. Only works for clearing lowest set bit. Sof if need to inspect every bit including zero's this won't work
5. **Time complexity** depends on the number of 1's
	1. Best case: $O(1)$
	2. Worse case: $O(32)$ (uint32_t)
	3. In general: $O(\text{popcount}(n))$ (`popcount` is a function that counts the number of 1 bits in a value)
