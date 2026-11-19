# Progress

## About me
- C experience: decent
- Kernel experience: has built and loaded simple modules; knows the basics
- Setup: Ubuntu VM (kernel 7.0.0-38-generic, gcc 15.2, coreutils are uutils, so `dd` behaves differently from GNU); this directory (on an Arch host, kernel 7.2.6-arch) is mounted into the VM at `/mnt/practice`. Build and load inside the VM. Kernel tree with checkpatch on the host: `~/kernel-dev/linux`. Hardware on hand: Raspberry Pi, ESP32 starter kit, 3D printer.
- Goals: contribute to the Linux kernel, specifically NVIDIA GPU drivers (nouveau/nova); long term, firmware for robots or rockets

## Current level
Level 2: Character device (second exercise). 02-kbuf-chardev works (38/38 tests), no critical findings, but I moved on before it formally passed (checkpatch 17E/5W, race comment incomplete, README questions unanswered). Because `read`/`write`/`open` took many rounds of help and the goto unwind was never done without help, Level 2 is being repeated with 03-kbank-multi before moving to Level 3.

## Weak spots
Top 3–5 concepts to focus on right now, each with one line on why.
- `off` vs `*off` (pointer vs pointee): mechanics now right (quiz 11-18), but still calls `*off` "global"; it's the `f_pos` of one `struct file`.
- printk format specifiers: `%u` on a signed int twice (02, quiz 11-18); -1 prints as 4294967295.
- Kernel coding style: the brace rule is still not clear (only function definitions put `{` on its own line); 02 left at 17E/5W; quiz answers had `{return ...;}` and `( (`.
- Concurrency reasoning: couldn't identify the check-then-set lost update on `data_len`; thought `data_len` was per-process and `ubuf` was shared.
- Error unwinding in real code: quiz 11-18 was clean (rating 3), but it has never been written without help; `kbank_init` in 03 is the real test.

## Concept tracker
Rating: 1 = can't do it without help, 2 = shaky, 3 = OK with docs, 4 = solid, 5 = could teach it.

| Concept | Level | Rating | Last practiced | Last tested | Notes |
|---|---|---|---|---|---|
| module_init/module_exit, __init/__exit | 1 | 3 | 2026-10-24 | – | Used correctly in 01 |
| module_param / MODULE_PARM_DESC | 1 | 3 | 2026-10-24 | – | Comfortable in 01 |
| sysfs param permissions | 1 | 3 | 2026-10-24 | 2026-11-18 | Set perms right, but couldn't explain write-bypasses-validation / charp 0444 |
| pr_fmt + KBUILD_MODNAME, pr_info | 1 | 4 | 2026-11-08 | 2026-11-18 | Used correctly in 01 and 02; predicted the prefix right in quiz 11-18 |
| printk format specifiers | 1 | 1 | 2026-11-08 | 2026-11-18 | Printed signed `size` with `%u` in 02; quiz 11-18 predicted `%u` of -1 prints `-1` (it prints 4294967295) |
| Failing init with an errno | 1 | 3 | 2026-11-08 | – | -EINVAL for a bad size in 02, correct |
| MODULE_LICENSE strings | 1 | 2 | 2026-10-24 | – | Confused with SPDX id ("GPL-2.0") |
| Kernel coding style / checkpatch | 1 | 1 | 2026-11-08 | – | 02: 33E/9W → 17E/5W; put braces on their own line for every block |
| Reading build errors | 1 | 2 | 2026-11-08 | – | Couldn't read `gcc: not found` / Error 127 in the VM |
| Error unwinding with goto | 2 | 3 | 2026-11-01 | 2026-11-18 | Correct in 02 only after heavy help; quiz 11-15: 1/3 bugs; quiz 11-18: found both (unset `ret`, wrong label skipping class_destroy). Still needs doing in real code without help (03) |
| Teardown order (reverse of init) | 2 | 2 | 2026-11-01 | – | `kbuf_exit` order needed repeated correction in 02 |
| ERR_PTR / IS_ERR / PTR_ERR | 2 | 2 | 2026-11-01 | 2026-11-15 | Used `!ptr` first in 02; fixed after a pointer to `err.h` |
| cdev_init / cdev_add / cdev_del | 2 | 2 | 2026-11-01 | – | Forgot `cdev_add()` at first; assigned `cdev_init()`'s void result to `ret` |
| class_create / device_create and destroy | 2 | 2 | 2026-11-01 | – | Used correctly after pointers; wrong device name and order at first |
| alloc_chrdev_region / MAJOR / MINOR | 2 | 3 | 2026-11-01 | – | Misread the base minor as `10` at first, then fixed it |
| kzalloc / kfree | 2 | 2 | 2026-11-08 | – | Wrong `kfree()` args in 11-01; used `sizeof(pointer)` as the allocation size in 11-08 |
| file_operations .owner | 2 | 2 | 2026-11-08 | – | Refcount test passes; README question 3 not answered yet |
| copy_to_user / copy_from_user | 2 | 2 | 2026-11-08 | – | Return value OK after a hint; used `copy_to_user` in `write`, then swapped `copy_from_user` args |
| File position `loff_t *ppos` | 2 | 2 | 2026-11-08 | 2026-11-18 | `off` vs `*off` confusion three times; quiz 11-15: fixes right but framed it as local vs global; used bare `off` again in Q2; quiz 11-18: knew the infinite-loop symptom and one f_pos per open, but still said "global `*off`" |
| Read/write bounds clamping | 2 | 3 | 2026-11-08 | 2026-11-18 | Quiz 11-15: proposed `off >= room`, mispredicted the overflow; quiz 11-18: all correct (always-false `< 0`, overflow + returns count, `*off >= SIZE` then clamp) |
| open() flags: O_ACCMODE, O_TRUNC, f_flags/f_mode | 2 | 3 | 2026-11-08 | 2026-11-18 | 02: needed help to get to O_ACCMODE; quiz 11-18: predicted all 4 cases of `& (O_WRONLY\|O_TRUNC)` and wrote the O_ACCMODE fix unaided |
| nonseekable_open / NULL .llseek | 3 | 2 | 2026-11-08 | – | Knew the LDD3 rule; modern kernels: NULL llseek → -ESPIPE |
| Races on shared driver state | 5 | 1 | 2026-11-08 | – | Missed the `data_len` check-then-set lost update in 02 |

## Mistakes to revisit
Specific mistakes and misconceptions. Mark `[x]` when resolved (two correct quiz answers).
- [ ] 2026-10-24, 01-greeter-params: wrote `MODULE_LICENSE("GPL-2.0")` → SPDX ids go in the `// SPDX-License-Identifier:` comment; MODULE_LICENSE takes strings like "GPL" or "GPL v2"
- [ ] 2026-10-24, 01-greeter-params: brace placement and spacing errors flagged by checkpatch → function braces on their own line, `if (x) {` style, space after keywords
- [ ] 2026-10-24, 01-greeter-params: could not explain why writing a param via sysfs bypasses init-time validation → sysfs writes go straight to the variable via param ops; init's checks only run once at load
- [ ] 2026-10-24, 01-greeter-params: could not explain why a charp param should be 0444 → a sysfs write would free/replace the string under code that may be using it
- [ ] 2026-11-01, 02-kbuf-chardev: success path fell through into the cleanup labels, then `goto`'d into `class_destroy()` → success must return before the first label
- [ ] 2026-11-01, 02-kbuf-chardev: `goto` jumped to the label for the step that failed → jump to the label that undoes the last step that succeeded; the first step just returns
- [ ] 2026-11-01, 02-kbuf-chardev: after reordering setup, changed the `goto` targets but left the labels in the old order, which left a live cdev after a `class_create()` failure → a failing step runs everything below its label, so labels must be the exact reverse of setup
- [ ] 2026-11-01, 02-kbuf-chardev: `kzalloc()` failure returned directly after `alloc_chrdev_region()` had succeeded, leaking the device number → once anything has succeeded, unwind instead of returning
- [ ] 2026-11-01, 02-kbuf-chardev: checked `class_create()`/`device_create()` with `!ptr` → they return ERR_PTR, never NULL; use `IS_ERR()` and `PTR_ERR()`
- [ ] 2026-11-01, 02-kbuf-chardev: `ret` left at 0 on the `class_create()` failure path → a failure would have returned success; set `ret` before every `goto` (quiz correct 1/2: 11-18)
- [ ] 2026-11-01, 02-kbuf-chardev: `kfree(kbuf)` freed the class, then `kfree(&my_ctx.buf)` passed the address of the pointer field → pass the value `kzalloc()` returned; the compiler won't catch it because `kfree()` takes `const void *`
- [ ] 2026-11-01, 02-kbuf-chardev: `device_destroy()` ran after `class_destroy()` in `kbuf_exit` → the device goes first because it depends on the class
- [ ] 2026-11-01, 02-kbuf-chardev: `cdev_del()` missing from exit, then called on the `cdev_add()` failure path → always delete a live cdev at exit, but never one that was never added
- [ ] 2026-11-01, 02-kbuf-chardev: `ret = cdev_init(...)` → `cdev_init()` returns void; check signatures in `include/linux/cdev.h`
- [ ] 2026-11-01, 02-kbuf-chardev: passed `10` as the base minor to `alloc_chrdev_region()`, thinking of it as a device number → that argument is the first minor; use 0 for a single device
- [ ] 2026-11-08, 02-kbuf-chardev: `off += n`, then `flip += n`, then `buffer + off` in `kbuf_read` → `off` is the address of the position; read and write it with `*off`
- [x] 2026-11-08, 02-kbuf-chardev: `if ((data_len - count) < 0)` on `size_t` → unsigned subtraction never goes negative, it wraps; compare before subtracting (quiz correct 2/2: 11-15, 11-18)
- [ ] 2026-11-08, 02-kbuf-chardev: `int bytes_to_copy = count` → keep `size_t`; `int` can truncate or go negative
- [ ] 2026-11-08, 02-kbuf-chardev: `copy_to_user()` failure logged but read carried on, and returned `count` instead of bytes copied → return `-EFAULT` on any uncopied bytes; return what was actually copied
- [ ] 2026-11-08, 02-kbuf-chardev: checked `inode->i_mode == O_TRUNC` in open → open flags are in `filp->f_flags` (per open), i_mode is the node's type/permissions; flags are a bitmask, test with `&`
- [ ] 2026-11-08, 02-kbuf-chardev: `f_flags & (O_WRONLY | O_TRUNC)` as "both set", then `O_ACCMODE & O_WRONLY` → `&` with an OR'd mask means *any*; the access mode is a 2-bit field (RDONLY 0, WRONLY 1, RDWR 2), so mask the flags with O_ACCMODE and compare, or test `f_mode & FMODE_WRITE` (quiz correct 1/2: 11-18)
- [ ] 2026-11-08, 02-kbuf-chardev: thought O_TRUNC reset should only apply to write-only opens → "opened for writing" includes O_RDWR (e.g. `fopen("w+")`)
- [ ] 2026-11-08, 02-kbuf-chardev: `write` limited by `data_len` instead of the capacity `size` → read is bounded by valid data, write by room
- [ ] 2026-11-08, 02-kbuf-chardev: `sizeof(buffer)` as the buffer size → sizeof a `char *` is 8, computed at compile time; keep the allocation size yourself
- [ ] 2026-11-08, 02-kbuf-chardev: `remaining = size - count` in write → heap overflow when count > size (unsigned wrap); remaining depends on the position: `size - *off` (quiz correct 1/2: 11-18)
- [ ] 2026-11-08, 02-kbuf-chardev: used `copy_to_user()` in `write`, then `copy_from_user(ubuf, kbuf, n)` → destination first, like memcpy; `copy_from_user(to_kernel, from_user, n)`
- [ ] 2026-11-08, 02-kbuf-chardev: updated `data_len` with `-=`, `+= n`, then proposed `+= *off` → new data_len = max(old data_len, *off after the write); a write never shrinks it
- [ ] 2026-11-08, 02-kbuf-chardev: added `if (0 < *off) return -ENOSPC` → fails every second write on the same fd
- [ ] 2026-11-08, 02-kbuf-chardev: fixed checkpatch by moving *every* brace to its own line → only function definitions do that; `struct`, `if`, `for`, etc. keep `{` on the same line
- [ ] 2026-11-08, 02-kbuf-chardev: printed signed `size` with `%u` → `%d` for int; `%u` for unsigned values like MAJOR()/MINOR() (repeated in quiz 11-18: predicted `%u` of -1 prints `-1`; it prints 4294967295)
- [ ] 2026-11-08, 02-kbuf-chardev: race comment said `data_len` "could differ per process" and that reading `ubuf` races → there is one shared `data_len`; the race is the check-then-set on it (lost update); `ubuf` is each process's own memory
- [ ] 2026-11-08, 02-kbuf-chardev: couldn't read `gcc: not found` / `Error 127` → find the first line saying *what* failed; 127 = command not found (a missing tool, not your code)
- [ ] 2026-11-15, quiz: described `off` vs `*off` as "local vs global" → it's pointer vs pointee; `*off` is the `f_pos` of this open file (one per `struct file`, not global) (repeated 11-18: "global `*off`"; the follow-up "moves the pointer, f_pos unchanged" was correct)
- [ ] 2026-11-15, quiz: didn't know the symptom of a position that never advances → `cat` loops forever (never gets EOF/0) (quiz correct 1/2: 11-18)
- [ ] 2026-11-15, quiz: proposed `if (off >= room)` as a write bounds check → bare pointer again, and compares position with room; correct: `if (*off >= size) return -ENOSPC;` then `count = min_t(size_t, count, size - *off)` (quiz correct 1/2: 11-18)
- [ ] 2026-11-15, quiz: predicted the unchecked write "keeps writing / returns garbage" → copies exactly `count` bytes past the end (heap overflow) and returns `count` as if it succeeded (quiz correct 1/2: 11-18)
- [ ] 2026-11-15, quiz: missed `goto err_region` on `alloc_chrdev_region()` failure and an unset `ret` on `class_create()` failure (both repeats of 11-01 items; `ret = 0` → init "succeeds", rmmod double-frees); also forgot `ret = -ENOMEM` before the kzalloc goto (quiz correct 1/2 for unset `ret`: 11-18)
- [ ] 2026-11-18, quiz: said a read with no position update prints "count bytes" each time → it returns `min(count, data_len - *off)`, so `cat` prints the 10 valid bytes over and over
- [ ] 2026-11-18, quiz: described a leaked class only as "leaks memory" → the class name stays registered, so the next `class_create()` fails with -EEXIST and you can't reload

## Quiz log
| Date | Topic | Score | Missed concepts |
|---|---|---|---|
| 2026-11-15 | [[2026-11-15-quick-1]] (quick) | 0/3 (3 partial) | loff_t *ppos, bounds/unsigned math, goto unwind (first-step return, set `ret` before goto) |
| 2026-11-18 | [[2026-11-18-quiz-1]] (quiz) | 3/5 (2 partial) | printk `%u` on signed int, `off`/`*off` still called "global" |

## Session log
### 2026-10-24: 01-greeter-params
- Status: done (functionally, 19/19 tests); checkpatch cleanup skipped
- Highest help level: 2
- Got comfortable with: module_param/MODULE_PARM_DESC, sysfs param perms, pr_fmt + KBUILD_MODNAME, failing init with -EINVAL, __init/__exit
- Struggled with: exact string matching, valid MODULE_LICENSE values, kernel brace/spacing style; never answered README questions 2-3 (sysfs write bypasses validation; why charp is 0444)
- Review findings: not recorded (checkpatch: 15 errors)
- Next: 02-kbuf-chardev (alloc_chrdev_region, cdev, class/device, read/write with copy_*_user, goto unwind)

### 2026-10-30: 02-kbuf-chardev
- Status: in progress; no exercise work or review this session
- Highest help level: none
- Next: continue 02-kbuf-chardev on the weekend of 2026-10-31

### 2026-11-01: 02-kbuf-chardev
- Status: in progress; `kbuf_init` and `kbuf_exit` finished and look correct on read-through, but not built or run yet. `read`/`write`/`open` are still stubs.
- Highest help level: 2 (for: goto unwind, ERR_PTR, teardown order, cdev API). No edits to my file, but the chat guidance on `goto` targets and exit order got specific, close to level 4, so treat the unwind as not yet independent.
- Got comfortable with: checking `kzalloc()`, saving and returning `alloc_chrdev_region()`'s result, `MAJOR()`/`MINOR()`, `.owner = THIS_MODULE`, and using the label mirror once the rule clicked
- Struggled with: goto unwind targets and label order, success path running cleanup, `IS_ERR()` vs `!ptr`, `kfree()` argument, exit order (see "Mistakes to revisit" for specifics)
- Review findings: no formal review yet. Issues caught during line-by-line checks are all fixed and listed in "Mistakes to revisit".

### 2026-11-08: 02-kbuf-chardev
- Status: done by my choice, not a formal pass. 38/38 tests pass in the VM; no critical findings. Left open: checkpatch 17E/5W, race comment incomplete (missing the `data_len` lost update, comment placed between `if` and `{`), README questions 1–4 unanswered.
- Highest help level: 2 (for: open flags, pointing to `fcntl.h`/`FMODE_WRITE`/`O_ACCMODE`; `copy_from_user` signature). The `data_len` growth rule was spelled out in words (effectively level 4). No edits to `kbuf.c`. Tutor fixed two bugs in `test.sh` (taint notices broke the load-message check; uutils `dd` seeks the output).
- Got comfortable with: EOF return in read, clamping to the smaller of count and remaining, `-EFAULT` handling, `-ENOSPC`, `nonseekable_open`, building in the VM
- Struggled with: `off` vs `*off`, unsigned arithmetic and bounds, open-flag bit logic, write limit and data_len rule, copy direction/arg order, brace rule, identifying the race (see "Mistakes to revisit")
- Review findings: critical 0, major 2 (checkpatch not 0/0; race comment incomplete), minor 3 (`%u` for signed size, now fixed; `pr_err` on user-triggerable -EFAULT; `unlikely()` in init), style 1 (naming: class global `kbuf`, `flip`, literal "kbuf" vs DEVICE_NAME)
- Next: 03-kbank-multi (Level 2 repeat): several devices from one driver, per-bank buffers through `filp->private_data`, `O_APPEND`, and a `fail_at` param that forces every init failure so each unwind path is tested, including partially completed loops. Re-tests `*ppos`, bounds, the data_len rule (`<>` overwrite test), copy direction, ERR_PTR, teardown order, checkpatch 0/0, and the race comment. Quiz Level 2 concepts soon. (A Level 3 exercise, 03-kring-misc, was drafted and then removed at my request.)

### 2026-11-15: quiz only (03-kbank-multi not started)
- Status: no exercise work; `03-kbank-multi/kbank.c` still empty. Took `/quiz quick`: 0/3, all partial ([[2026-11-15-quick-1]]).
- Highest help level: none (quiz only)
- Got comfortable with: `size_t` can't go negative; kzalloc failure after a region is allocated must unwind; label order (reverse of setup) was correct
- Struggled with: called `off` vs `*off` "local vs global"; reused a bare `off` in a bounds check; mispredicted the overflow's result; missed the first-step `goto` and an unset `ret` in an unwind
- Review findings: none (no code reviewed)
- Other: CLAUDE.md now saves every quiz to `Quizzes/YYYY-MM-DD-<variant>-<n>.md`
- Next: **start the session with another quiz** (I said I'd want one). Target goto unwind (set `ret`, first-step return), `*off`, and compare-before-subtract; rotate in other weak spots (O_ACCMODE, copy direction, races) for variety. Then start 03-kbank-multi with `kbank_init` and its unwind, written without help.

### 2026-11-18: quiz, then 03-kbank-multi
- Status: in progress. Took `/quiz`: 3/5, 2 partial ([[2026-11-18-quiz-1]]). Big improvement over 11-15 (0/3). Then started `03-kbank-multi/kbank.c` with a skeleton only: includes, `pr_fmt`, the three params, an empty `struct kbank_ctx`, and empty `kbank_init`/`kbank_exit`. Not built yet; ending the session to finish later.
- Highest help level: none
- Got comfortable with: goto unwind bugs (unset `ret`, wrong label), compare-before-subtract and the overflow result, O_ACCMODE bit logic
- Struggled with: `%u` for a signed int (repeat); still calls `*off` "global"
- Draft notes (unreviewed, not yet counted as mistakes; let the first build/checkpatch surface them and see whether I can read the errors myself):
  - `pr_fmt` uses `DBUILD_MODNAME` (typo for `KBUILD_MODNAME`)
  - `module_param()` was given description strings as its third argument → that argument is the sysfs permissions (e.g. 0444); descriptions go in `MODULE_PARM_DESC()`
  - `kbank_init` declared `void` → module init must return `int` (0 or -errno), which the unwind needs anyway
  - `struct kbank_ctx\n{` puts the brace on its own line (the brace-rule weak spot again); `static int fail_at = 0;` (checkpatch: don't initialise statics to 0); `struct kbank_ctx ctx;` is not `static`
  - Not written yet: `module_init`/`module_exit`, `MODULE_LICENSE`, fops, the unwind
- Next: resume `kbank.c`. Build early and read the first error myself before asking. Then write `kbank_init` and its unwind without help, and run the `fail_at` tests.
