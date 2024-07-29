#!/bin/bash
current_dir=`pwd`
sudo swapoff /dev/zram0
sleep 1
sudo /home/yuri/redistest/zramon.sh
cd /home/yuri/ycsb-0.17.0/
./bin/ycsb.sh load redis -s -P /home/yuri/redistest/workload_redis -p "redis.host=127.0.0.1" -p "redis.port=6379" -threads 16
sleep 15
ratio=50
distribution=zipfian
# sudo ./zramon.sh
resultbase="/home/yuri/redistest/result"
sudo rm -rf $resultbase/$distribution/$ratio/*.txt
mkdir -p $resultbase/$distribution/$ratio
cat /sys/fs/cgroup/yuri/redis/memory.stat > $resultbase/$distribution/$ratio/startmemstat.txt
cd $current_dir
sudo ./monitor_stat.sh /sys/fs/cgroup/yuri/redis/memory.stat $resultbase/$distribution/$ratio &
monitor_pid=$!
cd /home/yuri/ycsb-0.17.0/
./bin/ycsb.sh run redis -s -P workloads/workload_redis -p "redis.host=127.0.0.1" -p "redis.port=6379" -threads 4 > $resultbase/$distribution/$ratio/shell.txt 2>&1
cat /sys/fs/cgroup/yuri/redis/memory.stat > $resultbase/$distribution/$ratio/endmemstat.txt
sudo kill -9 $monitor_pid
cd $current_dir