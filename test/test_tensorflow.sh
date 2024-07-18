#!/bin/bash

source /home/cat22/桌面/tensorflow_env/tensorflow_env/bin/activate
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd $DIR/testbench/tensorflow/benchmarks/scripts/tf_cnn_benchmarks

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


# 1073741824
# 内存 2,052,824
# exec > >(tee -a $DIR/testoutcome/tensorflow_dram_result.txt) 2>&1
# exec > >(tee -a $DIR/testoutcome/tensorflow_swapfile_result.txt) 2>&1
# exec > >(tee -a $DIR/testoutcome/tensorflow_nolimit_result.txt) 2>&1
# exec > >(tee -a $DIR/testoutcome/tensorflow_rdma_result.txt) 2>&1
exec > >(tee -a $DIR/testoutcome/tensorflow_2nodeaverage_result.txt) 2>&1

# echo "50% swapfile"
# echo "50% dram"
# echo "50% rdma"
echo "50% 2nodeaverage"
echo 1051045888 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    (/usr/bin/time -v python3 tf_cnn_benchmarks.py --forward_only=True --data_format=NHWC --device=cpu --batch_size=128 --num_inter_threads=0 --num_intra_threads=2 --nodistortions --model=inception3 --kmp_blocktime=0 --num_batches=20 --num_warmup_batches 0) 2>&1 | grep -E 'User time \(seconds\)|System time \(seconds\)|Percent of CPU this job got|Elapsed \(wall clock\) time \(h:mm:ss or m:ss\)|Maximum resident set size \(kbytes\)|Major \(requiring I/O\) page faults|Minor \(reclaiming a frame\) page faults|Voluntary context switches|Involuntary context switches|Exit status' 
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

# echo "60% swapfile"
# echo "60% dram"
# echo "60% rdma"
echo "60% 2nodeaverage"
echo 1261255065 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    (/usr/bin/time -v python3 tf_cnn_benchmarks.py --forward_only=True --data_format=NHWC --device=cpu --batch_size=128 --num_inter_threads=0 --num_intra_threads=2 --nodistortions --model=inception3 --kmp_blocktime=0 --num_batches=20 --num_warmup_batches 0) 2>&1 | grep -E 'User time \(seconds\)|System time \(seconds\)|Percent of CPU this job got|Elapsed \(wall clock\) time \(h:mm:ss or m:ss\)|Maximum resident set size \(kbytes\)|Major \(requiring I/O\) page faults|Minor \(reclaiming a frame\) page faults|Voluntary context switches|Involuntary context switches|Exit status' 
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done


# echo "70% swapfile"
# echo "70% dram"
# echo "70% rdma"
echo "70% 2nodeaverage"
echo 1471464243 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    (/usr/bin/time -v python3 tf_cnn_benchmarks.py --forward_only=True --data_format=NHWC --device=cpu --batch_size=128 --num_inter_threads=0 --num_intra_threads=2 --nodistortions --model=inception3 --kmp_blocktime=0 --num_batches=20 --num_warmup_batches 0) 2>&1 | grep -E 'User time \(seconds\)|System time \(seconds\)|Percent of CPU this job got|Elapsed \(wall clock\) time \(h:mm:ss or m:ss\)|Maximum resident set size \(kbytes\)|Major \(requiring I/O\) page faults|Minor \(reclaiming a frame\) page faults|Voluntary context switches|Involuntary context switches|Exit status' 
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

# echo "80% swapfile"
# echo "80% dram"
# echo "80% rdma"
echo "80% 2nodeaverage"
echo 1681673420 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    (/usr/bin/time -v python3 tf_cnn_benchmarks.py --forward_only=True --data_format=NHWC --device=cpu --batch_size=128 --num_inter_threads=0 --num_intra_threads=2 --nodistortions --model=inception3 --kmp_blocktime=0 --num_batches=20 --num_warmup_batches 0) 2>&1 | grep -E 'User time \(seconds\)|System time \(seconds\)|Percent of CPU this job got|Elapsed \(wall clock\) time \(h:mm:ss or m:ss\)|Maximum resident set size \(kbytes\)|Major \(requiring I/O\) page faults|Minor \(reclaiming a frame\) page faults|Voluntary context switches|Involuntary context switches|Exit status' 
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done


# echo "90% swapfile"
# echo "90% dram"
# echo "90% rdma"
echo "90% 2nodeaverage"
echo 1891882598 > /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/pagerank_150M/memory.max
echo "adding current shell to pagerank_150M"
for i in {1..3}; do
    echo "Iteration $i"
    echo $$ | sudo tee /sys/fs/cgroup/yuri/pagerank_150M/cgroup.procs
    (/usr/bin/time -v python3 tf_cnn_benchmarks.py --forward_only=True --data_format=NHWC --device=cpu --batch_size=128 --num_inter_threads=0 --num_intra_threads=2 --nodistortions --model=inception3 --kmp_blocktime=0 --num_batches=20 --num_warmup_batches 0) 2>&1 | grep -E 'User time \(seconds\)|System time \(seconds\)|Percent of CPU this job got|Elapsed \(wall clock\) time \(h:mm:ss or m:ss\)|Maximum resident set size \(kbytes\)|Major \(requiring I/O\) page faults|Minor \(reclaiming a frame\) page faults|Voluntary context switches|Involuntary context switches|Exit status' 
    echo "memory.peak is:"
    cat /sys/fs/cgroup/yuri/pagerank_150M/memory.peak
done

# echo "不限制内存"
# for i in {1..3}; do
#     echo "Iteration $i"
#     (/usr/bin/time -v python3 tf_cnn_benchmarks.py --forward_only=True --data_format=NHWC --device=cpu --batch_size=128 --num_inter_threads=0 --num_intra_threads=2 --nodistortions --model=inception3 --kmp_blocktime=0 --num_batches=20 --num_warmup_batches 0) 2>&1 | grep -E 'User time \(seconds\)|System time \(seconds\)|Percent of CPU this job got|Elapsed \(wall clock\) time \(h:mm:ss or m:ss\)|Maximum resident set size \(kbytes\)|Major \(requiring I/O\) page faults|Minor \(reclaiming a frame\) page faults|Voluntary context switches|Involuntary context switches|Exit status' 
# done



deactivate