# 01: greeter (module parameters checkpoint)

You already know how to load a hello-world module. This exercise checks the
rest of Level 1 in about 30–60 minutes: module parameters, sysfs visibility,
validation, and failing `init` correctly. If it goes smoothly, we move straight
to character devices.

## Spec

Write `greeter.c`, a module named `greeter`, with these parameters:

| Parameter | Type   | Default   | sysfs permissions | Description                     |
|-----------|--------|-----------|-------------------|---------------------------------|
| `name`    | string | `"world"` | read-only (0444)  | who to greet                    |
| `count`   | int    | `1`       | read-write (0644) | how many times to greet (1..10) |
| `verbose` | bool   | `false`   | read-only (0444)  | print parameter values on load  |

### Behaviour

On load:
1. If `count` is outside `1..10`, print an error with `pr_err` and make the
   load **fail** with the correct errno. `insmod` should report an error and
   the module must not stay loaded.
2. If `verbose` is set, print `name=<name> count=<count>`.
3. Print `Hello, <name>` exactly `count` times.

On unload:
- Print `Goodbye, <name> (count=<count>)`, using the **current** value of
  `count`. It may have been changed through sysfs while the module was loaded.

### Constraints

- Every message must start with `greeter: `. Don't type the prefix into each
  string; find the idiomatic kernel way to do it.
- Use `pr_*` helpers, not raw `printk(KERN_...)`.
- Every parameter needs a description that shows up in `modinfo -p greeter.ko`.
- Set `MODULE_LICENSE`, `MODULE_AUTHOR`, and `MODULE_DESCRIPTION`.
- Mark the init and exit functions with the right section annotations.

## Concepts exercised

- `module_param`, `MODULE_PARM_DESC`, and parameter permissions
- `/sys/module/<name>/parameters/`
- Returning a negative errno from `module_init` and what the kernel does with it
- `pr_fmt` and `KBUILD_MODNAME`
- `__init` / `__exit`

## Testing

Build and test **inside the Ubuntu VM**. The module must be built against the
VM's running kernel, not the Arch host's.

```sh
sudo apt install build-essential linux-headers-$(uname -r)   # once
make
./test.sh      # uses sudo for insmod/rmmod/dmesg
```

## Questions to answer (put them in your head or in a comment)

1. Which errno did you return for a bad `count`, and why that one?
2. Run `echo 50 | sudo tee /sys/module/greeter/parameters/count` and then
   unload. What happens? Is that a bug in your validation?
3. Why does `name` use 0444 and not 0644? What would go wrong if userspace
   could write a `charp` parameter at any time?

## Stretch goals

- **Runtime validation:** use `module_param_cb()` with a custom
  `struct kernel_param_ops` so that writing an out-of-range value to
  `/sys/module/greeter/parameters/count` is rejected with an error. (This
  fixes the hole from question 2.)
- **Array parameter:** add `names` with `module_param_array()` so that
  `insmod greeter.ko names=alice,bob,carol` greets each name.
- Run `checkpatch.pl --no-tree -f greeter.c` (from a kernel source tree) and
  make it clean.
