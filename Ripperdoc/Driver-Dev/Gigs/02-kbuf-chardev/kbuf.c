// SPDX-License-Identifier: GPL-2.0
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/cdev.h>
#include <linux/device.h> 
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define COUNT 1
#define DEVICE_NAME "kbuf"

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Jonathan");
MODULE_DESCRIPTION("Basic char driver");

static int size = 4096;
module_param(size, int, 0444);
MODULE_PARM_DESC(size, "buffer size in bytes");

static struct class *kbuf; 

struct ctx{
	dev_t dev;
	struct cdev my_cdev;
	size_t data_len;
	char *buffer;
};

static struct ctx my_ctx;

static ssize_t kbuf_read(struct file *flip, char __user *ubuf, size_t count, loff_t *off){
	//TODO will complete later no help
	return count;
}
static ssize_t kbuf_write(struct file *flip, const char __user *ubuf, size_t count, loff_t *off){
	//TODO will complete later no help
	return count;
}

static int kbuf_open(struct inode *inode, struct file *flip){
	//TODO will complete later no help
	return 0;
}

static const struct file_operations kbuf_fops = {
	.read  = kbuf_read,
	.write = kbuf_write,
	.open  = kbuf_open
};

static int __init kbuf_init(void){

	if (size <= 0 || size > 65536){
		pr_err("range is 1-4096, size:%d\n",size);
		return -EINVAL;
	}
	
	my_ctx.buffer = kzalloc(size, GFP_KERNEL);
	kbuf = class_create("kbuf");

	cdev_init(&my_ctx.my_cdev, &kbuf_fops);
	alloc_chrdev_region(&my_ctx.dev, 10, COUNT, DEVICE_NAME);
	
	return 0;
}
static void __exit kbuf_exit(void){
	pr_info("unloading device");
}

module_init(kbuf_init);
module_exit(kbuf_exit);
