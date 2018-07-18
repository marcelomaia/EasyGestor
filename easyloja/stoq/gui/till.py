# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2011 Async Open Source <http://www.async.com.br>
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
""" Implementation of till application.  """

import decimal
import gettext
import gtk
import tempfile

import pango
from datetime import date
from kiwi.currency import format_price
from kiwi.datatypes import currency, converter
from kiwi.enums import SearchFilterPosition
from kiwi.log import Logger
from kiwi.python import Settable
from kiwi.ui.objectlist import Column, SearchColumn
from kiwi.ui.search import ComboSearchFilter
from stoq.gui.application import SearchableAppWindow
from stoqlib.api import api
from stoqlib.database.orm import AND, OR, const
from stoqlib.domain.events import SalesNFeCreate, SalesNFCEEvent
from stoqlib.domain.interfaces import IStorable
from stoqlib.domain.payment.views import FaturamentoSearch, DailyFaturamentoSearch
from stoqlib.domain.product import ProductStockItem, ProductAdaptToStorable, Product
from stoqlib.domain.sale import Sale, SaleView
from stoqlib.domain.till import Till
from stoqlib.exceptions import (StoqlibError, TillError, SellError,
                                ModelDataError)
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.dialogs.datepicker import PaymentRevenueDialog, DaySelectDialogDialog
from stoqlib.gui.dialogs.quotedialog import ConfirmSaleMissingDialog
from stoqlib.gui.dialogs.saledetails import SaleDetailsDialog
from stoqlib.gui.dialogs.tillhistory import TillHistoryDialog
from stoqlib.gui.editors.nfeeditor import NfeBranchDialog
from stoqlib.gui.editors.tilleditor import CashInEditor, CashOutEditor
from stoqlib.gui.fiscalprinter import FiscalPrinterHelper
from stoqlib.gui.keybindings import get_accels
from stoqlib.gui.search.personsearch import ClientSearch
from stoqlib.gui.search.salesearch import SaleSearch, SoldItemsByBranchSearch
from stoqlib.gui.search.tillsearch import TillFiscalOperationsSearch
from stoqlib.gui.slaves.saleslave import return_sale
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.message import yesno, warning
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.reporting.base.utils import print_file
from stoqlib.reporting.financialreport import FinancialReport
from stoqlib.reporting.sale import SalesReport

_ = gettext.gettext
log = Logger('stoq.till')

LOGO_WIDTH = 91
LOGO_HEIGHT = 32


class TillApp(SearchableAppWindow):
    app_name = _(u'Till')
    gladefile = 'till'
    search_table = SaleView
    search_labels = _(u'matching:')
    report_table = SalesReport
    embedded = True

    #
    # Application
    #

    def create_actions(self):
        group = get_accels('app.till')
        actions = [
            ('SaleMenu', None, _('Sale')),
            ('TillOpen', None, _('Open till...'),
             group.get('open_till')),
            ('TillClose', None, _('Close till...'),
             group.get('close_till')),
            ('TillVerify', None, _("Verificar caixa..."),
             None),
            ('TillRevenue', None, _("Faturamento de caixa..."),
             None),
            ('DailyFlow', None, _(u"Fluxo di�rio..."),
             None),
            ('TillAddCash', None, _('Cash addition...'), ''),
            ('TillRemoveCash', None, _('Cash removal...'), ''),
            ("SearchClient", None, _("Clients..."),
             group.get('search_clients'),
             _("Search for clients")),
            ("SearchSale", None, _("Sales..."),
             group.get('search_sale'),
             _("Search for sales")),
            ("SearchSoldItemsByBranch", None, _("Sold items by branch..."),
             group.get('search_sold_items_by_branch'),
             _("Search for items sold by branch")),
            ("SearchTillHistory", None, _("Till history..."),
             group.get('search_till_history'),
             _("Search for till history")),
            ("SearchFiscalTillOperations", None, _("Fiscal till operations..."),
             group.get('search_fiscal_till_operations'),
             _("Search for fiscal till operations")),
            ("Confirm", gtk.STOCK_APPLY, _("Confirm..."),
             group.get('confirm_sale'),
             _("Confirm the selected sale, decreasing stock and making it "
               "possible to receive it's payments")),
            ("Return", gtk.STOCK_CANCEL, _("Return..."),
             group.get('return_sale'),
             _("Return the selected sale, returning stock and the client's "
               "payments")),
            ("Details", gtk.STOCK_INFO, _("Details..."),
             group.get('sale_details'),
             _("Show details of the selected sale")),
            ("SalesGenerateNFe", None, "Gerar NFe"),
            ("SalesGenerateNFCe", None, "Gerar NFCe"),

        ]

        self.till_ui = self.add_ui_actions('', actions,
                                           filename="till.xml")
        self.set_help_section(_("Till help"), 'app-till')

        self.Confirm.set_short_label(_('Confirm'))
        self.Return.set_short_label(_('Return'))
        self.Details.set_short_label(_('Details'))
        self.Confirm.props.is_important = True
        self.Return.props.is_important = True
        self.Details.props.is_important = True

    def create_ui(self):
        self.popup = self.uimanager.get_widget('/SaleSelection')

        self.current_branch = api.get_current_branch(self.conn)
        # Groups
        self.main_vbox.set_focus_chain([self.app_vbox])
        self.app_vbox.set_focus_chain([self.search_holder, self.list_vbox])

        # Setting up the toolbar
        self.list_vbox.set_focus_chain([self.footer_hbox])
        self._setup_printer()
        self._setup_widgets()
        self.TillVerify.set_sensitive(False)

    def get_title(self):
        return _('Stoq - Till for Branch %03d') % (
            api.get_current_branch(self.conn).id,)

    def activate(self, params):
        self.app.launcher.add_new_items([self.TillAddCash,
                                         self.TillRemoveCash])
        self.app.launcher.add_search_items([self.SearchFiscalTillOperations,
                                            self.SearchClient,
                                            self.SearchSale])
        self.app.launcher.Print.set_tooltip(_("Print a report of these sales"))
        self.refresh()
        self._printer.check_till()
        self.check_open_inventory()

    def deactivate(self):
        self.uimanager.remove_ui(self.till_ui)

    def new_activate(self):
        self._run_add_cash_dialog()

    def search_activate(self):
        self._run_search_dialog(TillFiscalOperationsSearch)

    #
    # SearchableAppWindow
    #

    def set_open_inventory(self):
        self.set_sensitive(self._inventory_widgets, False)

    def create_filters(self):
        self.executer.set_query(self._query_executer)
        self.set_text_field_columns(['client_name', 'salesperson_name'])
        status_filter = ComboSearchFilter(_(u"Show orders"),
                                          self._get_status_values())
        status_filter.select(Sale.STATUS_CONFIRMED)
        self.add_filter(status_filter, position=SearchFilterPosition.TOP,
                        columns=['status'])

    def get_columns(self):
        return [SearchColumn('id', title=_('#'), width=60,
                             data_type=int, format='%05d', sorted=True),
                SearchColumn('invoice_number', title=_(u'Nota n�'), width=80,
                             format='%05d', data_type=int),
                SearchColumn('nfe_invoice', title=_(u'NFe n�'), width=80,
                             data_type=int),
                SearchColumn('nfce_invoice', title=_(u'NFCe n�'), width=80,
                             data_type=int),
                SearchColumn('daily_code', title=_(u'N� Diario'), width=80,
                             data_type=int),
                Column('status_name', title=_(u'Status'), data_type=str,
                       visible=False),
                SearchColumn('open_date', title=_('Date Started'), width=110,
                             data_type=date, justify=gtk.JUSTIFY_RIGHT),
                SearchColumn('client_name', title=_('Client'),
                             data_type=str, expand=True,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('salesperson_name', title=_('Salesperson'),
                             data_type=str, width=180,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('client_cpf', title=_('cpf'),
                             data_type=str, width=140, visible=False),
                SearchColumn('client_cnpj', title=_('cnpj'),
                             data_type=str, width=140),
                SearchColumn('total_quantity', title=_('Quantity'),
                             data_type=decimal.Decimal, width=100,
                             format_func=format_quantity),
                SearchColumn('total', title=_('Total'), data_type=currency,
                             width=100)]

    #
    # Private
    #

    def _query_executer(self, query, having, conn):
        # We should only show Sales that
        # 1) In the current branch (FIXME: Should be on the same station.
        # See bug 4266)
        # 2) Are in the status QUOTE or ORDERED.
        # 3) For the order statuses, the date should be the same as today

        new = AND(Sale.q.branchID == self.current_branch.id,
                  OR(Sale.q.status == Sale.STATUS_INITIAL,
                     Sale.q.status == Sale.STATUS_CONFIRMED,
                     Sale.q.status == Sale.STATUS_PAID,
                     Sale.q.status == Sale.STATUS_CANCELLED,
                     Sale.q.status == Sale.STATUS_QUOTE,
                     Sale.q.status == Sale.STATUS_ORDERED,
                     Sale.q.status == Sale.STATUS_RETURNED,
                     Sale.q.status == Sale.STATUS_RENEGOTIATED,
                     Sale.q.status == Sale.STATUS_FISCAL_NOTE,
                     const.DATE(Sale.q.open_date) == date.today()))

        if query:
            query = AND(query, new)
        else:
            query = new

        return self.search_table.select(query, having=having, connection=conn)

    def _setup_printer(self):
        self._printer = FiscalPrinterHelper(self.conn,
                                            parent=self)
        self._printer.connect('till-status-changed',
                              self._on_PrinterHelper__till_status_changed)
        self._printer.connect('ecf-changed',
                              self._on_PrinterHelper__ecf_changed)
        self._printer.setup_midnight_check()

    def _get_status_values(self):
        statuses = [(v, k) for k, v in Sale.statuses.items()]
        statuses.insert(0, (_('Any'), None))
        return statuses

    def _confirm_order(self):
        if self.check_open_inventory():
            return

        api.rollback_and_begin(self.conn)
        selected = self.results.get_selected()
        sale = Sale.get(selected.id, connection=self.conn)
        expire_date = sale.expire_date

        if (sale.status == Sale.STATUS_QUOTE and
                expire_date and expire_date.date() < date.today() and
                not yesno(_("This quote has expired. Confirm it anyway?"),
                          gtk.RESPONSE_YES,
                          _("Confirm quote"), _("Don't confirm"))):
            return

        # Lets confirm that we can create the sale, before opening the coupon
        prod_sold = dict()
        prod_desc = dict()
        for sale_item in sale.get_items():
            # Skip services, since we don't need stock to sell.
            if sale_item.is_service():
                continue
            storable = IStorable(sale_item.sellable.product, None)
            prod_sold.setdefault(storable, 0)
            prod_sold[storable] += sale_item.quantity
            prod_desc[storable] = sale_item.sellable.get_description()

        branch = self.current_branch
        missing = []
        for storable in prod_sold.keys():
            stock = storable.get_full_balance(branch)
            if stock < prod_sold[storable]:
                missing.append(Settable(storable=storable,
                                        description=prod_desc[storable],
                                        ordered=prod_sold[storable],
                                        stock=stock))
        # TODO Negative Stock
        if missing and not sysparam(self.conn).NEGATIVE_STOCK:
            retval = run_dialog(ConfirmSaleMissingDialog, self, sale, missing)
            if retval:
                self.refresh()
            return

        coupon = self._open_coupon()
        if not coupon:
            return

        for sale_item in sale.get_items():
            self.decrease_quote_quantity(sale_item.sellable.id, sale_item.quantity)

        self._add_sale_items(sale, coupon)
        try:
            if coupon.confirm(sale, self.conn):
                self.conn.commit()
                self.refresh()
        except SellError as err:
            warning(err)
        except ModelDataError as err:
            warning(err)

    def decrease_quote_quantity(self, sellable_id, quantity=0):
        trans = api.new_transaction()
        product_stock_items = ProductStockItem.select(AND(ProductStockItem.q.storableID == ProductAdaptToStorable.q.id,
                                                          ProductAdaptToStorable.q.originalID == Product.q.id,
                                                          Product.q.sellableID == sellable_id),
                                                      connection=trans)
        for product_stock_item in product_stock_items:
            product_stock_item.quote_quantity -= quantity
        trans.commit()

    def _open_coupon(self):
        coupon = self._printer.create_coupon()

        if coupon:
            while not coupon.open():
                if not yesno(_("Failed to open the fiscal coupon.\n"
                               "Until it is opened, it's not possible to "
                               "confirm the sale. Do you want to try again?"),
                             gtk.RESPONSE_YES, _("Try again"), _("Cancel coupon")):
                    break

        return coupon

    def _add_sale_items(self, sale, coupon):
        for sale_item in sale.get_items():
            coupon.add_item(sale_item)

    def _update_total(self):
        balance = currency(self._get_till_balance())
        text = _(u"Total: %s") % converter.as_string(currency, balance)
        self.total_label.set_text(text)
        green = '#003300'
        red = '#FF0000'
        self.total_label.set_color(green)
        if balance <= 0:
            self.total_label.set_color(red)
        self._update_avegare_ticket()

    def _get_till_balance(self):
        """Returns the balance of till operations"""
        try:
            till = Till.get_current(self.conn)
        except TillError:
            till = None

        if till is None:
            return currency(0)

        return till.get_balance()

    def _setup_widgets(self):
        # SearchSale is here because it's possible to return a sale inside it
        self._inventory_widgets = [self.Confirm, self.SearchSale,
                                   self.Return]
        self.register_sensitive_group(self._inventory_widgets,
                                      lambda: not self.has_open_inventory())

        self.total_label.set_size('xx-large')
        self.total_label.set_bold(True)

        self.till_status_label.set_size('xx-large')
        self.till_status_label.set_bold(True)
        manager = get_plugin_manager()
        if not manager.is_active('nfe2'):
            self.SalesGenerateNFe.set_visible(False)
        if not (manager.is_active('nfce') or manager.is_active('nfce_bematech')):
            self.SalesGenerateNFCe.set_visible(False)

    def _update_toolbar_buttons(self):
        sale_view = self.results.get_selected()
        if sale_view:
            can_confirm = sale_view.can_confirm()
            # when confirming sales in till, we also might want to cancel
            # sales
            can_return = (sale_view.can_return() or
                          sale_view.can_cancel())
        else:
            can_confirm = can_return = False

        self.set_sensitive([self.Details], bool(sale_view))
        self.set_sensitive([self.Confirm], can_confirm)
        self.set_sensitive([self.Return], can_return)
        self.set_sensitive([self.SalesGenerateNFe], self._can_generate_nfe(sale_view))
        self.set_sensitive([self.SalesGenerateNFCe], self._can_generate_nfce(sale_view))

    def _can_generate_nfe(self, sale_view):
        # if sale_view:
        #     manager = get_plugin_manager()
        #     status = sale_view.status
        #     is_active = manager.is_active('nfe2')
        #     if not is_active:
        #         return False
        #     return status == Sale.STATUS_CONFIRMED or status == Sale.STATUS_PAID
        # return False
        return True

    def _can_generate_nfce(self, sale_view):
        if sale_view:
            manager = get_plugin_manager()
            status = sale_view.status
            is_active = manager.is_active('nfce') or manager.is_active('nfce_bematech')
            if not is_active:
                return False
            return status == Sale.STATUS_CONFIRMED or \
                   status == Sale.STATUS_PAID or \
                   status == Sale.STATUS_RENEGOTIATED
        return False

    def _check_selected(self):
        sale_view = self.results.get_selected()
        if not sale_view:
            raise StoqlibError("You should have a selected item at "
                               "this point")
        return sale_view

    def _run_search_dialog(self, dialog_type, **kwargs):
        trans = api.new_transaction()
        self.run_dialog(dialog_type, trans, **kwargs)
        trans.close()

    def _run_details_dialog(self):
        sale_view = self._check_selected()
        run_dialog(SaleDetailsDialog, self, self.conn, sale_view)

    def _run_add_cash_dialog(self):
        try:
            model = run_dialog(CashInEditor, self, self.conn)
        except TillError as err:
            # Inform the error to the user instead of crashing
            warning(err)
            return

        if api.finish_transaction(self.conn, model):
            self._update_total()

    def _return_sale(self):
        if self.check_open_inventory():
            return

        sale_view = self._check_selected()
        retval = return_sale(self.get_toplevel(), sale_view, self.conn)
        if api.finish_transaction(self.conn, retval):
            self._update_total()
            self.refresh()
        sale = sale_view.sale
        for sale_item in sale.get_items():
            self.decrease_quote_quantity(sale_item.sellable.id, sale_item.quantity)

    def _update_ecf(self, has_ecf):
        # If we have an ecf, let the other events decide what to disable.
        if has_ecf:
            return

        # We dont have an ecf. Disable till related operations
        widgets = [self.TillOpen, self.TillClose, self.TillAddCash,
                   self.TillRemoveCash, self.app_vbox]
        self.set_sensitive(widgets, has_ecf)
        text = _(u"Till operations requires a connected fiscal printer")
        self.till_status_label.set_text(text)

    def _update_till_status(self, closed, blocked):
        # Three different situations;
        #
        # - Till is closed
        # - Till is opened
        # - Till was not closed the previous fiscal day (blocked)

        self.set_sensitive([self.TillOpen], closed)
        self.set_sensitive([self.TillClose], not closed or blocked)

        widgets = [self.TillAddCash, self.TillRemoveCash, self.app_vbox]
        self.set_sensitive(widgets, not closed and not blocked)

        if closed:
            text = _(u"Till closed")
            self.clear()
            self.setup_focus()
        elif blocked:
            text = _(u"Till blocked from previous day")
        else:
            till = Till.get_current(self.conn)
            text = _(u"Till opened on %s") % till.opening_date.strftime('%x')

        self.till_status_label.set_text(text)

        self._update_toolbar_buttons()
        self._update_total()

    def _update_avegare_ticket(self):
        total_array = []
        for p in self.results:
            if p:
                total_array.append(p.total)
        if total_array:
            total = sum(total_array)
            quantity = len(total_array)
            if not quantity:
                self.average_ticket.set_text(u"")
                return
            self.average_ticket.set_text(u"<b>N� de vendas: {quantity}. Ticket m�dio {ticket}</b>".
                                         format(ticket=format_price(total / quantity), quantity=quantity))
            self.average_ticket.set_use_markup(True)

    #
    # Callbacks
    #

    def on_SalesGenerateNFe__activate(self, action):
        if yesno(_('Voce realmente quer gerar uma NFe?'),
                 gtk.RESPONSE_YES, _("Yes"), _("No")):

            sale_view = self.results.get_selected()
            assert sale_view
            sale = Sale.get(sale_view.id, connection=self.conn)
            if api.sysparam(self.conn).CHOISE_BRANCH_NFE:
                sale = run_dialog(NfeBranchDialog, get_current_toplevel(), self.conn, sale)  # edits branch and

            if not sale.invoice_number:
                sale.invoice_number = Sale.get_last_invoice_number_from_branch(self.conn, sale.branch) + 1
            SalesNFeCreate.emit(sale)
            self.conn.commit()
            self.search.refresh()

    def on_SalesGenerateNFCe__activate(self, action):
        if yesno(_('Voce realmente quer gerar uma NFCe?'),
                 gtk.RESPONSE_YES, _("Yes"), _("No")):
            sale_view = self.results.get_selected()
            assert sale_view
            sale = Sale.get(sale_view.id, connection=self.conn)
            SalesNFCEEvent.emit(sale)
            self.conn.commit()
            self.search.refresh()

    def on_Confirm__activate(self, action):
        self._confirm_order()
        self._update_total()

    def on_results__double_click(self, results, sale):
        self._run_details_dialog()

    def on_results__selection_changed(self, results, sale):
        self._update_toolbar_buttons()

    def on_results__has_rows(self, results, has_rows):
        self._update_total()

    def on_results__right_click(self, results, result, event):
        self.popup.popup(None, None, None, event.button, event.time)

    def on_Details__activate(self, action):
        self._run_details_dialog()

    def on_Return__activate(self, action):
        self._return_sale()

    def _on_PrinterHelper__till_status_changed(self, printer, closed, blocked):
        self._update_till_status(closed, blocked)

    def _on_PrinterHelper__ecf_changed(self, printer, ecf):
        self._update_ecf(ecf)

    # Till

    def on_TillVerify__activate(self, button):
        self._printer.verify_till()

    def on_TillRevenue__activate(self, button):
        date = run_dialog(PaymentRevenueDialog, get_current_toplevel(), self.conn)
        payments = FaturamentoSearch(self.conn, date.start_date, date.end_date)
        payment_dict = {'saida': payments.saida,
                        'entrada': payments.entrada}
        pdf_path = '{}.pdf'.format(tempfile.mktemp())
        f = FinancialReport(pdf_path, payment_dict, date.start_date, date.end_date)
        f.save()
        print_file(pdf_path)

    def on_DailyFlow__activate(self, button):
        date = run_dialog(DaySelectDialogDialog, get_current_toplevel(), self.conn)
        payments = DailyFaturamentoSearch(self.conn, date.start_date, date.end_date)
        payment_dict = {'saida': payments.saida,
                        'entrada': payments.entrada,
                        'faturamento_ontem': payments.faturamento_ontem}
        pdf_path = '{}.pdf'.format(tempfile.mktemp())
        f = FinancialReport(pdf_path, payment_dict, date.start_date, date.end_date)
        f.save()
        print_file(pdf_path)

    def on_TillClose__activate(self, button):
        self._printer.close_till()

    def on_TillOpen__activate(self, button):
        self._printer.open_till()

    def on_TillAddCash__activate(self, action):
        self._run_add_cash_dialog()

    def on_TillRemoveCash__activate(self, action):
        model = run_dialog(CashOutEditor, self, self.conn)
        if api.finish_transaction(self.conn, model):
            self._update_total()

    # Search

    def on_SearchClient__activate(self, action):
        self._run_search_dialog(ClientSearch, hide_footer=True)

    def on_SearchSale__activate(self, action):
        if self.check_open_inventory():
            return

        self._run_search_dialog(SaleSearch)
        self.refresh()

    def on_SearchSoldItemsByBranch__activate(self, button):
        self._run_search_dialog(SoldItemsByBranchSearch)

    def on_SearchTillHistory__activate(self, button):
        dialog = TillHistoryDialog(self.conn)
        self.run_dialog(dialog, self.conn)

    def on_SearchFiscalTillOperations__activate(self, button):
        self._run_search_dialog(TillFiscalOperationsSearch)

    def _on_search__search_completed(self, search, results, states):
        self.search_completed(results, states)

        has_results = len(results)
        for widget in (self.app.launcher.Print, self.app.launcher.ExportCSV):
            widget.set_sensitive(has_results)
        self._save_filter_settings()
        self._update_avegare_ticket()
