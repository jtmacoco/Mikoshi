**Source**: [[Linux Kernel Programming]]
**Tags**: #drivers #linux #kernel 
**Description**: Notes on how to write first kernel module/driver 

# Kernel Headers
- `#include` are header kernel header files
- They look through the modules build soft link which points to the kernel header files location
---
# Module Macros
- Provide information to a customer using 
- `modinfo` will provide this macro info
---
# Entry & Exit Points
- Kernel mods don't have entry points like normal `main()` entry points
- Instead the follow `module_{init|exit}()` 
- So can be named anything as long as they end in `init` or `exit`
- These are code macros that specify the entry point
---
# Return Values
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
    - It may be ignored entirely if unloading/shutdown support isn’t needed.
---
# Running the kernel module

To work with modules need root access `sudo`

**Load Module**:    `insmod *.ko`
**Unload Module**: `rmmod *.ko`

To view any `printk` stuff used the `dmesg` command, this prints the kenrel messages 

---
# Listing live kernel modules
**List Modules**: `lsmod`
- This shows all of the live modules in chronological order
---
# Understanding kernel logging and printk
- A way to display stuff to user but is done as a kernel message so use `dmesg` to see output
## Using kernel memory ring buffer
- **Kernel log buffer**: memory buffer within the kernel virtual address space where the `printk` output is saved to
- Called a ring buffer since it's finite in size and once it gets full it gets overwritten from byte zero
## Kernel logging and systemd's journalctl
- Key idea is that since `printk` is volatile and overwrites data once it's reached the limit but how do we fix this
- To fix we write to a file in  a non volatile secondary storage.  
- **Systemmd** replaces or works in addition to the old SysV init framework. 

## Using printk log levels

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
1. kernel memory log buffer (always)
2. non-volatile log files (typical)
3. console device

**console**: Is whatever device Linux is using as a primary human interface, it doesn't have to be a screen it can be a cable connecting to another computer