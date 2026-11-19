// SPDX-License-Identifier: GPL-2.0
#define pr_fmt(fmt) DBUILD_MODNAME ": " fmt

#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

static int size    = 4096;
static int nbanks  = 4;
static int fail_at = 0;

module_param(nbanks, int, "number of devices (1..8)");
module_param(size, int, "buffer size in bytes");
module_param(fail_at, int, "test hook: force an init step to fail (0..5)");


struct kbank_ctx
{

};

struct kbank_ctx ctx;

static void __init kbank_init(void)
{

}

static void __exit kbank_exit(void)
{
}
