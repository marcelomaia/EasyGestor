# coding=utf-8
from stoqlib.domain.person import PersonAdaptToCreditProvider


def apply_patch(trans):
    for provider in PersonAdaptToCreditProvider.selectBy(trans):
        if provider.short_name == 'VISANET':
            provider.short_name = 'Cielo'
            provider.person.name = 'Cielo'
        if provider.provider_id == 'VISANET':
            provider.provider_id = 'Cielo'

        if provider.short_name == 'REDECARD':
            provider.short_name = 'Rede'
            provider.person.name = 'Rede'
        if provider.provider_id == 'REDECARD':
            provider.provider_id = 'Rede'

        if provider.short_name == 'AMEX':
            provider.short_name = 'American Express'
            provider.person.name = 'American Express'
        if provider.provider_id == 'AMEX':
            provider.provider_id = 'American Express'

        if provider.short_name == 'HIPERCARD':
            provider.short_name = 'Hipercard'
            provider.person.name = 'Hipercard'
        if provider.provider_id == 'HIPERCARD':
            provider.provider_id = 'Hipercard'

        if provider.short_name == 'BANRISUL':
            provider.short_name = 'Banpará'
            provider.person.name = 'Banpará'
        if provider.provider_id == 'BANRISUL':
            provider.provider_id = 'Banpará'

        if provider.short_name == 'PAGGO':
            provider.short_name = 'Stone'
            provider.person.name = 'Stone'
        if provider.provider_id == 'PAGGO':
            provider.provider_id = 'Stone'

        if provider.short_name == 'CREDISHOP':
            provider.short_name = 'BIN'
            provider.person.name = 'BIN'
        if provider.provider_id == 'CREDISHOP':
            provider.provider_id = 'BIN'

        if provider.short_name == 'CERTIF':
            provider.short_name = 'BNDES'
            provider.person.name = 'BNDES'
        if provider.provider_id == 'CERTIF':
            provider.provider_id = 'BNDES'
    trans.commit()
