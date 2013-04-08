#
# Copyright Copyright 2003 Sun Microsystems, Inc. All rights reserved.
#
# U.S. Government Rights - Commercial software. Government users are subject
# to the Sun Microsystems, Inc. standard license agreement and applicable
# provisions of the FAR and its supplements.
#
# Use is subject to license terms.
#
# This distribution may include materials developed by third parties. Sun,
# Sun Microsystems, the Sun logo and Solaris are trademarks or registered
# trademarks of Sun Microsystems, Inc. in the U.S. and other countries.
#
#

#
#
# Makefile to generate demo_module_5.so
# 
# usage:
# To point to a particular compiler, set CC.
# Example: setenv CC /usr/dist/share/forte_dev/bin/cc
# "make" : generate library for 64bit
# "make ARCH=32" : generate library for 32bit
# "make clean" : remove *.o , *.so
#

CFLAGS=-I. `net-snmp-config --cflags` $(LIBGTOPFLAGS)

LDLIBS=

PROG= demo_module_4.so
SRCS= demo_module_4.c
OBJS = $(SRCS:.c=.o)

# shared library flags (assumes gcc)
DLFLAGS=-fPIC -shared

all:$(PROG)
$(PROG): $(OBJS)
	$(CC) $(CFLAGS) $(DLFLAGS) $(LDLIBS) -o $@ $(OBJS)
.c.o:
	$(CC) $(CFLAGS) $(DLFLAGS) -g  -o $@ -c $<

clean:
	rm -f $(PROG) $(OBJS) *~


