#!/bin/bash

# exec &> ../testoutcome/stream_dram_result.txt
# exec &> ../testoutcome/stream_swapfile_result.txt
# exec &> ../testoutcome/stream_nolimit_result.txt
# exec &> ../testoutcome/stream_rdma_result.txt
# exec &> ../testoutcome/stream_2nodeaverage_result.txt
exec &> ../testoutcome/stream_2node_average_coarsness_result.txt

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

#4196372

# echo "50% swapfile"
# echo "50% dram"
# echo "50% rdma"
# echo "50% 2nodeaverage"
echo "50% 2nodeaveragecoarsness"
echo 2148542464 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ../testbench/stream/stream_c.exe
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

# echo "60% swapfile"
# echo "60% dram"
# echo "60% rdma"
# echo "60% 2nodeaverage"
echo "60% 2nodeaveragecoarsness"
echo 2578250956 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ../testbench/stream/stream_c.exe
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

# echo "70% swapfile"
# echo "70% dram"
# echo "70% rdma"
# echo "70% 2nodeaverage"
echo "70% 2nodeaveragecoarsness"
echo 3007959449 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ../testbench/stream/stream_c.exe
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done


# echo "80% swapfile"
# echo "80% dram"
# echo "80% rdma"
# echo "80% 2nodeaverage"
echo "80% 2nodeaveragecoarsness"
echo 3437667942 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ../testbench/stream/stream_c.exe
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

# echo "90% swapfile"
# echo "90% dram"
# echo "90% rdma"
# echo "90% 2nodeaverage"
echo "90% 2nodeaveragecoarsness"
echo 3867376435 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ../testbench/stream/stream_c.exe
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done


# echo "不限制内存"
# for i in {1..3}; do
#     echo "Iteration $i"
#     /usr/bin/time -v ../testbench/stream/stream_c.exe
# done