---
title: inode
source: "[[kernel]]"
tags:
  - kernel
  - drivers
  - vfs
type: reference
created: 2026-09-29
---
## What is inode

`struct inode` is the kernel's in-memory representation of a **file on a filesystem** (including device nodes like `/dev/miscdrv`). There is exactly **one inode per file**, shared by everyone who opens it.

For a device file, the inode holds:
- `i_rdev`: device number (major:minor), used to route `open()` to the right driver
- `i_mode`: file type (char/block device) + permission bits
- `i_cdev`: pointer to the `struct cdev` backing a char device
- ownership, timestamps, etc.

**inode vs file:**

| `struct inode`      | `struct file` (`filp`)                             |
| ------------------- | -------------------------------------------------- |
| The file itself     | One *open instance* of the file                    |
| One per device node | New one on every `open()`                          |
| Static metadata     | Per-open state: `f_flags`, `f_pos`, `private_data` |

---

## Example / Usage

```c
static int my_open(struct inode *inode, struct file *filp)
{
    unsigned int major = imajor(inode);
    unsigned int minor = iminor(inode);   // which device instance?

    /* Get driver's private struct from the embedded cdev */
    struct my_dev *dev = container_of(inode->i_cdev, struct my_dev, cdev);
    filp->private_data = dev;             // stash for read/write/ioctl

    pr_info("opened %u:%u\n", major, minor);
    return nonseekable_open(inode, filp); // passes inode through; marks filp non-seekable
}
```

In a **misc driver**, the misc core already sets `filp->private_data` to your `struct miscdevice *` before calling your `open`, so the inode often goes unused except for passing it along.

---

## When to Use

- Identifying **which device instance** was opened when one driver handles several minors → `iminor(inode)`
- Getting to your **driver's private data** via `container_of(inode->i_cdev, ...)` in classic cdev drivers
- Checking file **type or permissions** (`i_mode`)
- Passing to helpers that expect it: `nonseekable_open()`, `stream_open()`, `simple_open()`

---

## Watch Out For

- **Don't store per-open state in the inode.** It's shared across all opens and processes; use `filp->private_data` instead.
- The inode is only passed to `open` and `release`. In `read`/`write`/`ioctl`, get it via `file_inode(filp)` if you really need it.
- Use `imajor()`/`iminor()` rather than poking `i_rdev` bits directly.
- `file_path(filp, ...)` gets the path from the **file** (dentry), not the inode. An inode can have multiple paths (hard links) or none.
- For misc devices the major is always **10**; don't rely on it to distinguish your device.

