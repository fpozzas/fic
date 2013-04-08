#
#
# Makefile to generate demo_module_3.so
# 
# usage:
# To point to a particular compiler, set CC.
# "make" : generate library
# "make ARCH=32" : generate library for 32bit
# "make clean" : remove *.o , *.so
#

LIBGTOPFLAGS=-I /usr/include/libgtop-2.0/glibtop -I /usr/include/libgtop-2.0 -I /usr/include/glib-2.0/ -I /usr/lib/glib-2.0/include/
LDFLAGS=-I. `net-snmp-config --cflags` $(LIBGTOPFLAGS)

LIBGTOPLIBS=/usr/lib/libgtop-2.0.so
LDLIBS=$(LIBGTOPLIBS)

PROG= demo_module_3.so
SRCS= demo_module_3.c
OBJS = $(SRCS:.c=.o)

# shared library flags (assumes gcc)
DLFLAGS=-fPIC -shared

all:$(PROG)
$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) $(DLFLAGS) $(LDLIBS) -o $@ $(OBJS)
.c.o:
	$(CC) $(LDFLAGS) $(DLFLAGS) -g  -o $@ -c $<

clean:
	rm -f $(PROG) $(OBJS) *~


