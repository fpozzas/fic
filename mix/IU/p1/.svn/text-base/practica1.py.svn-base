#!/usr/bin/env python
#coding=utf-8

import random
import sys
from lipsum import generator 
import time
import datetime

try:
 	import pygtk 
  	pygtk.require("2.0")
except:
  	pass
try:
	import gtk
  	import gtk.glade
except:
	print 'paaaaaaaaaaaf'
	sys.exit(1)

class Principal:
	def __init__(self):
		self.gladefile = 'interfaz1.glade'
		w = gtk.glade.XML(self.gladefile,'window')
		w.signal_autoconnect(self)
		self._treeview = w.get_widget('treeview')
		self._textview = w.get_widget('textview')
		self._statusbar = w.get_widget('statusbar')
		self._statusbarid = self._statusbar.get_context_id("mainview")
		new = w.get_widget('botonnuevo')
		exit = w.get_widget('botonsalir')
		toolbar = w.get_widget('toolbar')
		win = w.get_widget('window')
		self._store = gtk.ListStore(str,str)
		self._treeview.set_model(self._store)
		columna = gtk.TreeViewColumn('title', gtk.CellRendererText(), text=0)
		self._treeview.append_column(columna)
		toolbar.set_focus_chain([new, exit])		
		win.set_focus_chain([toolbar, self._treeview])
		
	
	#Manejadores 
	
	def on_newbutton_clicked(self, widget):
		self.new_element()
	
	def on_exitbutton_clicked(self,widget):
		gtk.main_quit()
	
	def on_newmenu_activate(self, widget):
		self.new_element()
	
	def on_quitmenu_activate(self, widget):
		gtk.main_quit()
		
	def on_window_destroy(self, widget):
		gtk.main_quit()
	 
	def on_aboutmenu_activate(self, widget):
		w = gtk.glade.XML(self.gladefile,'aboutdialog')
		self._aboutdialog = w.get_widget('aboutdialog')
		w.signal_autoconnect(self)
		
	def on_aboutdialog_destroy(self, widget):
		self._aboutdialog.hide()
	
	def on_aboutdialog_response(self, widget,NULL):
		self._aboutdialog.hide()
	
	def on_treeview_cursor_changed(self, widget):
		sel, it = self._treeview.get_selection().get_selected()
		title = sel.get_value(it, 0)
		text = sel.get_value(it,1)
		self.get_text(text)
		self.set_statusbar(title)

	## funciones genericas
	
	def new_element(self):
		model = self._store.append(['title','text'])
		text = self.generate_text()
		title = self.generate_title()
		self._store.set_value(model, 0, title)
		self._store.set_value(model, 1, text)
		self.get_text(text)
		self.set_statusbar(title)
		new = self._store.get_path(model)
		self._treeview.set_cursor(new)	
	
	def generate_title(self):
		return str(random.random())
		
	def generate_text(self):
		return generator('sample.txt','dictionary.txt').generate_paragraph(True,3)
		
	def get_text(self, text):
		b = self._textview.get_buffer()
		b.set_text(text)
		
	
	def set_statusbar(self, title):
		fecha = datetime.date.today().strftime(" %d/%m/%Y")
		fechasrt = ("Fecha:" + " %s " ) % (fecha) 
		self._statusbar.pop(self._statusbarid)
		self._statusbar.push(self._statusbarid, fechasrt +" | Seleccionado: %s" % title)
	
		
if __name__ == "__main__":

	p = Principal()
	gtk.main()
