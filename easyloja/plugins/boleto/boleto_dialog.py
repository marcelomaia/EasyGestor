# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2010 Async Open Source <http://www.async.com.br>
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
## Author(s): George Kussumoto      <george@async.com.br>
##
##

# coding=utf-8
import webbrowser

from kiwi.python import Settable
from kiwi.ui.objectlist import ObjectList, Column
from kiwi.ui.views import SlaveView
from stoqlib.domain.payment.payment import Payment
from stoqlib.gui.editors.baseeditor import BaseEditor


class AffiliateBill(object):
    def __init__(self, item):
        self.status = item['status']
        self.id = item['id']
        self.total_cents = item['total_cents']
        self.total_paid_cents = item['total_paid_cents']
        self.total_paid = item['total_paid']
        self.email = item['email']
        self.secure_url = item['secure_url']
        self.total = item['total']
        self.description = ''
        for prod in item['items']:
            self.description += prod['description']
        self.logs = ''
        for log in item['logs']:
            self.logs += '{}--{}\n'.format(log['created_at'], log['description'])


class AffiliateBillsListSlave(SlaveView):
    def __init__(self, bills_items):
        self.info = ObjectList([Column('description', data_type=str, title='Descrição', sorted=True),
                                Column('status', data_type=str, title=u'Situação', format_func=self._get_status_name),
                                Column('total', data_type=str, title='Total'),
                                Column('total_paid', data_type=int, title='Total pago'),
                                Column('email', title='email', data_type=str),
                                Column('id', data_type=str, title='#')])
        for bill in bills_items:
            bill_obj = AffiliateBill(bill)
            self.info.append(bill_obj)
        SlaveView.__init__(self, self.info)

    def _get_status_name(self, arg):
        return Payment.iugu_statuses.get(arg, u'Não especificado')


class AffiliateBills(BaseEditor):
    """
    Recebe um resultado de uma consulta do iugu como parametro e uma conn
    """
    gladefile = 'AffiliateBills'
    model_type = Settable
    title = 'Busca de boletos do afiliado'
    size = (900, 700)
    proxy_widgets = ('name')

    def __init__(self, bills, conn):
        self.affiliate_items_slave = AffiliateBillsListSlave(bills)
        self.affiliate_items_slave.info.connect('selection-changed', self._affiliate_item_selection_changed)
        self.affiliate_items_slave.show()
        super(AffiliateBills, self).__init__(conn)
        self.attach_slave('place_holder', self.affiliate_items_slave)

    def create_model(self, trans):
        aff_bill = Settable(name=u'')
        return aff_bill

    def _affiliate_item_selection_changed(self, objectlist, affiliate):
        if affiliate.logs:
            self.logs.update(affiliate.logs)
        else:
            self.logs.update('...')

    def on_open_bill_button__clicked(self, button):
        selected = self.affiliate_items_slave.info.get_selected()
        if selected:
            webbrowser.open(selected.secure_url)
