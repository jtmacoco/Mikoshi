---
title: Unions
source: "[[C]]"
tags:
  - c
  - unions
created: 2026-07-03
---

## What is Unions

A union lets multiple members share the same memory address.
Only one member holds a value at a time.

---

## Example / Usage

[[Netrunner]]

```c
struct Color {
    union {
        struct { unsigned char r, g, b, a; };  // 4 bytes, one after another
        unsigned int packed;                   // 4 bytes, same memory
    };
}
```

- `r, g, b, a` access individual bytes
- `packed` reads all 4 bytes as one unsigned int
- Both point to the same memory - changing one changes the other

---

## When to Use

- Interpreting raw bytes multiple ways (Color, floats, network packets, etc.)
- Memory-constrained systems
- Kernel driver data packing

---

## Watch Out For

- Endianness affects byte order of packed
- Writing to one member invalidates the others

```c
union U {
    int i;
    float f;
};

U u;
u.i = 42;      // write to i
float x = u.f; // read f — this is the "invalidation" issue
```

`x` will output nonsense since `u.i` puts an `int`'s bit pattern into that storage

---

## Links

