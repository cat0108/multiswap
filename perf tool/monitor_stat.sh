#!/bin/bash

if [ $# -lt 2 ]; then
  echo "not enouth params use monitor_stat.sh [sourcefile] [resultpath]"
  exit 1
fi

source_stat=$1

result_base=$2
if [! ls $source_stat >/dev/null 2>&1 ]; then
  echo "use monitor_stat.sh [#sourcefile] [resultpath]"
  exit 1
fi
filename=$(basename "$source_stat")

# 提示用户输入第二个参数，并验证非空
if [ ! -d $result_base ]; then
  echo "use monitor_stat.sh [sourcefile] [#resultpath]"
  exit 1
fi

# 输出参数
number=0
while true; do
  # 执行需要重复执行的指令
    number=$(( $number + 1 ))
    output=$result_base/$filename-$number.txt
    cat $source_stat > $output
  # 等待 5 秒
  sleep 5
done