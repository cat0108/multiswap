#!/bin/bash
echo $$ >> /sys/fs/cgroup/cgroup.procs
sleep 1
cgdelete -r -g cpuset,cpu,io,memory,hugetlb,pids,rdma,misc:/yuri
echo $$
if [ ! -d "/sys/fs/cgroup/yuri/" ];then
	mkdir /sys/fs/cgroup/yuri
else
	echo "cgroup yuri already exists"
fi
echo "+memory" >> /sys/fs/cgroup/yuri/cgroup.subtree_control

if [ ! -d "/sys/fs/cgroup/yuri/pagerank_150M/" ];then
	mkdir /sys/fs/cgroup/yuri/pagerank_150M
else
	echo "cgroup yuri/pagerank_150M already exists"
fi

echo 134217728 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
gcc pagewalker.c -lm -O0 -fopenmp -o pagewalker

./pagewalker
echo "memory.peak is:"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak

