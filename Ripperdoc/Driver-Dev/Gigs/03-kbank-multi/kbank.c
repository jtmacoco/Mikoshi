// SPDX-License-Identifier: GPL-2.0
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uaccess.h>


MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Jonathan");
MODULE_DESCRIPTION("Kbank driver");

static int size    = 4096;
static int nbanks  = 4;
static int fail_at = 0;

module_param(nbanks, int, 0444);
module_param(size, int, 0444);
module_param(fail_at, int, 0444);

MODULE_PARM_DESC(nbanks, "number of devices (1..8)");
MODULE_PARM_DESC(size , "buffer size per bank in bytes (1..65536)");
MODULE_PARM_DESC(fail_at, "test hook: force an init step to fail (0..5)");

static struct class *kbank;

struct kbank_ctx{
	dev_t kbank_dev;
	struct kbank_bank *banks;
	struct cdev my_cdev;
};

struct kbank_bank{
	size_t data_len;
	char *buffer;
};

static struct kbank_ctx ctx;

static int __init kbank_init(void)
{
	int ret = 0;
	return ret;
}

static void __exit kbank_exit(void)
{
	pr_info("unregistered device\n");
}

module_init(kbank_init);
module_exit(kbank_exit);
