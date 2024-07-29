# #!/bin/bash
# if [ $# -lt 1 ]; then
#   echo "run_perf.sh [pid]"
#   exit 1
# fi
# sudo perf record -p $1 -g -F 99 -- sleep 30


if [ $# -lt 1 ]; then
  echo "Usage: run_perf.sh <command> [args...]"
  exit 1
fi

# 获取命令及其参数
command=$1
shift
args="$@"

# 使用 perf record 运行命令并记录性能数据
sudo perf record -g -- $command $args