#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# 定义架构变量
arch=xeon64

#!/bin/bash

# exec &> ./testoutcome/linpack_dram_result.txt
# exec &> ./testoutcome/linpack_swapfile_result.txt
exec &> ./testoutcome/linpack_nolimit_result.txt
# exec &> ./testoutcome/linpack_rdma_result.txt
# exec &> ./testoutcome/linpack_2nodeaverage_result.txt


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



#1572920





# echo "50% dram"
# # echo "50% swapfile"
# # echo "50% rdma"
# # echo "50% 2nodeaverage"
# echo 805335040 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "set memory.max to"
# cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "adding current shell to pagerank_150M"
# for i in {1..3}; do
#     echo "Iteration $i"
#     echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
#     {
#     echo "开始执行 xlinpack_xeon64: $(date)"
#     /usr/bin/time -v $DIR/testbench/linpack/xlinpack_$arch $DIR/testbench/linpack/lininput_$arch
#     echo "执行完成: $(date)"
#     } | tee $DIR/testbench/linpack/lin_$arch.txt   
#     echo "memory.peak is:"
#     cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
# done

# echo "60% dram"
# # echo "60% swapfile"
# # echo "60% rdma"
# # echo "60% 2nodeaverage"
# echo 966402048 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "set memory.max to"
# cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "adding current shell to pagerank_150M"
# for i in {1..3}; do
#     echo "Iteration $i"
#     echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
#     {
#     echo "开始执行 xlinpack_xeon64: $(date)"
#     /usr/bin/time -v $DIR/testbench/linpack/xlinpack_$arch $DIR/testbench/linpack/lininput_$arch
#     echo "执行完成: $(date)"
#     } | tee $DIR/testbench/linpack/lin_$arch.txt  
#     echo "memory.peak is:"
#     cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
# done

# echo "70% dram"
# # echo "70% swapfile"
# # echo "70% rdma"
# # echo "70% 2nodeaverage"
# echo 1127469056 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "set memory.max to"
# cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "adding current shell to pagerank_150M"
# for i in {1..3}; do
#     echo "Iteration $i"
#     echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
#     {
#     echo "开始执行 xlinpack_xeon64: $(date)"
#     /usr/bin/time -v $DIR/testbench/linpack/xlinpack_$arch $DIR/testbench/linpack/lininput_$arch
#     echo "执行完成: $(date)"
#     } | tee $DIR/testbench/linpack/lin_$arch.txt  
#     echo "memory.peak is:"
#     cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
# done


# echo "80% dram"
# # echo "80% swapfile"
# # echo "80% rdma"
# # echo "80% 2nodeaverage"
# echo 1288536064 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "set memory.max to"
# cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "adding current shell to pagerank_150M"
# for i in {1..3}; do
#     echo "Iteration $i"
#     echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
#     {
#     echo "开始执行 xlinpack_xeon64: $(date)"
#     /usr/bin/time -v $DIR/testbench/linpack/xlinpack_$arch $DIR/testbench/linpack/lininput_$arch
#     echo "执行完成: $(date)"
#     } | tee $DIR/testbench/linpack/lin_$arch.txt  
#     echo "memory.peak is:"
#     cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
# done

# echo "90% dram"
# # echo "90% swapfile"
# # echo "90% rdma"
# # echo "90% 2nodeaverage"
# echo 1449603072 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "set memory.max to"
# cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
# echo "adding current shell to pagerank_150M"
# for i in {1..3}; do
#     echo "Iteration $i"
#     echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
#     {
#     echo "开始执行 xlinpack_xeon64: $(date)"
#     /usr/bin/time -v $DIR/testbench/linpack/xlinpack_$arch $DIR/testbench/linpack/lininput_$arch
#     echo "执行完成: $(date)"
#     } | tee $DIR/testbench/linpack/lin_$arch.txt  
#     echo "memory.peak is:"
#     cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
# done


echo "不限制内存"
for i in {1..3}; do
    echo "Iteration $i"
    {
    echo "开始执行 xlinpack_xeon64: $(date)"
    /usr/bin/time -v $DIR/testbench/linpack/xlinpack_$arch $DIR/testbench/linpack/lininput_$arch
    echo "执行完成: $(date)"
    } | tee $DIR/testbench/linpack/lin_$arch.txt 
done

