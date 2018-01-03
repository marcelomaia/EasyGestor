# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005, 2009 Async Open Source <http://www.async.com.br>
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
##  Author(s): Stoq Team <stoq-devel@async.com.br>
##
##
""" Purchase receiving slaves implementation"""

from kiwi.datatypes import ValidationError, ValueUnset
from kiwi.utils import gsignal

from stoqlib.api import api
from stoqlib.domain.fiscal import CfopData
from stoqlib.domain.receiving import ReceivingOrder
from stoqlib.domain.person import PersonAdaptToTransporter
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.gui.editors.baseeditor import BaseEditorSlave
from stoqlib.gui.base.dialogs import run_dialog
from stoqlib.gui.editors.noteeditor import NoteEditor

_ = stoqlib_gettext


class ReceivingInvoiceSlave(BaseEditorSlave):

    model_type = ReceivingOrder
    gladefile = 'ReceivingInvoiceSlave'
    proxy_widgets = ('transporter',
                     'responsible_name',
                     'products_total',
                     'freight_combo',
                     'freight',
                     'ipi',
                     'cfop',
                     'branch',
                     'supplier_label',
                     'order_number',
                     'total',
                     'nfe_key',
                     'invoice_number',
                     'invoice_serie',
                     'icms_total',
                     'discount_value',
                     'secure_value',
                     'expense_value',
                     'freight_due_date')

    gsignal('activate')

    #
    # BaseEditorSlave hooks
    #

    def _setup_transporter_entry(self):
        # FIXME: Implement and use IDescribable on PersonAdaptToTransporter
        table = PersonAdaptToTransporter
        transporters = table.get_active_transporters(self.conn)
        items = [(t.person.name, t) for t in transporters]
        self.transporter.prefill(items)

    def _setup_freight_combo(self):
        freight_items = [(value, key) for (key, value) in
                         ReceivingOrder.freight_types.items()]

        # If the purchase's installments are paid, we cannot modify them.
        if (self.model.purchase.is_paid() and not self.visual_mode):
            ro = ReceivingOrder
            freight_items.remove((ro.freight_types[ro.FREIGHT_FOB_INSTALLMENTS],
                                  ro.FREIGHT_FOB_INSTALLMENTS))
            freight_items.remove((ro.freight_type[ro.FREIGHT_FOB_FIRST_INSTALLMENT],
                                  ro.FREIGHT_FOB_FIRST_INSTALLMENT))

        # Disconnect that callback to prevent an AttributeError
        # caused by the lack of a proxy.
        handler_func = self.after_freight_combo__content_changed
        self.freight_combo.handler_block_by_func(handler_func)

        self.freight_combo.prefill(freight_items)

        self.freight_combo.handler_unblock_by_func(handler_func)

    def _setup_widgets(self):
        self.total.set_bold(True)

        purchase = self.model.purchase
        if not purchase:
            for widget in (self.purchase_number_label,
                           self.purchase_supplier_label,
                           self.order_number, self.supplier_label):
                widget.hide()
        elif purchase and purchase.is_paid():
            for widget in (self.ipi, self.discount_value, self.icms_total,
                           self.secure_value, self.expense_value):
                widget.set_sensitive(False)

        self._setup_transporter_entry()
        self._setup_freight_combo()
        self.freight_due_date.set_sensitive(False)

        # CFOP entry setup
        cfop_items = [(item.get_description(), item)
                      for item in CfopData.select(connection=self.conn)]
        self.cfop.prefill(cfop_items)
        self.table.set_focus_chain([self.invoice_hbox,
                                    self.cfop,
                                    self.transporter,
                                    self.freight_combo,
                                    self.notes_box,
                                    self.freight,
                                    self.ipi,
                                    self.icms_total,
                                    self.discount_value,
                                    self.secure_value,
                                    self.expense_value])

    def create_freight_payment(self):
        """Tells if we should create a separate payment for freight or not

        It should return True or False. If True is returned, a separate payment
        will be created for freight. If not, it'll be included on installments.
        """
        freight_type = self.freight_combo.read()
        if freight_type == self.model.FREIGHT_FOB_PAYMENT:
            return True
        return False

    #
    # BaseEditorSlave hooks
    #

    def update_visual_mode(self):
        self.notes_button.hide()
        self.freight_combo.set_sensitive(False)

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model,
                                    ReceivingInvoiceSlave.proxy_widgets)

        self.model.invoice_total = self.model.get_products_total()

        purchase = self.model.purchase
        if purchase:
            if not self.visual_mode:
                # These values are duplicates from the purchase. If we are
                # visualising the order, the value should be it's own, not the
                # purchase ones.
                self.freight_combo.update(self.model.guess_freight_type())
                self.freight.update(purchase.expected_freight)

            self.model.supplier = purchase.supplier
            self.transporter.update(purchase.transporter)

        self.proxy.update('total')

    # def on_invoice_number__activate(self, widget):
    #     self.emit('activate')

    def on_freight__activate(self, widget):
        self.emit('activate')

    def on_ipi__activate(self, widget):
        self.emit('activate')

    def on_icms_total__activate(self, widget):
        self.emit('activate')

    def on_discount_value__activate(self, widget):
        self.emit('activate')

    def on_secure_value__activate(self, widget):
        self.emit('activate')

    def on_expense_value__activate(self, widget):
        self.emit('activate')

    def _positive_validator(self, widget, value):
        if value < 0:
            return ValidationError(_("This field cannot be negative"))

    on_freight__validate = _positive_validator
    on_ipi__validate = _positive_validator
    on_icms_total__validate = _positive_validator
    on_secure_value__validate = _positive_validator
    on_expense_value__validate = _positive_validator

    def on_notes_button__clicked(self, *args):
        run_dialog(NoteEditor, self, self.conn, self.model, 'notes',
                   title=_('Additional Information'))

    # def on_invoice_number__validate(self, widget, value):
    #     trans = api.new_transaction()
    #     # Using a transaction to do the verification bellow because,
    #     # if we use self.conn the changes on the invoice will be
    #     # saved at the same time in the database and it'll think
    #     # some valid invoices are invalid.
    #     order_count = ReceivingOrder.selectBy(invoice_number=value,
    #                                           supplier=self.model.supplier,
    #                                           connection=trans).count()
    #     trans.close()
    #     if order_count > 0:
    #         supplier_name = self.model.supplier.person.name
    #         return ValidationError(_(u'Invoice %d already exists for '
    #                                  'supplier %s.' % (value, supplier_name, )))

    def after_freight_combo__content_changed(self, widget):
        value = widget.read()

        if value == ReceivingOrder.FREIGHT_CIF_UNKNOWN:
            self.freight.update(0)
            self.freight.set_sensitive(False)
        else:
            if not self.visual_mode:
                self.freight.set_sensitive(True)
                if (not self.model.freight_total and
                    value in ReceivingOrder.FOB_FREIGHTS):
                    # Restore the freight value to the purchase expected one.
                    self.freight.update(self.model.purchase.expected_freight)

        if value == ReceivingOrder.FREIGHT_FOB_PAYMENT:
            self.freight_due_date.set_sensitive(True)
        else:
            self.freight_due_date.set_sensitive(False)

        self.proxy.update('total')

    def after_freight__content_changed(self, widget):
        try:
            value = widget.read()
        except ValidationError:
            value = ValueUnset

        if value is ValueUnset:
            self.model.freight_total = 0
        self.proxy.update('total')

    def after_ipi__content_changed(self, widget):
        try:
            value = widget.read()
        except ValidationError:
            value = ValueUnset

        if value is ValueUnset:
            self.model.ipi_total = 0
        self.proxy.update('total')

    def after_discount_value__content_changed(self, widget):
        try:
            value = widget.read()
        except ValidationError:
            value = ValueUnset

        if value is ValueUnset:
            self.model.discount_value = 0
        self.proxy.update('total')

    def after_discount_value__validate(self, widget, value):
        if value < 0:
            return ValidationError(_("Discount must be greater than zero"))
        if value > self.model.get_total():
            return ValidationError(_("Discount must be less "
                                     "than %s" % (self.model.get_total(), )))

    def after_secure_value__content_changed(self, widget):
        try:
            value = widget.read()
        except ValidationError:
            value = ValueUnset

        if value is ValueUnset:
            self.model.secure_value = 0
        self.proxy.update('total')

    def after_expense_value__content_changed(self, widget):
        try:
            value = widget.read()
        except ValidationError:
            value = ValueUnset

        if value is ValueUnset:
            self.model.expense_value = 0
        self.proxy.update('total')
