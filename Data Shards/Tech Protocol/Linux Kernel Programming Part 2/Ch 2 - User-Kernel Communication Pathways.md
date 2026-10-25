---
type: datashard
category: book-chapter
book: "[[Linux Kernel Programming]]"
author: Kaiwan N. Billimoria
chapter: 2
chapter_title: "User-Kernel Communication Pathways "
status: in-progress
tags:
  - book-notes
  - kernel
  - c
date_started: 2026-10-17
last_updated: 2026-10-25
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

**Summary**: 

---

## Code / Commands / Snippets

```c
// paste and annotate notable code as you go
```

**What it does:**

**Notes On Code Above:**

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
- Table of contents: [[Linux Kernel Programming Part 2]]
- Previous: [[Ch 1 - Writing a Simple misc Character Device Driver]]
