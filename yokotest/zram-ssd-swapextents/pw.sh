#!/bin/bash
echo $$ >> /sys/fs/cgroup/cgroup.procs
#turn off auto hugepage allocation first
echo madvise >> /sys/kernel/mm/transparent_hugepage/enabled

#turn off trace first
echo 0 > /sys/kernel/debug/tracing/tracing_on

#check current tracer
echo "current_tracer are belows:"
echo > /sys/kernel/debug/tracing/set_event
echo "nop" > /sys/kernel/debug/tracing/current_tracer
#cat /sys/kernel/debug/tracing/current_tracer
#add lru_gen tracer
echo >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "*lru_gen*" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "*mm_lru*" >> /sys/kernel/debug/tracing/set_ftrace_filter
# #echo "folio_add_lru" >> /sys/kernel/debug/tracing/set_ftrace_filter
# #echo "folio_add_lru_vma" >> /sys/kernel/debug/tracing/set_ftrace_notrace
# #echo "folio_*_gen" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "split_huge_page_to_list" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "mem_cgroup_swapin_charge_folio" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "read_swap_cache_async" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "swapin_readahead" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "node_reclaim" >> /sys/kernel/debug/tracing/set_ftrace_filter
# echo "swap_cluster_readahead" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# #echo "swap_readpage" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# echo "try_to_inc_max_seq" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# echo "folio_add_lru" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# #echo "try_charge_memcg" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# echo "try_to_free_mem_cgroup_pages" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# echo "do_huge_pmd_anonymous_page" >>  /sys/kernel/debug/tracing/set_ftrace_filter
# echo "do_madvise" >>  /sys/kernel/debug/tracing/set_ftrace_filter


echo "add all lru_gen tracers below: "
echo > /sys/kernel/debug/tracing/set_ftrace_filter
cat /sys/kernel/debug/tracing/set_ftrace_filter
# echo "function" > /sys/kernel/debug/tracing/current_tracer
# echo $$ >> /sys/kernel/debug/tracing/set_ftrace_pid
echo 0 > /sys/kernel/debug/tracing/events/pagemap/enable
echo 0 > /sys/kernel/debug/tracing/events/lru_gen/enable
echo 1 > /sys/kernel/debug/tracing/events/swap/enable
echo 1 > /sys/kernel/debug/tracing/events/swap/get_swap_pages_noswap/enable
echo 1 > /sys/kernel/debug/tracing/events/swap/swap_stat_count/enable
echo 0 > /sys/kernel/debug/tracing/events/swap/folio_add_to_swap/enable
echo 0 > /sys/kernel/debug/tracing/events/swap/swap_alloc_cluster/enable
echo 0 > /sys/kernel/debug/tracing/events/swap/scan_swap_map_slots/enable

#vmscan
echo 0 > /sys/kernel/debug/tracing/events/vmscan/enable
echo 0 > /sys/kernel/debug/tracing/events/vmscan/mm_shrink_slab_start/enable
echo 0 > /sys/kernel/debug/tracing/events/vmscan/mm_shrink_slab_end/enable
echo 0 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_write_folio/enable
echo 0 > /sys/kernel/debug/tracing/events/thp/add_thp_anon_rmap/enable
echo 0 > /sys/kernel/debug/tracing/events/thp/hm_mapcount_dec/enable
echo 0 > /sys/kernel/debug/tracing/events/thp/hm_deferred_split/enable
echo 0 > /sys/kernel/debug/tracing/events/vmscan/mm_ano_folio2/enable
echo 0 > /sys/kernel/debug/tracing/events/vmscan/mm_ano_folio/enable
echo 0 > /sys/kernel/debug/tracing/events/vmscan/try_charge_memcg/enable

#migrate
echo 0 > /sys/kernel/debug/tracing/events/migrate/mapcount_dec/enable

#kmem
echo 0 > /sys/kernel/debug/tracing/events/kmem/enable
echo 0 > /sys/kernel/debug/tracing/events/kmem/mm_page_alloc_slow/enable

echo 1 > /sys/kernel/debug/tracing/tracing_on

#do the work here
#./cpp/pagerank -d "-" ./3rddataset/PR-dataset/web-BerkStan.txt >> info.txt 2>&1 & 
#echo "$!" >> /sys/kernel/debug/tracing/set_ftrace_pid 

#adding memory presure to it
./pagewalker >> info.txt 2>&1 &
echo "$!" >> /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
echo "$!" >> /sys/kernel/debug/tracing/set_ftrace_pid 
taskset -pc 12 $!

cat /sys/kernel/debug/tracing/trace_pipe > trace_record_p.txt &
echo "$!" >> /sys/fs/cgroup/cgroup.procs
taskset -pc 13,14 $!
sleep 60
#./cpp/pagerank -d "-" ./3rddataset/PR-dataset/web-BerkStan.txt &
echo 0 > /sys/kernel/debug/tracing/tracing_on
#cat /sys/kernel/debug/tracing/trace >> trace_record.txt
