**Source**: [[Linux Kernel Contribution]]
**Tags**: #linux #on-contract
**Description**: Week one notes

## PHASE 1 — Weeks 1–4: C mastery, kernel-style

### Week 1 — String & memory functions

| Day       | Task (≈30 min)                                                                                                                                                                  |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Write `my_memset` and `my_memcpy` (byte-by-byte versions). Write the week's Makefile from scratch: one target, `CFLAGS`, `clean`.                                               |
| Tue       | Write `my_memmove` — handle overlapping regions (copy backwards when dst > src). Write a test that proves plain memcpy breaks on overlap and memmove doesn't.                   |
| Wed       | Write `my_strlen`, `my_strcpy`, `my_strncpy`, `my_strcmp`. Add pattern rules (`%.o: %.c`) and automatic variables (`$@`, `$<`) to the Makefile.                                 |
| Thu       | Write `my_strtok` (it keeps state between calls — use a `static` pointer, then think about why that's not thread-safe).                                                         |
| Fri       | Optimize `my_memcpy`: copy `size_t`-sized words instead of bytes; handle the unaligned head and tail bytes. Benchmark vs Monday's version with `clock_gettime`.                 |
| Sat (lab) | Read the kernel's real implementations in [`lib/string.c`](https://github.com/torvalds/linux/blob/master/lib/string.c). Compare to yours. Note every trick you didn't think of. |
| Sun       | Rest / catch-up.                                                                                                                                                                |

