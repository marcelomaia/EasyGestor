import os

import requests
from stoqlib.lib.osutils import get_application_dir
from decimal import Decimal

certifi_path = os.path.join(get_application_dir(), 'cacert.pem')
os.environ['REQUESTS_CA_BUNDLE'] = certifi_path


def extract_digits(text):
    return ''.join([p for p in text if p in '0123456789'])


#
# url = 'https://www.receitaws.com.br/v1/cnpj/{cnpj}'.format(cnpj=extract_digits('17.895.646/0001-87'))
#
# r = requests.get(url, timeout=3)
# data = r.json()
#
# company_name = data.get('nome')
# phone = data.get('telefone')
# email = data.get('email')
# uf = data.get('uf')
# company_status = data.get('situacao')
# status = data.get('status')
# district = data.get('bairro')
# street = data.get('logradouro')
# number = data.get('numero')
# postal_address = data.get('cep')
# city = data.get('municipio')
# legal_nature = data.get('natureza_juridica')
# cnpj = data.get('cnpj')
# fancy_name = data.get('fantasia')
#
# main_activity_data = data.get('atividade_principal')
# secondary_activity_data = data.get('atividades_secundarias')
#
# if status == 'ERROR':
#     print 'ERRO'
#
# partners_data = data.get('qsa')
# for partner in partners_data:
#     partner_qual = partner.get('qual')
#     partner_nome = partner.get('nome')
#     print 'parceiro', partner_qual, partner_nome
#
# for activity in main_activity_data:
#     description = activity.get('text')
#     code = activity.get('code')
#     print 'main', description, extract_digits(code)
#
# for activity in secondary_activity_data:
#     description = activity.get('text')
#     code = activity.get('code')
#     print 'secondary', description, extract_digits(code)
#
# print company_name, fancy_name
#

class CompanyData(object):
    def __init__(self, cnpj):
        url = 'https://www.receitaws.com.br/v1/cnpj/{cnpj}'.format(
            cnpj=extract_digits(cnpj))
        r = requests.get(url, timeout=60)
        self.data = r.json()

    def _get_responsible_name(self, data):
        partners_data = data.get('qsa')
        for partner in partners_data:
            partner_qual = partner.get('qual')
            partner_nome = partner.get('nome')
            return partner_nome

    def _get_main_cnae(self, data):
        main_activity_data = data.get('atividade_principal')
        for main_activity in main_activity_data:
            code = main_activity.get('code')
            text = main_activity.get('text')
            return code

    def get_company_data(self):
        if self.data.get('status') == 'ERROR':
            return False
        else:
            return dict(company_name=self.data.get('nome'),
                        phone_number=self.data.get('telefone'),
                        email=self.data.get('email'),
                        state=self.data.get('uf'),
                        company_status=self.data.get('situacao'),
                        status=self.data.get('status'),
                        district=self.data.get('bairro'),
                        street=self.data.get('logradouro'),
                        streetnumber=self.data.get('numero'),
                        postal_code=self.data.get('cep'),
                        city=self.data.get('municipio'),
                        legal_nature=self.data.get('natureza_juridica'),
                        cnpj=self.data.get('cnpj'),
                        fancy_name=self.data.get('fantasia'),
                        responsible_name=self._get_responsible_name(self.data),
                        social_capital=Decimal(self.data.get('capital_social')),
                        main_cnae_code=self._get_main_cnae(self.data))
