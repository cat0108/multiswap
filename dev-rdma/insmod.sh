#!/bin/bash

sudo ifconfig enp1s0f1np1 10.10.10.1 netmask 255.255.255.0
sudo insmod fastswap_rdma.ko sport=50000 sip=10.10.10.2 cip=10.10.10.1 nq=6
sudo insmod fastswap.ko