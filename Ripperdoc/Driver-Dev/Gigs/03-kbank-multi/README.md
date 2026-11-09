# 03: kbank (several char devices from one driver)

Level 2, second exercise. Same family as 02, but the driver now creates
**several** devices, `/dev/kbank0` … `/dev/kbank<N-1>`. Each has its own
buffer, so data written to one is never visible in another.

Why repeat Level 2: 02 works, but its weak spots need practice without help.
This exercise puts them under more pressure:
- **Error unwinding**: init now has loops (one buffer per bank, one device per
  bank), so a failure halfway through a loop must undo only the iterations that
  succeeded. A `fail_at` parameter lets the test **force** each failure, so
  every unwind path actually runs.
- **`read`/`write`/`*ppos`/bounds**: same rules as 02, now on a per-bank
  buffer that you reach through the open file.
- **Open flags**: `O_TRUNC` as before, plus `O_APPEND`.

You may reuse your own 02 code. That's the point: make it work per bank.

Expect 1–2 hours.

## Spec

Write `kbank.c`, a module named `kbank`.

### Module parameters

| Parameter | Type | Default | sysfs perms | Description                                  |
|-----------|------|---------|-------------|----------------------------------------------|
| `nbanks`  | int  | `4`     | 0444        | number of devices (1..8)                     |
| `size`    | int  | `4096`  | 0444        | buffer size per bank in bytes (1..65536)     |
| `fail_at` | int  | `0`     | 0444        | test hook: force an init step to fail (0..5) |

Any out-of-range value fails the load with `-EINVAL` before anything is set up.

### Registration (on load), in this order

1. Allocate `nbanks` device numbers with **one** `alloc_chrdev_region()`,
   minors `0 .. nbanks-1`, name `kbank`.
2. Allocate an array of `nbanks` bank structs, then a `size`-byte buffer for
   each bank (one allocation per bank, in a loop).
3. One `struct cdev` covering all `nbanks` minors (`cdev_add(..., nbanks)`).
4. Class `kbank`.
5. One device per bank, named `kbank<i>`, in a loop, so `/dev/kbank0` …
   appear under `/sys/class/kbank/`.
6. Log exactly: `kbank: registered <nbanks> devices, major <major> (size=<size>)`

If any step fails, undo **exactly** what succeeded, in reverse order, and
return that step's error. A failure inside a loop at iteration `i` must undo
iterations `0 .. i-1` of that loop, plus every earlier step.

On unload, undo everything in reverse order and log exactly:
`kbank: unregistered`

### `fail_at`: forced failures

When `fail_at` is set, **don't call** the real function for that step. Act as
if it had failed with the error shown, and let your normal error handling run.
Log one `kbank: ...` line saying which step failed.

| `fail_at` | Pretend this failed                                 | With              |
|-----------|-----------------------------------------------------|-------------------|
| 1         | allocating the bank array                           | NULL → `-ENOMEM`  |
| 2         | allocating the **last** bank's buffer (others OK)   | NULL → `-ENOMEM`  |
| 3         | `cdev_add()`                                        | `-ENODEV`         |
| 4         | `class_create()`                                    | `ERR_PTR(-ENODEV)`|
| 5         | `device_create()` for the **last** bank (others OK) | `ERR_PTR(-ENODEV)`|

For 4 and 5, put the `ERR_PTR` into the same variable the real call would have
returned, so your real `IS_ERR()`/`PTR_ERR()` check catches it. The point is
to test *your* error path, not to write a second one.

### File operations

- **open:** work out which bank this file is for, and store a pointer to that
  bank in `filp->private_data`. `read` and `write` use only that pointer, never
  a global "current bank". Reset the bank's `data_len` to 0 if opened **for
  writing** with `O_TRUNC` (same rule as 02).
- **read** at `*ppos`: same as 02. Return 0 at the end of the data. Otherwise
  copy at most `count` bytes without going past `data_len`, advance `*ppos`,
  and return the number of bytes copied.
- **write** at `*ppos`: same as 02. If the file was opened with **`O_APPEND`**,
  first move `*ppos` to the end of the bank's data (the shell's `>>`). Then:
  `-ENOSPC` if `*ppos >= size`, otherwise copy at most `count` bytes without
  passing `size`, advance `*ppos`, grow `data_len` if you wrote past it, and
  return the number of bytes copied.
- Bad user pointer → `-EFAULT`.
- `rmmod kbank` is refused while any `/dev/kbank*` is open.

### Constraints

- Every message starts with `kbank: ` via `pr_fmt`.
- Sizes and lengths are `size_t`; no `int` for byte counts.
- No `pr_err`/`pr_warn` for anything a user can trigger (full bank, bad
  pointer). Init failures *should* be logged.
- Declarations at the top of each block, then a blank line.
- **`checkpatch.pl --no-tree -f kbank.c`: 0 errors, 0 warnings.** `test.sh`
  runs it if it can find it in the VM. Otherwise, on the host:
  `perl ~/kernel-dev/linux/scripts/checkpatch.pl --no-tree -f kbank.c`
  Only *function definitions* put `{` on its own line; `struct`, `if`, `for`
  keep it on the same line.
- No locking yet, but write a **block comment above the code** describing one
  race: (a) the shared state, (b) which two operations collide, (c) what a
  user would see go wrong.

## Concepts exercised

- `alloc_chrdev_region()` with several minors; `MKDEV()`, `MAJOR()`, `MINOR()`
- One `cdev` serving several minors; `iminor()`; `filp->private_data`
- `kcalloc()` / `kzalloc()` / `kfree()` in loops
- `class_create()` / `device_create()` with a name format (`"kbank%d"`)
- `goto` unwind with **partially completed loops**; ERR_PTR / IS_ERR / PTR_ERR
- `*ppos`, bounds clamping, `copy_to_user()` / `copy_from_user()` (re-tested)
- `f_flags`: `O_ACCMODE`, `O_TRUNC`, `O_APPEND`

## Where to read

- `include/linux/fs.h`: `iminor()`, `struct file` (`private_data`, `f_flags`)
- `include/linux/kdev_t.h`: `MKDEV()` and friends
- `include/linux/slab.h`: `kcalloc()`. Why is it better than
  `kmalloc(n * size)`?
- `include/linux/device.h`: `device_create()` takes a printf-style name
- `Documentation/process/coding-style.rst`, section 7: `goto` unwind. Look at
  how in-tree drivers unwind a loop: a `while (i--)` loop or a
  `for (--i; i >= 0; i--)` loop after the label.

## Testing

Build and test **inside the Ubuntu VM**:

```sh
make clean; make
./test.sh        # uses sudo; output is also saved to test_output.txt
```

The test checks:
- the device nodes, their minors, and that the banks are isolated
- 02's read/write rules on a single bank, overwriting in place (`<>`) to test
  the `data_len` rule, `O_APPEND`, and `-ENOSPC`
- refusing unload while open, and cleanup after unload
- invalid parameters
- **every `fail_at` path**: the right errno, nothing left behind, and a normal
  load still working afterwards
- checkpatch, and no oops/WARN in the kernel log

A leaked device number or class shows up as a failure; a leaked `kmalloc`
doesn't, so the review will check that by reading the code.

By hand:
```sh
sudo sh -c 'echo one > /dev/kbank0; echo two > /dev/kbank1'
sudo cat /dev/kbank0 /dev/kbank1
sudo sh -c 'echo more >> /dev/kbank0'; sudo cat /dev/kbank0
sudo insmod kbank.ko nbanks=3 fail_at=5; sudo dmesg | tail -3
```

## Questions to answer

1. How does `open` work out which bank was opened? Why store the bank in
   `filp->private_data` instead of looking it up again in every `read`/`write`?
2. With `nbanks=3 fail_at=5`, list **in order** every cleanup call your init
   makes before returning.
3. Why must the buffers exist before `cdev_add()`? What could a user do in the
   gap if `cdev_add()` came first?
4. `copy_from_user()` returns 5. What does that mean, and what does your
   `write` return? (02 question 1, which was never answered.)
5. Why does `kcalloc(n, size, ...)` exist when `kmalloc(n * size, ...)` looks
   the same?

## Stretch goals

- **Per-bank cdevs:** give each bank its own `struct cdev` embedded in the
  bank struct, and find the bank in `open` with `container_of(inode->i_cdev, ...)`
  instead of `iminor()`. How does the unwind change?
- **Compare:** rewrite `read` with `simple_read_from_buffer()` (`fs/libfs.c`)
  and compare.
- **Leak check:** if your VM kernel has `CONFIG_DEBUG_KMEMLEAK`, run every
  `fail_at` value, then `echo scan > /sys/kernel/debug/kmemleak` and read the
  report.
