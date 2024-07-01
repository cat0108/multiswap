#!/bin/bash

sudo ifconfig enp1s0f1np1 10.10.10.1 netmask 255.255.255.0
sudo insmod fastswap_rdma.ko
sudo insmod fastswap.ko