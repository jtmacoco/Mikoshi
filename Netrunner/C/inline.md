---
title: inline
source: "[[C]]"
tags:
type: reference
created: 2026-08-08
---
## What is inline

A compiler hint that says: "instead of generating a function call to this function, paste its body directly at the call site." It only affects call overhead — it does not skip type-checking, bounds-checking, or any other compiler safety. It's just a hint; the compiler can ignore it, and modern compilers often auto-inline small functions on their own without being asked.

It also has a secondary, unrelated effect in C: it changes linkage rules so a function can be defined in a header file without causing "multiple definition" errors across files. That's a technicality, not a performance feature.

---

## Example / Usage

```c
static inline int rb_is_full(const ring_buffer_t *rb) {
    return (rb->head - rb->tail) == RB_SIZE;
}

// at the call site, this:
if (rb_is_full(rb)) { return -1; }

// effectively becomes (after inlining):
if ((rb->head - rb->tail) == RB_SIZE) { return -1; }
```

No jump, no call, no return — just the comparison pasted directly in.

---

## When to Use

- Function is **small** (one-liner: a comparison, a simple calc, a trivial getter/setter)
- Function is **called very frequently** (hot loop / hot path)
- Function is used **internally** within the same module, not part of a big external API

Example from the ring buffer: `rb_is_full` / `rb_is_empty` — one line, called on every put/get → inline.
`rb_put` / `rb_get` — do more work (bounds check + write + increment) and are the public API → not inlined.

---

## Watch Out For

- It's a **hint**, not a guarantee — compiler can ignore it
- Doesn't make code "unsafe" or skip checks — common misconception
- Only helps when call overhead is actually significant relative to the function's work; inlining a big function bloats code size for little/no speed gain
- Don't reach for it reflexively — for anything more than a couple lines, let the compiler's optimizer decide