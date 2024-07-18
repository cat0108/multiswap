#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/highmem.h>
#include <linux/pagemap.h>
#include "multiswap_dram.h"

//todo:进行检验，swapfile的size必须小于等于remote buffer size.
#ifndef ONEGB
#define ONEGB (1024UL*1024*1024)
#endif
#define SWAPFILE_SIZE (ONEGB * 8) 
#define REMOTE_BUF_SIZE (ONEGB * 8) /*remote_buf_size 超过 swapfile_size 的部分将不会采用frontswap*/

//#define DEBUG_MODE

#ifdef DEBUG_MODE
#define DEBUG_PRINT(fmt, ...) pr_info(fmt, ##__VA_ARGS__)
#else
#define DEBUG_PRINT(x) do {} while (0)
#endif

static void *drambuf;

int sswap_rdma_write(struct page *page, u64 roffset, unsigned int dev)
{
	//this part is not use frontswap
	if(roffset >= REMOTE_BUF_SIZE)
		return -1;
	void *page_vaddr;
	page_vaddr = kmap_atomic(page);
	copy_page((void *) (drambuf + roffset), page_vaddr);
	kunmap_atomic(page_vaddr);
	DEBUG_PRINT("write over\n");
	return 0;
}
EXPORT_SYMBOL(sswap_rdma_write);


int sswap_rdma_read_sync(struct page *page, u64 roffset, unsigned int dev)
{
	//this part is not use frontswap
	if(roffset >= REMOTE_BUF_SIZE)
		return -1;
	void *page_vaddr;

	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
	VM_BUG_ON_PAGE(!PageLocked(page), page);
	VM_BUG_ON_PAGE(PageUptodate(page), page);

	page_vaddr = kmap_atomic(page);
	copy_page(page_vaddr, (void *) (drambuf + roffset));
	kunmap_atomic(page_vaddr);

	SetPageUptodate(page);
	unlock_page(page);
	DEBUG_PRINT("read over\n");
	return 0;
}
EXPORT_SYMBOL(sswap_rdma_read_sync);


static void __exit sswap_dram_cleanup_module(void)
{
	vfree(drambuf);
	pr_info("DRAM backend is cleaned up\n");
}

static int __init sswap_dram_init_module(void)
{
	pr_info("start: %s\n", __FUNCTION__);
	pr_info("will use new DRAM backend");

	drambuf = vzalloc(REMOTE_BUF_SIZE);
	pr_info("vzalloc'ed %lu bytes for dram backend\n", REMOTE_BUF_SIZE);

	if(SWAPFILE_SIZE > REMOTE_BUF_SIZE) {
		pr_info("warning: swapfile size is larger than remote buffer size\n");
		pr_info("this may cause a part of pages are not use frontswap\n");
	}

	pr_info("DRAM backend is ready for reqs\n");
	return 0;
}

module_init(sswap_dram_init_module);
module_exit(sswap_dram_cleanup_module);

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("DRAM backend");
