#!/bin/bash
# echo $$ >> /sys/fs/cgroup/cgroup.procs
sleep 1
cgdelete -r -g cpuset,cpu,io,memory,hugetlb,pids,rdma,misc:/yuri
echo $$
if [ ! -d "/sys/fs/cgroup/yuri/" ];then
	mkdir /sys/fs/cgroup/yuri
else
	echo "cgroup yuri already exists"
fi
echo "+memory" >> /sys/fs/cgroup/yuri/cgroup.subtree_control

if [ ! -d "/sys/fs/cgroup/yuri/redis/" ];then
	mkdir /sys/fs/cgroup/yuri/redis
else
	echo "cgroup yuri/redis already exists"
fi

# 12.5GB dram --> max 13421772800
echo $(( 2560 * 1024 * 1024)) > /sys/fs/cgroup/yuri/redis/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/redis/memory.max
echo "adding current shell to redis"
bash kill_redis_server.sh
sleep 2
echo $$ >> /sys/fs/cgroup/yuri/redis/cgroup.procs
sleep 2
redis-server /home/yuri/redistest/redis.conf
# cat /var/run/redis/redis-server.pid >> /sys/fs/cgroup/yuri/redis/cgroup.procs
echo "now in the group are:"
cat /sys/fs/cgroup/yuri/redis/cgroup.procs
# 获取Redis进程ID
redis_pid=$(pgrep redis-server)
if [[ -z $redis_pid ]]; then
  echo "Redis进程未运行"
  exit 1
else
  echo "Redis 已启动 $redis_pid"
fi