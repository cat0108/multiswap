#if !defined(_SSWAP_RDMA_H)
#define _SSWAP_RDMA_H

#include <rdma/ib_verbs.h>
#include <rdma/rdma_cm.h>
#include <linux/inet.h>
#include <linux/module.h>
#include <linux/list.h>
#include <linux/mm_types.h>
#include <linux/gfp.h>
#include <linux/pagemap.h>
#include <linux/spinlock.h>

enum qp_type {
  QP_READ_SYNC,
  QP_READ_ASYNC,
  QP_WRITE_SYNC
};

struct sswap_rdma_dev {//ib: infiniband
  struct ib_device *dev;//rdma device
  struct ib_pd *pd;//protection domain
};

struct rdma_req {
  struct completion done;
  struct list_head list;
  struct ib_cqe cqe;
  u64 dma;
  struct page *page;
};

struct sswap_rdma_ctrl;

struct rdma_queue {
  struct ib_qp *qp;//queue pair
  struct ib_cq *cq;//completion queue
  spinlock_t cq_lock;
  enum qp_type qp_type;

  struct sswap_rdma_ctrl *ctrl;//rdma controller

  struct rdma_cm_id *cm_id;
  int cm_error;
  struct completion cm_done;//完成变量，用于同步

  atomic_t pending;//队列中未处理完的队列数量
};

struct sswap_rdma_memregion {
    u64 baseaddr;
    u32 key;
};

//rdma controller
struct sswap_rdma_ctrl {
  struct sswap_rdma_dev *rdev;
  struct rdma_queue *queues;
  struct sswap_rdma_memregion servermr;

  union {
    struct sockaddr addr;
    struct sockaddr_in addr_in;
  };

  union {
    struct sockaddr srcaddr;
    struct sockaddr_in srcaddr_in;
  };
};

//multi server node
struct gctrl_entry {
  struct sswap_rdma_ctrl *gctrl;
  struct list_head list;
  int serverport;
  char serverip[INET_ADDRSTRLEN];
  char clientip[INET_ADDRSTRLEN];
};

struct rdma_queue *sswap_rdma_get_queue(unsigned int idx,
                 enum qp_type type,struct sswap_rdma_ctrl *gctrl);
enum qp_type get_queue_type(unsigned int idx);
int sswap_rdma_read_sync(struct page *page, u64 roffset);
int sswap_rdma_write(struct page *page, u64 roffset);


#endif
