#!/usr/bin/env python
# -*-  coding: utf-8 -*-

import pygtk
import gtk
import gtk.glade

class Vista:
    _barraestado = None
    _ctx_barraestado = None

    def __init__(self, file, winname):
        xml = gtk.glade.XML(file)
        w = xml.get_widget(winname)
        self._barraestado = xml.get_widget('barra_estado')
        self._ctx_barraestado = self._barraestado.get_context_id('ejemplo')
        xml.signal_autoconnect(self)
        w.show_all()

    def notificar(self, estado):
        gtk.gdk.threads_enter()
        self._barraestado.pop(self._ctx_barraestado)
        self._barraestado.push(self._ctx_barraestado, "Estado: " + str(estado))
        gtk.gdk.threads_leave()
        
