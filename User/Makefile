.PHONY: clean all

CFLAGS := -Wall -g
LDLIBS := ${LDLIBS} -lrdmacm -libverbs -lpthread

APPS := client server

all: ${APPS}

client:
	gcc $(CFLAGS) -o client client.c $(LDLIBS)

server:
	gcc $(CFLAGS) -o server server.c $(LDLIBS)

clean:
	rm -f ${APPS}