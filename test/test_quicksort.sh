#!/bin/bash

exec &> ./testoutcome/quicksort_dram_result.txt

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



echo "50% dram"
echo 4294967296 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..10}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ./testbench/quicksort/quicksort 8191
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

echo "60% dram"
echo 5153960755 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..10}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ./testbench/quicksort/quicksort 8191
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

echo "70% dram"
echo 6012954214 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..10}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ./testbench/quicksort/quicksort 8191
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done


echo "80% dram"
echo 6871947673 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..10}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ./testbench/quicksort/quicksort 8191
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

echo "90% dram"
echo 6871947673 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..10}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    /usr/bin/time -v ./testbench/quicksort/quicksort 8191
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done


echo "不限制内存"
for i in {1..10}; do
    echo "Iteration $i"
    /usr/bin/time -v ./testbench/quicksort/quicksort 8191
done