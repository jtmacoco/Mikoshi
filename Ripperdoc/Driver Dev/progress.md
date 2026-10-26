# Driver Practice Progress

## About me

- C experience: decent
- Kernel/module experience so far: has built and loaded simple modules; knows the basics
- Setup (VM type, distro, kernel version): Ubuntu VM; this directory (on an Arch host) is mounted into the VM. Build and load inside the VM.
- Hardware available (e.g. Raspberry Pi, sensors), if any: Raspberry Pi, ESP32 starter kit, 3D printer
- Goal (job, hobby, a specific device): contribute to the Linux kernel, specifically NVIDIA GPU drivers (nouveau/nova); long term, firmware for robots or rockets

## Current level

Level 2: Character device (starting 02-kbuf-chardev). Level 1 done.

## Weak spots to revisit

- Kernel coding style: left 01 with 15 checkpatch errors (spacing, brace placement). 02 requires a clean checkpatch run.
- Exact output strings: several test failures came from small typos/punctuation; compare against the spec character by character.
- `MODULE_LICENSE` strings vs SPDX identifiers (used "GPL-2.0" at first).
- Ran tests on the Arch host instead of the Ubuntu VM; keep loading modules in the VM.

## Log

<!-- The tutor adds one entry per session, newest at the bottom. Format:

### YYYY-MM-DD: NN-exercise-name
- Status: done / in progress / abandoned
- Highest help level used: 1–5
- Got comfortable with:
- Struggled with:
- Next:
-->

### 2026-10-24: 01-greeter-params
- Status: done (functionally, 19/19 tests); checkpatch cleanup skipped
- Highest help level used: 2
- Got comfortable with: module_param/MODULE_PARM_DESC, sysfs param perms, pr_fmt + KBUILD_MODNAME, failing init with -EINVAL, __init/__exit
- Struggled with: exact string matching, valid MODULE_LICENSE values, kernel brace/spacing style; never answered README questions 2-3 (sysfs write bypasses validation; why charp is 0444)
- Next: 02-kbuf-chardev (alloc_chrdev_region, cdev, class/device, read/write with copy_*_user, goto unwind)
