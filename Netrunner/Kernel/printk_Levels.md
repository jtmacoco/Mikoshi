---
title: printk Levels
source: "[[Kernel]]"
tags:
  - printk
  - linux
  - kernel
created: 2026-07-03
noteType: cheatsheet
---

## What is printk Levels

Quick reference for printk levels.

**KERN_INFO**: one of 8 log levels that a kernel printk can get logged at
- This log level is not a priority specifier, instead it allows us to filter messages based on log level

---

## Example / Usage

| Macro | Value | Meaning |
|---|---|---|
| `KERN_EMERG` | 0 | System is unusable |
| `KERN_ALERT` | 1 | Action must be taken immediately |
| `KERN_CRIT` | 2 | Critical conditions |
| `KERN_ERR` | 3 | Error conditions |
| `KERN_WARNING` | 4 | Warning conditions |
| `KERN_NOTICE` | 5 | Normal but significant condition |
| `KERN_INFO` | 6 | Informational |
| `KERN_DEBUG` | 7 | Debug-level messages |
| `KERN_DEFAULT` | "" | The default |

`KERN_SOH` (`\001`, ASCII Start Of Header) is prepended to each level value — it's the marker that tells the kernel a priority follows, not a level itself.

Source: `include/linux/kern_levels.h`
