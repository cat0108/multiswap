#ifndef _SSWAP_DRAM_H
#define _SSWAP_DRAM_H

#include <linux/module.h>
#include <linux/vmalloc.h>



int sswap_rdma_read_sync(struct page *page, u64 roffset,unsigned int dev);
int sswap_rdma_write(struct page *page, u64 roffset,unsigned int dev);


#endif
