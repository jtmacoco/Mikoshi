// SPDX-License-Identifier: GPL-2.0

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>


MODULE_AUTHOR("Jonathan");
MODULE_DESCRIPTION("Greeter");
MODULE_LICENSE("GPL v2");//only thing needed rest are optional


static char *name="world";
static int count=1;
static bool verbose=false;

module_param(name,charp, 0444);
module_param(count,int, 0644);
module_param(verbose,bool, 0444);

MODULE_PARM_DESC(name, "Who name is for");
MODULE_PARM_DESC(count, "numbers of times to print name 1-10");
MODULE_PARM_DESC(verbose, "verbose output");


static int __init greeter_init(void){
	if (count <= 0 || count > 10){
		pr_err("FAIL count is outside 1..10, count was: %d\n", count);
		return -EINVAL;
	}
	if (verbose){
		pr_info("name=%s count=%d\n",name,count);
	}
	for (int i = 0; i < count; i++){
		pr_info("Hello, %s\n",name);
	}
	return 0;
}
static void __exit greeter_exit(void){
	pr_info("Goodbye, %s (count=%d)\n", name, count);
}

module_init(greeter_init);
module_exit(greeter_exit);
