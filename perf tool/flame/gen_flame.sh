#!/bin/bash
mkdir -p ./tmp
flamebase=/home/yuri/FlameGraph
sudo rm -rf ./tmp/*

sudo perf script -i ./perf.data &> ./tmp/perf.unfold

sudo $flamebase/stackcollapse-perf.pl ./tmp/perf.unfold &> ./tmp/perf.folded

sudo $flamebase/flamegraph.pl ./tmp/perf.folded > ./perf.svg
