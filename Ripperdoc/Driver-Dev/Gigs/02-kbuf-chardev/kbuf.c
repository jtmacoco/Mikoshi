// SPDX-License-Identifier: GPL-2.0

#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

MODULE_VERSION("GPL v2");
MODULE_AUTHOR("Jonathan");
MODULE_DESCRIPTION("Basic char driver");

static int size = 4096;
module_param(size, int, 0444);
MODULE_PARM_DESC(size,"buffer size in bytes");

static int __init kbuf_init(void){
	if (size <= 0 || size > 4096){
		pr_err("bounds 1-4096, size:%d ",size);
		return -EINVAL;
	}
	return 0;
}
static void kbuf_exit(void){
	pr_info("unloading device");
}

module_init(kbuf_init);
module_exit(kbuf_exit);
