# -*- coding: utf-8 -*-
import os
import sys

from interface import GenericPrinter

local_file = os.path.dirname(__file__)
sys.path.append(local_file)


class NonFiscalPrinter(GenericPrinter):
    """ Access other printer classes
    Usage:
        nfp = NonFiscalPrinter(brand='daruma', model='dr800', port='com1', dll='C:\\DarumaFramework.dll')
        npf.open_drawer()
    """

    def __init__(self, brand, model, port, dll, spooler_printer):
        module = __import__(brand, None, None)
        self._printerClass = getattr(module, model.upper())
        if model.upper() == 'GENERICSPOOLER':
            self._printer = self._printerClass(port, spooler_printer)
        else:
            self._printer = self._printerClass(port, dll)

    def open_drawer(self):
        self._printer.open_drawer()

    def close_port(self):
        self._printer.close_port()

    def write_text(self, txt):
        self._printer.write_text(txt)

    def ean13(self, txt):
        self._printer.ean13(txt)

    def cut_paper(self):
        self._printer.cut_paper()

    def set_baud_rate(self, br):
        self._printer.set_baud_rate()

    def test_printer(self):
        self._printer.test_printer()
