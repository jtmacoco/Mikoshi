---
title: struct file
source: "[[kernel]]"
tags:
  - kernel
  - drivers
type: reference
created: 2026-09-29
---
## What is struct file

`struct file` is the kernel's record of **one open instance** of a file. Every successful `open()` creates a new one, even when the same file is opened many times, and it is freed when the last reference is closed.

It lives in **kernel memory only**. Userspace never sees it; a program just gets back a **file descriptor** (an integer like 3) that the kernel maps to this struct.

Key fields:
- `f_flags`: flags passed to `open()` (`O_RDONLY`, `O_NONBLOCK`, `O_APPEND`...)
- `f_mode`: what this open may do (`FMODE_READ`, `FMODE_WRITE`, `FMODE_LSEEK`...)
- `f_pos`: current read/write position
- `f_op`: pointer to the `file_operations` (your driver's `open`, `read`, `write`...)
- `private_data`: a free `void *` for the driver to store per-open state
- `f_inode`: the inode this file refers to (get it with `file_inode(filp)`)

**Not the same as userspace `FILE *`:**
```
Userspace:  FILE *  →  wraps fd (e.g. 3)
                           │  system calls
Kernel:               struct file  →  struct inode
```
`FILE *` is a C library buffer in the program's memory; `struct file` is the kernel's own bookkeeping.

---
## Analogy

A library:
- **inode** = the book's **catalog card**: one per book, describes the book itself
- **struct file** = a **borrowing slip**: one per checkout, tracks *that* reader's session (current page, read-only or not)
- **file descriptor** = the **ticket number** handed to the reader
- **`FILE *`** = the reader's own **notebook** holding the ticket number plus notes

Ten people borrowing the same book → one catalog card, ten slips.

---

## Example / Usage

```c
struct my_state {
    int count;
};

static int my_open(struct inode *inode, struct file *filp)
{
    struct my_state *st = kzalloc(sizeof(*st), GFP_KERNEL);
    if (!st)
        return -ENOMEM;
    filp->private_data = st;              // per-open state lives here

    pr_info("flags = 0x%x\n", filp->f_flags);
    if (filp->f_flags & O_NONBLOCK)
        pr_info("opened non-blocking\n");
    return nonseekable_open(inode, filp);
}

static ssize_t my_read(struct file *filp, char __user *ubuf,
                       size_t len, loff_t *off)
{
    struct my_state *st = filp->private_data;   // get it back
    st->count++;
    return 0;
}

static int my_release(struct inode *inode, struct file *filp)
{
    kfree(filp->private_data);            // clean up on last close
    return 0;
}
```

---

## When to Use

- Storing **per-open state** (buffers, counters, session info) → `filp->private_data`
- Checking **how** the file was opened (`O_NONBLOCK`, read vs write) → `f_flags` / `f_mode`
- Getting the file's path for logging → `file_path(filp, buf, len)`
- Reaching the inode from `read`/`write`/`ioctl` → `file_inode(filp)`
- It's passed to nearly every `file_operations` method, so it's your main handle inside a driver

---

## Watch Out For

- **Not the same as `FILE *`** from `stdio.h`; totally separate layers.
- **One per open, not per device.** Device-wide state belongs in your driver's struct, not in `private_data` of a single file.
- `release` runs on the **last close**, not every `close()`. After `fork()` or `dup()`, several fds share one `struct file`.
- Use `*off` (the `loff_t *` argument) in `read`/`write` rather than touching `filp->f_pos` directly.
- Free anything you put in `private_data` in `release`, or it leaks.
- In a **misc driver**, the misc core sets `private_data` to your `struct miscdevice *` before calling `open`. If you overwrite it, save that pointer first if you need it.



