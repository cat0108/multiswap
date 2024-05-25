# 构建基于RDMA的多节点异质内存系统
**项目名称**

构建基于RDMA的多节点异质内存系统

**支持单位**

南开大学计算机学院

**目标描述**

RDMA是一种新型网络技术，CPU可以通过Infiniband RDMA网卡设备对连接的另一个设备上的内存发起访问。我们希望通过RDMA网卡、RDMA交换机构建一个3-5节点的原型系统。该系统应拥有2-3个远程内存节点和1-2个计算节点，我们希望可以在Linux内核层面，探索未来如何在更复杂RDMA拓扑连接上实现更高性能的内存池系统。

**所属赛道**

2023全国大学生操作系统比赛的“OS功能挑战”赛道

### 项目导师

宫晓利
- email: gongxiaoli@nankai.edu.cn 


### 难度

高

**说明**
1. 基于>6.1版本的linux发行版开发
2. 组成实际的原型系统
3. 可运行在86架构上
4. 性能开销、稳定性高

**文档**
1. linux kernel:https://kernel.org/

**License**
- GPLv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

### 项目实现列表

├─ 6.1kernel        # 增加patch后的Linux6.1内核
├─ dev-rdma         # RDMA驱动
│  ├─ fastswap.c    # frontswap_ops接口实现
│  ├─ fastswap_dram.c   # DRAM BACKEND
│  ├─ fastswap_dram.h   # DRAM BACKEND
│  ├─ fastswap_rdma.c
│  ├─ fastswap_rdma.h
│  ├─ insmod.sh     # 安装脚本
│  ├─ Makefile
│  └─ rmmod.sh      # 卸载脚本
├─ farmemserver     # 远程内存服务端
│  ├─ client.c
│  ├─ Makefile
│  └─ rmserver.c
├─ README.md
└─ test
   ├─ memory_limit_test.sh  # 测试脚本
   └─ pagewalker.c      # 测试正确性程序