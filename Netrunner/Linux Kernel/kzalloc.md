---
title: kzalloc
source: "[[kernel]]"
tags:
  - linux
  - kernel
  - kernel-func
type: reference
created: 2026-09-27
---
## What is kzalloc

`kzalloc` is a Linux kernel function that grabs a chunk of memory for you and wipes it clean (sets every byte to zero) before giving it to you. It's basically `kmalloc` (get memory) plus `memset` (clear it to zero), done in one step.

---
## Example / Usage

```c
struct my_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
if (!dev)
    return -ENOMEM;   // out of memory, bail out

/* ... use dev ... */

kfree(dev);           // give the memory back when done
```

- `sizeof(*dev)` is how much memory you want.
- `GFP_KERNEL` is the normal choice. It means "it's okay to wait if memory is tight."
- Use `GFP_ATOMIC` instead if you're somewhere that can't wait (like an interrupt handler or while holding a spinlock).
- Returns a `void *` to a block of memory

---

## When to Use

- When you're creating a new struct and want every field to start at zero, `NULL`, or `false`.
- When you want to avoid bugs from leftover junk data in memory.
- When the memory might end up being copied to userspace. Zeroing it first stops old kernel data from leaking out.
- In general, it's the safe default for allocating structs in the kernel.

---

## Watch Out For

- **Always check for `NULL`.** If there's no memory available, `kzalloc` returns `NULL` and you need to handle it.
- **Always free it with `kfree`.** Forgetting causes a memory leak.
- **Pick the right flag.** Using `GFP_KERNEL` in a spot that can't sleep (interrupts, spinlocks) can crash or hang the system.
- **It's not for huge allocations.** For large chunks, use `kvzalloc` instead, which can handle memory that isn't in one continuous block.
- **For arrays, use `kcalloc`.** It zeroes the memory too and also protects against math overflow when calculating the size.
- **In drivers, consider `devm_kzalloc`.** It frees the memory automatically when the driver is removed, so you don't have to remember to call `kfree`.