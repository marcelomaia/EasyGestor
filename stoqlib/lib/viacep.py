#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
from https://github.com/leogregianin/viacep-python/blob/master/viacep.py
"""
import json

import requests
from kiwi.ui.dialogs import error

requests.adapters.DEFAULT_RETRIES = 5


class ViaCEP:
    def __init__(self, cep):
        self.cep = cep

    def retorna_json_completo(self):
        url_api = ('http://www.viacep.com.br/ws/%s/json' % self.cep)
        try:
            req = requests.get(url_api, timeout=3)
        except Exception, e:
            error('Erro ao buscar cep')
            return False
        if req.status_code == 400:
            return False
        dados_json = json.loads(req.text)
        return dados_json

    def retorna_uf(self):
        url_api = ('http://www.viacep.com.br/ws/%s/json' % self.cep)
        req = requests.get(url_api)
        dados_json = json.loads(req.text)
        return dados_json['uf']


if __name__ == '__main__':
    test1 = ViaCEP('123123213')
    print(u'%s' % test1.retorna_json_completo())
