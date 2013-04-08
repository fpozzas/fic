#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import util

class Controlador(util.Sujeto):

    def __init__(self, modelo):
        util.Sujeto.__init__(self)
        modelo.anadirObservador(self)

    def registrar_vista(self, vista):
        self.anadirObservador(vista)

    def notificar(self, estado):
        print >> sys.stderr, "Ha ocurrido un cambio en el modelo, notifico a las vistas"
        self.actualizar(estado)
