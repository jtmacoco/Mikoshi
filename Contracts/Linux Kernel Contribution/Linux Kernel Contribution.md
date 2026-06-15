**Source**: [[Contracts]]
**Tags**: #linux  #on-contract
**Description**: Plan to make contribution to Linux Kernel
# C → Linux Kernel Contribution: 16-Week Daily Schedule

**Format:** ~30 min on weekdays. Saturday is a flexible "lab day" (45–60 min if you have it) for the bigger multi-session items. Sunday is rest or catch-up — falling behind is normal; just shift days, never skip a week's theme.

**Rules for every day:**

- Everything lives in one git repo (`c-practice/`), one folder per week. Commit daily with a real message (`Add word-aligned memcpy fast path`, not `update`).
- Every project gets a Makefile, written by hand. No IDE build buttons.
- Compile with `gcc -Wall -Wextra -g`. Run anything with pointers under `valgrind` or build with `-fsanitize=address`.
- Keep reading Billimoria in parallel — the book is your "theory track," this schedule is your "hands-on track."

---

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

### Week 2 — Bit manipulation

|Day|Task (≈30 min)|
|---|---|
|Mon|Set/clear/toggle/test a bit at position n. Count set bits three ways: naive loop, Kernighan's `n & (n-1)` trick, lookup table.|
|Tue|Check power-of-two, round up to next power of two, reverse the bits of a `uint32_t`.|
|Wed|Write alignment macros: `ALIGN_UP(x, a)`, `ALIGN_DOWN(x, a)`, `IS_ALIGNED(x, a)` (assume `a` is a power of two). These appear constantly in kernel code.|
|Thu|Implement a **bitmap**: `bitmap_set(map, n)`, `bitmap_clear`, `bitmap_test`, `bitmap_find_first_zero` over a `uint64_t` array. (The kernel tracks free pages this way.)|
|Fri|Write a function that hexdumps the raw bytes of _any_ value (`float`, `struct`, pointer). Use it to: detect endianness, see struct padding, look at IEEE-754 float layout.|
|Sat (lab)|Skim [`include/linux/bitops.h`](https://github.com/torvalds/linux/blob/master/include/linux/bitops.h) and `include/linux/bitmap.h`. Use `offsetof`/`sizeof` to inspect padding in a struct you define, then reorder fields to shrink it.|
|Sun|Rest / catch-up.|

### Week 3 — Allocators (the big one)

|Day|Task (≈30 min)|
|---|---|
|Mon|**Arena/bump allocator**: `arena_init(buf, size)`, `arena_alloc(n)` (just bump a pointer, aligned to 8), `arena_reset()`.|
|Tue|**Fixed-size pool allocator**: pre-carve a buffer into N equal slots, keep a free list of slots, `pool_alloc`/`pool_free` in O(1). (This is the idea behind the kernel slab allocator.)|
|Wed|**Free-list allocator, part 1**: block header struct (`size`, `next`), `my_malloc` that first-fit searches a free list over a static buffer.|
|Thu|**Free-list allocator, part 2**: `my_free` that returns blocks to the list; coalesce adjacent free blocks.|
|Fri|Add block splitting (don't hand out a 4 KB block for a 16-byte request). Write a stress test: random alloc/free loop, assert no corruption.|
|Sat (lab)|Replace the static buffer with real memory from `mmap(NULL, ..., MAP_ANONYMOUS)`. You now have a toy malloc. Run your stress test under ASan.|
|Sun|Rest / catch-up.|

### Week 4 — Kernel-idiom data structures

|Day|Task (≈30 min)|
|---|---|
|Mon|Implement `container_of(ptr, type, member)` yourself using `offsetof`. Write a tiny demo proving it recovers the outer struct from a pointer to a member. **This is THE kernel idiom — don't skip.**|
|Tue|Circular doubly linked list, kernel-style: the `struct list_head { *next, *prev }` is _embedded inside_ your data struct, not the other way around. Write `list_init`, `list_add`.|
|Wed|Add `list_del`, `list_for_each`, and a `list_entry` macro built on your `container_of`.|
|Thu|**Ring buffer** (power-of-two size, head/tail indices, index with `& (size-1)`): `rb_put`, `rb_get`, full/empty detection.|
|Fri|Hash table with chaining, using your kernel-style list as the bucket chains.|
|Sat (lab)|Read [`include/linux/list.h`](https://github.com/torvalds/linux/blob/master/include/linux/list.h) top to bottom — you'll understand all of it now. Compare with yours.|
|Sun|Rest / catch-up. Phase 1 done — you now write C the way the kernel does.|

---

## PHASE 2 — Weeks 5–8: Systems programming (userspace side of the boundary)

### Week 5 — Syscalls & file I/O

|Day|Task (≈30 min)|
|---|---|
|Mon|`cat` clone using raw `open`/`read`/`write`/`close` (no stdio). Handle short reads correctly.|
|Tue|Run your cat clone under `strace`. Read every line of output until each syscall makes sense. Then `strace ls` and skim.|
|Wed|**hexdump utility** like `xxd`: offset column, 16 hex bytes, ASCII column.|
|Thu|Rewrite the cat clone with `mmap` instead of read. Compare both under strace.|
|Fri|Parse a binary file format: read a BMP or WAV header into a packed struct (`__attribute__((packed))`), print its fields.|
|Sat (lab)|`stat` clone: print file size, permissions (decode the mode bits yourself), timestamps. Add error handling with `errno`/`perror` everywhere.|
|Sun|Rest / catch-up.|

### Week 6 — Processes & signals

|Day|Task (≈30 min)|
|---|---|
|Mon|`fork()` hello world: parent prints its PID and the child's; child prints its own and its parent's. Then fork twice and draw the process tree on paper.|
|Tue|`fork` + `execvp` + `waitpid`: run a command given on argv and report its exit status.|
|Wed|**Mini shell, part 1**: read a line, split into argv tokens (use your strtok!), fork/exec/wait in a loop. `exit` builtin.|
|Thu|**Mini shell, part 2**: add `cd` builtin and `>` output redirection (`open` + `dup2`).|
|Fri|Signals: install a `SIGINT` handler with `sigaction` so Ctrl-C prints a message instead of killing your shell. Read why you can only call async-signal-safe functions in handlers.|
|Sat (lab)|**Mini shell, part 3**: pipes — support `cmd1|
|Sun|Rest / catch-up.|

### Week 7 — /proc, /sys, and kernel interfaces

|Day|Task (≈30 min)|
|---|---|
|Mon|Spend the session just exploring: `cat /proc/cpuinfo`, `/proc/meminfo`, `/proc/self/status`, `/proc/self/maps`. Look at `/proc/self/maps` and identify stack, heap, your binary, libc.|
|Tue|Write a program that parses `/proc/meminfo` and prints memory usage as a percentage.|
|Wed|Write a mini `ps`: iterate `/proc/[pid]/` directories, read `comm` and `status`, print PID + name + state.|
|Thu|Parse `/proc/[pid]/maps` for a given PID and total up its mapped memory.|
|Fri|Explore `/sys`: find your CPU's frequency, cache sizes (`/sys/devices/system/cpu/cpu0/cache/`), and a block device's size. Write a small reader for one of them.|
|Sat (lab)|Cache experiment: sum a large 2D array row-major vs column-major, time both. Then array traversal vs linked-list traversal of the same data. Connect the numbers to the cache sizes you found in /sys.|
|Sun|Rest / catch-up.|

### Week 8 — Concurrency

|Day|Task (≈30 min)|
|---|---|
|Mon|Two pthreads increment a shared counter 1M times each _without_ locking. Run it five times, watch the result differ. Your first data race.|
|Tue|Fix it with a `pthread_mutex_t`. Then fix it again with C11 `atomic_fetch_add`. Time all three versions.|
|Wed|Producer/consumer: one thread `rb_put`s into your Week-4 ring buffer, another `rb_get`s, guarded by a mutex + condition variable.|
|Thu|Deadlock on purpose: two threads, two mutexes, opposite lock order. Watch it hang, attach `gdb` to see where. Fix with consistent lock ordering.|
|Fri|Run Monday's racy program under `valgrind --tool=helgrind` or build with `-fsanitize=thread`. Read the report fully.|
|Sat (lab)|Read about spinlocks vs mutexes and why the kernel cares about the difference (you can't sleep in interrupt context). Skim Billimoria's locking chapters if you've reached them.|
|Sun|Rest / catch-up. Phase 2 done — userspace holds no mysteries.|

---

## PHASE 3 — Weeks 9–14: Kernel land

> From here, work inside a VM (QEMU or VirtualBox) so crashes are consequence-free. Sync with Billimoria's chapters — the book covers all of this in depth.

### Week 9 — Build and boot your own kernel

| Day       | Task (≈30 min)                                                                                                                                                                                                   |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Set up the VM + install build deps (`build-essential, libncurses-dev, flex, bison, libssl-dev, libelf-dev, bc`). Start `git clone` of the kernel (it's big — let it run).                                        |
| Tue       | `make defconfig`, then poke around `make menuconfig` for 15 min just to see what's in there. Start `make -j$(nproc)` and let it build while you read.                                                            |
| Wed       | Finish/fix the build. `make modules_install && make install` (or copy bzImage for QEMU).                                                                                                                         |
| Thu       | Boot your kernel. Verify with `uname -r`. If it doesn't boot, debugging that _is_ the lesson.                                                                                                                    |
| Fri       | Change one thing: edit the version string (`CONFIG_LOCALVERSION` or EXTRAVERSION in the top Makefile), rebuild (notice incremental builds are fast), reboot, see your name in `uname -r`.                        |
| Sat (lab) | Explore the source tree: `kernel/`, `mm/`, `fs/`, `drivers/`, `include/linux/`. Find `lib/string.c` and `include/linux/list.h` — old friends. Install `cscope` or use https://elixir.bootlin.com for navigation. |
| Sun       | Rest / catch-up.                                                                                                                                                                                                 |

### Week 10 — First kernel modules

| Day       | Task (≈30 min)                                                                                                                                                           |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Mon       | Hello-world module: `module_init`/`module_exit`, `printk`, the `obj-m += hello.o` Makefile. `insmod`, check `dmesg`, `rmmod`.                                            |
| Tue       | Add `MODULE_LICENSE/AUTHOR/DESCRIPTION`, use `pr_info`/`pr_err` instead of raw printk, read about printk log levels. `modinfo` your module.                              |
| Wed       | Module parameters: `module_param(myint, int, 0644)`, pass it at insmod time, change it via `/sys/module/yourmod/parameters/`.                                            |
| Thu       | Make the module do something at init: walk the kernel's task list (`for_each_process`) and print every PID + comm to dmesg. Your Week-4 list knowledge pays off here.    |
| Fri       | Deliberately oops: dereference NULL in your module, read the oops in dmesg line by line (RIP, call trace, registers). Reboot the VM, no harm done.                       |
| Sat (lab) | Re-read the matching Billimoria chapters with the code open. Clean up your modules; run `scripts/checkpatch.pl --file` on them for the first time and fix every warning. |
| Sun       | Rest / catch-up.                                                                                                                                                         |

### Week 11 — Character device driver

| Day       | Task (≈30 min)                                                                                                                               |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Skeleton **misc char device** (`miscdevice` + `misc_register`): registers `/dev/mydev`, empty `file_operations`.                             |
| Tue       | Implement `open` and `release`; log who opens it.                                                                                            |
| Wed       | Implement `read`: return a fixed message via `copy_to_user`. Test with `cat /dev/mydev`.                                                     |
| Thu       | Implement `write` with `copy_from_user` into a kernel buffer; make `read` return whatever was last written. You've built a tiny echo device. |
| Fri       | Handle edge cases: partial reads (`*ppos`), buffer bounds, return values. Test with `dd bs=1`.                                               |
| Sat (lab) | Add a mutex around the buffer (two processes writing concurrently = the race you made in Week 8, but in the kernel). checkpatch everything.  |
| Sun       | Rest / catch-up.                                                                                                                             |

### Week 12 — Kernel APIs

| Day       | Task (≈30 min)                                                                                                                                              |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Replace your driver's static buffer with `kmalloc`/`kfree`. Read about GFP flags (`GFP_KERNEL` vs `GFP_ATOMIC`) — and why the difference exists (sleeping). |
| Tue       | Use the real kernel linked list (`LIST_HEAD`, `list_add_tail`, `list_for_each_entry`) to store every string ever written to your device.                    |
| Wed       | Create a `/proc/mydev_stats` entry (`proc_create` + `seq_file`) showing read/write counts.                                                                  |
| Thu       | Add a timer (`timer_setup`/`mod_timer`) that logs a heartbeat every 5 s while the module is loaded.                                                         |
| Fri       | Add a sysfs attribute (`device_create_file` or kobject attr) to expose one tunable of your driver.                                                          |
| Sat (lab) | Read your whole driver top to bottom as if reviewing a stranger's patch. checkpatch with `--strict`. Fix style ruthlessly.                                  |
| Sun       | Rest / catch-up.                                                                                                                                            |

### Weeks 13–14 — Debugging & tracing

| Day         | Task (≈30 min)                                                                                                                                                                                                                                                                                                                 |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| W13 Mon     | Dynamic debug: `pr_debug` in your module, enable it at runtime via `/sys/kernel/debug/dynamic_debug/control`.                                                                                                                                                                                                                  |
| W13 Tue     | Decode an oops properly: trigger one, use `addr2line`/`gdb` on the module `.ko` to map RIP to your source line.                                                                                                                                                                                                                |
| W13 Wed     | ftrace 101: `trace-cmd record -p function_graph` (or raw tracefs) on one of your device reads; look at the call graph.                                                                                                                                                                                                         |
| W13 Thu     | Trace your own functions: filter ftrace to `mydev_*` and watch your driver execute.                                                                                                                                                                                                                                            |
| W13 Fri     | `perf top` and `perf stat` on your Week-7 cache experiment. See cache misses as actual counter values.                                                                                                                                                                                                                         |
| W13 Sat     | KASAN: rebuild kernel with `CONFIG_KASAN=y` (start build, takes a while), then write a deliberate use-after-free in your module and watch KASAN catch it.                                                                                                                                                                      |
| W14 Mon–Fri | Buffer week: finish anything that slipped, re-do whatever felt shaky, finish remaining Billimoria chapters. As a test engineer you'll appreciate this one: write a userspace **test script** for your char driver (open/read/write/edge cases) — this is exactly what kernel selftests look like (`tools/testing/selftests/`). |
| W14 Sat     | Skim a real staging driver in `drivers/staging/` end to end. Notice you can mostly read it now.                                                                                                                                                                                                                                |
| W14 Sun     | Rest. Phase 3 done — you've written, broken, and debugged kernel code.                                                                                                                                                                                                                                                         |

---

## PHASE 4 — Weeks 15–16+: The road to a merged patch

### Week 15 — Tooling & process

| Day       | Task (≈30 min)                                                                                                                                                                                                             |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Read `Documentation/process/submitting-patches.rst` (in your kernel tree). Half today, half tomorrow.                                                                                                                      |
| Tue       | Finish it + read `Documentation/process/coding-style.rst`.                                                                                                                                                                 |
| Wed       | Set up `git send-email` (Gmail app-password or msmtp). Practice: `git format-patch -1` on a commit in your practice repo and send it **to yourself**. Check it arrives as clean plain text.                                |
| Thu       | Do the kernelnewbies.org **First Kernel Patch** tutorial, part 1. Subscribe to the kernelnewbies mailing list.                                                                                                             |
| Fri       | First Kernel Patch tutorial, part 2. Learn `get_maintainer.pl` — run it on a few files to see who you'd mail.                                                                                                              |
| Sat (lab) | Clone the **staging tree** (Greg KH's staging.git, `staging-next` branch). Run `checkpatch.pl -f` across files in `drivers/staging/` and shortlist real warnings you understand (style, spacing, unnecessary casts, etc.). |
| Sun       | Rest.                                                                                                                                                                                                                      |

### Week 16 — First patch

| Day | Task (≈30 min)                                                                                                                                                                   |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon | Pick ONE small checkpatch cleanup in `drivers/staging/` from your shortlist. Make the fix. Build that driver (`make M=drivers/staging/xxx`) to prove it compiles.                |
| Tue | Write the commit message in kernel style: `staging: xxx: fix yyy` subject, imperative body explaining _why_. Sign off with `git commit -s`.                                      |
| Wed | `git format-patch`, run checkpatch **on the patch itself**, fix anything. `get_maintainer.pl` for the To/Cc list.                                                                |
| Thu | Re-read the patch one final time as a reviewer would. Send it. 🎉                                                                                                                |
| Fri | While waiting: prepare a second, different cleanup the same way.                                                                                                                 |
| Sat | Read responses if any; respond politely, send v2 if asked (`[PATCH v2]` + changelog below the `---`). Otherwise browse the staging list to see how others' patches get reviewed. |
| Sun | Rest. You're a kernel contributor (or days away from being one).                                                                                                                 |

---

## After Week 16: becoming a real contributor

- **Pick one subsystem** you actually like (drivers you own hardware for, mm, networking, your laptop's wifi driver...). Lurk on its mailing list (lore.kernel.org) 15 min/day for 2–3 weeks before sending anything.
- Graduate from style cleanups to: doc fixes → small bug fixes from syzbot/bugzilla reports → adding selftests (your day job is a genuine superpower here — subsystems chronically lack tests) → small features.
- Keep a `notes.md` of every idiom and review comment you encounter. Review feedback on the lists is a free education.
- Sustainable pace beats heroics: 30 focused minutes daily for a year makes you genuinely dangerous.

## Slip policy (you have a job)

- Miss a day → shift everything; never compress two days into one.
- Miss a week → repeat the week's Sat lab as a refresher, then continue.
- A task overruns 30 min → stop mid-task, leave a `// NEXT:` comment, resume tomorrow. Resuming is its own skill and kernel work is exactly like this.