# -*- coding: utf-8 -*-

# 3702 - Adicionar método de pagamento 'fiado'

from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.lib.translation import stoqlib_gettext as _

# Add the 'store_credit' payment method when we are updating the database,
# otherwise the payment method will be added automaticaly when setting up the
# system.

def apply_patch(trans):
    has_methods = PaymentMethod.select(connection=trans).count() > 0
    if has_methods:
        method = PaymentMethod.selectOneBy(method_name='store_credit',
                                             connection=trans)
        if method is None:
            PaymentMethod(method_name=u'store_credit',
                          description=_(u'Store Credit'),
                          max_installments=1,
                          connection=trans)
