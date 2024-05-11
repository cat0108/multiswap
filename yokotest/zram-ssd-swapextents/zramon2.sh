#!/bin/bash

modprobe zram num_devices=1
swapoff /dev/zram0

numstream=$(cat /sys/block/zram0/max_comp_streams)
echo "numstream = ${numstream}"
algo=$(cat /sys/block/zram0/comp_algorithm)
echo "used algorythm is ${algo}"

# Initialize /dev/zram0 with 256MB disksize
echo $((256*1024*1024)) > /sys/block/zram0/disksize
echo $((256*1024*1024)) > /sys/block/zram0/mem_limit

#swap on
mkswap /dev/zram0
#setting the max priority
swapon -p 1000 /dev/zram0

