#
#
# Makefile to generate demo_module_2.so
#
# usage:
# "make" : generate library
# "make clean" : remove *.o , *.so
#

CC=gcc
LDFLAGS=-I. `net-snmp-config --cflags`

LDLIBS=

PROG= demo_module_2.so
SRCS= demo_module_2.c
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
	rm -f $(PROG) $(OBJS) *~
