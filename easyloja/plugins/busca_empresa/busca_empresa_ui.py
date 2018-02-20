# -*- coding: utf-8 -*-
import os
import platform
import sys
from unicodedata import normalize
from kiwi.ui.dialogs import info
from stoqlib.database.runtime import get_connection
from stoqlib.domain.events import ResultListEvent

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)

class BuscaEmpresaUI(object):
    def __init__(self):
        self.conn = get_connection()
        ResultListEvent.connect(self._on_ResultListEvent)

    def validate_result_list(self, resultlist):
        l = []
        for product_view in resultlist:
            l.append(len(product_view.code))
        return l.count(l[0]) == len(l)

    def _on_ResultListEvent(self, resultlist):
        if not self.validate_result_list(resultlist):
            info(u'Todos os códigos devem ser do mesmo tamanho. 4, 5 ou 6 dígitos')
            return False
        path = get_mgv_path()
        f = open(path, 'w')
        controlarray = []
        for product_view in resultlist:
            if self._validade_product_view(product_view):
                description = remove_accentuation(product_view.description)
                if product_view.code not in controlarray:
                    controlarray.append(product_view.code)
                    line = '{DD}{ETQ}{TPVD}{CODE}{PRICE}{VLDD}{DESC}0000000000000000110000000000000000000000000000000000000000000000000000000000000000000000\n' \
                        .format(DD='01', ETQ='', TPVD='0', CODE=fill_zeros(product_view.code, 6, type='code'),
                                PRICE=fill_zeros(product_view.price, 6), VLDD='000',
                                DESC=fill_spaces(description, 50))
                    f.write(line)
        f.close()
        return path

    def _validade_product_view(self, pv):
        if extract_digits(pv.code) != pv.code:
            return False
        if not pv.code:
            return False
        if not pv.description:
            return False
        return True
