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
last_updated: 2026-10-03
---

## TL;DR
> Drivers are complicated

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
| Devres           | Device Resoureces                                 |       |

---

## Core Concepts
<!-- One entry per idea — add as you encounter them, expand later -->

- **Concept:** Device files are the entry point to a driver
  - Why it matters: User space never calls a driver directly. It opens `/dev/<name>`, and the kernel uses the file's type (char/block) plus its `{major:minor}` pair to route the call to the right driver.
  - Related to: Major/minor numbers, VFS, [[Writing Your First Kernel Module Part 1]]
---
- **Concept:** Char vs. block vs. network devices
  - Why it matters: Block devices are storage and can be mounted. Network devices are their own category. Almost everything else is a char device, and that's the kind this chapter writes.
  - Related to: Device files, misc drivers
---
- **Concept:** The Linux Device Model (bus, device, driver)
  - Why it matters: Every device sits on a bus. The bus matches a device to a driver ("binding"), then calls the driver's `probe()`. Drivers register with both a bus and a subsystem framework.
  - Related to: `probe()`/`remove()`, platform drivers, misc framework
---
- **Concept:** The misc framework
  - Why it matters: It's the simplest way to write a char driver. Every misc driver shares major 10 and gets its own minor (often `MISC_DYNAMIC_MINOR`). `misc_register()` creates the `/dev` node for you, and there's no `probe()` to write.
  - Related to: `struct miscdevice`, LDM, platform drivers
---
- **Concept:** `file_operations` (fops) = kernel polymorphism
  - Why it matters: On `open()`, the VFS creates a `struct file` and points its `f_op` at your fops table. After that, each syscall (`read`, `write`, `release`...) is dispatched to your matching function. Your function signatures must match the `file_operations` struct exactly.
  - Related to: VFS, `struct file`, [[#VFS & FOPS]]
---
- **Concept:** The user/kernel boundary
  - Why it matters: `__user` pointers hold user-space addresses and must never be dereferenced in the kernel. Move data only with `copy_to_user()`/`copy_from_user()`, which return the number of bytes *not* copied (non-zero = failure, usually return `-EFAULT`).
  - Related to: `read`/`write` methods, `sparse`
---
- **Concept:** Process context vs. atomic/interrupt context
  - Why it matters: Some kernel functions can sleep (`copy_from_user()`, `kzalloc(..., GFP_KERNEL)`). They're only safe in process context, never in interrupt or atomic context.
  - Related to: `PRINT_CTX()`, memory allocation flags
---
- **Concept:** Error conventions: return `-errno`
  - Why it matters: Kernel methods signal failure by returning a negative errno (`-ENOMEM`, `-EIO`, `-EFAULT`). Unimplemented methods can produce misleading results (e.g., `read = NULL` gives `EINVAL`, and an unimplemented `llseek` can appear to succeed), so be explicit, like calling `nonseekable_open()`.
  - Related to: fops, `llseek`
---
- **Concept:** Log with `dev_*()`, not `pr_*()`, in drivers
  - Why it matters: `dev_info()` and friends take a `struct device *` and prefix each message with the subsystem and device name, so you can tell which device printed what.
  - Related to: `pr_fmt`, `printk`

---

## Assumed Knowledge

- General Linux knowledge is needed

---

## Session Log
<!-- Running, dated notes — Newest entry on top. -->

### 2026-10-03
-  driver context or private driver data structure
	- have a conveniently accessible data structure containing all relevant info in one place
- Divide driver implementation into 5 pars
	1. driver initialization,
	2. read method
	3. write method functionality implementation,
	4. driver cleanup
	5. userspace application that will use our device driver
	
**Code Section**: [[#10/03/26 Code]]

**Summary**: 
Writing a misc driver with a secret, so slightly more complex than the previous driver written.


---
### 2026-09-30
- kernel provides inline functions to transfer data from kernel to user space and vice versa
	- `copy_to_user()`
	- `copy_from_user()`
	- Return value is number of uncopied bytes 
	- A non-zero values = error 

**Code Section**: [[#09/30/26 Code]]

---
### 2026-09- 29
- Kernel VFS will auto-invoke driver's `f_op` methods
- Can test the practice misc driver made with `dd(1)` 
- `copy_from_user()` ==can only be used in a process context where it's safe to sleep and never in any kind of atomic or interrupt context==

**Code Section**: [[#09/29/26 Code]]

---
### 2026-09- 28
- `errno` value returned by VFS not very intuitive
	- If set `read()` func ptr of `f_op` to `NULL`, VFS will cause `EINVAL` value saying this failed because of invalid arg which is not right
	- `lseek()` system call that has driver seek specific location in file aka the device we are writing
	- kernel names `f_op` function pointer as `llseek` this is to remind us that the return value from `lseek` can be 64-bit (long long) quantity
	- **Issue**: If we don't implement `llseek` it still returns a random positive value causing the user mode app to think it succeed; To fix do this 
		1. Set `llseek` to the special `no_llseek` value
		2. Invoke the `nonseekable_open()` func in driver's `open()` method, specifying that the file is non-seekable

---
### 2026-09- 27

- When writing a device driver use the `dev_*()` family so `dev_info()`, `dev_warn()`, `dev_err()`, `dev_dbg()`, etc. Rather than `printk()` or `pr_*()` (`pr_info()`, `pr_err()`)
- `dev_*()` routines take a pointer to a `struct device` as their first arg, so the kernel uses it to automatically prefix each message with info about which device printed it
- How should the driver author implement the different `f_ops` for a driver?
	- **Key Point**: signature of our `f_ops` function say `open` function, it should be identical to the `file_operation` structure `open`
	- This is true for any function
- `file_path()` gets the path of a file

**Code Section**: [[#09/27/26 Code]]

---
### 2026-09- 24
- If a method is unsporrted say we didn't write the `fops` function for it like `poll()`
	- VFS will detect `fops` pointer so `poll` and then it returns the correct negative integer signaling a fail
	- Important, think back to semantics in programming languages if left undefined could cause issues

---
### 2026-09- 23
- All `misc` drivers are of the character type 
- When a user-space process/thread opens a device file registered to this driver (via the misc framework), the kernel VFS allocates and initializes a `struct file` for that open and sets its `f_op` to the driver's `file_operations` (from `.fops` in `struct miscdevice`), so later calls like `read()`/`write()` are routed to the driver's functions. [[#VFS & FOPS]]
- If a process opens drivers device file via the `open` system call the driver should issue the related system file call `foo` (for example) on that device file
	- Function will change based on system call say `open` or `read`
	- Each system call maps to its own slot in the fops table, so a different driver function runs for each operation

---
### 2026-09- 21
- I fixed my linux setup to have correct heaers and nvim setup, lsp didn't have clang
- `misc_register()` API takes one parameter, a ptr to a data struct of type `miscdevice`
- All `misc` drivers are character type and use the same **major number 10** 
- `file_operations` struct or **fops** contains function pointers (think of as **virtual methods**) which are possible system calls that could be issued to the (device) file; such as `read`, `write`, `poll`, etc...
	- Basically has a bunch of function pointers to do stuff
	- It's kernel's way of doing polymorphism in
	- **I/YOU NEED TO SET THESE FUNCTION POINTERS**
	- This is like saying hey these are the function pointers you can use with this driver I'm making
	
---
### 2026-09- 20
- When you plug in a device like a USB, the bus driver (USB bus) notices it and matches it to the right device driver; once matched ("bound"), the kernel calls the driver's `probe()` function, which sets up the device (allocates memory, IRQs, etc) sit it's ready to use.
- Drivers register in 2 places:
	1.  **Bus** which physically connects through (I2C, PCI, USB, etc..)
	2. **Subsystem Framework**: matches what kind of device it is (RTC, networking, etc)
- Book goes over simplest drivers **misc** drivers, no need to implement `probe()`/`remove()` methods
- To practice more complex driver that use `probe()` start by writing a simple **platform driver**, registering it with the kernel's `misc` framework and the platform bus, a pseudo-bus infrastructure that supports devices that do not physically reside on any physical bus
	- Get Started here [kernel-platform-devices](https://www.kernel.org/doc/html/latest/driver-api/driver-model/platform.html#platform-devices-and-drivers) this is the doc for platform drivers 
- To write a driver belonging to the `misc` class we need to register it ourselves

---
### 2026-09-19 
- **Minor number**: Typically interpreted as either physical or logical instance of the device, or represent functionality 
- `misc` can be used for giving every small character device it's own scarce major number this allows Linux to tell the drivers apart by their minor number
- The LDM, a bit simplistically, can be thought of as having – and tying together – these major components:
	- The **buses** on the system.
	- The **devices** on them.
	- The **device drivers** that drive the devices (also often referred to as **client** drivers).
- Every single device must reside on a bus

---
### 2026-09-17 
- Devices/Drivers are organized in a tree like hierarchy within the kernel
- Block devices have capability to be mounted and a part of user file system **char devices don't**
- Since block devices can be mounted storage devices are typically block based
- If it's not  a storage or network device then it's a character device (simply put)
- `{major:minor}` pair is a single unsigned 32-bit quantity

---
### 2026-09-16 
- Read the intro
- Kernel Distinguishes between device files by two attributes
	1. Type of file - either character (char) or block
	2. The major and minor number see [[Writing Your First Kernel Module Part 1]] for more info

---

## Code / Commands / Snippets

### 10/03/26 Code

```c
// ch1/miscdrv_rdwr/​miscdrv_rdwr.c  
[ ... ]  
static int __init miscdrv_rdwr_init(void)  
{  
    int ret;  
    struct device *dev;  
  
    ret = misc_register(&llkd_miscdev);  
    [ ... ]  
    dev = llkd_miscdev.this_device;
    [ ... ]  
    ctx = devm_kzalloc(dev, sizeof(struct drv_ctx), GFP_KERNEL);
    if (unlikely(!ctx))  
        return -ENOMEM;  
  
    ctx->dev = dev;  
    strscpy(ctx->oursecret, "initmsg", 8);  
    [ ... ]  
    return 0;         /* success */  
}
```

**What it does:**
- Init's the `dev` member of `ctx` private struct as well as the *secrete* string

**Notes on Code Above**: 
- `devm_kzalloc`: 
	- Takes in a device pointer but the memory is not allocated to the device, rather the device ptr is used make a note that this chunk of memory was allocated and it belongs to me (this is my memory), so when I die, destroy this memory too
	- The device pointer is like a guardian who is responsible for the memory: it doesn't provide or approve it but once the device is destroyed the memory it's responsible for is freed with it
	- In the background the device ptr keeps a list (a tracker of sorts) of the memory it's responsible for so when we remove the device (exit) it the kernel goes through the list and frees the memory,  This is called **devres**
	- So the memory gets allocated to ctx

---
```c
// ch1/miscdrv_rdwr/miscdrv_rdwr.c  
[ ... ]  
/* The driver 'context' (or private) data structure;  
 * all relevant 'state info' reg the driver is here. */  
struct drv_ctx {  
    struct device *dev;  
    int tx, rx, err, myword;  
    u32 config1, config2;  
    u64 config3;  
#define MAXBYTES 128 /* Must match the userspace app; we should actually  
                      * use a common header file for things like this */  
    char oursecret[MAXBYTES];
};  
static struct drv_ctx *ctx;

```

**What it does:**
- A struct containing all the information in one place

**Notes on Code Above**: 
- Nothing fancy just creates a struct 

---
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

---
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

---
## Architecture / Diagrams

![[Ch 1 - Writing a Simple misc Character Device Driver-20260917235845549.png]]

- **What it is**: Minor/Major numbers and how they correlate.

---

## Questions & Confusions
- In section with first code block why is ther 4 numbers in permissions instead of standard 3? 
- so could I make a driver that uses all the memory then would that crash a computer? (kmalloc memory stuff) [[#09/29/26 Code]]

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
