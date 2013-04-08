#
#
# Makefile to generate demo_module_1.so
# 
# usage:
# "make" : generate library
# "make clean" : remove *.o , *.so
#

CC=gcc
LIBGTOPFLAGS=-I /usr/include/libgtop-2.0/glibtop -I /usr/include/libgtop-2.0 -I /usr/include/glib-2.0/ -I /usr/lib/glib-2.0/include/
LDFLAGS=-I. `net-snmp-config --cflags` $(LIBGTOPFLAGS)

LIBGTOPLIBS=/usr/lib/libgtop-2.0.so
LDLIBS=$(LIBGTOPLIBS)

PROG= demo_module_1.so
SRCS= demo_module_1.c 
OBJS = $(SRCS:.c=.o)

# shared library flags (assumes gcc)
DLFLAGS=-fPIC -shared

all:$(PROG)
$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) $(DLFLAGS) $(LDLIBS) -o $@ $(OBJS)
.c.o:
	@if test "$(CC)" = "" ; then \
	echo "Environment variable CC must be set with compiler path" ; \
	exit 1 ; \
	fi
	$(CC) $(LDFLAGS) $(DLFLAGS) -g  -o $@ -c $<

clean:
	rm -f $(OBJS) $(PROG) *~



