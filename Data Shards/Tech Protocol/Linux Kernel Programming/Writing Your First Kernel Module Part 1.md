---
title: Writing Your First Kernel Module
source: "[[Linux Kernel Programming]]"
tags:
  - book
  - reference
  - drivers
  - linux
  - kernel
created: 2026-07-03
author: Kaiwan N. Billimoria
subject: kernel programming / device drivers
status: reading
rating:
---

## Why I'm Reading This

To learn how to write drivers

---
# Notes

## Kernel Headers
- `#include` are header kernel header files
- They look through the modules build soft link which points to the kernel header files location
---
## Module Macros
- Provide information to a customer using 
- `modinfo` will provide this macro info
---
## Entry & Exit Points
- Kernel mods don't have entry points like normal `main()` entry points
- Instead the follow `module_{init|exit}()` 
- So can be named anything as long as they end in `init` or `exit`
- These are code macros that specify the entry point
---
## Return Values
```c
static int  __init <modulename>_init(void);
static void __exit <modulename>_exit(void);
```

- `static` qualifier implies they are private to this kernel module
- `init` returns an integer value
	- works with `0/-E` convention
	- 0 means **success**
	- Any negative values means **Failure**
- `IS_ERR()` inline functions: Figures out if value is in the range [-1 to -4095]
	- Useful since will figure out for use
- `__init` marks code that is **only needed during startup/initialization**.
	- `__init` macro defines an init.text
	- Any data declared with the `__initdata` goes in the `init.data`
    - After the program or kernel finishes starting up, that code can be discarded from memory to save space.
- `__exit` marks code used during **shutdown or module unloading**.
    - It may be ignored entirely if unloading/shutdown support isn't needed.
---
## Running the kernel module

To work with modules need root access `sudo`

**Load Module**:    `insmod *.ko`
**Unload Module**: `rmmod *.ko`

To view any `printk` stuff used the `dmesg` command, this prints the kenrel messages 

---
## Listing live kernel modules
**List Modules**: `lsmod`
- This shows all of the live modules in chronological order
---
### Understanding kernel logging and printk
- A way to display stuff to user but is done as a kernel message so use `dmesg` to see output
### Using kernel memory ring buffer
- **Kernel log buffer**: memory buffer within the kernel virtual address space where the `printk` output is saved to
- Called a ring buffer since it's finite in size and once it gets full it gets overwritten from byte zero
### Kernel logging and systemd's journalctl
- Key idea is that since `printk` is volatile and overwrites data once it's reached the limit but how do we fix this
- To fix we write to a file in  a non volatile secondary storage.  
- **Systemmd** replaces or works in addition to the old SysV init framework. 

### Using printk log levels

`printk(KERN_INFO "Hello, world\n");` 
**KERN_INFO**: one of 8 log levels that a kernel printk can get logged at
- This log level is not a priority specifier, instead it allows us to filter messages based on log level
```C title=log-levels
// include/linux/kern_levels.h
#ifndef __KERN_LEVELS_H__
#define __KERN_LEVELS_H__
#define KERN_SOH    "\001"      /* ASCII Start Of Header */
#define KERN_SOH_ASCII  '\001'
#define KERN_EMERG    KERN_SOH "0"    /* system is unusable */
#define KERN_ALERT    KERN_SOH "1"    /* action must be taken immediately */
#define KERN_CRIT     KERN_SOH "2"    /* critical conditions */
#define KERN_ERR      KERN_SOH "3"    /* error conditions */
#define KERN_WARNING  KERN_SOH "4"    /* warning conditions */
#define KERN_NOTICE   KERN_SOH "5"    /* normal but significant condition */
#define KERN_INFO     KERN_SOH "6"    /* informational */
#define KERN_DEBUG    KERN_SOH "7"    /* debug-level messages */
#define KERN_DEFAULT          ""      /* the default 
```

### The pr_<foo\> convenience macros 
The clunky
``` c
printk(KERN_FOO "<format-str>", vars...); 
```

is replaced with the elegant

``` c
      pr_foo("<format-str>", vars...);
```

`<foo>` is the log level of emerge, alert, crit, err, warn, notice, info, or debug

EX:
```c title=raw_printk
printk(KERN_ERR "Something went wrong: %d\n", err_code);
printk(KERN_INFO "Device initialized: %s\n", dev_name);
printk(KERN_DEBUG "Value is: %d\n", val);
```

```c title=pr_foo
pr_err("Something went wrong: %d\n", err_code);
pr_info("Device initialized: %s\n", dev_name);
pr_debug("Value is: %d\n", val);
```

`pr_count()`: continues the previous `printk` so can add to it basically later kind of like concat
- ensure final `pr_count()` contains the new line so `pr_count("\n")`

`dev_*()` Macros: when writing a driver log messages need to say which device they're coming from. A system might have 5 USB devices  and a generic `pr_err("something broke")` is useless since don't know which one broke

EX:
```c 
// Generic – who knows which device this is about?
pr_err("Failed to read register: %d\n", err);

// Device-aware – kernel automatically prepends device info
dev_err(dev, "Failed to read register: %d\n", err);
```
### Writing to the console
`printk` output can go to 3 locations
1. kernel memory log buffer (always) (dmesg)
2. non-volatile log files (typical)
3. console device (like the terminal)

**console**: Is whatever device Linux is using as a primary human interface, it doesn't have to be a screen it can be a cable connecting to another computer

- **teletype terminal**: `tty`, is a terminal device in Linux, an interface the kernel provides for text base I/O, aka a terminal
- `sysctl` : A proc-based mechanism, `sysctl` is the mechanism for **reading and modifying kernel parameters at runtime**, without needing to recompile the kernel or reboot the system. It covers things like networking behavior, virtual memory tuning, filesystem limits, security settings, and more.

```bash
cat /proc/sys/kernel/printk
4    4    1    7
```

We interpret the preceding four numbers as `printk` log levels (with `0` being the highest and `7` the lowest in terms of “urgency”). The preceding four-integer sequence’s meaning is this:

- The current (console) log level. _The key implication is that all messages less than this value will be sent to the console device as well!_
- The default level for messages that lack an explicit log level.
- The minimum allowed log level.
- The boot-time default log level.

### Writing output to Raspberry Pi Console

```c
#include <linux/init.h>
#include <linux/module.h>

MODULE_AUTHOR("Jonathan Macoco");
MODULE_DESCRIPTION("LKP2E");
MODULE_LICENSE("Dual MIT/GPL");

MODULE_VERSION("0.2");

static int __init printk_loglvl_init(void)
{
	pr_emerg ( "Hello, world @ log-level KERN_EMERG  [0]\n");
	pr_alert ( "Hello, world @ log-level KERN_ALERT  [1]\n");
	pr_crit  ( "Hello, world @ log-level KERN_CRIT   [2]\n");
	pr_err   ( "Hello, world @ log-level KERN_ERR    [3]\n");
	pr_warn(  "Hello, world @ log-level KERN_WARNING [4]\n");
	pr_notice("Hello, world @ log-level KERN_NOTICE  [5]\n");
	pr_info(  "Hello, world @ log-level KERN_INFO    [6]\n");
	pr_debug( "Hello, world @ log-level KERN_DEBUG   [7]\n");

	return 0;
}
static void __exit printk_loglvl_exit(void)
{
	pr_info("Goodbye, world @ log-level KERN_INFO    [6]\n");
}

module_init(printk_loglvl_init);
module_exit(printk_loglvl_exit);
```

```bash title=general-make
KDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../linux)
DRIVERS_OUT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../drivers)

obj-m += printk_loglvl.o

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	cp *.ko $(DRIVERS_OUT)/

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f $(DRIVERS_OUT)/printk_loglvl.ko
```

![[Writing Your First Kernel Module Part 1-20260909223532277.png]]

- This image above implies that all `printk` instances less than log level 7 will appear on the console device (terminal)
- We can adjust the Makefile with the debug flag just need to add:

```bash
# Enable the pr_debug() as well (rm the comment from one of the lines below)
# (Note: EXTRA_CFLAGS deprecated; use ccflags-y)
#ccflags-y += -DDEBUG
#CFLAGS_printk_loglvl.o := -DDEBUG
```
