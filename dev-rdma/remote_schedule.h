#ifndef _REMOTE_SCHEDULE_H
#define _REMOTE_SCHEDULE_H

#include "linux/fs.h"
#include "linux/types.h"
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/fs.h>
#include <linux/module.h>
#include <linux/spinlock.h>


#define MAX_REMOTE_NODES 2
/* One remote address space for each 64M remote space */
#define REMOTE_ADDRESS_SPACE_SHIFT 14
#define REMOTE_ADDRESS_SPACE_PAGES (1 << REMOTE_ADDRESS_SPACE_SHIFT)

#define MAKE_XA_MSG(slot, type) (((slot) << 4) | ((type) & 0xF))
#define REMOTE_TYPE(xa_msg) ((xa_msg) & 0xF)
#define REMOTE_SLOT(xa_msg) ((xa_msg) >> 4)

struct remote_mapping_flags {
    union {
        uint8_t flags;
        struct {
            uint8_t mapping_success : 1;
            uint8_t mapping_full : 1;
            //剩下几位保留，可以进行扩展
            uint8_t reserve : 6;
        } bits;
    };
};

struct remote_bitmap {
    unsigned long *mapping;
    spinlock_t w_lock;
    unsigned long nr_pages;
    unsigned long free_pages;
};

u64 sswap_add_mapping(unsigned int type, pgoff_t pageid, struct remote_mapping_flags *flags);
u64 sswap_get_mapping(unsigned int *type, pgoff_t pageid);

u64 sswap_scheduler_write(unsigned int *type, pgoff_t pageid);
u64 sswap_scheduler_read(unsigned int *type, pgoff_t pageid);
#endif

#ifndef ONEGB
#define ONEGB (1024UL*1024*1024)
#endif


#ifndef REMOTE_BUF_SIZE
#define REMOTE_BUF_SIZE (ONEGB * 8)
#endif



