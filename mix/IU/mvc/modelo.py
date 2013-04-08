#!/usr/bin/env python
# -*- coding: utf-8 -*-

import util

class Modelo(util.Sujeto):
    _estado = None

    def __init__(self):
        util.Sujeto.__init__(self)
        self._estado = False

    def nuevo(self, estado):
        self._estado = estado
        self.actualizar(estado)
        
