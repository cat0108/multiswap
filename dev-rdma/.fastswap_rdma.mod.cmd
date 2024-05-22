cmd_/home/cat22/gitRepo/dev-rdma/fastswap_rdma.mod := printf '%s\n'   fastswap_rdma.o | awk '!x[$$0]++ { print("/home/cat22/gitRepo/dev-rdma/"$$0) }' > /home/cat22/gitRepo/dev-rdma/fastswap_rdma.mod
