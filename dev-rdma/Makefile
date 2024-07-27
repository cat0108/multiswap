OFA_DIR ?= /usr/src/ofa_kernel/default
OFA_INCLUDE := $(OFA_DIR)/include
OFA_SYMVERS := $(OFA_DIR)/Module.symvers

ifneq ($(LINUXINCLUDE),)
# kbuild part of makefile

LINUXINCLUDE := \
  -I$(OFA_INCLUDE) \
  ${LINUXINCLUDE}

else
# normal makefile

export KBUILD_EXTRA_SYMBOLS=$(OFA_SYMVERS)
KDIR ?= /lib/modules/`uname -r`/build

default: release

release:
	$(MAKE) -C $(KDIR) M=$$PWD

debug:
	$(MAKE) -C $(KDIR) M=$$PWD CFLAGS_MODULE="-g"

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif

obj-m  := multiswap.o
ifeq ($(BACKEND),RDMA)
	obj-m += multiswap_rdma.o
	CFLAGS_multiswap.o = -DBACKEND=2
else
	obj-m += multiswap_dram.o
	CFLAGS_multiswap.o = -DBACKEND=1
endif
