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
struct ctx
{
	dev_t dev;
	struct cdev my_cdev;
	size_t data_len;
	char *buffer;
};

static struct ctx my_ctx;

static ssize_t kbuf_read(struct file *flip, char __user *ubuf, size_t count, loff_t *off)
{
	size_t data_len = my_ctx.data_len;
	if (*off >= data_len)
		return 0;
	size_t remaining = data_len - *off;
	size_t bytes_to_copy = 0;

	if (count > remaining)
		bytes_to_copy = remaining;
	else
		bytes_to_copy = count;

	if (copy_to_user(ubuf, my_ctx.buffer + *off, bytes_to_copy))
	{
		pr_err("failed to copy to user\n");
		return -EFAULT; 
	}
	*off+=bytes_to_copy;
	return bytes_to_copy;
}

static ssize_t kbuf_write(struct file *flip, const char __user *ubuf, size_t count, loff_t *off)
{

	if (*off >= size)
		return -ENOSPC;
	size_t remaining = size-*off;
	size_t bytes_to_write = 0;

	if (count > remaining)
		bytes_to_write = remaining;
	else
		bytes_to_write = count;

	if (copy_from_user(my_ctx.buffer + *off, ubuf, bytes_to_write))
	/*
	 * race condition due to multiple process trying to write the same buffer at the same time. This will potentially 
	 * cause the data to not be written in order. Since both process' will write to the same buffer as well as reading 
	 * from ubuf. data_len will also could differ per process or thread.
	*/
	{
		pr_err("failed to copy from user\n");
		return -EFAULT; 
	}
	*off += bytes_to_write;
	if (*off > my_ctx.data_len)
		my_ctx.data_len = *off;
	return bytes_to_write;
}

static int kbuf_open(struct inode *inode, struct file *flip)
{
	int access_mode = flip->f_flags & O_ACCMODE;
	if ( (access_mode == O_WRONLY || access_mode == O_RDWR) && (flip->f_flags & O_TRUNC) )
		my_ctx.data_len = 0;
	return nonseekable_open(inode, flip);
}

static const struct file_operations kbuf_fops = {
	.read  = kbuf_read,
	.write = kbuf_write,
	.open  = kbuf_open,
	.owner = THIS_MODULE //needed
};

static int __init kbuf_init(void)
{
	int ret = 0;
	if (size <= 0 || size > 65536)
	{
		pr_err("range is 1-65536, size:%d\n", size);
		return -EINVAL;
	}
	
	
	ret = alloc_chrdev_region(&my_ctx.dev, 0, COUNT, DEVICE_NAME);
	if (ret)
	{
		pr_err("Failed to allocate device numbers\n");
		return ret;
	}

	my_ctx.buffer = kzalloc(size, GFP_KERNEL);
	if (unlikely(!my_ctx.buffer))
	{
		pr_err("Failed to alloc buf\n");
		ret = -ENOMEM;
		goto un_reg;
	}

	cdev_init(&my_ctx.my_cdev, &kbuf_fops);
	ret = cdev_add(&my_ctx.my_cdev, my_ctx.dev, COUNT);
	if (ret)
	{
		pr_err("Failed to register character device\n");
		goto buf_free;
	}

	kbuf = class_create("kbuf");
	if (IS_ERR(kbuf))
	{
		pr_err("Failed to create kbuf class\n");
		ret = PTR_ERR(kbuf);
		goto del_cdev;
	}

	struct device *my_dev = device_create(kbuf, NULL, my_ctx.dev, NULL, "kbuf");
	if (IS_ERR(my_dev))
	{
		pr_err("Failed to create device\n");
		ret = PTR_ERR(my_dev);
		goto dest_class;
	}
	unsigned int major_num = MAJOR(my_ctx.dev);
	unsigned int minor_num = MINOR(my_ctx.dev);
	pr_info("registered %u:%u (size=%d)\n", major_num, minor_num,size);
	return ret;

dest_class:
	class_destroy(kbuf);
del_cdev:
	cdev_del(&my_ctx.my_cdev);
buf_free:
	kfree(my_ctx.buffer);
un_reg:
	unregister_chrdev_region(my_ctx.dev, COUNT);

	return ret;
}

static void __exit kbuf_exit(void)
{
	device_destroy(kbuf, my_ctx.dev);
	class_destroy(kbuf);
	cdev_del(&my_ctx.my_cdev);
	kfree(my_ctx.buffer);
	unregister_chrdev_region(my_ctx.dev, COUNT);
	pr_info("unregistered\n");
}

module_init(kbuf_init);
module_exit(kbuf_exit);
