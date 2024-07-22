.PHONY: clean all

CFLAGS := -Wall -g
LDLIBS := ${LDLIBS} -lrdmacm -libverbs -lpthread

APPS := client rmserver

all: ${APPS}

client:
	gcc $(CFLAGS) -o client client.c $(LDLIBS)

server:
	gcc $(CFLAGS) -o server server.c $(LDLIBS)
rmserver:
	g++ $(CFLAGS) -O2 -g -ggdb -Werror -o rmserver rmserver.c $(LDLIBS)

clean:
	rm -f ${APPS}