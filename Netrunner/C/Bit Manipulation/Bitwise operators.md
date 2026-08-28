---
title: Kernighan Trick
source: "[[C]]"
tags:
  - bit-manipulation
type: cheatsheet
created: 2026-07-05
---

## What is Bitwise operators

Bitwise operators work on the binary representation of integers, one bit at a time

---
# Cheat sheet

| Operator             | Symbol | Name                      | Example (`a=5, b=3`) |
| -------------------- | ------ | ------------------------- | -------------------- |
| AND                  | `&`    | Bitwise AND               | `5 & 3 = 1`          |
| OR                   | `\|`   | Bitwise OR                | `5 \| 3 = 7`         |
| XOR                  | `^`    | Bitwise XOR               | `5 ^ 3 = 6`          |
| NOT                  | `~`    | Bitwise NOT               | `~5 = -6`            |
| Left Shift           | `<<`   | Shift Left                | `5 << 1 = 10`        |
| Right Shift          | `>>`   | Shift Right               | `5 >> 1 = 2`         |
| Unsigned Right Shift | `>>>`  | Zero-fill Shift (JS/Java) | `-5 >>> 1`           |

`5 = 0101`, `3 = 0011` in binary (4-bit examples below).

---

## Truth Tables

### AND (`&`) — 1 only if both bits are 1

|A|B|A & B|
|---|---|---|
|0|0|0|
|0|1|0|
|1|0|0|
|1|1|1|

### OR (`|`) — 1 if at least one bit is 1

|A|B|A \| B|
|---|---|---|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|1|

### XOR (`^`) — 1 if bits are different

|A|B|A ^ B|
|---|---|---|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|0|

### NOT (`~`) — flips every bit

|A|~A|
|---|---|
|0|1|
|1|0|

> `~x` is equivalent to `-x - 1` in two's complement systems.

### XNOR

| A   | B   | A ⊙ B (XNOR) |
| --- | --- | ------------ |
| 0   | 0   | 1            |
| 0   | 1   | 0            |
| 1   | 0   | 0            |
| 1   | 1   | 1            |

---

## Worked Example

```
  0101   (5)
& 0011   (3)
------
  0001   (1)

  0101   (5)
| 0011   (3)
------
  0111   (7)

  0101   (5)
^ 0011   (3)
------
  0110   (6)
```

---

## Shift Operators

|Operator|Effect|Example|
|---|---|---|
|`x << n`|Shift bits left by `n`, fill with 0s. Equivalent to `x * 2^n`|`5 << 2 = 20`|
|`x >> n`|Shift bits right by `n`, sign-extend (arithmetic shift). Equivalent to `x / 2^n` (floor)|`-8 >> 1 = -4`|
|`x >>> n`|Shift right, fill with 0s regardless of sign (logical shift)|`-8 >>> 1 = large positive #`|

---

## Common Tricks & Idioms

|Goal|Code|Notes|
|---|---|---|
|Check if even/odd|`x & 1`|`0` = even, `1` = odd|
|Multiply by 2ⁿ|`x << n`|Faster than `*` in some contexts|
|Divide by 2ⁿ|`x >> n`|Floor division for positive numbers|
|Check if power of 2|`x != 0 && (x & (x - 1)) == 0`|Powers of 2 have exactly one bit set|
|Swap two variables|`a ^= b; b ^= a; a ^= b;`|No temp variable needed|
|Set a bit|`x \| (1 << n)`|Turns bit `n` to 1|
|Clear a bit|`x & ~(1 << n)`|Turns bit `n` to 0|
|Toggle a bit|`x ^ (1 << n)`|Flips bit `n`|
|Check a bit|`(x >> n) & 1`|Returns 0 or 1|
|Get lowest set bit|`x & (-x)`|Isolates rightmost 1-bit|
|Clear lowest set bit|`x & (x - 1)`|Useful for counting set bits|
|Count set bits (Brian Kernighan)|Loop `x &= (x-1)` until `x==0`, count iterations|O(number of 1 bits)|
|Absolute value (no branch)|`(x ^ (x >> 31)) - (x >> 31)`|32-bit signed int trick|
|Check opposite signs|`(a ^ b) < 0`|True if signs differ|

---

## Bit Flags / Masks Pattern

```python
READ    = 1 << 0   # 0001
WRITE   = 1 << 1   # 0010
EXECUTE = 1 << 2   # 0100

perms = READ | WRITE          # combine flags -> 0011
has_write = perms & WRITE     # check flag    -> truthy
perms &= ~WRITE                # remove flag   -> 0001
perms ^= EXECUTE               # toggle flag   -> 0101
```

---

## Operator Precedence Gotcha

In many languages (C, Python, JS), `&`, `|`, `^` have **lower precedence** than comparison operators.

```python
# Wrong — evaluates as x & (1 == flag)
if x & 1 == flag:

# Right — use parentheses
if (x & 1) == flag:
```

Always wrap bitwise expressions in parentheses when mixing with comparisons.

---

## Quick Reference Table

| Expression        | Meaning                               |
| ----------------- | ------------------------------------- |
| `x & (x-1)`       | Clear lowest set bit                  |
| `x & -x`          | Isolate lowest set bit                |
| `x \| (x+1)`      | Set lowest cleared bit                |
| `x ^ (x & (x-1))` | Extract lowest set bit (alt)          |
| `~x + 1`          | Two's complement negation (`-x`)      |
| `x & (n-1)`       | Fast `x % n` when `n` is a power of 2 |
