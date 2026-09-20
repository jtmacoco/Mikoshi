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
| Minor Number     |                                               |       |

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

### 2026-09-19 
- 

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
