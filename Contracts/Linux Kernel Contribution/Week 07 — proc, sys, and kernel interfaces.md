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

## Notes

- `strstr` finds first occurrence of substring within larger string
- `sscanf` reads formatted data from string instead of standard input (keyboard)
- `buf + total`: that's the write position, and it advances each loop iteration.

# Wednesday

## Solution

```c
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define BUF_SIZE 8192
int main(int argc, char **argv){
	if (argc < 2){
		perror("Usage ./main pid\n");
		_exit(1);
	}
	char path[256];
	int p = snprintf(path,sizeof(path), "/proc/%s/maps",argv[1]);
	if (p < 0 || (size_t)p >= sizeof(path)){
		perror("pid argument to long\n");
		_exit(1);
	}
	char buf[BUF_SIZE];
	printf("%s\n",path);
	int fd = open(path,O_RDONLY);
	size_t n; 
	size_t total = 0;
	while ((n = read(fd, buf+total,BUF_SIZE-total-1))>0){
		total+=(size_t)n;
		if (total > BUF_SIZE-1) break;
	}
	close(fd);
	if (n < 0){
		perror("read failed");
		_exit(1);
	}
	buf[total] = '\0';
	unsigned long start, end;
	char *line = buf;
	unsigned long long mapped_total = 0;
	while (line < buf + total && *line){
		if (sscanf(line, "%lx-%lx", &start, &end) == 2){
			mapped_total += (end - start);
		}
		char *next = strchr(line, '\n');//move to end of line
		if (!next) break;
		line = next+1;
	}
	printf("Total mapped: %llu bytes (%.2f KB)\n", mapped_total, mapped_total / 1024.0);

	return 0;
}
```

## Notes

Each line in `/proc/[pid]/maps` looks like this:

```bash
address           perms offset   dev   inode   pathname
00400000-00452000 r-xp  00000000 08:02 173521  /usr/bin/dbus-daemon
7f3a2c000000-7f3a2c021000 rw-p 00000000 00:00 0
```

The size of each mapping is the **difference between the start and end addresses** in the first field (both in hex). So to get total mapped memory, you sum `(end - start)` for every line.

So difference between `00400000-00452000` from the above example

- `strchr` returns pointing at the `\n` character
- `sscanf` : Signature: `int sscanf(const char *str, const char *format, ...);` 

`str` — the string to parse (in this case, `line`, pointing partway into `buf`).
`format` — a format string, same mini-language as `printf`, describing what to look for and in what order.
`...` — pointers to variables where matched values get stored.
Return value — the number of items successfully matched and assigned. This is important and easy to overlook: it's not a boolean, it's a count.

# Thursday

- Mixed up Thursday and Wednesday 
