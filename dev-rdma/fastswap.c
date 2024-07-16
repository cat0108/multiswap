#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/module.h>
#include <linux/frontswap.h>
#include <linux/debugfs.h>
#include <linux/spinlock.h>
#include <linux/vmalloc.h>
#include <linux/delay.h>
#include <linux/page-flags.h>
#include <linux/memcontrol.h>
#include <linux/smp.h>

#define B_DRAM 1
#define B_RDMA 2
//使用dram backend时将NUM_SERVERS设置为1
#define NUM_SERVERS 2

#ifndef BACKEND
#error "Need to define BACKEND flag"
#endif

#if BACKEND == B_DRAM
#define DRAM
#include "fastswap_dram.h"
#elif BACKEND == B_RDMA
#define RDMA
#include "fastswap_rdma.h"
#else
#error "BACKEND can only be 1 (DRAM) or 2 (RDMA)"
#endif

//test swapfile
//#define USESWAP

static int sswap_store(unsigned type, pgoff_t pageid,
        struct page *page)
{
#ifdef USESWAP
  return -1;
#endif
  //printk("in sswap_store\n");
  pgoff_t roffset = pageid / NUM_SERVERS;
  if (sswap_rdma_write(page, roffset << PAGE_SHIFT, pageid % NUM_SERVERS)) {
    pr_err("could not store page remotely\n");
    return -1;
  }

  return 0;
}


static int sswap_load(unsigned type, pgoff_t pageid, struct page *page)
{
#ifdef USESWAP
  return -1;
#endif
  pgoff_t roffset = pageid / NUM_SERVERS;
  if (unlikely(sswap_rdma_read_sync(page, roffset << PAGE_SHIFT, pageid % NUM_SERVERS))) {
    pr_err("could not read page remotely\n");
    return -1;
  }

  return 0;
}


static void sswap_invalidate_page(unsigned type, pgoff_t offset)
{
  return;
}

static void sswap_invalidate_area(unsigned type)
{
  pr_err("sswap_invalidate_area\n");
}

static void sswap_init(unsigned type)
{
  pr_info("sswap_init end\n");
}

static struct frontswap_ops sswap_frontswap_ops = {
  .init = sswap_init,
  .store = sswap_store,
  .load = sswap_load,
  .invalidate_page = sswap_invalidate_page,
  .invalidate_area = sswap_invalidate_area,

};

static int __init sswap_init_debugfs(void)
{
  return 0;
}

static int __init init_sswap(void)
{
  pr_info("begin init sswap\n");
 if(frontswap_register_ops(&sswap_frontswap_ops))
 {
    pr_err("sswap register ops failed!\n");
    return -1;
 }
  if (sswap_init_debugfs())
    pr_err("sswap debugfs failed\n");

  pr_info("sswap module loaded\n");
  return 0;
}

static void __exit exit_sswap(void)
{
  pr_info("unloading sswap\n");
}

module_init(init_sswap);
module_exit(exit_sswap);

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("Fastswap driver");
