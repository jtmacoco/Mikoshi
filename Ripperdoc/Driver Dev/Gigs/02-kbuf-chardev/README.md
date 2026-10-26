# 02: kbuf (your first character device)

Level 2. You'll write a driver that creates `/dev/kbuf`, a device node backed
by a buffer in kernel memory. Whatever you write to it, you can read back. It's
small, but it covers the full char-device lifecycle: getting a device number,
registering file operations, creating the `/dev` node, moving data across the
user/kernel boundary, and tearing it all down in the right order.

Expect 1–2 hours.

## Spec

Write `kbuf.c`, a module named `kbuf`.

### Module parameter

| Parameter | Type | Default | sysfs perms | Description                         |
|-----------|------|---------|-------------|-------------------------------------|
| `size`    | int  | `4096`  | 0444        | buffer size in bytes (1..65536)     |

If `size` is out of range, the load must fail with the right errno, and
**nothing** may be left behind (no device number, no class, no `/dev` node).

### Registration (on load)

1. Get a **dynamically allocated** device number (major) with one minor.
2. Allocate the buffer of `size` bytes. Don't use a fixed-size global array.
3. Register your file operations with a `struct cdev`.
4. Create a device class named `kbuf` and a device named `kbuf`, so udev
   creates `/dev/kbuf` and `/sys/class/kbuf/kbuf/` appears.
5. Log exactly: `kbuf: registered <major>:<minor> (size=<size>)`

If any step fails, undo every step that already succeeded, **in reverse
order**, and return that step's error code.

On unload, undo everything in reverse order and log exactly: `kbuf: unregistered`

### File operations

The driver keeps one buffer and remembers `data_len`, the number of valid
bytes in it.

- **open:** if the file is opened for writing with `O_TRUNC` (which is what
  the shell's `>` does), reset `data_len` to 0.
- **read(count) at position `*ppos`:**
  - If `*ppos >= data_len`, return 0 (end of file).
  - Otherwise copy at most `count` bytes, without going past `data_len`,
    advance `*ppos`, and return the number of bytes copied.
- **write(count) at position `*ppos`:**
  - If `*ppos >= size`, return `-ENOSPC` (buffer full).
  - Otherwise copy at most `count` bytes, without going past `size`. A short
    write is allowed. Advance `*ppos`, grow `data_len` if you wrote past it,
    and return the number of bytes copied.
- **release:** nothing required. You may log at `pr_debug` level.
- A bad user pointer must return `-EFAULT`, never crash.
- While `/dev/kbuf` is open, `rmmod kbuf` must be refused ("Module kbuf is in
  use"). One field in `file_operations` makes that happen.

### Constraints

- Every message starts with `kbuf: ` via `pr_fmt`, as in exercise 01.
- **`checkpatch.pl --no-tree -f kbuf.c` must report 0 errors, 0 warnings.**
  Run it before you say you're done.
- Use the modern APIs. LDD3 (2005) predates some of them; see the API notes below.
- Concurrency isn't required yet (that's Level 5). Assume one user at a time,
  but write a comment saying where a race could happen.

## Concepts exercised

- `dev_t`, `MAJOR()`/`MINOR()`, `alloc_chrdev_region()` / `unregister_chrdev_region()`
- `struct cdev`, `cdev_init()`, `cdev_add()`, `cdev_del()`
- `class_create()`, `device_create()`, and their destroy counterparts
- `struct file_operations` and its `.owner` field
- `copy_to_user()` / `copy_from_user()`, and what their return value means
- `loff_t *ppos`: how the kernel tracks file position for you
- `kzalloc()` / `kfree()`
- The `goto` error-unwind pattern in init functions

## Where to read

- `include/linux/fs.h`: `struct file_operations`, `alloc_chrdev_region`
- `include/linux/cdev.h`: the whole cdev API is about 30 lines
- `include/linux/device/class.h`: `class_create`
- `include/linux/uaccess.h`: `copy_to_user` / `copy_from_user`
- `Documentation/process/coding-style.rst`, section 7 ("Centralized exiting
  of functions"): the `goto` unwind style
- LDD3 chapter 3 is still a good conceptual explanation of char devices.

### API notes (if you're reading LDD3)

- `class_create()` takes **one** argument (the name) since kernel 6.4. LDD3
  and older tutorials pass `THIS_MODULE` first, which no longer compiles.
- LDD3 uses `register_chrdev()` in places. That's the old all-in-one API, which
  grabs 256 minors. Use `alloc_chrdev_region()` plus `cdev` instead.
- LDD3 creates `/dev` nodes with `mknod` in a script. With `device_create()`,
  udev does it for you.

## Testing

Build and test **inside the Ubuntu VM**, not on the host.

```sh
make
./test.sh        # uses sudo; output is also saved to test_output.txt
```

The test exercises reads, writes, `O_TRUNC`, short writes on a full buffer,
small reads with `dd bs=1`, refusing unload while the device is open, bad
`size` values, and cleanup after unload. Every failure shows the expected and
the actual result.

You can also poke at it by hand:
```sh
sudo sh -c 'echo hello > /dev/kbuf'
sudo cat /dev/kbuf
ls -l /dev/kbuf; grep kbuf /proc/devices; ls /sys/class/kbuf/
```

## Questions to answer

1. `copy_to_user()` returns a number, not an error code. What does that number
   mean, and what should your `read` return if it's nonzero?
2. Why must teardown happen in the reverse order of setup? Pick one wrong
   order and describe what could go wrong.
3. What does `.owner = THIS_MODULE` actually do? What would happen if you
   forgot it and someone ran `rmmod` while a process had `/dev/kbuf` open?
4. Where is the race if two processes write at the same time?

## Stretch goals

- **Read-write for everyone:** make `/dev/kbuf` mode 0666 from the driver
  itself, not with `chmod` or a udev rule. Hint: look at the class's
  `devnode` callback.
- **`O_APPEND`:** make `>>` append to the existing data instead of
  overwriting from position 0.
- **Compare:** after your version works, read about `simple_read_from_buffer()`
  in `fs/libfs.c` and compare it with your `read`.
