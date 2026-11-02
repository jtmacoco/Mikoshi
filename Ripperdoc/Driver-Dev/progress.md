# Progress

## About me
- C experience: decent
- Kernel experience: has built and loaded simple modules; knows the basics
- Setup: Ubuntu VM; this directory (on an Arch host) is mounted into the VM. Build and load inside the VM. Hardware on hand: Raspberry Pi, ESP32 starter kit, 3D printer.
- Goals: contribute to the Linux kernel, specifically NVIDIA GPU drivers (nouveau/nova); long term, firmware for robots or rockets

## Current level
Level 2: Character device. Level 1 done (01-greeter-params); 02-kbuf-chardev still in progress and not yet reviewed. In `kbuf.c`, `kbuf_init` and `kbuf_exit` now look correct on read-through but have never been built or run. `read`/`write`/`open` are still stubs that I want to finish without help.

## Weak spots
- Error unwinding with goto: took many rounds of line-by-line help in 02; kept jumping to the label for the step that failed instead of the last step that succeeded.
- Error pointers: used `!ptr` on `class_create()`/`device_create()` even after being told they return ERR_PTR.
- Teardown order: `kbuf_exit` needed repeated correction; `device_destroy()` ran after `class_destroy()` until the last fix.
- Kernel coding style: left 01 with 15 checkpatch errors (spacing, brace placement). 02 requires a clean checkpatch run, and `kbuf.c` still has the same brace and `if(` issues.
- sysfs parameter semantics: never answered 01 README questions on sysfs writes bypassing validation and why charp is 0444.
- Also keep in mind: compare output strings against the spec character by character (01 failures, `unregistered` in 02); build and load in the Ubuntu VM, not on the Arch host; MODULE_LICENSE vs SPDX (used "GPL-2.0" in 01, "GPL v2" correctly in 02).

## Concept tracker
Rating: 1 = can't do it without help, 2 = shaky, 3 = OK with docs, 4 = solid, 5 = could teach it.

| Concept | Level | Rating | Last practiced | Last tested | Notes |
|---|---|---|---|---|---|
| module_init/module_exit, __init/__exit | 1 | 3 | 2026-10-24 | – | Used correctly in 01 |
| module_param / MODULE_PARM_DESC | 1 | 3 | 2026-10-24 | – | Comfortable in 01 |
| sysfs param permissions | 1 | 2 | 2026-10-24 | – | Set perms right, but couldn't explain write-bypasses-validation / charp 0444 |
| pr_fmt + KBUILD_MODNAME, pr_info | 1 | 3 | 2026-10-24 | – | Used correctly in 01 |
| Failing init with an errno | 1 | 3 | 2026-10-24 | – | Returned -EINVAL correctly in 01 |
| MODULE_LICENSE strings | 1 | 2 | 2026-10-24 | – | Confused with SPDX id ("GPL-2.0") |
| Kernel coding style / checkpatch | 1 | 1 | 2026-10-24 | – | 15 checkpatch errors left in 01 |
| Error unwinding with goto | 2 | 2 | 2026-11-01 | – | Correct in 02 only after many rounds of line-level help; retest without help |
| Teardown order (reverse of init) | 2 | 2 | 2026-11-01 | – | `kbuf_exit` order needed repeated correction in 02 |
| ERR_PTR / IS_ERR / PTR_ERR | 2 | 2 | 2026-11-01 | – | Used `!ptr` first in 02; fixed after a pointer to `err.h` |
| cdev_init / cdev_add / cdev_del | 2 | 2 | 2026-11-01 | – | Forgot `cdev_add()` at first; assigned `cdev_init()`'s void result to `ret` |
| class_create / device_create and destroy | 2 | 2 | 2026-11-01 | – | Used correctly after pointers; wrong device name and order at first |
| alloc_chrdev_region / MAJOR / MINOR | 2 | 3 | 2026-11-01 | – | Misread the base minor as `10` at first, then fixed it |
| kzalloc / kfree | 2 | 2 | 2026-11-01 | – | Passed the class pointer, then `&my_ctx.buf`, to `kfree()` before getting it right |
| file_operations .owner | 2 | 2 | 2026-11-01 | – | Added after a prompt; README question 3 not answered yet |

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
- [ ] 2026-11-01, 02-kbuf-chardev: `ret` left at 0 on the `class_create()` failure path → a failure would have returned success; set `ret` before every `goto`
- [ ] 2026-11-01, 02-kbuf-chardev: `kfree(kbuf)` freed the class, then `kfree(&my_ctx.buf)` passed the address of the pointer field → pass the value `kzalloc()` returned; the compiler won't catch it because `kfree()` takes `const void *`
- [ ] 2026-11-01, 02-kbuf-chardev: `device_destroy()` ran after `class_destroy()` in `kbuf_exit` → the device goes first because it depends on the class
- [ ] 2026-11-01, 02-kbuf-chardev: `cdev_del()` missing from exit, then called on the `cdev_add()` failure path → always delete a live cdev at exit, but never one that was never added
- [ ] 2026-11-01, 02-kbuf-chardev: `ret = cdev_init(...)` → `cdev_init()` returns void; check signatures in `include/linux/cdev.h`
- [ ] 2026-11-01, 02-kbuf-chardev: passed `10` as the base minor to `alloc_chrdev_region()`, thinking of it as a device number → that argument is the first minor; use 0 for a single device

## Quiz log
| Date | Topic | Score | Missed concepts |
|---|---|---|---|

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
- Next (picking up 2026-11-02):
  1. Write `kbuf_read`, `kbuf_write` and `kbuf_open` without help. Finish `read` before any testing, because the stub never signals end of file and `cat` would hang.
  2. Small `kbuf_init` cleanups: `%u` for major and minor on line 98; move the declarations on lines 90, 96 and 97 to the top of the function.
  3. Add the comment the spec requires saying where a race could happen.
  4. Run `checkpatch.pl --no-tree -f kbuf.c` (0 errors, 0 warnings required).
  5. Build and run `test.sh` in the Ubuntu VM.
  6. Answer the 4 README questions, then ask for the full review.
