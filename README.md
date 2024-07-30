# 构建基于RDMA的多节点异质内存系统 multiswap
赛题：proj309

RDMA是一种新型网络技术，CPU可以通过Infiniband RDMA网卡设备对连接的另一个设备上的内存发起访问。我们希望通过RDMA网卡、RDMA交换机构建一个3-5节点的原型系统。该系统应拥有2-3个远程内存节点和1-2个计算节点，我们希望可以在Linux内核层面，探索未来如何在更复杂RDMA拓扑连接上实现更高性能的内存池系统。


# 参赛队伍简介
学校： 南开大学

队长： 曹骜天

队员：朱奕翔、许宸

项目导师：宫晓利

# 项目简介
近10年，远程内存作为一种新兴的内存扩展介质，为体系结构领域带来了新鲜的话题。学界与工业界在“如何减小访问远程内存的开销”方面进行了大量的研究工作。从RDMA的引入到使用CXL(Compute Express Link) 进行直接内存访问，从分布式共享内存到分离式内存的主流协议变化。采用各种手段，来减少访问远程内存访问导致的性能下降。

本项目旨在从工程实现的角度，利用Linux内核中的swap子系统及其对多设备的原生支持和frontswap的可扩展性，基于RDMA实现远程内存页面传输协议。我们设计并构建了多节点混合远程内存池系统MultiswapSys，创建了一个拥有计算节点和两个内存节点的内存池集群，模拟数据中心中部分机器存在闲置内存的情况。通过实验，我们分析了在不同带宽限制的场景下系统的性能表现，并提出了针对性能瓶颈的优化方法。

我们的研究不仅实现了一个多节点的远程内存池原型系统，还对计算节点和内存节点各自面临的挑战进行了深入探讨。最终，通过优化内存分配和页面传输机制，我们显著提高了在带宽限制下系统的整体性能，为未来大规模数据中心和高性能计算环境中的远程内存技术应用提供了有价值的参考。

# 硬件支持
第五代RDMA网卡：Nvidia Mellanox ConnectX-5 RoCE

![alt text](./image/image.png)

以太网交换机：NVIDIA Mellanox SN2700
![alt text](./image/Switch.jpg)

# 开发环境
|     | Linux kernel  | Nvidia MLNX OFED driver  | OS  |
|:---------:|:--------:|:--------:|:--------:|
| **计算节点**   | 6.1.87  | 23.10-3.2.2.0-LTS  | Ubuntu 22.04  |
| **内存节点**   | 5.15  | 5.8-4.1.5.0-LTS  | Ubuntu 20.04  |





**License**
- GPLv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

### 项目目录
```shell
├─ 6.1kernel        # submodule:增加patch后的Linux6.1内核
├─ dev-rdma         # RDMA驱动
│  ├─ Makefile       
│  ├─ insdram.sh     # 安装DRAM BACKEND
│  ├─ insmod.sh      # 安装RDMA BACKEND
│  ├─ multiswap.c    # multiswap
│  ├─ multiswap_dram.c  # DRAM BACKEND
│  ├─ multiswap_dram.h
│  ├─ multiswap_rdma.c  # RDMA BACKEND
│  ├─ multiswap_rdma.h
│  ├─ rmdram.sh      # 移除DRAM BACKEND
│  └─ rmmod.sh       # 移除RDMA BACKEND
├─ farmemserver     # 远程内存服务端
│  ├─ client.c      # 用户态客户端连接测试
│  ├─ Makefile
│  └─ rmserver.c    # server程序
├─ README.md
└─ test     # 测试相关
   ├─ memory_limit_test.sh  # 测试正确性脚本
   ├─ pagewalker.c      # 测试正确性程序
   ├── data_test        # 性能测试脚本
   ├── averagetime      # 数据处理后结果
   ├── plot 
   ├── testbench     # benchmark
   │   ├── kmeans     
   │   ├── quicksort
   │   ├── linpack
   │   ├── mbw      
   │   ├── stream
   │   └──tensorflow
   └── testoutcome # 测试结果原始数据
   

```

### 项目开发设计文档
[项目设计文档](https://gitlab.eduxiji.net/T202410055992676/project2210132-233922/-/blob/dev-rdma/设计文档.pdf)