---
title: Week 5 — Syscalls & file IO
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-10
status: on-contract
client: personal
deadline:
stack:
---
| Day       | Task (≈30 min)                                                                                                                               |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | `cat` clone using raw `open`/`read`/`write`/`close` (no stdio). Handle short reads correctly.                                                |
| Tue       | Run your cat clone under `strace`. Read every line of output until each syscall makes sense. Then `strace ls` and skim.                      |
| Wed       | **hexdump utility** like `xxd`: offset column, 16 hex bytes, ASCII column.                                                                   |
| Thu       | Rewrite the cat clone with `mmap` instead of read. Compare both under strace.                                                                |
| Fri       | Parse a binary file format: read a BMP or WAV header into a packed struct (`__attribute__((packed))`), print its fields.                     |
| Sat (lab) | `stat` clone: print file size, permissions (decode the mode bits yourself), timestamps. Add error handling with `errno`/`perror` everywhere. |
| Sun       | Rest / catch-up.                                                                                                                             |


## Progress Log

- 2026-08-10: Contract initialized

# Monday


| FD  | Name   | Purpose         |
| --- | ------ | --------------- |
| 0   | stdin  | standard input  |
| 1   | stdout | standard output |
| 2   | stderr | standard error  |

``` c
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>

#define BUF_SIZE 4096
size_t write_all(int fd, const char *buf, size_t count){
	size_t total = 0;
	while (total < count){
		ssize_t n = write(fd, buf+total, count-total);
		if (n < 0){
			if(errno == EINTR) continue;
			return -1;
		}
		total+=n;
	}
	return total;
}
int main(int argc, char **argv){
	int fd = open(argv[1], O_RDONLY);
	char buf[BUF_SIZE];
	size_t n;
	while (1){
		n = read(fd,buf,BUF_SIZE);
		if (n < 0){
			if (errno == EINTR) continue;//interrupted syscall, just retry
			perror("read");
			close(fd);
			return 1;
		}
		if (n == 0){
			return 0;
		}
		if (write_all(1,buf,n)<0){
			perror("write");
			close(fd);
			return 1;
		}
	}


}
```

## Notes

 `read(fd, buf, BUF_SIZE)` is a _request_, not a _guarantee_

The call says: "kernel, I have a buffer `buf` that can hold up to `BUF_SIZE` (4096) bytes — give me as many bytes as you can, up to that limit."

The kernel is free to give you **fewer** than that. `BUF_SIZE` is just the _ceiling_ — the size of the empty box you're handing over. It is not a promise the box comes back full.

So this single call handles both cases automatically, because of what it returns:

- If there are ≥4096 bytes left in the file → kernel fills the buffer completely, returns `n = 4096`.
- If there are only, say, 708 bytes left (the "last bits" at the end of the file) → kernel copies just those 708 bytes into your buffer, and returns `n = 708`.
- If there's nothing left → returns `n = 0`.

The number `4096` never changes — that's just the size of your buffer, fixed at compile time. What changes call-to-call is `n`, the **return value**, telling you how many bytes actually landed in that buffer this time.

### So where does "handling" the partial read happen?

Not in the `read()` call itself — that call already naturally gives you the correct count via its return value, no matter how much data was available. The "handling" is entirely about **what you do with `n` afterward**:


```c
n = read(fd, buf, BUF_SIZE);   // ask for up to 4096, get back however many exist
```

- Correct: `write_all(1, buf, n)` — write exactly the `n` bytes that were actually read

# Tuesday

```c title=strace-output
strace ./main test.txt 
execve("./main", ["./main", "test.txt"], 0x7ffda2518298 /* 49 vars */) = 0
brk(NULL)                               = 0x55aa96fe6000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=187543, ...}) = 0
mmap(NULL, 187543, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f708214c000
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200y\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 896, 64) = 896
fstat(3, {st_mode=S_IFREG|0755, st_size=2190624, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f708214a000
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 896, 64) = 896
mmap(NULL, 2214768, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f7081e00000
mmap(0x7f7081e24000, 1531904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x24000) = 0x7f7081e24000
mmap(0x7f7081f9a000, 479232, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19a000) = 0x7f7081f9a000
mmap(0x7f708200f000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20e000) = 0x7f708200f000
mmap(0x7f7082015000, 31600, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f7082015000
close(3)                                = 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f7082147000
arch_prctl(ARCH_SET_FS, 0x7f7082147740) = 0
set_tid_address(0x7f7082147d68)         = 8224
set_robust_list(0x7f7082147a20, 24)     = 0
rseq(0x7f7082147680, 0x21, 0, 0x53053053) = 0
mprotect(0x7f708200f000, 16384, PROT_READ) = 0
mprotect(0x55aa6330b000, 4096, PROT_READ) = 0
mprotect(0x7f70821bc000, 8192, PROT_READ) = 0
prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
getrandom("\xc0\x8a\xa6\x5e\x57\x0e\x98\x21", 8, GRND_NONBLOCK) = 8
munmap(0x7f708214c000, 187543)          = 0
openat(AT_FDCWD, "test.txt", O_RDONLY)  = 3
read(3, "Hello World!\n", 4096)         = 13
write(1, "Hello World!\n", 13Hello World!
)          = 13
read(3, "", 4096)                       = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

## Notes

- **Dynamic linker setup**: `access("/etc/ld.so.preload"...)`, `openat(.../ld.so.cache...)`, and the `libc.so.6` loading/mmap calls are just the loader mapping shared libraries into memory before your program's actual logic runs. This is boilerplate you'll see in almost any dynamically-linked binary's trace.
- **Thread/TLS setup**: `arch_prctl`, `set_tid_address`, `set_robust_list`, `rseq` — glibc initializing thread-local storage and threading bookkeeping.
- So `read(3` since as seen prior the file descriptors 0-2 are already take so the file descriptor hands out the **lowest unused number** each time something is opened
- **File descriptors**: small integers a process uses to refer to open files
- `openat(AT_FDCWD, "test.txt", O_RDONLY) = 3` — opens the file, gets file descriptor 3
- `read(3, "Hello World!\n", 4096) = 13` means read 13 bytes from the file
- `write(1, "Hello World!\n", 13) = 13` — writes those 13 bytes to stdout (fd 1)
- `read(3, "", 4096) = 0` — reads again, gets 0 bytes (EOF)
- `exit_group(0)` — process exits cle

# Wednesday