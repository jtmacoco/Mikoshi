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
last_updated: 2026-09-17
---

## TL;DR
> Keep this updated as your understanding sharpens — it's fine if it's rough or wrong early on.

---

## Vocabulary / Key Terms
<!-- Add terms the moment you hit them, even before you fully understand them -->

| Term             | Definition                                    | Notes |
| ---------------- | --------------------------------------------- | ----- |
| Device Driver    | Interface between OS and peripheral hw device |       |
| Device File/Node | Entry point into device driver                |       |
| Major Number     | Represents the class of device                |       |
| Minor Number     | The interpretation of the device              |       |
| LDM              | Linux Device Model                            |       |

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

### 2026-09- 20
- When you pplug in a device like a USB, the bus driver (USB bus) notices it and matches it to the right device driver; once matched ("bound"), the kernel calls the driver's `probe()` function, which sets up the device (allocates memory, IRQs, etc) sit it's ready to use.
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

![[Ch 1 - Writing a Simple misc Character Device Driver-20260917235845549.png]]

### 2026-09-16 
- Read the intro
- Kernel Distinguishes between device files by two attributes
	1. Type of file - either character (char) or block
	2. The major and minor number see [[Writing Your First Kernel Module Part 1]] for more info

---

## Code / Commands / Snippets

```c
// paste and annotate notable code as you go
```

**What it does:**
**Gotchas / edge cases:**

---

## Architecture / Diagrams


---

## Questions & Confusions
- 

---

## Connections
- Builds on: 
- Contrasts with: 
- Referenced later in: 

---

## Personal Analogies 
- 

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
