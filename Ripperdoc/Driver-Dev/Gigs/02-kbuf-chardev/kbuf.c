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
	size_t data_len = my_ctx.data_len;
	if (*off >= data_len){
		return 0;
	}
	//no loop needed
	size_t remaining = data_len - *off;
	size_t bytes_to_copy = 0;

	if (count > remaining)
		bytes_to_copy = remaining;
	else
		bytes_to_copy = count;

	if (copy_to_user(ubuf,my_ctx.buffer + *off, bytes_to_copy)){
		pr_err("failed to copy to user\n");
		return -EFAULT; 
	}
	*off+=bytes_to_copy;
	return bytes_to_copy;
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
	.open  = kbuf_open,
	.owner = THIS_MODULE //needed
};

static int __init kbuf_init(void){
	int ret = 0;
	if (size <= 0 || size > 65536){
		pr_err("range is 1-65536, size:%d\n",size);
		return -EINVAL;
	}
	
	
	ret = alloc_chrdev_region(&my_ctx.dev, 0, COUNT, DEVICE_NAME);
	if (ret){
		pr_err("Failed to allocate device numbers\n");
		return ret;
	}

	my_ctx.buffer = kzalloc(size, GFP_KERNEL);
	if (unlikely(!my_ctx.buffer)){
		pr_err("Failed to alloc buf\n");
		ret = -ENOMEM;
		goto un_reg;
	}

	cdev_init(&my_ctx.my_cdev, &kbuf_fops);
	ret = cdev_add(&my_ctx.my_cdev, my_ctx.dev, COUNT);
	if (ret){
		pr_err("Failed to register character device\n");
		goto buf_free;
	}

	kbuf = class_create("kbuf");
	if(IS_ERR(kbuf)){
		pr_err("Failed to create kbuf class\n");
		ret = PTR_ERR(kbuf);
		goto del_cdev;
	}

	struct device *my_dev = device_create(kbuf, NULL, my_ctx.dev, NULL, "kbuf");
	if (IS_ERR(my_dev)){
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
static void __exit kbuf_exit(void){
	device_destroy(kbuf, my_ctx.dev);
	class_destroy(kbuf);
	cdev_del(&my_ctx.my_cdev);
	kfree(my_ctx.buffer);
	unregister_chrdev_region(my_ctx.dev, COUNT);
	pr_info("unregistered\n");
}

module_init(kbuf_init);
module_exit(kbuf_exit);
