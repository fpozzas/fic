#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Sujeto:
    _observadores = None
    def __init__(self):
        self._observadores = []

    def anadirObservador(self, observador):
        self._observadores.append(observador)
        
    def eliminarObservador(self, observador):
        self._observadores.remove(observador)

    def actualizar(self, estado):
        for o in self._observadores:
            o.notificar(estado)

