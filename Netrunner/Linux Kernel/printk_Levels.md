---
title: printk Levels
source: "[[Linux Kernel]]"
tags:
  - printk
  - linux
  - kernel
created: 2026-07-03
type: cheatsheet
---

## What is printk Levels

Quick reference for printk levels.

**KERN_INFO**: one of 8 log levels that a kernel printk can get logged at
- This log level is not a priority specifier, instead it allows us to filter messages based on log level

---

## Example / Usage

| Macro          | Shorthand     | Device variant | Value | Meaning                          |
| -------------- | ------------- | -------------- | ----- | -------------------------------- |
| `KERN_EMERG`   | `pr_emerg()`  | `dev_emerg()`  | 0     | System is unusable               |
| `KERN_ALERT`   | `pr_alert()`  | `dev_alert()`  | 1     | Action must be taken immediately |
| `KERN_CRIT`    | `pr_crit()`   | `dev_crit()`   | 2     | Critical conditions              |
| `KERN_ERR`     | `pr_err()`    | `dev_err()`    | 3     | Error conditions                 |
| `KERN_WARNING` | `pr_warn()`   | `dev_warn()`   | 4     | Warning conditions               |
| `KERN_NOTICE`  | `pr_notice()` | `dev_notice()` | 5     | Normal but significant condition |
| `KERN_INFO`    | `pr_info()`   | `dev_info()`   | 6     | Informational                    |
| `KERN_DEBUG`   | `pr_debug()`  | `dev_dbg()`    | 7     | Debug-level messages             |
| `KERN_DEFAULT` | —             | —              | ""    | The default                      |

```c
/* These two lines are equivalent */
printk(KERN_WARNING "temperature too high: %d\n", temp);
pr_warn("temperature too high: %d\n", temp);
```

> [!note]
> - `pr_debug()` only prints when `DEBUG` is defined or dynamic debug is enabled for that call site.
> - `KERN_DEFAULT` has no `pr_*` shorthand, so use `printk(KERN_DEFAULT ...)` directly.
> - Use `pr_warn()`, not `pr_warning()`; the older name was removed from the kernel.


`KERN_SOH` (`\001`, ASCII Start Of Header) is prepended to each level value — it's the marker that tells the kernel a priority follows, not a level itself.

Source: `include/linux/kern_levels.h`
