# 构建基于RDMA的多节点异质内存系统
**项目名称**

构建基于RDMA的多节点异质内存系统

**支持单位**

南开大学计算机学院

**项目概述**

近10年，远程内存作为一种新兴的内存扩展介质，为体系结构领域带来了新鲜的话题。学界与工业界在“如何减小访问远程内存的开销”方面进行了大量的研究工作。从RDMA的引入到使用CXL(Compute Express Link) 进行直接内存访问，从分布式共享内存到分离式内存的主流协议变化。我们采用各种手段，来减少访问远程内存访问导致的性能下降。但是仅考虑计算节点侧性能的研究是远远不够的。

本工作中，我们试图从工程实现如何构建的角度出发，利用swap子系统多设备的原生支持以及frontswap的可扩展性，在内核中基于RDMA实现了远程内存页面传输协议。同时思考多节点混合远程内存池系统MultiswapSys的构建方式，真正利用现有技术搭建一个多节点内存池原型，并探究计算节点以及内存节点各自会遇到的挑战。

我们基于fastswap在linux 6.1上完成了一个多节点MultiswapSys系统原型，实际配置了一个最低拥有一个计算节点与两个内存节点的可扩展内存池集群，模拟数据中心集群中部分机器存在闲置内存的真实情况。尝试构建了低维护开销的内存分配系统，测试了在带宽限制、memory带宽抢占等不通场景下系统性能的表现。同时，针对存在的性能瓶颈问题，给出了我们的建议。

### 项目导师

宫晓利
- email: gongxiaoli@nankai.edu.cn 



**说明**
1. 基于>6.1版本的linux发行版开发
2. 组成实际的原型系统
3. 可运行在86架构上
4. 性能开销、稳定性高

**文档**
1. linux kernel:https://kernel.org/

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
└─ test
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