---
title: struct class
aliases: [class_create, class_destroy, class_register, device_create, device_destroy, /sys/class]
source: "[[Driver Dev]]"
tags: [linux-kernel, drivers, level-2, device-model, ripperdoc]
level: 2
status: learning
created: 2026-11-19
updated: 2026-11-19
related: []
sources: [include/linux/device/class.h, include/linux/device.h, Documentation/driver-api/driver-model/]
---

# struct class

## Summary
A `struct class` is a device-model grouping of devices by *what they do* (`tty`, `input`, `block`), not how they're connected. Registering one creates `/sys/class/<name>/`. Each `device_create()` under it adds an entry there and sends a uevent, which makes devtmpfs/udev create `/dev/<name>` for you. A char driver works without one (`cdev_add()` is enough), but then nobody creates the `/dev` node and you'd have to `mknod` by hand.

## Key APIs
- `class_create(name)` (`device/class.h`): allocates and registers a class. Returns `struct class *` or an **ERR_PTR**, never NULL. Since 6.4 it takes no `THIS_MODULE` argument.
- `class_destroy(cls)`: unregisters it and frees it.
- `class_register(&cls)` / `class_unregister(&cls)`: the modern alternative for a `static const struct class` you define yourself. Returns 0 or -errno.
- `device_create(cls, parent, devt, drvdata, fmt, ...)` (`device.h`): creates `/sys/class/<cls>/<name>` and the `/dev/<name>` node for `devt`. Returns ERR_PTR on failure.
- `device_destroy(cls, devt)`: removes that device (and its node).

## How to use it
- One class per driver; one `device_create()` per device node, each with its own `devt` (`MKDEV(major, minor)`).
- Init order: device number → cdev → class → device(s). Exit is the exact reverse: devices → class → cdev → region.
- Check every pointer return with `IS_ERR()` / `PTR_ERR()`.

```c
cls = class_create("demo");
if (IS_ERR(cls))
	return PTR_ERR(cls);	/* or goto the right unwind label */
dev = device_create(cls, NULL, devt, NULL, "demo%d", 0);
```

## Pitfalls
- Checking with `!cls`: it's an ERR_PTR, so the check never fires (02-kbuf-chardev).
- `class_destroy()` before `device_destroy()`: the device lives inside the class and must go first (02-kbuf-chardev).
- Leaking the class on an error path is worse than a memory leak. The name stays registered, so the next `class_create()` with that name fails with `-EEXIST` and the module can't be reloaded until reboot.
- Old tutorials use `class_create(THIS_MODULE, "name")`. That form was removed in 6.4. LDD3 predates this API entirely and uses manual `mknod`.

## Check yourself
> [!question]- You call `cdev_add()` but skip `class_create()`/`device_create()`. Does the device work?
> Yes. The cdev is live, so `open()` on a node with that major:minor reaches your fops. But no `/dev` node or `/sys/class` entry is created, so you'd have to `mknod /dev/x c MAJOR MINOR` yourself.

> [!question]- What's in `/sys/class/<name>/` after loading a driver with 4 devices?
> One entry per `device_create()` call (e.g. `demo0` to `demo3`), each with a `dev` file holding `MAJOR:MINOR`.
