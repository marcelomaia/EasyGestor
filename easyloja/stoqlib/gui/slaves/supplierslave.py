# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005, 2006 Async Open Source <http://www.async.com.br>
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
""" Supplier editor slaves implementation"""
import gtk
from kiwi.ui.delegates import GladeSlaveDelegate
from kiwi.ui.gadgets import render_pixbuf
from kiwi.ui.objectlist import Column
from stoqlib.domain.payment.category import PaymentCategory
from stoqlib.domain.person import PersonCategoryPaymentInfo

from stoqlib.gui.editors.baseeditor import BaseEditorSlave, BaseRelationshipEditorSlave
from stoqlib.gui.editors.personpaymentinfo import PersonPaymentEditor
from stoqlib.domain.interfaces import ISupplier
from stoqlib.lib.message import info
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext

class SupplierDetailsSlave(BaseEditorSlave):
    model_iface = ISupplier
    gladefile = 'SupplierDetailsSlave'
    proxy_widgets = ('statuses_combo', 'product_desc')

    def setup_proxies(self):
        items = [(value, constant)
                    for constant, value in self.model_type.statuses.items()]
        self.statuses_combo.prefill(items)
        self.proxy = self.add_proxy(self.model,
                                    SupplierDetailsSlave.proxy_widgets)

class SupplierCategorySlave(BaseRelationshipEditorSlave):
    model_type = PersonCategoryPaymentInfo
    target_name = _('Payment Category')
    editor = PersonPaymentEditor

    def __init__(self, conn, supplier):
        self.conn = conn
        self.supplier = supplier
        GladeSlaveDelegate.__init__(self, gladefile=self.gladefile)
        self._setup_widgets()

    def get_targets(self):
        categories = PaymentCategory.select(connection=self.conn).orderBy('name')
        return [(c.name, c) for c in categories]

    def get_relations(self):
        return self.supplier.get_payments_category_info()

    def create_model(self):
        supplier = self.supplier
        payment_category = self.target_combo.get_selected_data()

        if supplier.has_payment_category(payment_category):
            payment_desc = payment_category.get_description()
            info(_(u'%s is already supplied by %s' % (supplier.person.name,
                                                      payment_desc,)))
            return

        model = PersonCategoryPaymentInfo(person=supplier.person,
                                          payment_category=payment_category,
                                          connection=self.conn)
        return model

    def get_columns(self):
        return [Column('payment_category.name', title=_(u'Supplier'),
                       data_type=str, expand=True, sorted=True),
                Column('payment_category.color', title=_('Description'), width=120,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                ]
