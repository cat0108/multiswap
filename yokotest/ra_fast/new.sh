#!/bin/bash

# 创建名为 mygroup 的内存控制组
sudo cgcreate -g memory:mygroup

# 将 mygroup 的 memory.limit_in_bytes 文件设置为 134217728（128MB）
echo 134217728 | sudo tee /sys/fs/cgroup/memory/mygroup/memory.limit_in_bytes

# 将当前进程的 PID 写入 mygroup 的 cgroup.procs 文件
echo $$ | sudo tee /sys/fs/cgroup/memory/mygroup/cgroup.procs

sudo insmod /home/zyx/fastswap/drivers/fastswap_dram.ko

sudo insmod /home/zyx/fastswap/drivers/fastswap.ko
