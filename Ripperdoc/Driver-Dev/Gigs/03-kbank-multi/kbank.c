// SPDX-License-Identifier: GPL-2.0
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/slab.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define DEVICE_NAME "kbank"

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Jonathan");
MODULE_DESCRIPTION("Kbank driver");

static int size    = 4096;
static int nbanks  = 4;
static int fail_at;

module_param(nbanks, int, 0444);
module_param(size, int, 0444);
module_param(fail_at, int, 0444);

MODULE_PARM_DESC(nbanks, "number of devices (1..8)");
MODULE_PARM_DESC(size, "buffer size per bank in bytes (1..65536)");
MODULE_PARM_DESC(fail_at, "test hook: force an init step to fail (0..5)");

static struct class *kbank;

struct kbank_ctx {
	dev_t kbank_dev;
	struct kbank_bank *banks;
	struct cdev my_cdev;
};

struct kbank_bank {
	size_t data_len;
	char *buffer;
};

static struct kbank_ctx ctx;

static int __init kbank_init(void)
{
	int ret = 0;

	if (size > 65536 || size <= 0) {
		pr_err("range is 1-65536, size:%d\n", size);
		return -EINVAL;
	}
	if (nbanks > 8 || nbanks <= 0) {
		pr_err("range is 1-8, nbanks:%d\n", nbanks);
		return -EINVAL;
	}
	if (fail_at > 5 || fail_at < 0) {
		pr_err("range is 0-5, fail_at:%d\n", fail_at);
		return -EINVAL;
	}

	ret = alloc_chrdev_region(&ctx.kbank_dev, 0, nbanks, DEVICE_NAME);
	if (ret) {
		pr_err("Failed to alloc buf\n");
		return ret;
	}

	ctx.banks = kcalloc(nbanks, sizeof(struct kbank_bank), GFP_KERNEL);
	if (unlikely(!ctx.banks)) {
		ret = -ENOMEM;
		goto err_unregister_chrdev;
	}

	for (int i = 0; i < nbanks; ++i) {
		ctx.banks[i].buffer = kzalloc(size, GFP_KERNEL);
		ctx.banks[i].data_len = 0;
	}


	if (ret) {
		pr_err("Failed to allocate device numbers\n");
		return ret;
	}

err_unregister_chrdev:
	unregister_chrdev_region(ctx.kbank_dev, nbanks);

	return ret;
}

static void __exit kbank_exit(void)
{
	pr_info("unregistered device\n");
}

module_init(kbank_init);
module_exit(kbank_exit);
