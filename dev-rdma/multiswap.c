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
#include "remote_schedule.h"

#ifndef ONEGB
#define ONEGB (1024UL*1024*1024)
#endif
#define B_DRAM 1
#define B_RDMA 2
//使用dram backend时将NUM_SERVERS设置为1
#define NUM_SERVERS 2

//四选一
//#define FINE_GRAINED
//#define COARSE_GRAINED
//#define USESWAP
//#define USEDRAM
#define USE_SCHEDULE


#ifndef BACKEND
#error "Need to define BACKEND flag"
#endif

#if BACKEND == B_DRAM
#define DRAM
#include "multiswap_dram.h"
#elif BACKEND == B_RDMA
#define RDMA
#include "multiswap_rdma.h"
#else
#error "BACKEND can only be 1 (DRAM) or 2 (RDMA)"
#endif


#define RATING 3


static int schedule_node(pgoff_t pageid)
{
  if(pageid % RATING == RATING - 1)
  {
    return 1;
  }
  else
  {
   return 0;
  }
}

static int sswap_store(unsigned type, pgoff_t pageid,
        struct page *page)
{
#ifdef USESWAP
  return -1;
#endif

#ifdef USEDRAM
  if (sswap_rdma_write(page, pageid << PAGE_SHIFT,0)) {
    pr_err("could not store page in dram\n");
    return -1;
  }
  return 0;
#endif
#ifdef FINE_GRAINED
  if (sswap_rdma_write(page, pageid << PAGE_SHIFT, schedule_node(pageid))) {
    pr_err("could not store page remotely\n");
    return -1;
  }
  return 0;
#endif

#ifdef COARSE_GRAINED
  unsigned int dev = ((pageid << PAGE_SHIFT) > ONEGB * 4) ? 1 : 0;
  if (sswap_rdma_write(page, pageid << PAGE_SHIFT, dev)) {
    pr_err("could not store page remotely\n");
    return -1;
  }
  return 0;
#endif

#ifdef USE_SCHEDULE
  unsigned int rtype;
  u64 roffset;
  roffset = sswap_scheduler_write(&rtype, pageid);
  if (sswap_rdma_write(page, roffset,rtype)) {
    pr_err("could not store page in dram\n");
    return -1;
  }
  return 0;
#endif
}


static int sswap_load(unsigned type, pgoff_t pageid, struct page *page)
{
#ifdef USESWAP
  return -1;
#endif

#ifdef USEDRAM
  if (unlikely(sswap_rdma_read_sync(page, pageid << PAGE_SHIFT,0))) {
    pr_err("could not read page in dram\n");
    return -1;
  }
  return 0;
#endif

#ifdef FINE_GRAINED
  if (unlikely(sswap_rdma_read_sync(page, pageid << PAGE_SHIFT, schedule_node(pageid)))) {
    pr_err("could not read page remotely\n");
    return -1;
  }
  return 0;
#endif

#ifdef COARSE_GRAINED
  unsigned int dev = ((pageid << PAGE_SHIFT) > ONEGB * 4) ? 1 : 0;
  if (unlikely(sswap_rdma_read_sync(page, pageid << PAGE_SHIFT, dev))) {
    pr_err("could not read page remotely\n");
    return -1;
  }
  return 0;
#endif

#ifdef USE_SCHEDULE
  unsigned int rtype;
  u64 roffset;
  roffset = sswap_scheduler_read(&rtype, pageid);
  if (unlikely(sswap_rdma_read_sync(page, roffset, rtype))) {
    pr_err("could not read page in dram\n");
    return -1;
  }
  return 0;
#endif
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
  //打印count信息
  //printk("page_count[0]=%llu, page_count[1]=%llu\n", page_counting[0], page_counting[1]);
}

module_init(init_sswap);
module_exit(exit_sswap);

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("multiswap driver");
