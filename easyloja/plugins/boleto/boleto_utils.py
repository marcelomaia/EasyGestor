# coding=utf-8
import os

from kiwi.log import Logger
from stoqlib.database.runtime import new_transaction
from stoqlib.domain.person import PersonAdaptToAffiliate

log = Logger("stoq-nfe-plugin")

from marketplace_iugu import MarketPlace


def extract_digits(word):
    return ''.join([p for p in word if p in '0123456789'])


def build_activate_affiliate_params(affiliateview):
    data = {'data': {
        'price_range': 'Mais que R$ 500,00',
        'physical_products': affiliateview.physical_products,
        'business_type': affiliateview.business_type,
        'automatic_transfer': True,
        'address': '{}, {}'.format(affiliateview.street, affiliateview.streetnumber),
        'cep': extract_digits(affiliateview.postal_code),
        'city': affiliateview.city,
        'state': affiliateview.state,
        'telephone': extract_digits(affiliateview.phone_number),
        'bank': PersonAdaptToAffiliate.banks.get(affiliateview.bank),
        'bank_ag': affiliateview.bank_ag,
        'account_type': PersonAdaptToAffiliate.account_types.get(affiliateview.account_type),
        'bank_cc': affiliateview.bank_cc}
    }

    if affiliateview.cnpj:
        data['data']['person_type'] = 'Pessoa Jurídica'
        data['data']['cnpj'] = extract_digits(affiliateview.cnpj)
        data['data']['company_name'] = affiliateview.fancy_name
        data['data']['resp_name'] = affiliateview.responsible_name
        data['data']['resp_cpf'] = extract_digits(affiliateview.responsible_cpf)
    else:
        data['data']['name'] = affiliateview.name
        data['data']['person_type'] = 'Pessoa Física'
        data['data']['cpf'] = extract_digits(affiliateview.cpf)
    return data


def create_affiliate(affiliateview):
    """Cria uma subconta na iugu
    retorna algo assim:
    {u'user_token': u'110ef366314a888eaabab2eb8b10df9b', u'live_api_token': u'374f6c8073edcdabf13b658fadfd545f',
     u'test_api_token': u'7584e94f9a185392091cea5065672e42', u'account_id': u'624229F5C249421EB6D11C183DF3D8A1',
      u'name': u'TESTE MARCELO 20%'}"""
    m = MarketPlace()
    name = '{} {}%'.format(affiliateview.name, float(affiliateview.commission_percent))
    retval = m.create_subaccount(name, float(affiliateview.commission_percent))
    if retval.get('errors'):
        log.debug('Erro ao criar afiliado: {}'.format(retval.get('errors')))
        return False
    print retval
    log.debug('Criou afiliado: {}'.format(retval))
    trans = new_transaction()
    affiliate = PersonAdaptToAffiliate.get(affiliateview.affiliate_id, connection=trans)
    affiliate.user_token = retval['user_token']
    affiliate.live_api_token = retval['live_api_token']
    affiliate.test_api_token = retval['test_api_token']
    affiliate.account_id = retval['account_id']
    affiliate.iugu_name = retval['name']
    affiliate.iugu_name = PersonAdaptToAffiliate.STATUS_PENDING  # status pendente para afiliado.
    trans.commit(close=True)
    return True


def verify_subaccount(affiliateview):
    try:
        data = build_activate_affiliate_params(affiliateview)
        log.debug("Parametros de validação de afiliado! {}".format(data))
        # trocando para token do usuario
        os.environ['IUGU_API_TOKEN'] = affiliateview.user_token
        m = MarketPlace()
        retval = m.verify_subaccount(affiliateview.account_id, data)
        if retval.get('errors'):
            log.debug('Erro ao verificar afiliado: {}'.format(retval.get('errors')))
            return False
        else:
            log.debug('Verificando Afiliado...: {}'.format(retval))
            trans = new_transaction()
            affiliate = PersonAdaptToAffiliate.get(affiliateview.affiliate_id, connection=trans)
            affiliate.status = PersonAdaptToAffiliate.STATUS_ANALYSIS  # deixa o afiliado em status de analise
            trans.commit(close=True)
            return True
    except Exception, e:
        log.debug('Erro: {}'.format(str(e)))
        return False
