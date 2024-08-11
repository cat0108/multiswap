#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include "remote_schedule.h"
#include <linux/pagemap.h>

//we don't really need these operations
static const struct address_space_operations remote_aops = {
    .writepage = NULL,
    .dirty_folio = NULL,
};

//we use address_space to store the mapping between pageid and remote address
struct address_space *remote_spaces __read_mostly;
static unsigned int nr_remote_spaces __read_mostly;

//bitmap
static struct remote_bitmap* remote_map[MAX_REMOTE_NODES];
static unsigned long nr_remote_maps[MAX_REMOTE_NODES];

static int init_remote_bitmap(unsigned int type, unsigned long nr_pages)
{
    struct remote_bitmap *maps, *map;
    unsigned int i, nr;

    nr = DIV_ROUND_UP(nr_pages, REMOTE_ADDRESS_SPACE_PAGES);
    maps = kvcalloc(nr, sizeof(struct remote_bitmap), GFP_KERNEL);
    if(!maps)
        return -ENOMEM;
    for(i = 0; i < nr; i++) {
        map = maps + i;
        map->mapping = kvcalloc(BITS_TO_LONGS(REMOTE_ADDRESS_SPACE_PAGES), sizeof(unsigned long), GFP_KERNEL);
        if(!map->mapping)
            return -ENOMEM;
        spin_lock_init(&map->w_lock);
        map->free_pages = map->nr_pages = REMOTE_ADDRESS_SPACE_PAGES;
    }
    remote_map[type] = maps;
    nr_remote_maps[type] = nr;
    return 0;
}

static int exit_remote_bitmap(unsigned int type)
{
    int i;
    struct remote_bitmap *maps = remote_map[type], *map;
    for(i = 0; i < nr_remote_maps[type]; i++) {
        map = maps + i;
        kvfree(map->mapping);
    }
    kvfree(maps);
    remote_map[type] = NULL;
    return 0;
}

static int init_remote_address_space(unsigned long nr_pages)
{
    struct address_space *spaces, *space;
    unsigned int i, nr;
    nr = DIV_ROUND_UP(nr_pages, REMOTE_ADDRESS_SPACE_PAGES);
    spaces = kvcalloc(nr, sizeof(struct address_space), GFP_KERNEL);
    if(!spaces)
        return -ENOMEM;
    for(i = 0; i < nr; i++) {
        space = spaces + i;
        //init xarray
        xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
		atomic_set(&space->i_mmap_writable, 0);
		space->a_ops = &remote_aops;
		mapping_set_no_writeback_tags(space);
    }
    nr_remote_spaces = nr;
    remote_spaces = spaces;


    return 0;
}

static void exit_remote_address_space(void)
{
    int i;
    struct address_space *spaces = remote_spaces, *space;
    for(i = 0; i < nr_remote_spaces; i++) {
        space = spaces + i;
        xa_destroy(&space->i_pages);
    }
    kvfree(spaces);
    nr_remote_spaces = 0;
    remote_spaces = NULL;
}

static unsigned long sswap_select_slot(unsigned int type, struct remote_mapping_flags *flags)
{
    unsigned long nr_pages, slot;
    struct remote_bitmap *map, *temp;
    unsigned int i, offset;

    temp = remote_map[type];
    nr_pages = temp->nr_pages;
    offset = 0;
    for(i = 0; i < nr_remote_maps[type]; i++)
    {
        map = temp + i;

        spin_lock_irq(&map->w_lock);
        if(map->free_pages != 0)
        {
            slot = find_first_zero_bit(map->mapping, nr_pages);

            flags->bits.mapping_success = 1;
            //set bit, update bitmap
            set_bit(slot, map->mapping);
            map->free_pages--;
            spin_unlock_irq(&map->w_lock);
            return slot + offset;
        }
        spin_unlock_irq(&map->w_lock);

        offset += nr_pages;
    }
    
    pr_info("all remote bitmap is full\n");
    flags->bits.mapping_full = 1;
    return 0;

}


/**
* sswap_add_mapping() - select a slot and add a mapping between pageid and remote memory.
* @type: remote memory node id.
* @pageid: local pageid to be mapped.
* @flags: whether mapping success.
* Return: roffset in remote memory region.
*/
u64 sswap_add_mapping(unsigned int type, pgoff_t pageid, struct remote_mapping_flags *flags)
{
    struct address_space *address_space;
    unsigned long slot, xa_msg, old_msg, offset;
    unsigned int old_type;
    void *entry;

    address_space = &remote_spaces[pageid >> REMOTE_ADDRESS_SPACE_SHIFT];

    //if old mapping exists, we should delete it in bitmap first
    if((entry = xa_load(&address_space->i_pages, pageid)) != NULL)
    {
        //pr_info("replace old mappings\n");
        old_msg = xa_to_value(entry);
        old_type = REMOTE_TYPE(old_msg);
        slot = REMOTE_SLOT(old_msg);
        offset = slot / REMOTE_ADDRESS_SPACE_PAGES;
        slot = slot % REMOTE_ADDRESS_SPACE_PAGES;

        spin_lock_irq(&remote_map[old_type][offset].w_lock);
        clear_bit(slot, remote_map[old_type][offset].mapping);
        remote_map[old_type][offset].free_pages++;
        spin_unlock_irq(&remote_map[old_type][offset].w_lock);
        //pr_info("replace old mappings complete\n");
    }

    slot = sswap_select_slot(type, flags);

    //no available slot, find another type
    if(flags->bits.mapping_full == 1)
    {
        pr_info("mapping fulls\n");
        return 0;
    }
    
    xa_msg = MAKE_XA_MSG(slot, type);
    entry = xa_mk_value(xa_msg);
    //xa_load can overwrite the old mapping, so we don't need to delete it
    if(xa_err(xa_store(&address_space->i_pages, pageid, entry, GFP_KERNEL)))
    {
        pr_err("failed to add mapping\n");
        VM_BUG_ON(1);
    }
    return slot << PAGE_SHIFT;
}

/**
* sswap_get_mapping - delete a mapping
* @type: remote memory node id.
* @pageid: local pageid to be unmapped.
* Return: roffset in remote memory region.
*/
u64 sswap_get_mapping(unsigned int *type, pgoff_t pageid)
{
    struct address_space *address_space;
    void *entry;
    unsigned long slot, xa_msg;

    address_space = &remote_spaces[pageid >> REMOTE_ADDRESS_SPACE_SHIFT];
    entry = xa_load(&address_space->i_pages, pageid);
    if(!entry)
    {
        pr_err("failed to get mapping, mapping did not exists\n");
        VM_BUG_ON(1);
    }
    xa_msg = xa_to_value(entry);
    *type = REMOTE_TYPE(xa_msg);
    slot = REMOTE_SLOT(xa_msg);

    // entry = xa_erase(&address_space->i_pages, pageid);
    // if(!entry)
    // {
    //     pr_err("failed to remove mapping, mapping did not exists\n");
    //     VM_BUG_ON(1);
    // }

    // spin_lock_irq(&remote_map[*type].w_lock);
    // clear_bit(slot, remote_map[*type].mapping);
    // spin_unlock_irq(&remote_map[*type].w_lock);

    return slot << PAGE_SHIFT;
}


u64 sswap_scheduler_read(unsigned int *type, unsigned long pageid)
{
    return sswap_get_mapping(type, pageid);
}
EXPORT_SYMBOL(sswap_scheduler_read);


//todo:add schedule algorithm here
/**
* sswap_scheduler_write: this function is used to select a slot for writing, 
* we schedule in it.
* @type: the remote node id.
* @pageid: the page to be writed.
* Return: the roffset in remote node.
* todo: add schedule algorithm here, decide which node to write, the only thing you
* need to do is to appoint a node.
*/
u64 sswap_scheduler_write(unsigned int *type, pgoff_t pageid)
{
    struct remote_mapping_flags flags;
    u64 ret;
    flags.flags = 0;
    if(pageid % 2 == 0)
    {
        ret = sswap_add_mapping(0, pageid, &flags);
        *type = 0;
        if (flags.bits.mapping_full)
        {
            ret = sswap_add_mapping(1, pageid, &flags);
            *type = 1;
        }
    }
    else
    {
        ret = sswap_add_mapping(1, pageid, &flags);
        *type = 1;
        if (flags.bits.mapping_full) {
            ret = sswap_add_mapping(0, pageid, &flags);
            *type = 0;
        }
    }
    return ret;
}
EXPORT_SYMBOL(sswap_scheduler_write);


static int __init init_scheduler(void)
{
    int i, ret;
    unsigned long nr_pages;

    nr_pages = REMOTE_BUF_SIZE >> PAGE_SHIFT;

    for(i = 0; i<MAX_REMOTE_NODES; i++)
    {
        if((ret = init_remote_bitmap(i, nr_pages)) != 0)
        {
            pr_err("remote bitmap alloc failed\n");
            goto delete_bitmap;
        }
    }
    if((ret = init_remote_address_space(nr_pages)) != 0)
    {
        pr_err("remote mapping init failed\n");
        goto delete_remote_as;
    }
    pr_info("remote scheduler initialized\n");
    return 0;

delete_remote_as:
    exit_remote_address_space();

delete_bitmap:
    for(i = 0; i<MAX_REMOTE_NODES; i++)
    {
        exit_remote_bitmap(i);
    }
    return ret;
}

static void __exit exit_scheduler(void)
{
    int i;
    for(i = 0; i<MAX_REMOTE_NODES; i++)
    {
        exit_remote_bitmap(i);
    }
    exit_remote_address_space();
    pr_info("remote scheduler exited\n");
}


module_init(init_scheduler);
module_exit(exit_scheduler);

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("remote scheduler");