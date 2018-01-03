# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2008 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##
"""Payment category, user defined grouping of payments
"""

from stoqlib.database.orm import ForeignKey, DateTimeCol, IntCol, StringCol
from stoqlib.domain.base import Domain
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class PaymentIuguBill(Domain):
    """
    I am an intermediary between easyloja and iugu, my job is to persist bills data
    docs: http://support.iugu.com/hc/pt-br/articles/213163706-Lista-de-status-de-fatura-e-seus-significados
    @:parameter payment: a Payment in easyloja
    """
    (STATUS_PENDING,
     STATUS_PAID,
     STATUS_CANCELED,
     STATUS_DRAFT,
     STATUS_PARTIALLY_PAID,
     STATUS_REFUNDED,
     STATUS_EXPIRED,
     STATUS_IN_PROTEST,
     STATUS_CHARGEBACK,
     STATUS_IN_ANALISYS) = range(10)

    statuses = {STATUS_PENDING: _(u'pending'),
                STATUS_PAID: _(u'paid'),
                STATUS_CANCELED: _(u'canceled'),
                STATUS_DRAFT: _(u'draft'),
                STATUS_PARTIALLY_PAID: _(u'partially_paid'),
                STATUS_REFUNDED: _(u'refunded'),
                STATUS_EXPIRED: _(u'expired'),
                STATUS_IN_PROTEST: _(u'in_protest'),
                STATUS_CHARGEBACK: _(u'chargeback'),
                STATUS_IN_ANALISYS: _(u'in_analysis')}

    iugu_id = StringCol(default='')
    status = IntCol(default=STATUS_PENDING)
    secure_id = StringCol(default='')
    secure_url = StringCol(default='')
    due_date = DateTimeCol(default=None)
    paid_at = DateTimeCol(default=None)
    doc_pdf = StringCol(default=None)
    payment = ForeignKey('Payment')
