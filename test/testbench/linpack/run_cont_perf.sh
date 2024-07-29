#! /bin/bash

# the workload uses 1.5G of memory
set -e
PERF="perf stat -d"


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
arch=xeon64
#echo "running linpack without memory limit"
#sudo $PERF ./runme_xeon64
#
#echo "running linpack 1152M"
#../scripts/changemem_cgroup2.sh 1152M
#sudo ../scripts/exec_cgroupv2.sh $PERF ./runme_xeon64
#
#echo "running linpack 768M"
#../scripts/changemem_cgroup2.sh 768M
#sudo ../scripts/exec_cgroupv2.sh $PERF ./runme_xeon64

# echo "running linpack 384M"
# ../scripts/changemem_cgroup2.sh 384M
# sudo ../scripts/exec_cgroupv2.sh ./runme_xeon64
{
    echo "开始执行 xlinpack_xeon64: $(date)"
    /usr/bin/time -v $PERF $DIR/xlinpack_$arch $DIR/lininput_$arch
    echo "执行完成: $(date)"
    } | tee $DIR/lin_$arch.txt
