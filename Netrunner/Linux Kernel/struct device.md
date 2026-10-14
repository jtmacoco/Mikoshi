---
title: struct device
source: "[[kernel]]"
tags:
  - kernel
  - device
  - drivers
type: reference
created: 2026-10-13
---
## What is struct device

The kernel's generic record of a device. Every device has one, usually
embedded inside a bus-specific struct (pci_dev, usb_device, platform_device).
It holds common info: name, parent, bound driver, sysfs entry, managed
resources, and a private data slot.

---
## Analogy

A base class in C. Bus-specific structs "inherit" from it by embedding it,
so the kernel core can treat every device the same way.

---

## Example / Usage

```c
struct drv_ctx {
    struct device *dev;
};

ctx->dev = my_miscdev.this_device;   // kernel creates it, you keep a pointer

dev_info(ctx->dev, "opened\n");                    // logging
buf = devm_kzalloc(ctx->dev, size, GFP_KERNEL);    // auto-freed memory
dev_set_drvdata(ctx->dev, ctx);                    // stash private data
```

---

## When to Use

- Logging: dev_info(), dev_warn(), dev_err()
- Managed allocations: devm_* functions
- Storing/retrieving driver data: dev_set_drvdata() / dev_get_drvdata()
- Any kernel API that needs to know which device you mean

---

## Watch Out For

- You don't own it; the kernel creates and frees it. Only hold a pointer.
- Only grab the pointer after registration succeeds (e.g., misc_register()).
- devm_* memory is freed when the device is removed. Don't use it after.
- Don't touch its fields directly; use the kernel helper functions.


