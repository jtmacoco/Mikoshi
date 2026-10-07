---
title: Static
source: "[[C]]"
tags:
  - c
  - types
type: reference
created: 2026-10-06
---

## What is Static

`static` is a C storage-class specifier (not a type). It means two different things depending on where it's used:

- **On a function or file-level (global) variable:** limits visibility to the current `.c` file (*internal linkage*). Other files can't see or call it, and can reuse the same name without conflict.
- **On a variable inside a function:** the variable keeps its value between calls (*static storage duration*). It's created once, not on every call, but is still only accessible inside that function.

Without `static`, functions and globals have *external linkage*: visible to the linker and every other file in the program (or the entire kernel).

---
## Analogy

- **Static function/global** = a private room in your house. Everyone in your house (the `.c` file) can use it; neighbors (other files) can't even see it. A neighbor can have their own room with the same name and nothing clashes.
- **Static local variable** = a notepad left on your desk. Each time you come back to the desk (call the function), what you wrote last time is still there.

---

## Example / Usage

```c
/* File-level: private to this file */
static int open_miscdrv(struct inode *inode, struct file *filp)
{
    return 0;
}

static int device_count;   /* global, but only visible in this file */

/* Still callable by the kernel through a function pointer */
static const struct file_operations llkd_misc_fops = {
    .open = open_miscdrv,
};

/* Init/exit are usually static too */
static int __init miscdrv_init(void) { return 0; }
static void __exit miscdrv_exit(void) { }
module_init(miscdrv_init);
module_exit(miscdrv_exit);

/* Inside a function: keeps its value between calls */
void count_calls(void)
{
    static int n = 0;   /* initialized once */
    n++;                /* 1, 2, 3, ... across calls */
}
```

---

## When to Use

- Any function or global variable used **only within one `.c` file**. In a single-file kernel driver, that's almost everything.
- Fixes the kernel warning: `no previous prototype for function 'x'` (`-Wmissing-prototypes`).
- Avoids name collisions in the kernel's single shared namespace.
- Lets the compiler inline or remove unused functions.
- Inside a function, when you need state that persists across calls (counters, one-time init flags).

**Leave `static` off when:**
- Another `.c` file in the same driver calls the function → declare it in a shared header.
- You export it to other modules with `EXPORT_SYMBOL()` / `EXPORT_SYMBOL_GPL()`.

---

## Watch Out For

- **`static` ≠ global.** At file level it does the opposite: it makes things *less* visible.
- **Two meanings.** At file level it changes *visibility*; inside a function it changes *lifetime*.
- **It hides the name, not the function.** A static function can still be called through a pointer (e.g., `file_operations`), which is how the kernel calls your driver's `open`/`read`.
- **Don't silence `-Wmissing-prototypes`** by adding a prototype at the top of the same `.c` file. Use `static`, or a real shared header.
- **Static locals are shared state.** Every call (and every thread or CPU in the kernel) sees the same variable, so concurrent access needs locking or atomics.
- **Static locals are initialized only once**, with a constant expression; the initializer doesn't re-run on each call.
- **Userspace vs kernel:** plain `gcc` doesn't warn by default, but the kernel enables `-Wmissing-prototypes`, and with `CONFIG_WERROR=y` the warning becomes a build error.



