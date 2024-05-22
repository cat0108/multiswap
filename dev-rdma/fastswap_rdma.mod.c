#include <linux/module.h>
#define INCLUDE_VERMAGIC
#include <linux/build-salt.h>
#include <linux/elfnote-lto.h>
#include <linux/export-internal.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

BUILD_SALT;
BUILD_LTO_INFO;

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

#ifdef CONFIG_RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

SYMBOL_CRC(sswap_rdma_write, 0x65bfc6ee, "");
SYMBOL_CRC(sswap_rdma_read_sync, 0x0d8960a1, "");

static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0xbdfb6dbb, "__fentry__" },
	{ 0x92997ed8, "_printk" },
	{ 0x5b8239ca, "__x86_return_thunk" },
	{ 0x65487097, "__x86_indirect_thunk_rax" },
	{ 0xd0da656b, "__stack_chk_fail" },
	{ 0x754d539c, "strlen" },
	{ 0xac5fcec0, "in4_pton" },
	{ 0xa095e841, "rdma_create_qp" },
	{ 0x7787b9e2, "rdma_disconnect" },
	{ 0x707ddacd, "rdma_destroy_qp" },
	{ 0x8b7ffd13, "ib_free_cq" },
	{ 0xd83fe691, "rdma_destroy_id" },
	{ 0x8f11d500, "ib_unregister_client" },
	{ 0x37a0cba, "kfree" },
	{ 0x66450793, "kmem_cache_destroy" },
	{ 0xeb233a45, "__kmalloc" },
	{ 0xec48ece8, "kmem_cache_alloc" },
	{ 0x608741b5, "__init_swait_queue_head" },
	{ 0x97651e6c, "vmemmap_base" },
	{ 0x7cd8d75e, "page_offset_base" },
	{ 0x721a9ed, "dma_map_page_attrs" },
	{ 0xe38e03dc, "kmem_cache_free" },
	{ 0xc844aaaa, "dma_sync_single_for_device" },
	{ 0x34db050b, "_raw_spin_lock_irqsave" },
	{ 0xf6e2f932, "ib_process_cq_direct" },
	{ 0xd35cce70, "_raw_spin_unlock_irqrestore" },
	{ 0x7a2af7b4, "cpu_number" },
	{ 0x1d24c881, "___ratelimit" },
	{ 0x54928a4, "dma_unmap_page_attrs" },
	{ 0xf49fe6ca, "unlock_page" },
	{ 0xa6257a2f, "complete" },
	{ 0x93d6dd8c, "complete_all" },
	{ 0x907df803, "rdma_event_msg" },
	{ 0x59587ee2, "__ib_alloc_pd" },
	{ 0x92cce524, "ib_dealloc_pd_user" },
	{ 0x54b1fac6, "__ubsan_handle_load_invalid_value" },
	{ 0x56470118, "__warn_printk" },
	{ 0x9256bf9b, "__ib_alloc_cq" },
	{ 0x445f7465, "rdma_resolve_route" },
	{ 0x1aedb885, "rdma_connect_locked" },
	{ 0xc60d0620, "__num_online_cpus" },
	{ 0x7fe89a32, "kmem_cache_create" },
	{ 0xf49c6736, "ib_register_client" },
	{ 0xf02aa937, "wait_for_completion_interruptible_timeout" },
	{ 0x51362156, "init_net" },
	{ 0xaae759ff, "__rdma_create_kernel_id" },
	{ 0x3ceb7322, "rdma_resolve_addr" },
	{ 0xc31db0ce, "is_vmalloc_addr" },
	{ 0x4c9d28b0, "phys_base" },
	{ 0xa1117671, "dev_driver_string" },
	{ 0xeae3dfd6, "__const_udelay" },
	{ 0xddf6ad7a, "completion_done" },
	{ 0x2850e4b7, "param_ops_string" },
	{ 0x8e693e96, "param_ops_int" },
	{ 0xd0487021, "module_layout" },
};

MODULE_INFO(depends, "rdma_cm,ib_core");


MODULE_INFO(srcversion, "D02EC3BF4C3A97BFDB546AB");
