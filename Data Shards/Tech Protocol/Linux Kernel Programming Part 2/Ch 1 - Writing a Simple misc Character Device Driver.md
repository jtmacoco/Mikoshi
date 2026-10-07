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
last_updated: 2026-10-04
---

## TL;DR
>`misc` drivers are the easiest way to write a char driver. Register a `struct miscdevice` (all share major 10) and the kernel makes the `/dev` node for you. You fill in a `file_operations` table, and the VFS calls your functions when a user opens, reads, or writes the device file. Only move data with `copy_to_user()`/`copy_from_user()`. Careless copies can let an attacker get root.

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

| Term             | Definition                                        |
| ---------------- | ------------------------------------------------- |
| Device Driver    | Interface between OS and peripheral hw device     |
| Device File/Node | Entry point into device driver                    |
| Major Number     | Represents the class of device                    |
| Minor Number     | The interpretation of the device                  |
| LDM              | Linux Device Model                                |
| Device           | Physical (or virtual) thing itself, so like a USB |
| Driver           | Software that knows how to talk to the device     |
| Fops             | File Operations                                   |
| VFS              | Virtual Filesystem Switch                         |
| `dd(1)`          | Disk Duplicator                                   |
| Devres           | Device Resoureces                                 |
| UVA              | User Space Virtual Address                        |
| KASAN            | Kernel Address Sanitizer                          |
| RUID             | Real User ID                                      |
| EUID             | Effective User ID                                 |
| GPL              | General Public License                            |

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

### 2026-10-04
- naive usage of `copy_from/to_user()`can cause security issues as malicious users can overwrite memory to their advantage
	- Hackers can try to insert code through this function since driver has kernel level privileges  
- *KASAN*: A compiler instrumentation feature
- Added `HACKIT` writing zeroes into the process's UID member and making it user mode obtain root access
- RUID or EUID if set to specific value 0 it implies they have root access
- Now typically use POSIX Capabilities mode, it allows to give specific access and capabilities on a thread rather than giving a process or thread complete access to the system as root

**Summary**:
Still going over writing the secret misc driver but specifically the write functionality. Went over the actual C application that calls the driver as well but I didn't add it to the notes since its fairly basic IMO. It just takes in the device driver file and performs read and write on the file. Going over now ==Hacking the secret driver==

**Code Section***: [[#10/04/26 Code]]

---
### 2026-10-03
-  driver context or private driver data structure
	- have a conveniently accessible data structure containing all relevant info in one place
- Divide driver implementation into 5 parts (can be seen in the code section)
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

### 10/04/26 Code

```c title=bad_driver_buggy_write0
// in ch1/bad_miscdrv  
**$ diff -u ../miscdrv/rdwr_test.c rdwr_test_hackit.c**  
[ ... ]  
+**#define HACKIT**  
[ ... ]  
+#ifndef HACKIT  
+     strncpy(buf, argv[3], num);  
+#else  
+     printf("%s: attempting to get root ...\n", argv[0]);  
+     /*  
+      * Write only 0's ... our 'bad' driver will write this into  
+      * this process's current->cred->uid member, thus making us  
+      * root !  
+      */  
+     memset(buf, 0, num);  
 #endif  
- } else { // test writing ..  
          n = **write**(fd, buf, num);  
[ ... ]  
+     printf("%s: wrote %zd bytes to %s\n", argv[0], n, argv[2]);  
+#ifdef HACKIT  
+     if (getuid() == 0) {  
+         printf(" !Pwned! uid==%d\n", getuid());  
+         **/* the hacker's holy grail: spawn a root shell */**  
+         **execl**("/bin/sh", "sh", (char *)NULL);  
+     }  
+#endif  
[ ... ]


**$ diff -u ../miscdrv_rdwr/miscdrv_rdwr.c bad_miscdrv.c**  
[...]             
         // << this is within the driver's write method >>  
 static ssize_t write_miscdrv_rdwr(struct file *filp, const char __user *ubuf,  
 size_t count, loff_t *off)  
 {  
        int ret = count;  
        struct device *dev = ctx->dev;  
+       void *new_dest = NULL;  
[ ... ]  
+#define DANGER_GETROOT_BUG  
+//#undef DANGER_GETROOT_BUG  
+#ifdef DANGER_GETROOT_BUG  
+     /* Make the destination of the copy_from_user() point to the current  
+      * process context's **(real) UID**; this way, we redirect the driver to  
+      * write zero's here. Why? Simple: traditionally, a **UID == 0** is what  
+      * defines root capability!  
+      */  
+      **new_dest = &current->cred->uid;  
**+      count = 4; /* change count as we're only updating a 32-bit quantity */  
+      pr_info(" [current->cred=%px]\n", (TYPECST)current->cred);  
+#else  
+      new_dest = kbuf;  
+#endif

```

**What it does**:
- Gives root access to userspace process

**Notes on code above**:
- I combined two code sections here since they are the changes for the same functionality 
- when `DANGER_GETROOT_BUG` is defined, it sets the `new_dest` ptr to the address of the real UID member within the credential structure
- `current` is a kernel macro that gives you a ptr to the `struct task_struct` of the process (or thread) that is currently running on the CPU
- `task_struct` is kernel's big process descriptor: it holds PID, name, credentials, memory map, etc..


---

```c title=bad_driver_buggy_read
// in ch1/bad_miscdrv  
$ diff -u ../miscdrv_rdwr/miscdrv_rdwr.c bad_miscdrv.c*
[ ... ]  
+#include <linux/cred.h>            ​// access to struct cred  
#include "../../convenient.h"  
[ ... ]  
static ssize_t **read_miscdrv_rdwr**(struct file *filp, char __user *ubuf,  
[ ... ]  
+ void *kbuf = NULL;  
+ **void *new_dest** = NULL;  
[ ... ]  
+#define READ_BUG  
+//#undef READ_BUG  
+#ifdef READ_BUG  
[ ... ]  
+ new_dest = ubuf+(512*1024);
+#else  
+ new_dest = ubuf;  
+#endif  
[ ... ]  
+ if (copy_to_user(**new_dest**, ctx->oursecret, secret_len)) {  
[ ... ]
```
**What it does**:
- Changes user space destination pointer to point to an illegal location

**Notes on code above**:
- Note defines a macro that alters the user space destination by adding certain number of bytes (illegal)
- Moves 512kb ahead of the correct destination
- Throws a `bad address` as the `perror`
	- internally several checks are done to avoid these kinds of issues thus bad address error
	

---

```c title=cleanup
static void __exit miscdrv_rdwr_exit(void)  
{  
    misc_deregister(&llkd_miscdev);  
    pr_info("LLKD misc (rdwr) driver deregistered, bye\n");  
}
```

**What it does**:
- de-registers device and frees memory 
**Notes on code above**:
- Nothing special 


---

```c title=write_method
static ssize_t  
**write_miscdrv_rdwr**(struct file *filp, const char __user *ubuf, size_t count, loff_t *off)  
{  
    int ret = count;  
    void *kbuf = NULL;  
    struct device *dev = ctx->dev;  
    char tasknm[TASK_COMM_LEN];  
  
    PRINT_CTX();  
    if (unlikely(count > MAXBYTES)) { /* paranoia */  
        dev_warn(dev, "count %zu exceeds max # of bytes allowed, "  
                "aborting write\n", count);  
        goto out_nomem;  
    }  
    dev_info(dev, "%s wants to write %zd bytes\n", get_task_comm(tasknm, current), count);  
  
    ret = -ENOMEM;  
    kbuf = kvmalloc(count, GFP_KERNEL);  
    if (unlikely(!kbuf))  
        goto out_nomem;  
    memset(kbuf, 0, count);  
  
    /* Copy in the user supplied buffer 'ubuf' - the data content  
     * to write ... */  
    ret = -EFAULT;  
    if (copy_from_user(kbuf, ubuf, count)) {  
        dev_warn(dev, "copy_from_user() failed\n");  
        goto out_cfu;  
     }  
  
    /* In a 'real' driver, we would now actually write (for 'count' bytes)  
     * the content of the 'ubuf' buffer to the device hardware (or   
     * whatever), and then return.  
     * Here, we do nothing, we just pretend we've done everything :-)  
     */  
    strscpy(ctx->oursecret, kbuf, (count > MAXBYTES ? MAXBYTES : count));  
    [...]  
    // Update stats  
    ctx->rx += count; // our 'receive' is wrt this driver  
  
    ret = count;  
    dev_info(dev, " %zd bytes written, returning... (stats: tx=%d, rx=%d)\n",  
            count, ctx->tx, ctx->rx);  
out_cfu:  
    kvfree(kbuf);  
out_nomem:  
    return ret;  
}
```

**What it does:**
Changes the secrete message from 

**Notes on the code above:**
- `kvmalloc()`: allocates memory for a buffer to hold the user data
- Copy data from user space app to the kernel buffer, `kbuf`
- Use `dev_xxx()` so `dev_inf()` instead of `printk` routines, *recommended for drivers*

---
### 10/03/26 Code

```c title=read_method
static ssize_t read_miscdrv_rdwr(struct file *filp, char __user *ubuf,
                                 size_t count, loff_t *off)
{
    int ret = count, secret_len = strlen(ctx->oursecret);
    struct device *dev = ctx->dev;
    char tasknm[TASK_COMM_LEN];

    PRINT_CTX();
    dev_info(dev, "%s wants to read (upto) %zd bytes\n",
             get_task_comm(tasknm, current), count);

    ret = -EINVAL;
    if (count < MAXBYTES) {
        [...] << we don't display some validity checks here >>

    /* In a 'real' driver, we would now actually read the content of the
     * [...]
     * Returns 0 on success, i.e., non-zero return implies an I/O fault).
     * Here, we simply copy the content of our context structure's
     * 'secret' member to userspace.
     */
    ret = -EFAULT;
    if (copy_to_user(ubuf, ctx->oursecret, secret_len)) {
        dev_warn(dev, "copy_to_user() failed\n");
        goto out_notok;
    }
    ret = secret_len;

    /* Update stats */
    ctx->tx += secret_len; /* our 'transmit' is wrt this driver */
    dev_info(dev, " %d bytes read, returning... (stats: tx=%d, rx=%d)\n",
             secret_len, ctx->tx, ctx->rx);

out_notok:
    return ret;
}
```

**What it does:**
- When someone reads the device file it hands back the secret 

**Notes on the code above:**
- `tasknm` is a small local buffer holding the name of the process doing the read
- `out_notok` is a label that `goto` can jump to

---

```c title=init
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
- Convention to make every function `static`
- *Rule of thumb*: Make function  `static` whenever only that one `.c` file uses it

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
- In C `struct file_operations` is a type because you can't drop the `stcut` part in C
- the dot use in `.open` is initializer syntax it's like saying `fops.open`
- This is kind of like overriding in C++ since `.release`, and the others have some function definition but we change that 

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
	- [[Writing Your First Kernel Module Part 1]]: module init/exit, Makefile, `insmod`/`rmmod`; a misc driver is just a module that also calls `misc_register()`
	- Kernel memory allocation: [[kzalloc]], GFP flags, and `devm_*` (devres) managed allocations
	- VFS internals: [[inode]], `struct file`, and how syscalls get routed
	- Process credentials: `task_struct` → `cred` (RUID/EUID), which is exactly what the HACKIT demo overwrites
	- C function pointers: fops is a vtable built by hand
- Contrasts with:
	- "Full" char drivers: `alloc_chrdev_region()` + `cdev_add()` + `class_create()`/`device_create()`, where you do by hand what the misc framework does for you (major number, `/dev` node)
	- Platform drivers: have `probe()`/`remove()` and bind via a bus; misc drivers skip that
	- Block and network drivers: mountable storage and the netdev stack, not file-like byte streams
	- `pr_*()` logging in plain modules vs `dev_*()` in drivers
	- Plain `memcpy()` vs `copy_to/from_user()`: why user pointers need special handling
- Referenced later in:
	- User–kernel communication (Ch 2): `ioctl` is just another fops method; procfs/sysfs/debugfs are alternatives to a device file
	- Interrupts (Ch 4): why `copy_from_user()` can't be used in atomic context
	- Kernel synchronization (Ch 6–7): the secret driver's context struct is shared by every opener with no lock, which is a race condition waiting to happen
	- Security: POSIX capabilities, KASAN
	
---

## Personal Analogies 

### VFS & FOPS
Think of your fops table as a business card listing "for reads, call this number; for writes, call that one." Registering the misc device hands the card to the kernel. Each time someone opens your device, the VFS makes a fresh case file (`struct file`) and staples your card to it (`f_op`). Whenever that person later asks to read or write, the VFS checks the stapled card and calls your function.

---
## Practical Exercises / Labs
> Questions from book

- Load up the first miscdrv skeleton misc driver kernel module and issue lseek(2) on it; what happens? (Does it succeed? What's the return value from lseek?) If not, okay, how will you fix this?
- Write a misc class character driver that behaves as a simple converter program (assume its path name is /dev/convert). For example, writing the temperature in Fahrenheit units, it should return (write to the kernel log) the temperature in Celsius. Thus, doing echo 98.6 > /dev/convert should result in the value 37 C being written to the kernel log. Additionally, do the following:
    1. Validate that the data passed to your driver is a numeric value.
    2. How will you handle floating-point values? (Tip: refer to the section _Floating point not allowed in the kernel_ in _Linux Kernel Programming_, _Chapter 5_, _Writing Your First Kernel Module LKMs – Part 2._)
- Write a "task display" driver; here, we'd like a user space process to write a thread (or process) PID to it. When you now read from the driver's device node (assume its path name is /dev/task_display), you should receive details regarding the task (which is pulled from its task structure, of course). For example, doing echo 1 > /dev/task_display followed by cat /dev/task_display should have the driver emit task details of PID 1 to the kernel log. Don't forget to add validity checks (check the PID is valid, and so on).
- (A bit more advanced:) Write a "proper" LDM-based driver; the misc drivers covered here did register with the kernel's misc framework, but simply, implicitly, used the raw character interface as the bus. The LDM prefers that a driver must register with a kernel framework and a bus driver. Hence, write a "demo" driver that registers itself with the kernel's misc framework and the platform bus. This will involve creating a fake platform device as well.  
    (_Note the following t__ips_:  
    a) Do refer to [Chapter 2](https://learning.oreilly.com/library/view/linux-kernel-programming/9781801079518/4042025e-27a1-40f4-a2f7-223f601107dc.xhtml), _User-Kernel Communication Pathways_, particularly the _Creating a simple platform device_ and _Platform devices_ sections.  
    b) A possible solution to this driver can be found here: solutions_to_assgn/ch12/misc_plat/.)
	
---

## Further Reading / Tangents

- Look more into disk duplicator 

---

## Chapter Summary 

This chapter introduced the basics of writing device drivers specifically `misc` drivers. We went through blocks and character drivers also examining the major and minor numbers. This chapter focused mainly on the `misc` framework and writing a `misc` driver due to it's simplicity and ease to make. We went over examples such as initializing a simple driver to reading and writing to and from the driver using a simple C program (aka application while simple). Then went into detail about I/O and how it works internally. The chapter ends with *hacks* on the potential dangers of reading and writing to the driver/device if not done carefully further emphasizing security is important

---

## Backlinks
- Table of contents: [[Linux Kernel Programming Part 2]]
- `unlikely`: [[unlikely]]
- `inode`: [[inode]]
- `kzalloc`: [[kzalloc]]
- static: [[Static]]
