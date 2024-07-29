#!/bin/bash
count=0
while true; do
    redis_pid=$(pgrep redis-server)

    if [[ -z $redis_pid ]]; then
        echo "Redis进程未运行"
        exit 1
    fi

    # 获取Redis线程ID
    thread_ids=$(ps -T -p $redis_pid | awk '{if(NR>1) print $2}')

    if [[ -z $thread_ids ]]; then
        echo "Redis线程未运行"
        exit 1
    fi

    # 杀死Redis线程
    for thread_id in $thread_ids; do
        echo "Killing Redis线程 $thread_id"
        if [ "$count" -gt 5 ]; then
            sudo kill $thread_id
        else
            sudo kill -9 $thread_id
        fi
    done

    if [ "$count" -gt 5 ]; then
        sudo kill $redis_pid
    else
        sudo kill -9 $redis_pid
    fi    
    echo "Killing Redis-server进程 $redis_pid"

    sleep 3
    count=$(($count + 1))
done
# 获取Redis进程ID
echo "Redis线程已全部杀死"