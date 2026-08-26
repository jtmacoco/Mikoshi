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

# Tuesday

## Solution

## Notes

- `strstr` finds first occurrence of substring within larger string
- `sscanf` reads formatted data from string instead of standard input (keyboard)
- `buf + total`: that's the write position, and it advances each loop iteration.

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#define BUF_SIZE 8192
int main(){
	printf("working\n");
	char *meminfo = "/proc/meminfo";
	int fd = open(meminfo,O_RDONLY);
	char buf[BUF_SIZE];

	size_t n;
	size_t total = 0;
	while ((n = read(fd, buf+total, sizeof(buf)-total-1)) > 0){
		total+=(size_t)(n);
		if (total >= sizeof(buf)-1) break;
	}
	close(fd);
	if (n < 0){
		write(2, "read failed\n", 12);
		return 1;
	}
	buf[total] = '\0';
	long mem_total = -1;
	long mem_available = -1;
	char *p;

	if ((p = strstr(buf, "MemTotal:"))!=NULL){
		sscanf(p, "MemTotal: %ld", &mem_total);
	}
	if ((p = strstr(buf, "MemAvailable:"))!=NULL){
		sscanf(p, "MemAvailable: %ld", &mem_available);
	}
	double percentage = ((double)mem_available/(double)mem_total) * 100;
	printf("%lo\n",mem_total);
	printf("%f\n",percentage);
	return 0;
}
```

# Wednesday