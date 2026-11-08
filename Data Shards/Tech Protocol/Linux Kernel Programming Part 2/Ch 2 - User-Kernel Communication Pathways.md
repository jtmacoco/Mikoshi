---
type: datashard
category: book-chapter
book: "[[Linux Kernel Programming Part 2]]"
author: Kaiwan N. Billimoria
chapter: 2
chapter_title: "User-Kernel Communication Pathways "
status: in-progress
tags:
  - book-notes
  - kernel
  - c
date_started: 2026-10-17
last_updated: 2026-11-02
---

## TL;DR
> Keep this updated as your understanding sharpens — it's fine if it's rough or wrong early on.

---

## Vocabulary / Key Terms

| Term        | Definition                                                                                                                                                                             | Notes |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| pseudo-file | A pseudo-file is an entry that looks like a normal file but has nothing stored on disk; the kernel generates its contents on the fly each time it's read, as with everything in /proc. |       |
| ABI         | Application Binary Interface                                                                                                                                                           |       |

---

## Core Concepts

- **Concept:**
  - Why it matters:
  - Related to: 

---

## Assumed Knowledge

- Have a VM of linux up and running and cloned book repo

---

## Session Log
<!-- Running, dated notes — the actual "as I read it" capture. Newest entry on top. -->
### 2026-11- 02
- Use `single_open()` and `seq_read`, `seq_lseek`, and `seq_release` (built in kernel functions) are the correct approach to using procfs
- Most devices use RESTful APIs which is pared in JSON (typically)
- Designing and implementing kernel to user (and vice versa) communication in easily parsable formats like JSON

**Code**: 
[[#2026-11- 07 Code]]

**Summary**:
Continuing to go over the procfs creation code. Again mostly done in the code section this session. 

**Stopped here**:
A few misc procfs APIs

---
### 2026-11- 02
- By default all `procfs` files have their `owner:group` attributes as `root:root`

**Code**: 
[[#2026-11- 02 Code]]

**Summary**: 
Continuing from where I left off. Currently diving more into the code and will see how to write a simple proc driver. A lot of **today's reading was in the code section**. When over some of the functions used to actually create things in the `procs` directory.  I stopped at this line `The open method of fops points to a function we must define:`. Use it for next time to find where I left off

---
### 2026-10- 24
- Chapter will go over communication/interfacing with user space C apps 
- Only way to access kernel from user space is through system calls
- Virtual filesystem called `proc`
- `proc` is a way to interface between kernel and user space
- `proc` used for status reporting and debugging core kernel systems
- `proc` content is on RAM so volatile, also all pseudo objects
- Thinks in `proc` are generated on the fly
- Directories under `/proc` who's names are integer values represent processes currently alive on the system
- `/proc/PID/` contains info regarding a process
- **Purpose of Proc fs**:
	- One: Simple for anyone to look inside and gain info about internals of processes
	- Only need to know basic shell commands
	- Two: root can write into certain pseudo files unser `/proc/sys`
	- Feature is called sysctl
- procfs is an **ABI**
- **do not use procfs for their own purpose or their interfaces, debug or otherwise**
	- Reason being originally it was super easy to add files here, so everyone kept adding and it became a mess
	- This would break user programs as they start reading it and depending on the exact format, So the kernel can never change or remove it without breaking those programs
	- Quick hack became bad
- Version 2.6 provides the `/sys` for driver info and `/debugfs` is for debugging purposes, `/proc` is for process and core kernel info only, a separation of concerns
- Choices to export interfaces
	- `sysfs`
	- `debugfs`
	- `netlinksocket`
	- `ioctl1`
- Don't use `proc` for non-core stuff such as drivers
**Code**: 
[[#2026-10- 24 Code]]

**Summary**: 
Went over the `proc` directory and the prupose of `proc`. Found that it is dynamically generated meaning each open the kernel dynamically generates the file. To update the system use the `/sys` so systemctl. Basically it changed in version 2.6 making it easier to work with instead of being a big dump directory.


---

## Code / Commands / Snippets

### 2026-11- 07 Code

```c
#define DEBUG_LEVEL_MIN     0
#define DEBUG_LEVEL_MAX     2
[...]
/* proc file 1 : modify the driver's debug_level global variable as per what user space writes */
static ssize_t myproc_write_debug_level(struct file *filp, 
                const char __user *ubuf, size_t count, loff_t *off)
{
   char buf[12];
   int ret = count, prev_dbglevel;
   [...]
   prev_dbglevel = debug_level;
   // < ... validity checks (not shown here) ... >
   /* Get the user mode buffer content into the kernel (into 'buf') */
   if (copy_from_user(buf, ubuf, count)) {
        ret = -EFAULT;
        goto out;
   }
   [...]
   ret = kstrtoint(buf, 0, &debug_level); /* update it! */
   if (ret)
        goto out;
  if (debug_level < DEBUG_LEVEL_MIN || debug_level > DEBUG_LEVEL_MAX) {
            [...]
            debug_level = prev_dbglevel;
            ret = -EFAULT; goto out;
   }
   /* just for fun, let's say that our drv ctx 'config1'
      represents the debug level */
   gdrvctx->config1 = debug_level;
   ret = count;
out:
   mutex_unlock(&mtx);
   return ret;
}
```

**What it does:**
- Write callback function
**Notes On Code Above:**
- Perform checking on the copied data the user space process wrote to use
- `kstrtoint` converts the input buffer into a an int, then store it in the `debug_level` variable
	- The 0 is the base so base is decimal
---
```c
/* Our proc file 1: displays the current value of debug_level */  
static int proc_show_debug_level(struct seq_file *seq, void *v)  
{  
    if (mutex_lock_interruptible(&mtx))  
        return -ERESTARTSYS;  
    seq_printf(seq, "debug_level:%d\n", debug_level);
    mutex_unlock(&mtx);  
    return 0;  
}
```

**What it does:**
- Displays the current value of debug_level
**Notes On Code Above:**
- Uses a mutex lock to avoid race conditions
- `seq_printf()` is similar to `sprintf()`
	- It writes formatted data into the `seq_file` object’s internal kernel buffer
	- It does not touch user space itself
	- `seq_read()` later copies the buffered data to the user-space process with `copy_to_user()`
- Analogy  [[#`struct seq_file`|struct_seq_file]] 
	- The text we read from a procfs file has to come from somewhere
	- procfs files aren't stored on disk, so the text is generated on demand every time the file is read
	- When we read the file, the kernel calls our module's `show` function
	- `show` writes the text onto a scratch pad (the `seq_file` buffer) using `seq_printf()`
	- `seq_read()` then copies the scratch pad's contents to the user-space program
	- Restaurant analogy: reading = ordering, `show` = the kitchen cooking, `seq_read()` = the waiter bringing the food


---

```c
static int myproc_open_dbg_level(struct inode *inode, struct file *file)  
{  
    return single_open(file, proc_show_debug_level, NULL);  
}
```

**What it does:**
- Opens a proc file
**Notes On Code Above:**
- `single_open` is an API, the proc filesystem will call back the `proc_show_debug_level` routine
- 

---
### 2026-11- 02 Code

```c
static const struct file_operations fops_rdwr_dbg_level = {  
    .owner = THIS_MODULE,  
    .open = myproc_open_dbg_level,  
    .read = seq_read,  
    .write = myproc_write_debug_level,  
    .llseek = seq_lseek,  
    .release = single_release,  
};
```

**What it does:**
- Defines the file operations

**Notes On Code Above:**
- has a `.owner` which is different from before
- `.owner` tells the kernel which module these functions be long to
- `THIS_MODULE` is a macro pointing to it's own `struct module`

---

```c
// ch2/procfs_simple_intf/procfs_simple_intf.c[...]  
#define PROC_FILE1           "llkdproc_debug_level"  
#define PROC_FILE1_PERMS     0644  
[...]  
static int __init procfs_simple_intf_init(void)  
{  
    int stat = 0;  
    [...]  
    /* 1. Create the PROC_FILE1 proc entry under the parent dir OURMODNAME;  
     * this will serve as the 'dynamically view/modify debug_level'  
     * (pseudo) file */  
    if (!proc_create(PROC_FILE1, PROC_FILE1_PERMS, gprocdir,  
                     **&fops_rdwr_dbg_level)) {  
    [...]  
    pr_debug("proc file 1 (/proc/%s/%s) created\n", OURMODNAME, PROC_FILE1);  
    [...]
```

**What it does:**
- creates the `procfs` file that controls projects debug level

**Notes On Code Above:**
- `PROC_FILE1` is a macro in we define
- `PROC_FILE1_PERMS` are default permission bits `0644` we define in the code

---

```c
static struct proc_dir_entry *gprocdir;  
[...]  
gprocdir = proc_mkdir(OURMODNAME, NULL);
```

**What it does:**
- Creates procfs directory

**Notes On Code Above:**
- `OURMODNAME` is a linux macro grabbing the name of the module

---

```c title=profcfs_drv_ctx
// ch2/procfs_simple_intf/procfs_simple_intf.c  
[ ... ]  
/* Borrowed from ch1; the 'driver context' data structure;  
 * all relevant 'state info' reg the driver and (fictional) 'device'  
 * is maintained here.  
 */  
**struct drv_ctx** {  
    int tx, rx, err, myword, power;  
    u32 config1; /* treated as equivalent to 'debug level' of our driver */  
    u32 config2;  
    u64 config3;  
#define MAXBYTES   128  
    char oursecret[MAXBYTES];  
};  
static struct drv_ctx *gdrvctx;  
static int debug_level;    /* 'off' (0) by default ... */
```

**What it does:**
- Just a normal struct to hold our data similar to previous chapter

**Notes On Code Above:**
- `debug_level` provides dynamic control over the debug verbosity (more or less text in output)
- Will assign between a range of `[0-2]`
	- $0$ implies no debug messages
	- $1$ is medium debug verbosity
	- $2$ implies high debug verbosity
- will be able to query and set the debug level from user space via `procfs`
---
```c title=remove_proc
void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
```

**What it does:**
- Removes proc and frees it if not in use

**Notes On Code Above:**
- Nothing fancy does as it says

---
### 2026-10- 24 Code

```c title=procfs_file
struct proc_dir_entry *proc_create(const char *name, umode_t mode,  
                         struct proc_dir_entry *parent,                         const struct file_operations *proc_fops);
```

**What it does:**
- Creates a file

**Notes On Code Above:**
- Expected to populate with methods (notice `fops`)

---
```c title=mkdir_under_proc
struct proc_dir_entry *proc_mkdir(const char *name,  
                         struct proc_dir_entry *parent);
```

**What it does:**
- Creates a directory under the `/proc` directory

**Notes On Code Above:**
- `struct proc_dir_entry` is a directory within the proc directory, if NULL parent directory is just `/proc`

---

## Architecture / Diagrams


---

## Questions & Confusions
- [ ]

---

## Connections
- Builds on: [[]]
- Contrasts with: [[]]
- Referenced later in: [[]]

---

## Personal Analogies 
### `struct seq_file`

- ou’re a writer and `seq_read()` is the mail carrier.
- The `seq_file` is a notepad the carrier hands you.
- Your `show` function writes on the notepad (`seq_printf`).
- The carrier delivers the notepad’s contents to the user, in as many trips as they need, and keeps track of what has been delivered.

You never talk to the user directly. You just write on the notepad.

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
- Table of contents: [[Linux Kernel Programming Part 2]]
- Previous: [[Ch 1 - Writing a Simple misc Character Device Driver]]
