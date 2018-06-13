# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2012 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##
"""
stoq/gui/receivable/receivable.py:

    Implementation of receivable application.
"""

import gettext
import gtk

import datetime
import pango
from kiwi.currency import format_price
from kiwi.datatypes import currency
from kiwi.enums import SearchFilterPosition
from kiwi.python import all
from kiwi.ui.gadgets import render_pixbuf
from kiwi.ui.objectlist import SearchColumn, Column
from kiwi.ui.search import ComboSearchFilter, DateSearchFilter
from kiwi.ui.widgets.label import Label
from stoq.gui.application import SearchableAppWindow
from stoqlib.api import api
from stoqlib.database.runtime import get_connection
from stoqlib.domain.events import CancelBillEvent, GenerateDuplicateEvent, VerifyAffiliateBillsEvent
from stoqlib.domain.events import (CreatedInPaymentEvent, PrintBillEvent, GenerateBillEvent, CheckBillStatusEvent,
                                   CheckPaidBillEvent)
from stoqlib.domain.payment.bill import PaymentIuguBill
from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.domain.payment.operation import register_payment_operations
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.payment.views import InPaymentView
from stoqlib.domain.till import Till
from stoqlib.exceptions import TillError
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.dialogs.datepicker import PaymentRevenueDialog, PaymentAffiliateBillsDialog
from stoqlib.gui.dialogs.paymentchangedialog import (PaymentDueDateChangeDialog,
                                                     PaymentStatusChangeDialog)
from stoqlib.gui.dialogs.paymentcommentsdialog import PaymentCommentsDialog
from stoqlib.gui.dialogs.paymentflowhistorydialog import PaymentFlowHistoryDialog
from stoqlib.gui.editors.paymenteditor import InPaymentEditor
from stoqlib.gui.keybindings import get_accels
from stoqlib.gui.printing import print_report
from stoqlib.gui.search.paymentsearch import CardPaymentSearch
from stoqlib.gui.search.paymentsearch import InPaymentBillCheckSearch
from stoqlib.gui.slaves.installmentslave import SaleInstallmentConfirmationSlave
from stoqlib.gui.stockicons import STOQ_BARCODE
from stoqlib.gui.wizards.renegotiationwizard import ReceivableRenegotiationWizard
from stoqlib.lib.dateutils import localtoday
from stoqlib.lib.message import warning
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.reporting.payment import ReceivablePaymentReport
from stoqlib.reporting.payments_receipt import InPaymentReceipt

_ = gettext.gettext


class ReceivableApp(SearchableAppWindow):
    # TODO: Change all widget.set_sensitive to self.set_sensitive([widget])

    app_name = _('Accounts receivable')
    gladefile = 'receivable'
    search_table = InPaymentView
    search_label = _('matching:')
    report_table = ReceivablePaymentReport
    embedded = True

    #
    # Application
    #

    def create_actions(self):
        group = get_accels('app.receivable')
        actions = [
            # File
            ('AddReceiving', gtk.STOCK_ADD, _('Account receivable...'),
             group.get('add_receiving'),
             _('Create a new account receivable')),
            ('PaymentFlowHistory', None,
             _('Payment _flow history...'),
             group.get('payment_flow_history')),
            ('CheckPaidBills', STOQ_BARCODE,
             _('Verificar boletos pagos'),
             None,
             _('Verifica boletos que já foram pagos no banco e atualiza no easyloja')),

            # Payment
            ('PaymentMenu', None, _('Payment')),
            ('Details', gtk.STOCK_INFO, _('Details...'),
             group.get('payment_details'),
             _('Show details for the selected payment'),),
            ('Receive', gtk.STOCK_APPLY, _('Receive...'),
             group.get('payment_receive'),
             _('Receive the selected payments')),
            ('CancelPayment', gtk.STOCK_REMOVE, _('Cancel payment...'),
             group.get('payment_cancel'),
             _('Cancel the selected payment')),
            ('SetNotPaid', gtk.STOCK_UNDO, _('Set as not paid...'),
             group.get('payment_set_not_paid'),
             _('Mark the selected payment as not paid')),
            ('ChangeDueDate', gtk.STOCK_REFRESH, _('Change due date...'),
             group.get('payment_change_due_date'),
             _('Change the due date of the selected payment')),
            ('Renegotiate', None, _('Renegotiate...'),
             group.get('payment_renegotiate'),
             _('Renegotiate the selected payments')),
            ('Comments', None, _('Comments...'),
             group.get('payment_comments'),
             _('Add comments to the selected payment')),
            ('PrintBill', gtk.STOCK_PRINT, _('Print bill...'),
             group.get('payment_print_bill'),
             _('Print a bill for the selected payment')),
            ('CancelBill', gtk.STOCK_PRINT, _('Cancelar Boleto...'),
             None,
             _('Cancela o boleto de um dado pagamento')),
            ('GenerateBillDuplicate', gtk.STOCK_PRINT, _('Gerar segunda via de Boleto...'),
             None,
             _('Gera uma segunda via de boleto')),
            ('GenerateBill', gtk.STOCK_PRINT, _('Gerar boleto...'),
             group.get('payment_print_bill'),
             _('Gera um boleto avulso')),
            ('PrintReceipt', None, _('Print _receipt...'),
             group.get('payment_print_receipt'),
             _('Print a receipt for the selected payment')),

            ('CheckBillStatus', gtk.STOCK_INFO, _('Verificar boleto...'),
             group.get('payment_details'),
             _('Verifica se o boleto foi pago'),),

            # Search
            ('BillCheckSearch', None, _('Bills and checks...'),
             group.get('search_bills'),
             _('Search for bills and checks')),
            ('CardPaymentSearch', None, _('Card payments...'),
             group.get('search_card_payments'),
             _('Search for card payments')),
            ('BillAffiliateSearch', gtk.STOCK_PRINT, _('Buscar boletos de afiliados...'),
             None,
             _('Busca boletos de afiliados')),
        ]
        self.receivable_ui = self.add_ui_actions(None, actions,
                                                 filename='receivable.xml')
        self.set_help_section(_("Accounts receivable help"), 'app-receivable')

        self.Receive.set_short_label(_('Receive'))
        self.Details.set_short_label(_('Details'))
        self.Receive.props.is_important = True
        self.popup = self.uimanager.get_widget('/ReceivableSelection')

    def create_ui(self):
        self.app.launcher.add_new_items([self.AddReceiving])
        self.app.launcher.add_search_items([self.BillCheckSearch,
                                            self.CardPaymentSearch])
        self.app.launcher.Print.set_tooltip(
            _("Print a report of this payments"))
        self.results.set_selection_mode(gtk.SELECTION_MULTIPLE)
        parent = self.get_statusbar_message_area()

        self.search.set_summary_label(column='real_value',
                                      label='<b>Valor real:</b>',
                                      format='<b>%s</b>',
                                      parent=parent)
        # parent.pack_end(total_label, False, False)
        self.search.search.results.set_cell_data_func(
            self._on_results__cell_data_func)

    def activate(self, params):
        self._update_widgets()

        # FIXME: double negation is weird here
        if not params.get('no-refresh'):
            self.search.refresh()

    def deactivate(self):
        self.uimanager.remove_ui(self.receivable_ui)

    def new_activate(self):
        self._add_receiving()

    def search_activate(self):
        self._run_bill_check_search()

    #
    # SearchableAppWindow hooks
    #

    def create_filters(self):
        self.set_text_field_columns(['description', 'drawee'])
        self.status_filter = ComboSearchFilter(_('Show payments'),
                                               self._get_status_values())
        self.executer.add_filter_query_callback(
            self.status_filter, self._get_status_query)
        self.add_filter(self.status_filter,
                        SearchFilterPosition.TOP)

    def get_columns(self):
        return [SearchColumn('id', title=_('#'), long_title=_("Payment ID"),
                             width=60, data_type=int,
                             format='%04d'),
                Column('color', title=_('Description'), width=20,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                Column('cost_center_color', title=_('Centro de custo'), width=20,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                Column('comments_number', title=_(u'Comments'),
                       visible=False),
                SearchColumn('description', title=_('Description'),
                             data_type=str, ellipsize=pango.ELLIPSIZE_END,
                             column='color', expand=True),
                SearchColumn('drawee', title=_('Drawee'), data_type=str,
                             ellipsize=pango.ELLIPSIZE_END, width=140),
                SearchColumn('client_fancy_name', title=_('Fancy Name'), data_type=str,
                             ellipsize=pango.ELLIPSIZE_END, width=140),
                SearchColumn('client_cpf', title=_('cpf'),
                             data_type=str, width=140, visible=False),
                SearchColumn('client_cnpj', title=_('cnpj'),
                             data_type=str, width=140),
                SearchColumn('sale_open_date', title=_('Dt. abrt. venda'),
                             data_type=datetime.date, width=100),
                SearchColumn('sale_confirm_date', title=_('Dt. confirm. venda'),
                             data_type=datetime.date, width=100),
                SearchColumn('open_date', title=_('Open date'),
                             data_type=datetime.date, width=100),
                SearchColumn('due_date', title=_('Due date'),
                             data_type=datetime.date, width=100, sorted=True),
                SearchColumn('paid_date', title=_('Paid date'),
                             data_type=datetime.date, width=100),
                SearchColumn('status_str', title=_('Status'), width=100,
                             data_type=str, search_attribute='status',
                             valid_values=self._get_status_values(),
                             visible=False),
                SearchColumn('method_description', title=_('Payment Method'), width=100,
                             data_type=str, visible=False,
                             valid_values=self._get_payment_method_values()),
                SearchColumn('value', title=_('Value'), data_type=currency,
                             width=90),
                SearchColumn('branch_name', title='Na filial', data_type=str, width=90, searchable=True),
                SearchColumn('real_value', title=_('Valor real'), data_type=currency,
                             width=90, searchable=False),
                SearchColumn('fee', title=_('Taxa %'), data_type=float,
                             width=90, searchable=False),
                SearchColumn('paid_value', title=_('Paid'),
                             long_title=_('Paid value'),
                             data_type=currency, width=90),
                SearchColumn('category', title=_('Category'), data_type=str,
                             long_title=_('Payment category'), width=110,
                             visible=False),
                SearchColumn('notes', title=_(u'Observações'),
                             data_type=str, visible=False, width=140),
                SearchColumn('cost_center', title=_('Centro'), data_type=str,
                             long_title=_('Centro de custo'), width=110,
                             visible=False, column='cost_center_color')
                ]

    #
    # Public API
    #

    def search_for_date(self, date):
        self.status_filter.select(None)
        dfilter = DateSearchFilter(_("Paid or due date"))
        dfilter.set_removable()
        dfilter.mode.select_item_by_position(5)
        self.add_filter(dfilter, columns=["paid_date", "due_date"])
        dfilter.start_date.set_date(date)
        self.search.refresh()

    #
    # Private
    #

    def _update_widgets(self):
        selected = self.results.get_selected_rows()
        one_item = len(selected) == 1
        self.Receive.set_sensitive(self._can_receive(selected))
        self.Details.set_sensitive(
            one_item and self._can_show_details(selected))
        self.Comments.set_sensitive(
            one_item and self._can_show_comments(selected))
        self.ChangeDueDate.set_sensitive(
            one_item and self._can_change_due_date(selected))
        self.CancelPayment.set_sensitive(
            one_item and self._can_cancel_payment(selected))
        self.PrintReceipt.set_sensitive(
            one_item and self._is_paid(selected))
        self.SetNotPaid.set_sensitive(
            one_item and self._is_paid(selected))
        self.PrintBill.set_sensitive(self._can_print_bill(selected))
        self.CancelBill.set_sensitive(self._can_cancel_bill(selected))
        self.GenerateBillDuplicate.set_sensitive(self._can_cancel_bill(selected))
        self.GenerateBill.set_sensitive(self._can_generate_bill(selected))
        self.CheckBillStatus.set_sensitive(self._can_check_bill_status(selected))
        manager = get_plugin_manager()
        boleto_active = manager.is_active('boleto')
        self.CheckPaidBills.set_sensitive(boleto_active)

    def _on_search__search_completed(self, search, results, states):
        self.search_completed(results, states)

        has_results = len(results)
        for widget in (self.app.launcher.Print, self.app.launcher.ExportCSV):
            widget.set_sensitive(has_results)
        self._save_filter_settings()
        self._update_summary_label()

    def _update_summary_label(self):
        parent = self.get_statusbar_message_area()
        frame = parent.get_children()
        framebkp = []
        for i in range(1, len(frame) - 1):
            framebkp.append(frame[i])
        if len(frame) >= 4:
            for widget in framebkp:
                parent.remove(widget)

        total_column = self.results.get_column_by_name('value')
        paid_column = self.results.get_column_by_name('paid_value')

        total_attr = total_column.attribute
        paid_attr = paid_column.attribute

        get_total_attribute = total_column.get_attribute
        get_paid_attribute = paid_column.get_attribute

        total_value = self.get_column_value(get_total_attribute, total_attr, total_column)
        paid_value = self.get_column_value(get_paid_attribute, paid_attr, paid_column)

        total_str = "<b>" + "Valor: R$ " + format_price(str(currency(total_value))) + "</b>"
        total_label = Label(total_str)
        paid_str = "<b>" + "Valor pago: R$ " + format_price(str(currency(paid_value))) + "</b>"
        paid_label = Label(paid_str)

        parent.pack_end(total_label, False, False, 10)
        parent.pack_end(paid_label, False, False, 10)

        total_label.show()
        paid_label.show()

    def get_column_value(self, get_attribute, attr, column):
        value = sum([get_attribute(obj, attr, 0) or 0 for obj in self.results],
                    column.data_type('0'))
        return value

    def _get_status_values(self):
        values = [(v, k) for k, v in Payment.statuses.items()]
        values.insert(0, (_("Any"), None))
        return values

    def _get_payment_method_values(self):
        items = [(value, key) for key, value in PaymentMethod.get_method_values(get_connection()).items()]
        items.insert(0, (_('Any'), None))
        return items

    def _get_status_query(self, state):
        if state.value == Payment.STATUS_LATE:
            return (InPaymentView.q.status == Payment.STATUS_PENDING) & (InPaymentView.q.due_date <= localtoday())
        elif state.value is None:
            return InPaymentView.q.status >= 0
        return InPaymentView.q.status == state.value

    def _show_details(self, receivable_view):
        trans = api.new_transaction()
        payment = trans.get(receivable_view.payment)
        retval = run_dialog(InPaymentEditor, self, trans, payment)
        if retval:
            CreatedInPaymentEvent.emit(retval)
        if api.finish_transaction(trans, retval):
            self.search.refresh()
        trans.close()
        return retval

    def _show_comments(self, receivable_view):
        trans = api.new_transaction()
        retval = run_dialog(PaymentCommentsDialog, self, trans,
                            receivable_view.payment)
        api.finish_transaction(trans, retval)

    def _receive(self, receivable_views):
        """
        Receives a list of items from a receivable_views, note that
        the list of receivable_views must reference the same sale
        @param receivable_views: a list of receivable_views
        """
        assert self._can_receive(receivable_views)

        trans = api.new_transaction()

        payments = [trans.get(view.payment) for view in receivable_views]

        retval = run_dialog(SaleInstallmentConfirmationSlave, self, trans,
                            payments=payments)

        if api.finish_transaction(trans, retval):
            # We need to refresh the whole list as the payment(s) can possibly
            # disappear for the selected view
            self.refresh()
        trans.close()
        self._update_widgets()

    def _add_receiving(self):
        trans = api.new_transaction()
        retval = self.run_dialog(InPaymentEditor, trans)
        if retval:
            CreatedInPaymentEvent.emit(retval)
        if api.finish_transaction(trans, retval):
            self.search.refresh()

    def _change_due_date(self, receivable_view):
        """ Receives a receivable_view and change the payment due date
        related to the view.
        @param receivable_view: a InPaymentView instance
        """
        assert receivable_view.can_change_due_date()
        trans = api.new_transaction()
        payment = trans.get(receivable_view.payment)
        sale = trans.get(receivable_view.sale)
        retval = run_dialog(PaymentDueDateChangeDialog, self,
                            trans, payment, sale)

        if api.finish_transaction(trans, retval):
            receivable_view.sync()
            self.results.update(receivable_view)

        trans.close()

    def _change_status(self, receivable_view, status):
        """Show a dialog do enter a reason for status change
        @param receivable_view: a InPaymentView instance
        """
        trans = api.new_transaction()
        payment = trans.get(receivable_view.payment)
        order = trans.get(receivable_view.sale)
        retval = run_dialog(PaymentStatusChangeDialog, self, trans,
                            payment, status, order)

        if api.finish_transaction(trans, retval):
            receivable_view.sync()
            self.results.update(receivable_view)
            self.results.unselect_all()

        trans.close()

    def _is_paid(self, receivable_view):
        """
        Determines if the selected payment is paid.
        To do so he must meet the following condition:
          - The payment status needs to be set to PAID
        """
        if not receivable_view:
            return False
        # retorno True permite que todas as contas e receber possam emitir boleto
        #        independente de seu status
        return True

    #        return receivable_view[0].is_paid()

    def _can_receive(self, receivable_views):
        """
        Determines if a list of receivable_views can be received.
        To do so they must meet the following conditions:
          - Be in the same sale
          - The payment status needs to be set to PENDING
        """

        if not receivable_views:
            return False

        # Until we fix bug 3703, don't allow receiving store credit payments
        # if any(view.method_name == 'store_credit'
        #        for view in receivable_views):
        #     return False

        if len(receivable_views) == 1:
            return receivable_views[0].status == Payment.STATUS_PENDING

        sale = receivable_views[0].sale
        if sale is None:
            return False
        return all(view.sale == sale and
                   view.status == Payment.STATUS_PENDING
                   for view in receivable_views)

    def _can_renegotiate(self, receivable_views):
        """whether or not we can renegotiate this payments

        This do to much queries. Dont call inside _update_widgets to avoid
        unecessary queries. Instead, call before the user actually tries to
        renegotiate.
        """
        if not len(receivable_views):
            return False

        # Parent is a Sale or a PaymentRenegotiation
        parent = receivable_views[0].get_parent()

        if not parent:
            return False

        client = parent.client

        if not client:
            return False

        return all(view.get_parent() and
                   view.get_parent().client is client and
                   view.get_parent().can_set_renegotiated()
                   for view in receivable_views)

    def _can_cancel_payment(self, receivable_views):
        """whether or not we can cancel the receiving.
        """
        if len(receivable_views) != 1:
            return False

        return receivable_views[0].can_cancel_payment()

    def _can_change_due_date(self, receivable_views):
        """
        Determines if a list of receivable_views can have it's due date
        changed. To do so they must meet the following conditions:
          - The list  must have only one element
          - The payment was not paid
        """
        if len(receivable_views) != 1:
            return False

        return receivable_views[0].can_change_due_date()

    def _can_show_details(self, receivable_views):
        """Determines if we can show the receiving details for a list of
        receivable views.
        To do so they must meet the following conditions:
          - Be in the same sale or
          - One receiving that not belong to any sale
        """
        if not receivable_views:
            return False

        sale = receivable_views[0].sale_id
        if sale is None:
            if len(receivable_views) == 1:
                return True
            else:
                return False

        return all(view.sale_id == sale for view in receivable_views[1:])

    def _can_show_comments(self, receivable_views):
        return len(receivable_views) == 1

    def _can_print_bill(self, receivable_views):
        "pode imprimir quando o boleto esta pendente"
        return (len(receivable_views) == 1 and
                receivable_views[0].method_name == 'bill' and
                PaymentIuguBill.selectOneBy(payment=receivable_views[0].id,
                                            status=PaymentIuguBill.STATUS_PENDING,
                                            connection=self.conn) is not None)

    def _can_cancel_bill(self, receivable_views):
        "Só pode cancelar se tiver um pagamento pendente"
        if receivable_views:
            bill = PaymentIuguBill.selectOneBy(payment=receivable_views[0].id,
                                               status=PaymentIuguBill.STATUS_PENDING,
                                               connection=self.conn)
            return (len(receivable_views) == 1 and
                    receivable_views[0].method_name == 'bill' and bill is not None)
        return False

    def _can_generate_bill(self, receivable_views):
        "Pode gerar se nao tiver nada ou se tiver um cancelado"
        if receivable_views:
            bill = PaymentIuguBill.selectOneBy(payment=receivable_views[0].id,
                                               connection=self.conn)
            is_cancelled = False
            if bill:
                is_cancelled = bill.status == PaymentIuguBill.STATUS_CANCELED
            return (len(receivable_views) == 1 and
                    receivable_views[0].method_name == 'bill' and (not bill or is_cancelled))
        return False

    def _can_check_bill_status(self, receivable_views):
        return (len(receivable_views) == 1 and
                receivable_views[0].method_name == 'bill' and
                PaymentIuguBill.selectOneBy(payment=receivable_views[0].id,
                                            connection=self.conn) is not None)

    def _run_card_payment_search(self):
        run_dialog(CardPaymentSearch, self, self.conn)

    def _run_bill_check_search(self):
        run_dialog(InPaymentBillCheckSearch, self, self.conn)

    #
    # Kiwi callbacks
    #

    def _on_results__cell_data_func(self, column, renderer, pv, text):
        if not isinstance(renderer, gtk.CellRendererText):
            return text

        if pv.paid_date and self.status_filter.get_state().value is None:
            renderer.set_property('strikethrough', True)
            renderer.set_property('strikethrough-set', True)
        else:
            renderer.set_property('strikethrough-set', False)
        if not pv.paid_date and pv.due_date < datetime.datetime.now():
            renderer.set_property('weight', pango.WEIGHT_BOLD)
            renderer.set_property('weight-set', True)
        else:
            renderer.set_property('weight-set', False)
        return text

    def on_results__row_activated(self, klist, receivable_view):
        self._show_details(receivable_view)

    def on_results__selection_changed(self, receivables, selected):
        self._update_widgets()

    def on_results__right_click(self, results, result, event):
        self.popup.popup(None, None, None, event.button, event.time)

    def on_Details__activate(self, button):
        selected = self.results.get_selected_rows()[0]
        self._show_details(selected)

    def on_Receive__activate(self, button):
        self._receive(self.results.get_selected_rows())

    def on_Comments__activate(self, action):
        receivable_view = self.results.get_selected_rows()[0]
        self._show_comments(receivable_view)

    def on_PrintReceipt__activate(self, action):
        register_payment_operations()
        receivable_view = self.results.get_selected_rows()[0]
        payment = receivable_view.payment
        date = datetime.date.today()
        print_report(InPaymentReceipt, payment=payment,
                     order=receivable_view.sale, date=date)

    def on_PaymentFlowHistory__activate(self, action):
        self.run_dialog(PaymentFlowHistoryDialog, self.conn)

    def on_AddReceiving__activate(self, action):
        self._add_receiving()

    def on_CancelPayment__activate(self, action):
        receivable_view = self.results.get_selected_rows()[0]
        self._change_status(receivable_view, Payment.STATUS_CANCELLED)

    def on_SetNotPaid__activate(self, action):
        receivable_view = self.results.get_selected_rows()[0]
        self._change_status(receivable_view, Payment.STATUS_PENDING)

    def on_ChangeDueDate__activate(self, action):
        receivable_view = self.results.get_selected_rows()[0]
        self._change_due_date(receivable_view)

    def on_BillCheckSearch__activate(self, action):
        self._run_bill_check_search()

    def on_BillAffiliateSearch__activate(self, action):
        retval = run_dialog(PaymentAffiliateBillsDialog, None, self.conn)
        if retval:
            VerifyAffiliateBillsEvent.emit(retval)

    def on_CheckPaidBills__activate(self, action):
        # BUG de não abrir as telas de pagamento, search refresh resolve ele
        dates = run_dialog(PaymentRevenueDialog, get_current_toplevel(), self.conn)
        if dates:
            CheckPaidBillEvent.emit(dates.start_date, dates.end_date)
        self.search.refresh()

    def on_CardPaymentSearch__activate(self, action):
        self._run_card_payment_search()

    def on_Renegotiate__activate(self, action):
        try:
            Till.get_current(self.conn)
        except TillError, e:
            warning(str(e))
            return
        receivable_views = self.results.get_selected_rows()
        if not self._can_renegotiate(receivable_views):
            warning(_('Cannot renegotiate selected payments'))
            return
        trans = api.new_transaction()
        groups = list(set([trans.get(v.group) for v in receivable_views]))
        retval = run_dialog(ReceivableRenegotiationWizard, self, trans,
                            groups)
        if api.finish_transaction(trans, retval):
            self.search.refresh()

    def on_PrintBill__activate(self, action):
        items = self.results.get_selected_rows()
        payments = [item.payment for item in items]
        for payment in payments:
            PrintBillEvent.emit(payment)

    def on_CancelBill__activate(self, action):
        items = self.results.get_selected_rows()
        payments = [item.payment for item in items]
        for payment in payments:
            CancelBillEvent.emit(payment)

    def on_GenerateBillDuplicate__activate(self, action):
        items = self.results.get_selected_rows()
        payments = [item.payment for item in items]
        for payment in payments:
            GenerateDuplicateEvent.emit(payment)

    def on_GenerateBill__activate(self, action):
        items = self.results.get_selected_rows()
        payments = [item.payment for item in items]
        for payment in payments:
            GenerateBillEvent.emit(payment)

    def on_CheckBillStatus__activate(self, action):
        items = self.results.get_selected_rows()
        trans = api.new_transaction()
        payments = [trans.get(item.payment) for item in items]
        for payment in payments:
            paid_value = CheckBillStatusEvent.emit(payment)
            if paid_value:
                payment.penalty = float(paid_value) - float(payment.value)
                trans.commit()
                self._receive(self.results.get_selected_rows())
        trans.close()
        self.search.refresh()
