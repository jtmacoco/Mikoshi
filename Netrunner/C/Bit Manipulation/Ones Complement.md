---
title: Ones Complement
source: "[[C]]"
tags:
type: cheatsheet
created: 2026-07-05
---

## What is Ones Complement

**One’s complement** is a signed binary representation where negative numbers are formed by flipping every bit of the corresponding positive number, which results in both a positive and negative zero.

---

## Example / Usage

In a 4-bit one’s complement system:
```c
+5  = 0101  
-5  = 1010  (flip all bits)

However:
+0  = 0000  
-0  = 1111  ← duplicate zero problem
```



---

## When to Use

Don't really use anymore

---

## Watch Out For 

- Can have negative 0

```c
+0 = 0000  
-0 = 1111 ← duplicate zero problem
```

| Binary | Value (Unsigned) | One’s Complement Value |
| ------ | ---------------- | ---------------------- |
| 0000   | 0                | +0                     |
| 0001   | 1                | +1                     |
| 0010   | 2                | +2                     |
| 0011   | 3                | +3                     |
| 0100   | 4                | +4                     |
| 0101   | 5                | +5                     |
| 0110   | 6                | +6                     |
| 0111   | 7                | +7                     |
| 1000   | 8                | -7                     |
| 1001   | 9                | -6                     |
| 1010   | 10               | -5                     |
| 1011   | 11               | -4                     |
| 1100   | 12               | -3                     |
| 1101   | 13               | -2                     |
| 1110   | 14               | -1                     |
| 1111   | 15               | **-0** ⚠️              |





