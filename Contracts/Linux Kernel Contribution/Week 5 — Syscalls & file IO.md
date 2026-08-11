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

- ✅ Correct: `write_all(1, buf, n)` — write exactly the `n` bytes that were actually read