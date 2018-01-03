# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2009 Async Open Source <http://www.async.com.br>
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
##
""" Classes for sale details """

import datetime
import gtk

import pango
from kiwi.datatypes import currency
from kiwi.log import Logger
from kiwi.ui.widgets.contextmenu import ContextMenu, ContextMenuItem
from kiwi.ui.widgets.list import Column, ColoredColumn
from stoqlib.api import api
from stoqlib.domain.events import (SalesNfeDetails, HasNFeHistoryEvent, PrintBillEvent, CheckPendingBillEvent,
                                   CheckCreatedBillEvent, GenerateBatchBillEvent, SaleSLastEmitEvent)
from stoqlib.domain.interfaces import IClient
from stoqlib.domain.payment.views import PaymentChangeHistoryView
from stoqlib.domain.person import Person
from stoqlib.domain.renegotiation import RenegotiationData
from stoqlib.domain.sale import (SaleView, Sale, SaleReturnedItemsView,
                                 SaleReturnedItem, SaleReturned)
from stoqlib.domain.stockincrease import StockIncreaseItem, new_stock_increase
from stoqlib.domain.transfer import TransferOrderItem
from stoqlib.exceptions import StoqlibError
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.gtkadds import change_button_appearance
from stoqlib.gui.dialogs.clientdetails import ClientDetailsDialog
from stoqlib.gui.dialogs.renegotiationdetails import RenegotiationDetailsDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.gui.printing import print_report
from stoqlib.lib.defaults import payment_value_colorize
from stoqlib.lib.message import info
from stoqlib.lib.message import yesno
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.reporting.sale import SaleOrderReport
from stoqlib.reporting.transfer_receipt import TransferOrderReceipt

_ = stoqlib_gettext
log = Logger('stoq.salesdetails')


class _TemporaryOutPayment(object):
    class method:
        description = None

    def __init__(self, payment):
        self.id = payment.id
        self.description = payment.description
        self.method.description = payment.method.description
        self.method.method_name = payment.method.method_name
        self.due_date = payment.due_date
        self.paid_date = payment.paid_date
        self.status_str = payment.get_status_str()
        self.base_value = -payment.base_value
        self.paid_value = -(payment.paid_value or 0)


class SaleDetailsDialog(BaseEditor):
    gladefile = "SaleDetailsDialog"
    model_type = SaleView
    title = _(u"Sale Details")
    size = (750, 460)
    hide_footer = True
    proxy_widgets = ('status_lbl',
                     'client_lbl',
                     'salesperson_lbl',
                     'open_date_lbl',
                     'total_lbl',
                     'order_number',
                     'subtotal_lbl',
                     'surcharge_lbl',
                     'discount_lbl',
                     'invoice_number')
    payment_widgets = ('total_discount',
                       'total_interest',
                       'total_penalty',
                       'total_paid',
                       'total_value',)

    def __init__(self, conn, model=None, visual_mode=False, can_return=True):
        """ Creates a new SaleDetailsDialog object

        @param conn: a database connection
        @param model: a L{stoqlib.domain.sale.Sale} object
        """
        self.can_return = can_return
        BaseEditor.__init__(self, conn, model,
                            visual_mode=visual_mode)

    def _setup_columns(self):
        self.items_list.set_columns(self._get_items_columns())
        self.payments_list.set_columns(self._get_payments_columns())
        self.payments_info_list.set_columns(self._get_payments_info_columns())
        self.returned_items_list.set_columns(self._get_returned_items_columns())

    def _get_payments(self, sale):
        for payment in sale.payments:
            if payment.is_outpayment():
                yield _TemporaryOutPayment(payment)
            else:
                yield payment

    def _get_bill_payments(self, sale):
        for payment in sale.payments:
            if payment.method.method_name == 'bill' and payment.is_inpayment():
                yield payment

    def _setup_widgets(self):
        if not self.model.client_id:
            self.details_button.set_sensitive(False)
        self._setup_columns()

        self.sale_order = Sale.get(self.model.id, connection=self.conn)

        if (self.sale_order.status == Sale.STATUS_RETURNED or
                    self.sale_order.status == Sale.STATUS_RENEGOTIATED):
            self.status_details_button.show()
        else:
            self.status_details_button.hide()

        sale_items = self.sale_order.get_items()
        self.items_list.add_list(sale_items)

        buffer = gtk.TextBuffer()
        buffer.set_text(self.sale_order.get_details_str())
        self.notes.set_buffer(buffer)

        self.payments_list.add_list(self._get_payments(self.sale_order))
        changes = PaymentChangeHistoryView.select_by_group(
            self.sale_order.group,
            connection=self.conn)
        self.payments_info_list.add_list(changes)

        self._setup_print_bills()
        self._setup_generate_bills()

        manager = get_plugin_manager()
        if not manager.is_active('nfe2'):
            self.nfe_details_button.hide()

        has_nfe_history = HasNFeHistoryEvent.emit(self.model.sale)
        if not has_nfe_history:
            self.nfe_details_button.hide()
        if not self.model.sale.can_confirm():
            self.confirm_sale_button.hide()
        if self.model.status not in (Sale.STATUS_QUOTE, Sale.STATUS_ORDERED):
            self.confirm_sale_button.hide()

        items = SaleReturnedItemsView.select(
            SaleReturnedItemsView.q.sale_id == self.model.id,
            connection=self.conn)

        self.returned_items_list.add_list(list(items))

        if self.can_return:
            self._create_itens_context_menu()
        change_button_appearance(self.print_button, gtk.STOCK_PRINT, 'Imprimir')
        self._setup_set_print_button_nf()

        if self.model.daily_code:
            self.title = _(u"Venda de N°%s do dia %s" % (self.model.daily_code,
                                                         self.model.open_date.strftime('%d/%m/%Y')))

    def _setup_set_print_button_nf(self):
        manager = get_plugin_manager()
        is_active = manager.is_active('impnf')
        if not is_active:
            self.print_button_nf.hide()

    def _setup_generate_bills(self):
        sale = Sale.get(self.model.id, connection=self.conn)
        payments = sale.payments
        self.generate_bills_button.hide()
        if CheckPendingBillEvent.emit(payments):
            self.generate_bills_button.show()

    def _setup_print_bills(self):
        sale = Sale.get(self.model.id, connection=self.conn)
        payments = sale.payments
        self.print_bills.hide()
        if CheckCreatedBillEvent.emit(payments):
            self.print_bills.show()

    def _create_itens_context_menu(self):
        menu = ContextMenu()

        item = ContextMenuItem(_('Retornar'))
        item.connect('activate', self._on_context_items__activate)
        menu.append(item)

        self.items_list.set_context_menu(menu)
        menu.show_all()

    def _confirm_sale(self, sale):
        from stoqlib.gui.fiscalprinter import FiscalPrinterHelper
        if not yesno(_('Voce realmente quer confirmar a venda?'),
                     gtk.RESPONSE_YES, _("Yes"), _("No")):
            return
        trans = api.new_transaction()
        sale = Sale.selectOneBy(id=sale.id, connection=trans)
        self._printer = FiscalPrinterHelper(self.conn,
                                            parent=self)
        self._coupon = self._printer.create_coupon()
        assert self._coupon
        ordered = self._coupon.confirm(sale, trans)
        log.info("Checking out")
        trans.commit(True)
        self._coupon = None
        info(u'Venda #{}, situação: {}'.format(sale.id, Sale.get_status_name(sale.status)))
        self.confirm_sale_button.hide()

    def _receipt_dialog(self, order, conn):
        msg = _('Would you like to print a receipt for this transfer?')
        if yesno(msg, gtk.RESPONSE_YES, _("Print receipt"), _("Don't print")):
            items = TransferOrderItem.selectBy(transfer_order=order,
                                               connection=conn)
            print_report(TransferOrderReceipt, order, items)
        return

    def _on_context_items__activate(self, *args, **kwargs):
        sale_item = self.items_list.get_selected()
        if SaleReturnedItem.can_returned(sale_item, self.conn):
            sale_item.notes = _('Devolvido - Crédito gerado ao cliente')
            trans = api.new_transaction()
            item_increase = StockIncreaseItem(sellable=sale_item.sellable,
                                              quantity=sale_item.quantity,
                                              connection=trans)
            increase = new_stock_increase(trans)
            increase.add_item(item_increase)
            increase.confirm()
            # Create a Return notification for this item
            rSaleItem = SaleReturnedItem(quantity=sale_item.quantity,
                                         price=sale_item.price,
                                         sale_item=sale_item,
                                         base_price=sale_item.base_price,
                                         sale=sale_item.sale,
                                         sellable=sale_item.sellable,
                                         connection=trans)
            rSaleItem.make_return()
            trans.commit()
            trans.close()
            info(_("Uma entrada manual foi efetuada para este produto"))
        else:
            info(_("Não foi Possivel Concluir Operação"))

    def _get_payments_columns(self):
        return [Column('id', "#", data_type=int, width=50,
                       format='%04d', justify=gtk.JUSTIFY_RIGHT),
                Column('method.description', _("Type"),
                       data_type=str, width=60),
                Column('description', _("Description"), data_type=str,
                       width=150, expand=True),
                Column('due_date', _("Due date"), sorted=True,
                       data_type=datetime.date, width=90,
                       justify=gtk.JUSTIFY_RIGHT),
                Column('paid_date', _("Paid date"),
                       data_type=datetime.date, width=90),
                Column('status_str', _("Status"), data_type=str, width=80),
                ColoredColumn('value', _("Value"), data_type=currency,
                              width=90, color='red',
                              justify=gtk.JUSTIFY_RIGHT,
                              data_func=payment_value_colorize),
                ColoredColumn('paid_value', _("Paid value"), data_type=currency,
                              width=92, color='red',
                              justify=gtk.JUSTIFY_RIGHT,
                              data_func=payment_value_colorize)]

    def _get_items_columns(self):
        return [Column('sellable.code', _("Code"), sorted=True,
                       data_type=str, width=130),
                Column('sellable.description',
                       _("Description"), data_type=str, expand=True,
                       width=200),
                Column('quantity_unit_string', _("Quantity"), data_type=str,
                       width=100, justify=gtk.JUSTIFY_RIGHT),
                Column('price', _("Price"), data_type=currency, width=100),
                Column('total', _("Total"), data_type=currency, width=100)]

    def _get_payments_info_columns(self):
        return [Column('change_date', _(u"When"),
                       data_type=datetime.date, sorted=True, ),
                Column('description', _(u"Payment"),
                       data_type=str, expand=True,
                       ellipsize=pango.ELLIPSIZE_END),
                Column('changed_field', _(u"Changed"),
                       data_type=str, justify=gtk.JUSTIFY_RIGHT),
                Column('from_value', _(u"From"),
                       data_type=str, justify=gtk.JUSTIFY_RIGHT),
                Column('to_value', _(u"To"),
                       data_type=str, justify=gtk.JUSTIFY_RIGHT),
                Column('reason', _(u"Reason"),
                       data_type=str, expand=True,
                       ellipsize=pango.ELLIPSIZE_END)]

    def _get_returned_items_columns(self):
        return [Column('id', _("Code"), sorted=True,
                       data_type=str, width=130),
                Column('description', _(u"Descricao"),
                       data_type=str, expand=True,
                       ellipsize=pango.ELLIPSIZE_END),
                Column('quantity', _("Quantity"),
                       data_type=str, expand=True,
                       ellipsize=pango.ELLIPSIZE_END),
                Column('price', _("Price"),
                       data_type=currency,
                       width=100),
                Column('total', _("Total"),
                       data_type=currency,
                       width=100)
                ]

    #
    # BaseEditor hooks
    #

    def setup_proxies(self):
        self._setup_widgets()
        self.add_proxy(self.model, SaleDetailsDialog.proxy_widgets)
        self.add_proxy(self.model.sale.group,
                       SaleDetailsDialog.payment_widgets)
        self.add_proxy(SaleReturned(self.model.id, self.conn),
                       ('total_returned',))

    #
    # Kiwi handlers
    #

    def on_print_button__clicked(self, button):
        print_report(SaleOrderReport,
                     Sale.get(self.model.id, connection=self.conn))

    def on_print_button_nf__clicked(self, button):
        sale = Sale.get(self.model.id, connection=self.conn)
        SaleSLastEmitEvent.emit(sale)

    def on_print_bills__clicked(self, button):
        sale = Sale.get(self.model.id, connection=self.conn)
        payments = sale.payments
        for payment in payments:
            PrintBillEvent.emit(payment)

    def on_nfe_details_button__clicked(self, button):
        SalesNfeDetails.emit(self.model.sale)

    def on_confirm_sale_button__clicked(self, button):
        self._confirm_sale(self.model.sale)

    def on_details_button__clicked(self, button):
        if not self.model.client_id:
            raise StoqlibError("You should never call ClientDetailsDialog "
                               "for sales which clients were not specified")
        client = Person.iget(IClient, self.model.client_id,
                             connection=self.conn)
        run_dialog(ClientDetailsDialog, get_current_toplevel(), self.conn, client)

    def on_status_details_button__clicked(self, button):
        if self.sale_order.status == Sale.STATUS_RETURNED:
            run_dialog(SaleReturnDetailsDialog, get_current_toplevel(), self.conn,
                       self.sale_order)
        elif self.sale_order.status == Sale.STATUS_RENEGOTIATED:
            # XXX: Rename to renegotiated
            run_dialog(RenegotiationDetailsDialog, get_current_toplevel(), self.conn,
                       self.sale_order.group.renegotiation)

    def on_generate_bills_button__clicked(self, button):
        info('Aguarde um momento para a geração do(s) boleto(s)!')
        sale = Sale.get(self.model.id, connection=self.conn)
        GenerateBatchBillEvent.emit(sale)
        self._setup_generate_bills()
        self._setup_print_bills()


class SaleReturnDetailsDialog(BaseEditor):
    gladefile = "HolderTemplate"
    model_type = Sale
    title = _(u"Sale Cancellation Details")
    size = (650, 350)
    hide_footer = True

    def setup_slaves(self):
        from stoqlib.gui.slaves.saleslave import SaleReturnSlave
        if self.model.status != Sale.STATUS_RETURNED:
            raise StoqlibError("Invalid status for sale order, it should be "
                               "cancelled")

        renegotiation = RenegotiationData.selectOneBy(sale=self.model,
                                                      connection=self.conn)
        if renegotiation is None:
            raise StoqlibError("Returned sales must have the renegotiation "
                               "information.")

        self.slave = SaleReturnSlave(self.conn, self.model, renegotiation,
                                     visual_mode=True)
        self.attach_slave("place_holder", self.slave)
