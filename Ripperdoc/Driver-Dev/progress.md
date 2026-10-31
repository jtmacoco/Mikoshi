# Progress

## About me
- C experience: decent
- Kernel experience: has built and loaded simple modules; knows the basics
- Setup: Ubuntu VM; this directory (on an Arch host) is mounted into the VM. Build and load inside the VM. Hardware on hand: Raspberry Pi, ESP32 starter kit, 3D printer.
- Goals: contribute to the Linux kernel, specifically NVIDIA GPU drivers (nouveau/nova); long term, firmware for robots or rockets

## Current level
Level 2: Character device. Level 1 done (01-greeter-params); 02-kbuf-chardev still in progress and not yet reviewed. `kbuf.c` has the ctx struct, size param, fops table and a partial `kbuf_init`; `read`/`write`/`open` are stubs that I want to finish without help.

## Weak spots
- Kernel coding style: left 01 with 15 checkpatch errors (spacing, brace placement). 02 requires a clean checkpatch run.
- Exact output strings: several test failures in 01 came from small typos/punctuation; compare against the spec character by character.
- MODULE_LICENSE vs SPDX identifiers: used "GPL-2.0" at first in 01.
- sysfs parameter semantics: never answered 01 README questions on sysfs writes bypassing validation and why charp is 0444.
- Workflow: ran tests on the Arch host instead of the Ubuntu VM; keep loading modules in the VM.

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

## Mistakes to revisit
Specific mistakes and misconceptions. Mark `[x]` when resolved (two correct quiz answers).
- [ ] 2026-10-24, 01-greeter-params: wrote `MODULE_LICENSE("GPL-2.0")` → SPDX ids go in the `// SPDX-License-Identifier:` comment; MODULE_LICENSE takes strings like "GPL" or "GPL v2"
- [ ] 2026-10-24, 01-greeter-params: brace placement and spacing errors flagged by checkpatch → function braces on their own line, `if (x) {` style, space after keywords
- [ ] 2026-10-24, 01-greeter-params: could not explain why writing a param via sysfs bypasses init-time validation → sysfs writes go straight to the variable via param ops; init's checks only run once at load
- [ ] 2026-10-24, 01-greeter-params: could not explain why a charp param should be 0444 → a sysfs write would free/replace the string under code that may be using it

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
