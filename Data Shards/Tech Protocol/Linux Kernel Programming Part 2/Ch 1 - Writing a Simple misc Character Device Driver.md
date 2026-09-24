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
last_updated: 2026-09-23
---

## TL;DR
> Keep this updated as your understanding sharpens — it's fine if it's rough or wrong early on.

---

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

### 2026-09- 23
- All `misc` drivers are of the character type 
- When a user-space process/thread opens a device file registered to this driver (via the misc framework), the kernel VFS allocates and initializes a `struct file` for that open and sets its `f_op` to the driver's `file_operations` (from `.fops` in `struct miscdevice`), so later calls like `read()`/`write()` are routed to the driver's functions. [[#VFS & FOPS]]

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

**What it does:** Basic setup for a misc device
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
- 

---

## Chapter Summary (fill in once finished)
> Written last, in your own words, no peeking at the book.


---

## Backlinks
- Table of contents: [[Linux Kernel Programming - TOC]]
