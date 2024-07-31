.PHONY: clean all

CFLAGS := -Wall -g
LDLIBS := ${LDLIBS} -lrdmacm -libverbs -lpthread

APPS := rmserver

all: ${APPS}

rmserver:
	g++ $(CFLAGS) -O2 -g -ggdb -Werror -o rmserver rmserver.c $(LDLIBS)

clean:
	rm -f ${APPS}