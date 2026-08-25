---
title: Week 7 — proc, sys, and kernel interfaces
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-24
status: on-contract
client: personal
deadline:
stack: c
---

| Day       | Task (≈30 min)                                                                                                                                                                                         |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Mon       | Spend the session just exploring: `cat /proc/cpuinfo`, `/proc/meminfo`, `/proc/self/status`, `/proc/self/maps`. Look at `/proc/self/maps` and identify stack, heap, your binary, libc.                 |
| Tue       | Write a program that parses `/proc/meminfo` and prints memory usage as a percentage.                                                                                                                   |
| Wed       | Write a mini `ps`: iterate `/proc/[pid]/` directories, read `comm` and `status`, print PID + name + state.                                                                                             |
| Thu       | Parse `/proc/[pid]/maps` for a given PID and total up its mapped memory.                                                                                                                               |
| Fri       | Explore `/sys`: find your CPU's frequency, cache sizes (`/sys/devices/system/cpu/cpu0/cache/`), and a block device's size. Write a small reader for one of them.                                       |
| Sat (lab) | Cache experiment: sum a large 2D array row-major vs column-major, time both. Then array traversal vs linked-list traversal of the same data. Connect the numbers to the cache sizes you found in /sys. |
| Sun       | Rest / catch-up.                                                                                                                                                                                       |

## Progress Log

- 2026-08-24: Contract initialized

# Monday

## Notes

- Swap is a memory management method.
- **Swap**: Is disk space your computer uses as overflow when it turns out of physical RAM

RAM is fast but limited. When your programs need more memory than you have RAM available, the operating system takes chunks of data that aren't being actively used and moves them from RAM onto a reserved area of your hard drive or SSD — that reserved area is the swap (sometimes called a "swap file," "swap partition," or "page file" on Windows). This frees up RAM for whatever needs it right now. If that swapped-out data is needed again, the OS moves it back into RAM.
- Kind of like a safety net
- `/proc/self/maps` is a virtual file on Linux that shows you the memory map of the process reading it — i.e., "self" means whatever process opened the file. If you `cat /proc/1234/maps` instead, you'd see process 1234's memory map.
- `libc` are standard c library (.so) files
- `.so` files are shared object files, Linux version of shared libraries (similar to windows `.dll` files)
- Idea is that rather than every program bundling its own private copy of common code, the code lives in one `.so` file