---
title: Twos Complement
source: "[[C]]"
tags:
type: cheatsheet
created: 2026-07-05
---

## What is Twos Complement

**Two’s complement** is a signed binary representation where negative numbers are formed by inverting all bits and adding 1, allowing a single zero and efficient arithmetic using standard binary addition.

---

## Example / Usage

### Example: Convert +5 to -5 in Two’s Complement (4-bit)

```c
Step 1: Start with +5 in binary
+5 = 0101

Step 2: Take One’s Complement (flip all bits)
0101 → 1010   (this is -5 in 1’s complement)

Step 3: Add 1
1010
+   1
-----
1011

Result:
-5 = 1011 (in 2’s complement)
```


---

## When to Use

You use **two’s complement** basically whenever you need to represent **signed integers in binary on real computers**.

---

## Table
| Binary | Unsigned | Two’s Complement Value |
| ------ | -------- | ---------------------- |
| 0000   | 0        | 0                      |
| 0001   | 1        | 1                      |
| 0010   | 2        | 2                      |
| 0011   | 3        | 3                      |
| 0100   | 4        | 4                      |
| 0101   | 5        | 5                      |
| 0110   | 6        | 6                      |
| 0111   | 7        | 7                      |
| 1000   | 8        | -8                     |
| 1001   | 9        | -7                     |
| 1010   | 10       | -6                     |
| 1011   | 11       | -5                     |
| 1100   | 12       | -4                     |
| 1101   | 13       | -3                     |
| 1110   | 14       | -2                     |
| 1111   | 15       | -1                     |





