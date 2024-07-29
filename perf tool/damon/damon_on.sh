#!/bin/bash
current_dir=`pwd`
damon_base=/sys/kernel/mm/damon/admin

cd $damon_base
sudo echo 0 > kdamonds/nr_kdamonds
sleep 1
sudo echo 1 > kdamonds/nr_kdamonds
sleep 1
sudo echo 1 > kdamonds/0/contexts/nr_contexts
sudo echo 1 > kdamonds/0/contexts/0/targets/nr_targets
sudo echo 1 > kdamonds/0/contexts/0/schemes/nr_schemes
sudo echo vaddr > kdamonds/0/contexts/0/operations
sudo echo stat > kdamonds/0/contexts/0/schemes/0/action
sudo echo 50000 >  kdamonds/0/contexts/0/monitoring_attrs/nr_regions/min
sudo echo 50000 >  kdamonds/0/contexts/0/monitoring_attrs/nr_regions/max
sudo echo 100 >  kdamonds/0/contexts/0/monitoring_attrs/intervals/sample_us
sudo echo 10000 >  kdamonds/0/contexts/0/monitoring_attrs/intervals/aggr_us

#events
sudo echo 1 > /sys/kernel/tracing/events/damon/enable
sudo echo 1 > /sys/kernel/tracing/events/damon/enable
sudo ehco 1 > /sys/kernel/debug/tracing/events/lru_gen/folio_ws_chg_se/enable
sudo echo 1 > /sys/kernel/debug/tracing/events/lru_gen/folio_ws_chg/enable
#events enable
sudo echo 1 > /sys/kernel/debug/tracing/tracing_on


#set damon
sudo echo "$1" > kdamonds/0/contexts/0/targets/0/pid_target
cat  kdamonds/0/contexts/0/targets/0/pid_target
echo "turn on kdamond"
echo on > kdamonds/0/state
cat kdamonds/0/state
cd $current_dir
# sudo perf record -e damon:damon_aggregated &
sudo perf record -e swap:folio_add_to_swap &

# #sudo perf record -e btrfs:btrfs_inode_evict
perfpid=$!
sleep 10
cd $damon_base
cat kdamonds/0/state
cat kdamonds/0/contexts/0/targets/0/regions/nr_regions
cd $current_dir

sleep 20
sudo kill -9 $perfpid
ps -ef | grep perf
sudo echo 0 > /sys/kernel/debug/tracing/tracing_on

cd $damon_base
echo "turn off kdamond"
echo off > kdamonds/0/state
cd $current_dir

perf script
