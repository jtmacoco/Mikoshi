---
type: datashard
category: book-chapter
book: "[[Linux Kernel Programming]]"
author: Kaiwan N. Billimoria
chapter: 1
chapter_title: Writing a Simple misc Character Device Driver
status: in-progress
tags:
  - book-notes
  - kernel
  - c
date_started: 2026-09-16
last_updated: 2026-09-28
---

## TL;DR
> Keep this updated as your understanding sharpens — it's fine if it's rough or wrong early on.

---
## Table of Contents
```dataviewjs
const path = dv.current().file.path;
const file = app.vault.getAbstractFileByPath(path);
const headings = app.metadataCache.getFileCache(file)?.headings ?? [];

if (headings.length === 0) {
  dv.paragraph("No sections found.");
} else {
  const minLevel = Math.min(...headings.map(h => h.level));
  const md = headings
    .map(h => `${"\t".repeat(h.level - minLevel)}- [[#${h.heading}|${h.heading}]]`)
    .join("\n");
  dv.paragraph(md);
}
```

## Vocabulary / Key Terms
<!-- Add terms the moment you hit them, even before you fully understand them -->

| Term             | Definition                                        | Notes |
| ---------------- | ------------------------------------------------- | ----- |
| Device Driver    | Interface between OS and peripheral hw device     |       |
| Device File/Node | Entry point into device driver                    |       |
| Major Number     | Represents the class of device                    |       |
| Minor Number     | The interpretation of the device                  |       |
| LDM              | Linux Device Model                                |       |
| Device           | Physical (or virtual) thing itself, so like a USB |       |
| Driver           | Software that knows how to talk to the device     |       |
| Fops             | File Operations                                   |       |
| VFS              | Virtual Filesystem Switch                         |       |
| `dd(1)`          | Disk Duplicator                                   |       |

---

## Core Concepts
<!-- One entry per idea — add as you encounter them, expand later -->

- **Concept:**
  - Why it matters:
  - Related to: 

---

## Assumed Knowledge

- General Linux knowledge is needed

---

## Session Log
<!-- Running, dated notes — Newest entry on top. -->

### 2026-09-30
- kernel provides inline functions to transfer data from kernel to user space and vice versa
	- `copy_to_user()`
	- `copy_from_user()`
	- Return value is number of uncopied bytes 
	- A non-zero values = error 


### 2026-09- 29
- Kernel VFS will auto-invoke driver's `f_op` methods
- Can test the practice misc driver made with `dd(1)` 
- `copy_from_user()` **can only be used in a process context where it's safe to sleep and never in any kind of atomic or interrupt context**

**Code Section**: [[#09/29/26 Code]]
### 2026-09- 28
- `errno` value returned by VFS not very intuitive
	- If set `read()` func ptr of `f_op` to `NULL`, VFS will cause `EINVAL` value saying this failed because of invalid arg which is not right
	- `lseek()` system call that has driver seek specific location in file aka the device we are writing
	- kernel names `f_op` function pointer as `llseek` this is to remind us that the return value from `lseek` can be 64-bit (long long) quantity
	- **Issue**: If we don't implement `llseek` it still returns a random positive value causing the user mode app to think it succeed; To fix do this 
		1. Set `llseek` to the special `no_llseek` value
		2. Invoke the `nonseekable_open()` func in driver's `open()` method, specifying that the file is non-seekable

### 2026-09- 27

> Go over `nonseekable_open()` I kinda skipped this part
- When writing a device driver use the `dev_*()` family so `dev_info()`, `dev_warn()`, `dev_err()`, `dev_dbg()`, etc. Rather than `printk()` or `pr_*()` (`pr_info()`, `pr_err()`)
- `dev_*()` routines take a pointer to a `struct device` as their first arg, so the kernel uses it to automatically prefix each message with info about which device printed it
- How should the driver author implement the different `f_ops` for a driver?
	- **Key Point**: signature of our `f_ops` function say `open` function, it should be identical to the `file_operation` structure `open`
	- This is true for any function
- `file_path()` gets the path of a file
**Code Section**: [[#09/27/26 Code]]

### 2026-09- 24
- If a method is unsporrted say we didn't write the `fops` function for it like `poll()`
	- VFS will detect `fops` pointer so `poll` and then it returns the correct negative integer signaling a fail
	- Important, think back to semantics in programming languages if left undefined could cause issues


### 2026-09- 23
- All `misc` drivers are of the character type 
- When a user-space process/thread opens a device file registered to this driver (via the misc framework), the kernel VFS allocates and initializes a `struct file` for that open and sets its `f_op` to the driver's `file_operations` (from `.fops` in `struct miscdevice`), so later calls like `read()`/`write()` are routed to the driver's functions. [[#VFS & FOPS]]
- If a process opens drivers device file via the `open` system call the driver should issue the related system file call `foo` (for example) on that device file
	- Function will change based on system call say `open` or `read`
	- Each system call maps to its own slot in the fops table, so a different driver function runs for each operation

### 2026-09- 21
- I fixed my linux setup to have correct heaers and nvim setup, lsp didn't have clang
- `misc_register()` API takes one parameter, a ptr to a data struct of type `miscdevice`
- All `misc` drivers are character type and use the same **major number 10** 
- `file_operations` struct or **fops** contains function pointers (think of as **virtual methods**) which are possible system calls that could be issued to the (device) file; such as `read`, `write`, `poll`, etc...
	- Basically has a bunch of function pointers to do stuff
	- It's kernel's way of doing polymorphism in
	- **I/YOU NEED TO SET THESE FUNCTION POINTERS**
	- This is like saying hey these are the function pointers you can use with this driver I'm making
	
### 2026-09- 20
- When you plug in a device like a USB, the bus driver (USB bus) notices it and matches it to the right device driver; once matched ("bound"), the kernel calls the driver's `probe()` function, which sets up the device (allocates memory, IRQs, etc) sit it's ready to use.
- Drivers register in 2 places:
	1.  **Bus** which physically connects through (I2C, PCI, USB, etc..)
	2. **Subsystem Framework**: matches what kind of device it is (RTC, networking, etc)
- Book goes over simplest drivers **misc** drivers, no need to implement `probe()`/`remove()` methods
- To practice more complex driver that use `probe()` start by writing a simple **platform driver**, registering it with the kernel's `misc` framework and the platform bus, a pseudo-bus infrastructure that supports devices that do not physically reside on any physical bus
	- Get Started here [kernel-platform-devices](https://www.kernel.org/doc/html/latest/driver-api/driver-model/platform.html#platform-devices-and-drivers) this is the doc for platform drivers 
- To write a driver belonging to the `misc` class we need to register it ourselves

### 2026-09-19 
- **Minor number**: Typically interpreted as either physical or logical instance of the device, or represent functionality 
- `misc` can be used for giving every small character device it's own scarce major number this allows Linux to tell the drivers apart by their minor number
- The LDM, a bit simplistically, can be thought of as having – and tying together – these major components:
	- The **buses** on the system.
	- The **devices** on them.
	- The **device drivers** that drive the devices (also often referred to as **client** drivers).
- Every single device must reside on a bus

### 2026-09-17 
- Devices/Drivers are organized in a tree like hierarchy within the kernel
- Block devices have capability to be mounted and a part of user file system **char devices don't**
- Since block devices can be mounted storage devices are typically block based
- If it's not  a storage or network device then it's a character device (simply put)
- `{major:minor}` pair is a single unsigned 32-bit quantity


### 2026-09-16 
- Read the intro
- Kernel Distinguishes between device files by two attributes
	1. Type of file - either character (char) or block
	2. The major and minor number see [[Writing Your First Kernel Module Part 1]] for more info

---

## Code / Commands / Snippets

### 09/30/26 Code

```c
static ssize_t read_method(struct file *filp, char __user *ubuf, size_t count, loff_t *off)  
{  
     char *kbuf = kzalloc(...);  
     [ ... ]  
     /* ... do what's required to get data from the hardware device into kbuf ... */  
    if (**copy_to_user(buf, kbuf, count)**) {  
        dev_warn(dev, "copy_to_user() failed\n");  
        goto out_rd_fail;  
    }  
    [ ... ]  
    return count;    /* success */  
out_rd_fail:  
    kfree(kbuf);  
 return -EIO; /* or -EFAULT */  
}
```

**What it does:**
Shows sudo code of passing data to user space from kernel space
**Notes on 

![[Ch 1 - Writing a Simple misc Character Device Driver-20260930221503158.png]]


---
### 09/29/26 Code

```c
dd if=/dev/llkd_miscdrv of=readtest bs=4k count=1
```

**What it does:**
Opens the file we pass as a parameter so `/dev/llkd_miscdrv` 

**Notes On Code Above**: 
- Fancy way of opening the driver file and reading it without creating a C program
- Opens the file via `if=`, then it will read from the file
- The output is to be written to the file specified by the parameter `of=`; the `bs` specifies the block size to perform I/O in
- `count` is the number of times to perform I/O

---

```c
/*  
 * read_miscdrv()  
 * The driver's read 'method'; it has effectively 'taken over' the read syscall  
 * functionality! Here, we simply print out some info.  
 * The POSIX standard requires that the read() and write() system calls return  
 * the number of bytes read or written on success, 0 on EOF (for read) and -1 (-ve errno)  
 * on failure; we simply return 'count', pretending that we 'always succeed'.  
 */  
static ssize_t read_miscdrv(struct file *filp, char __user *ubuf, size_t count, loff_t *off)**  
{  
        pr_info("to read %zd bytes\n", count);  
        return count;  
}
```

**What it does:**
Shows the number of bytes the user space process wants to read

**Notes On Code Above**: 
- [[struct file]]
- **`char __user *ubuf`**: a pointer to the buffer the user program passed to `read()`. This is where you're supposed to put the data.
- **`loff_t *off`**: a pointer to the current file position. `loff_t` is the kernel's type for file offsets, a `long long`, so 64 bits even on 32-bit systems, which allows files larger than 4 GB. It's passed as a pointer so your function can update it, for example `*off += bytes_read;`, and the next `read()` continues where the last one left off.
- `__user` is an annotation not a real type, it tells reader and static checker `sparse` that the ptr holds a **user-space address** not a kernel one
- Must never dereference a user pointer directly in kernel code

---
### 09/27/26 Code

```c
static int open_miscdrv(struct inode *inode, struct file *filp){
    char *buf = kzalloc(PATH_MAX, GFP_KERNEL);
    if (unlikely(!buf))
        return -ENOMEM;
    PRINT_CTX();// displays process (or atomic) context info
     pr_info(" opening \"%s\" now; wrt open file: f_flags = 0x%x\n",
        file_path(filp, buf, PATH_MAX), filp->f_flags);
    kfree(buf);
    return nonseekable_open(inode, filp);
}
```

**What it does:**
Prints open when a process or thread calls the custom `mis` device

**Notes On Code Above**: 
- Open implementation for custom `mis` device making the open function
- Allocate some memory for a buffer (to hold the pathname of our device)
- `kzalloc`: Go to [[kzalloc]] note
- Current issue `PRINT_CTX()` macro hasn't been made yet 
- C allows for implicit casts **(make a separate note on this later)**
- `unlikely`: Go to [[unlikely]] note
- `inode`:  Go to [[inode]] note

---

```c title=09/27/26
//ch1 miscdrv
#define pr_fmt(fmt) "%s:%s(): " fmt, KBUILD_MODNAME, __func__
#include <linux/miscdevice.h>
#include <linux/fs.h>

static const struct file_operations llkd_misc_fops = {
    .open = open_miscdrv,
    .read = read_miscdrv,
    .write = write_miscdrv,
    .release = close_miscdrv,
};

static struct miscdevice llkd_miscdev = {
    .minor = MISC_DYNAMIC_MINOR, //kernel dynamically asigns number
    .name = "llkd_miscdrv", //name kernel uses for device
    .mode = 0666, //sets node permisions 
    .fops = &llkd_misc_fops, //conect to this driver's functionality
};

```
---
**What it does:**
Added file ops process and threads can perform on this device
**Notes On Code Above**: 
- These are functions that have yet to be implemented will show later

---
```c title=dev_vs_pr
pr_info("device opened\n");
dev_info(dev, "device opened\n");
```

**What it does:**
outputs:
```
device opened
misc llkd_miscdrv: device opened
```

**Notes On Code Above**: 
- The first line gives no clue where it came from
- The second tells you it came from the misc subsystem, and specifically from the `llkd_miscdrv` device

### 09/23/26 Code

```c title=09/23/26
.fops = &llkd_misc_fops, /* connect to this driver's 'functionality' */
```

**What it does:** 
Ties process's file operations pointer to the device driver's file operation structure

**Notes On Code Above**:
- Essential what the driver will do now that it's setup for this device
- What kind of operations can this driver do 

---
```c title=09/23/26
open()   → f_op->open    → open_miscdrv()
read()   → f_op->read    → read_miscdrv()
write()  → f_op->write   → write_miscdrv()
close()  → f_op->release → close_miscdrv()
```

**What it does:**
Mapping of system calls to file operations

**Notes On Code Above**: 
- Different system calls mean different file operations (functions)

### 09/22/26 Code

```c title=09/22/26
//ch1 miscdrv
#define pr_fmt(fmt) "%s:%s(): " fmt, KBUILD_MODNAME, __func__
#include <linux/miscdevice.h>
#include <linux/fs.h>

static struct miscdevice llkd_miscdev = {
    .minor = MISC_DYNAMIC_MINOR, //kernel dynamically asigns number
    .name = "llkd_miscdrv", //name kernel uses for device
    .mode = 0666, //sets node permisions 
    .fops = &llkd_misc_fops, //conect to this driver's functionality
};

static int __init miscdrv_init(void){
    int ret; //return
    struct device *dev;
    ret = misc_register(&llkd_miscdev);
    if (ret != 0){
        pr_notice("misc device registration failed, aborting\n");
        return ret;
    }
}
```

**What it does:**
Basic setup for a misc device

**Notes On Code Above**:
- `.name`: On successful registration kernel will automatically create a device node using this form `/dev/<name>`
- permissions: see [[Linux#Permissions]] 





## Architecture / Diagrams

![[Ch 1 - Writing a Simple misc Character Device Driver-20260917235845549.png]]

- **What it is**: Minor/Major numbers and how they correlate.

---

## Questions & Confusions
- In section with first code block why is ther 4 numbers in permissions instead of standard 3? 

---

## Connections
- Builds on: 
- Contrasts with: 
- Referenced later in: 

---

## Personal Analogies 

### VFS & FOPS
Think of your fops table as a business card listing "for reads, call this number; for writes, call that one." Registering the misc device hands the card to the kernel. Each time someone opens your device, the VFS makes a fresh case file (`struct file`) and staples your card to it (`f_op`). Whenever that person later asks to read or write, the VFS checks the stapled card and calls your function.

---
## Practical Exercises / Labs

---

## Further Reading / Tangents
<!-- Things this chapter made you curious about but that are out of scope for now -->
- Look more into disk duplicator 

---

## Chapter Summary (fill in once finished)
> Written last, in your own words, no peeking at the book.


---

## Backlinks
- Table of contents: [[Linux Kernel Programming - TOC]]
