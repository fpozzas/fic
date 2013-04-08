#!/usr/bin/env python
# -*- coding: utf-8 -*-

import threading
import pygtk
import gtk

class Main(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)

    def run(self):
        gtk.gdk.threads_init()
        gtk.main()

    def stop(self):
        gtk.main_quit()
