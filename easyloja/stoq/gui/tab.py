# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2007 Async Open Source <http://www.async.com.br>
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
""" Implementation of sales application.  """
from datetime import date
from decimal import Decimal
import gobject
import gettext
import decimal
import gtk

import pango
from kiwi.datatypes import currency, ValidationError
from kiwi.enums import SearchFilterPosition
from kiwi.python import Settable
from kiwi.ui.dialogs import yesno, warning, password
from kiwi.ui.gadgets import render_pixbuf
from kiwi.ui.search import ComboSearchFilter
from kiwi.ui.objectlist import Column, SearchColumn

from stoqlib.domain.till import Till
from stoqlib.exceptions import SellError, ModelDataError
from stoqlib.gui.dialogs.quotedialog import ConfirmSaleMissingDialog
from stoqlib.gui.fiscalprinter import FiscalPrinterHelper
from stoqlib.domain.events import SalesReportPrint, SaleStatusChangedEvent, SalesCompareEvent, SaleSEmitEvent
from stoqlib.domain.service import ServiceView
from stoqlib.domain.product import Product
from stoqlib.domain.views import (ProductFullStockItemView, ProductComponentView,
                                  SellableFullStockView, ProductWithStockView)
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.domain.fiscal import CfopData
from stoqlib.gui.base.wizards import BaseWizard
from stoqlib.database.runtime import get_connection, get_current_user
from stoqlib.api import api
from stoqlib.domain.interfaces import ISalesPerson, IStorable
from stoqlib.domain.invoice import InvoicePrinter
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.payment.operation import register_payment_operations
from stoqlib.domain.person import Person
from stoqlib.domain.sale import Sale, SaleTabView, SaleTab
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.gui.editors.invoiceeditor import SaleInvoicePrinterDialog
from stoqlib.gui.editors.noteeditor import NoteEditor
from stoqlib.gui.keybindings import get_accels
from stoqlib.gui.search.callsearch import ClientCallsSearch
from stoqlib.gui.search.commissionsearch import CommissionSearch
from stoqlib.gui.search.loansearch import LoanItemSearch, LoanSearch
from stoqlib.gui.search.personsearch import ClientSearch
from stoqlib.gui.search.productsearch import ProductSearch
from stoqlib.gui.search.salesearch import DeliverySearch, SoldItemsByBranchSearch
from stoqlib.gui.search.servicesearch import ServiceSearch
from stoqlib.gui.slaves.saleslave import SaleListToolbar
from stoqlib.gui.stockicons import (STOQ_PRODUCTS, STOQ_SERVICES,
                                    STOQ_CLIENTS, STOQ_DELIVERY)
from stoqlib.gui.wizards.abstractwizard import SellableItemStep, _SellableSearch
from stoqlib.gui.wizards.loanwizard import NewLoanWizard, CloseLoanWizard
from stoqlib.gui.wizards.salequotewizard import SaleQuoteWizard, StartSaleQuoteStep, SaleQuoteItemStep
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.invoice import SaleInvoice, print_sale_invoice
from stoqlib.lib.message import info
from stoqlib.lib.parameters import sysparam
from stoqlib.reporting.sale import SalesReport
from stoq.gui.application import SearchableAppWindow


_ = gettext.gettext


class TabApp(SearchableAppWindow):
    app_name = _('Comandas')
    gladefile = 'sales_app'
    search_table = SaleTabView
    search_label = _('matching:')
    report_table = SalesReport
    embedded = True

    #28/11/12

    cols_info = {
        Sale.STATUS_CANCELLED: 'cancel_date',   #3
        Sale.STATUS_QUOTE: 'open_date',         #6
    }

    def __init__(self, app):
        self.summary_label = None
        self._visible_date_col = None
        SearchableAppWindow.__init__(self, app)
        gobject.timeout_add(13000, self._on_TabIncomevent)
        SaleSEmitEvent.connect(self._on_TabIncomevent)
        SalesCompareEvent.connect(self._on_TabIncomevent)

    #
    # Application
    #
    def _on_TabIncomevent(self):
        print "Deveria dar um refreshhh....\n"
        self.search.refresh()

    def create_actions(self):
        group = get_accels('app.sales')
        actions = [

            # File
            ("SaleQuote", None, _("Sale quote..."), '',
             _('Create a new quote for a sale')),
            ("LoanNew", None, _("Loan...")),
            ("LoanClose", None, _("Close loan...")),

            ("TillOpen", None, _("Open Till..."),
             group.get('till_open')),
            ("TillClose", None, _("Close Till..."),
             group.get('till_close')),

            # Search
            ("SearchSoldItemsByBranch", None, _("Sold items by branch..."),
             group.get("search_sold_items_by_branch"),
             _("Search for sold items by branch")),
            ("SearchProduct", STOQ_PRODUCTS, _("Products..."),
             group.get("search_products"),
             _("Search for products")),
            ("SearchService", STOQ_SERVICES, _("Services..."),
             group.get("search_services"),
             _("Search for services")),
            ("SearchDelivery", STOQ_DELIVERY, _("Deliveries..."),
             group.get("search_deliveries"),
             _("Search for deliveries")),
            ("SearchClient", STOQ_CLIENTS, _("Clients..."),
             group.get("search_clients"),
             _("Search for clients")),
            ("SearchClientCalls", None, _("Client Calls..."),
             group.get("search_client_calls"),
             _("Search for client calls")),
            ("SearchCommission", None, _("Commissions..."),
             group.get("search_commissions"),
             _("Search for salespersons commissions")),
            ("LoanSearch", None, _("Loans..."),
             group.get("search_loans")),
            ("LoanSearchItems", None, _("Loan items..."),
             group.get("search_loan_items")),

            # Sale
            ("SaleMenu", None, _("Sale")),

            ("SalesPrintInvoice", gtk.STOCK_PRINT, _("_Print invoice...")),
            ("SalesGenerateReport", None, _("Relatorio")),
            ("SalesCheckout", None, _("Confirm payment")),
            ("SalesEditTab", None, _("Editar Detalhes da Comanda")),
            ("SalesCancel", None, _("Cancelar Comanda...")),
            ("Edit", gtk.STOCK_EDIT, _("Edit..."), '',
             _("Edit the selected sale, allowing you to change the details "
               "of it")),
            ("Details", gtk.STOCK_INFO, _("Details..."), '',
             _("Show details of the selected sale"))
        ]

        self.sales_ui = self.add_ui_actions("", actions,
                                            filename="tab.xml")

        self.SaleQuote.set_short_label(_("New Sale Quote"))
        self.SearchClient.set_short_label(_("Clients"))
        self.SearchProduct.set_short_label(_("Products"))
        self.SearchService.set_short_label(_("Services"))
        self.SearchDelivery.set_short_label(_("Deliveries"))
        self.Edit.set_short_label(_("Edit"))
        self.Details.set_short_label(_("Details"))
        self.set_help_section(_("Sales help"), 'app-sales')

    def create_ui(self):
        self.popup = self.uimanager.get_widget('/SaleSelection')
        self.current_branch = api.get_current_branch(self.conn)

        self._columns = self.get_columns()
        self._setup_columns()
        self._setup_widgets()

        self.app.launcher.add_new_items([self.SaleQuote])
        self.app.launcher.add_search_items([
            self.SearchProduct,
            self.SearchClient,
            self.SearchService,
            self.SearchDelivery])
        self.app.launcher.Print.set_tooltip(_("Print a report of these sales"))
        self._setup_printer()

    def _setup_printer(self):
        self._printer = FiscalPrinterHelper(self.conn,
                                            parent=self)
        self._printer.connect('till-status-changed',
                              self._on_PrinterHelper__till_status_changed)
        self._printer.connect('ecf-changed',
                              self._on_PrinterHelper__ecf_changed)
        self._printer.setup_midnight_check()

    def activate(self, params):
        self.check_open_inventory()
        self._update_toolbar()
        self._printer.check_till()

    def setup_focus(self):
        self.search.refresh()

    def deactivate(self):
        self.uimanager.remove_ui(self.sales_ui)

    def new_activate(self):
        self._new_sale_quote()
        self.search.refresh()

    def search_activate(self):
        self._search_product()

    def set_open_inventory(self):
        self.set_sensitive(self._inventory_widgets, False)

    #
    # SearchableAppWindow
    #

    def create_filters(self):
        self.set_text_field_columns(['client_name', 'salesperson_name'])
        status_filter = ComboSearchFilter(_('Show sales with status'),
                                          self._get_status_values())
        status_filter.select(Sale.STATUS_CONFIRMED)
        self.executer.add_filter_query_callback(
            status_filter, self._get_status_query)
        self.add_filter(status_filter, position=SearchFilterPosition.TOP)

    def get_columns(self):
        self._status_col = Column('status_name', title=_('Status'),
                                  data_type=str, width=80, visible=False)

        cols = [SearchColumn('id', title=_('#'), width=60,
                             format='%05d', data_type=int),
                SearchColumn('tab_num', title=_('Comanda'), width=90, data_type=int, sorted=True),
                SearchColumn('table_num', title=_('Mesa'), width=50, data_type=int),
                SearchColumn('color', title=_('status'), width=60,
                             data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                self._status_col,
                SearchColumn('client_name', title=_('Client'),
                             data_type=str, width=130, expand=True,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('salesperson_name', title=_('Salesperson'),
                             data_type=str, width=130,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('total_quantity', title=_('Items'),
                             data_type=decimal.Decimal, width=70,
                             format_func=format_quantity),
                SearchColumn('total', title=_('Total'), data_type=currency,
                             width=130)]
        return cols

    #
    # Private
    #

    def _setup_widgets(self):
        self._setup_slaves()
        self._inventory_widgets = [self.sale_toolbar.return_sale_button, self.LoanNew, self.LoanClose]
        self.register_sensitive_group(self._inventory_widgets,
                                      lambda: not self.has_open_inventory())

    def _setup_slaves(self):
        # This is only here to reuse the logic in it.
        self.sale_toolbar = SaleTabListToolbar(self.conn, self.results)

    def _can_cancel(self, view):
        # Here we want to cancel only quoting sales. This is why we don't use
        # Sale.can_cancel here.
        return bool(view and view.status == Sale.STATUS_QUOTE)

    def _can_edit(self, view):
        return bool(view and view.status == Sale.STATUS_QUOTE)

    def _update_toolbar(self, *args):
        sale_view = self.results.get_selected()
        #FIXME: Disable invoice printing if the sale was returned. Remove this
        #       when we add proper support for returned sales invoice.
        can_print_invoice = bool(sale_view and
                                 sale_view.client_name is not None and
                                 sale_view.status != Sale.STATUS_RETURNED)
        self.set_sensitive([self.SalesPrintInvoice], can_print_invoice)
        self.set_sensitive([self.SalesCancel], self._can_cancel(sale_view))
        self.set_sensitive([self.sale_toolbar.return_sale_button, self.Details],
                           bool(sale_view))
        self.set_sensitive([self.sale_toolbar.edit_button, self.Edit],
                           self._can_edit(sale_view))

        self.sale_toolbar.set_report_filters(self.search.get_search_filters())

    def _print_invoice(self):
        sale_view = self.results.get_selected()
        assert sale_view
        sale = Sale.get(sale_view.id, connection=self.conn)
        station = api.get_current_station(self.conn)
        printer = InvoicePrinter.get_by_station(station, self.conn)
        if printer is None:
            info(_("There are no invoice printer configured for this station"))
            return
        assert printer.layout

        invoice = SaleInvoice(sale, printer.layout)
        if not invoice.has_invoice_number() or sale.invoice_number:
            print_sale_invoice(invoice, printer)
        else:
            trans = api.new_transaction()
            retval = self.run_dialog(SaleInvoicePrinterDialog, trans,
                                     trans.get(sale), printer)
            api.finish_transaction(trans, retval)
            trans.close()

    def _setup_columns(self, sale_status=Sale.STATUS_CONFIRMED):
        self._status_col.visible = False

        if sale_status is None:
            # When there is no filter for sale status, show the
            # 'date started' column by default
            sale_status = Sale.STATUS_INITIAL
            self._status_col.visible = True

        if self._visible_date_col:
            self._visible_date_col.visible = False

        for col in self._columns:
            if col.attribute != 3 or col.attribute != 6:
                continue
            if col.attribute == self.cols_info[sale_status]:
                self._visible_date_col = col
                col.visible = True
                break

        self.results.set_columns(self._columns)
        # Adding summary label again and make it properly aligned with the
        # new columns setup

    def _get_status_values(self):
        items = [(value, key) for key, value in Sale.statuses.items()
                 # No reason to show orders in sales app
                 if key != Sale.STATUS_ORDERED]
        items.insert(0, (_('Any'), None))
        return items

    def _get_status_query(self, state):
        self._setup_columns(state.value)

        self.user = get_current_user(get_connection())

        #Não é Administrador
        if self.user.profile.id != 1:
            if state.value is None:
                return SaleTabView.q.user_logged == self.user.username
            else:
                return (SaleTabView.q.user_logged == self.user.username) & (SaleTabView.q.status == state.value)

        if state.value is None:
            return SaleTabView.q.status != Sale.STATUS_CONFIRMED

        return SaleTabView.q.status == state.value

    def _new_sale_quote(self):
        trans = api.new_transaction()
        sale_model = self.run_dialog(SaleTabWizard, trans)
        # sale event
        SaleStatusChangedEvent.emit(sale_model, sale_model.status)
        tab_model = self.run_dialog(TabEditor, trans, None, sale_model)

        trans.add_created_object(tab_model)
        api.finish_transaction(trans, sale_model)
        trans.close()

    def _search_product(self):
        hide_cost_column = not api.sysparam(self.conn).SHOW_COST_COLUMN_IN_SALES
        self.run_dialog(ProductSearch, self.conn, hide_footer=True,
                        hide_toolbar=True, hide_cost_column=hide_cost_column)

    #
    # Kiwi callbacks
    #

    def _on_sale_toolbar__sale_returned(self, toolbar, sale):
        self.search.refresh()

    def _on_sale_toolbar__sale_edited(self, toolbar, sale):
        self.search.refresh()

    def on_results__selection_changed(self, results, sale):
        self._update_toolbar()

    def on_results__has_rows(self, results, has_rows):
        self._update_toolbar()

    def on_results__right_click(self, results, result, event):
        self.popup.popup(None, None, None, event.button, event.time)

    # Sales

    def on_SaleQuote__activate(self, action):
        self._new_sale_quote()
        self.search.refresh()

    def on_SalesCancel__activate(self, action):
        # if self.has_permission():
        if yesno(_('This will cancel the selected quote. Are you sure?')) == gtk.RESPONSE_YES:
            #return
            trans = api.new_transaction()
            sale_view = self.results.get_selected()
            sale = trans.get(sale_view.sale)
            #        sale.cancel()
            sale.status = Sale.STATUS_RETURNED
            api.finish_transaction(trans, True)
            self.search.refresh()
            saleTab = SaleTab.selectOneBy(sale=sale, status=SaleTab.STATUS_OPENED, connection=self.conn)
            saleTab.status = SaleTab.STATUS_CLOSED
            saleTab.color = '#FF0000'
            self.conn.commit()

    def on_SalesPrintInvoice__activate(self, action):
        return self._print_invoice()

    def on_SalesGenerateReport__activate(self, action):
        if yesno(_('Voce deseja imprimrir o relatorio?')) == gtk.RESPONSE_YES:
            selected = self.results.get_selected()
            assert selected
            sale = Sale.get(selected.id, connection=self.conn)
            SalesReportPrint.emit(sale)                         # EBI 18/09/2013
            self.search.refresh()

    def _on_PrinterHelper__till_status_changed(self, printer, closed, blocked):
        pass
        #self._till_status_changed(closed, blocked)

    def on_SalesCheckout__activate(self, action):
        # if self.has_permission():
        till = Till.get_current(get_connection())
        if till is None:
            warning(u'Caixa ainda não foi aberto hoje ou ja esta fechado',
                    'Visite o app CAIXA para mais detalhes!')
            return
        self._confirm_order()

    def on_SalesEditTab__activate(self, action):
        selected = self.results.get_selected()
        assert selected
        sale = Sale.get(selected.id, connection=self.conn)
        tab = SaleTab.get(self.get_sale_tab_id(selected.id), connection=self.conn)
        model = self.run_dialog(TabEditor, self.conn, tab, sale)

        self.conn.commit()
        self.search.refresh()

    # till
    def on_TillClose__activate(self, action):
        self._printer.close_till()

    def on_TillOpen__activate(self, action):
        self._printer.open_till()

    def get_sale_tab_id(self, sale_id):
        tab = SaleTab.select(sale_id == SaleTab.q.saleID, connection=self.conn)
        return tab[0].id

    def _on_PrinterHelper__ecf_changed(self, printer, has_ecf):
        # If we have an ecf, let the other events decide what to disable.
        if has_ecf:
            return

    def has_permission(self):
        """ Checks if the person knows the current logged user password
        """
        pwd = password(_("Password:")) or ''
        user = get_current_user(self.conn)
        import hashlib
        h = hashlib.new('sha256')
        h.update(user.username)                     # logged user
        h.update(pwd)                               # given password

        if h.hexdigest() == user.password:
            return True
        else:
            return False

    # Loan

    def on_LoanNew__activate(self, action):
        if self.check_open_inventory():
            return
        trans = api.new_transaction()
        model = self.run_dialog(NewLoanWizard, trans)
        api.finish_transaction(trans, model)
        trans.close()

    def on_LoanClose__activate(self, action):
        if self.check_open_inventory():
            return
        trans = api.new_transaction()
        model = self.run_dialog(CloseLoanWizard, trans)
        api.finish_transaction(trans, model)
        trans.close()

    def on_LoanSearch__activate(self, action):
        self.run_dialog(LoanSearch, self.conn)

    def on_LoanSearchItems__activate(self, action):
        self.run_dialog(LoanItemSearch, self.conn)

    # Search

    def on_SearchClient__activate(self, button):
        self.run_dialog(ClientSearch, self.conn, hide_footer=True)

    def on_SearchProduct__activate(self, button):
        self._search_product()

    def on_SearchCommission__activate(self, button):
        self.run_dialog(CommissionSearch, self.conn)

    def on_SearchClientCalls__activate(self, action):
        self.run_dialog(ClientCallsSearch, self.conn)

    def on_SearchService__activate(self, button):
        self.run_dialog(ServiceSearch, self.conn, hide_toolbar=True)

    def on_SearchSoldItemsByBranch__activate(self, button):
        self.run_dialog(SoldItemsByBranchSearch, self.conn)

    def on_SearchDelivery__activate(self, action):
        self.run_dialog(DeliverySearch, self.conn)

    # Toolbar

    def on_Edit__activate(self, action):
        self.sale_toolbar.edit()
        self.search.refresh()

    def on_Details__activate(self, action):
        self.sale_toolbar.show_details()
        self.search.refresh()

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

        if missing:
            retval = run_dialog(ConfirmSaleMissingDialog, self, sale, missing)
            saleTab = SaleTab.selectOneBy(sale=sale, status=SaleTab.STATUS_OPENED, connection=self.conn)
            saleTab.status = SaleTab.STATUS_CLOSED
            saleTab.color = '#FF0000'
            self.conn.commit()
            if retval:
                self.refresh()
            return

        coupon = self._open_coupon()
        if not coupon:
            return
        self._add_sale_items(sale, coupon)
        try:
            if coupon.confirm(sale, self.conn):
                saleTab = SaleTab.selectOneBy(sale=sale, status=SaleTab.STATUS_OPENED, connection=self.conn)
                saleTab.status = SaleTab.STATUS_CLOSED
                saleTab.color = '#FF0000'
                self.conn.commit()
                self.refresh()

        except SellError as err:
            warning(err)
        except ModelDataError as err:
            warning(err)

    def _open_coupon(self):
        # self._printer = FiscalPrinterHelper(self.conn,
        #                                     parent=self)
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
        if yesno(u'Adicionar Tx. de Serviço?', 
                 parent=get_current_toplevel()) == gtk.RESPONSE_YES:
            tax_service = sysparam(get_connection()).TAX_SERVICE
            sale_subtotal = sale.get_sale_subtotal()
            tax_price = sale_subtotal * currency(0.1)
            sale.add_sellable(tax_service.sellable,
                              price=tax_price)

        for sale_item in sale.get_items():
            coupon.add_item(sale_item)


class SaleTabWizard(SaleQuoteWizard):
    size = (775, 400)
    help_section = 'sale-quote'
    has_edit_button = False

    def __init__(self, conn, model=None):
        title = self._get_title(model)
        model = model or self._create_model(conn)

        if model.status != Sale.STATUS_QUOTE:
            raise ValueError('Invalid sale status. It should '
                             'be STATUS_QUOTE')

        register_payment_operations()
        first_step = StartTabSaleQuoteStep(conn, self, model)
        BaseWizard.__init__(self, conn, first_step, model, title=title,
                            edit_mode=False)

    def _get_title(self, model=None):
        if not model:
            return _('Nova Comanda')
        return _('Editar Comanda')

    def _create_model(self, conn):
        salesperson = None

        sale = Sale(coupon_id=None,
                    status=Sale.STATUS_QUOTE,
                    salesperson=salesperson,
                    branch=api.get_current_branch(conn),
                    group=PaymentGroup(connection=conn),
                    cfop=sysparam(conn).DEFAULT_SALES_CFOP,
                    operation_nature=sysparam(conn).DEFAULT_OPERATION_NATURE,
                    connection=conn)
        return sale

    def finish(self):
        self.retval = self.model
        self.close()
        sale = self.model


class SaleTabListToolbar(SaleListToolbar):
    def edit(self, sale_view=None):
        if sale_view is None:
            sale_view = self.sales.get_selected()
        trans = api.new_transaction()
        sale = trans.get(sale_view.sale)
        before_edit = self.extract_info(sale)
        model = run_dialog(SaleTabWizard, self.parent, trans, sale)
        after_edit = self.extract_info(model)
        SalesCompareEvent.emit(before_edit, after_edit)
        retval = api.finish_transaction(trans, model)
        trans.close()

        if retval:
            self.emit('sale-edited', retval)

    def extract_info(self, sale):
        info = []
        assert sale
        for sale_item in sale.get_items():
            description = sale_item._get_sellable()._get_description()
            quantity = sale_item._get_quantity()
            note = sale_item._get_notes() or ""
            try:
                location = sale_item._get_sellable()._get_product()._get_location()
            except:
                location = ""
            info.append((description, location, quantity, note, sale.id))
        return info


class StartTabSaleQuoteStep(StartSaleQuoteStep):

    def _setup_widgets(self):
        # Hide total and subtotal
        self.table1.hide()
        self.hbox4.hide()
        # Hide invoice number details
        self.invoice_number_label.hide()
        self.invoice_number.hide()
        # hides
        self.transporter_lbl.hide()
        self.transporter.hide()
        self.create_transporter.hide()
        self._fill_clients_combo()
        self.create_client.hide()
        self.client_details.hide()
        self.expire_date.hide()
        self.expire_label.hide()
        self.client_category.hide()
        self.client_category_lbl.hide()
        self.subtotal_expander.hide()
        self.invoice_number.hide()
        self.notes_button.hide()
        self.invoice_number_label.hide()
        self.nature_lbl.hide()
        self.operation_nature.hide()


        # Salesperson combo
        salespersons = Person.iselect(ISalesPerson, connection=self.conn)
        items = [(s.person.name, s) for s in salespersons]
        self.salesperson.prefill(items)
        
        user = api.get_current_user(conn=get_connection())
        can_edit_salesperson = self.model.salesperson == ISalesPerson(user.person) or self.model.salesperson is None
        can_edit_client = self.model.client is None

        # enable or disable dialogs
        self.salesperson.set_sensitive(can_edit_salesperson)
        self.client.set_sensitive(can_edit_client)

        # CFOP combo
        if sysparam(self.conn).ASK_SALES_CFOP:
            cfops = [(cfop.get_description(), cfop)
                        for cfop in CfopData.select(connection=self.conn)]
            self.cfop.prefill(cfops)
        else:
            self.cfop_lbl.hide()
            self.cfop.hide()
            self.create_cfop.hide()
            
    def next_step(self):
        return SaleTabQuoteItemStep(self.wizard, self, self.conn, self.model)

            
class SaleTabQuoteItemStep(SaleQuoteItemStep):

    can_delete = False

    def setup_proxies(self):
        self.proxy = self.add_proxy(None, SellableItemStep.proxy_widgets)
        self.cost.hide()
        self.cost_label.hide()

    def get_columns(self):
        columns = [
            Column('sellable.code', title=_(u'Code'), data_type=str, width=80),
            Column('sellable.description', title=_('Description'),
                   data_type=str, expand=True, searchable=True),
            Column('quantity', title=_('Quantity'), data_type=float, width=100,
                   format_func=format_quantity), ]

        columns.extend([
            Column('price', title=_('Price'), data_type=currency, width=80),
            Column('total', title=_('Total'), data_type=currency, width=90), ])

        return columns

    def setup_slaves(self):
        SellableItemStep.setup_slaves(self)
        self.hide_add_button()
        self.xml_button.hide()
        self.item_lbl.hide()
        self.barcode.hide()
        self.product_button.hide()
        self.kiwilabel2.hide()
        self.quantity.hide()
        self.cost_label.hide()
        self.cost.hide()
        self.xml_label.hide()
        self.add_sellable_button.hide()
        self.label1.hide()
        self.label2.hide()
        # self.slave.delete_button.hide()

    def sellable_selected(self, sellable):
        SellableItemStep.sellable_selected(self, sellable)
        if sellable:
            price = sellable.get_price_for_category(
                                    self.model.client_category)
            self.cost.set_text("%s" % price)
            self.proxy.update('cost')

    def _run_advanced_search(self, search_str=None):
        supplier = None
        has_supplier = hasattr(self.model, 'supplier')
        if has_supplier:
            supplier = self.model.supplier
        ret = run_dialog(Tab_SellableSearch, self.wizard,
                         self.conn,
                         search_str=search_str,
                         table=self.sellable_view,
                         supplier=supplier,
                         editable=self.sellable_editable,
                         query=self.get_sellable_view_query())
        if not ret:
            return

        # We receive different items depend on if we
        # - selected an item in the search
        # - created a new item and it closed the dialog for us
        if not isinstance(ret, (Product, ProductFullStockItemView,
                                ProductComponentView, SellableFullStockView,
                                ServiceView, ProductWithStockView)):
            raise AssertionError(ret)

        sellable = ret.sellable
        if not self.can_add_sellable(sellable):
            return
        self.barcode.set_text(sellable.barcode)
        self.sellable_selected(sellable)
        self.quantity.grab_focus()

    # def post_init(self):
    #     SellableItemStep.post_init(self)
    #     # self.slave.set_editor(NoteEditor2)
    #     self._refresh_next()

    # def on_add_sellable_button__clicked(self, button):
    #     self._add_sellable()

class Tab_SellableSearch(_SellableSearch):
    
    def create_filters(self):
        self.set_text_field_columns(['code', 'description'])
        self.executer.set_query(self.executer_query)
        
    def get_columns(self):
        columns = [SearchColumn('code', title=_(u'Code'), data_type=str),
                   SearchColumn('description', title=_('Description'),
                                data_type=str, expand=True, sorted=True)]

        if 'minimum_quantity' in self._table.columns:
            columns.append(SearchColumn('minimum_quantity',
                                        title=_(u'Minimum Qty'),
                                        data_type=Decimal, visible=False))

        if 'stock' in self._table.columns:
            columns.append(SearchColumn('stock', title=_(u'In Stock'),
                                        data_type=Decimal))

        return columns

    def _on_search__search_completed(self, search, results, states):
        self.search_completed(results, states)


class NoteEditor2(NoteEditor):
    """ Simple editor that offers a label and a textview. """
    gladefile = "ComboNoteEditor"
    proxy_widgets = ('notes', 'notes_combobox')
    size = (600, 300)

    def __init__(self, conn, model, attr_name='notes', title='', label_text=None,
                 visual_mode=False):
        assert model, ("You must supply a valid model to this editor "
                       "(%r)" % self)
        self.model_type = type(model)
        self.title = title
        self.label_text = label_text
        self.attr_name = attr_name
        self.items = ''

        BaseEditor.__init__(self, conn, model, visual_mode=visual_mode)
        self._setup_widgets()

    def _setup_widgets(self):
        items = sysparam(self.conn).ITEMS_TO_TAB.split(';')
        if self.label_text:
            self.notes_label.set_text(self.label_text)
        self.notes.set_accepts_tab(False)
        self.notes_combobox.prefill(items)

    #
    # BaseEditor hooks
    #

    def setup_proxies(self):
        self.notes.set_property('model-attribute', self.attr_name)
        self.add_proxy(self.model, NoteEditor.proxy_widgets)

    def get_title(self, *args):
        return self.title

    #
    # Callbacks
    #

    def on_key_press(self, widget, event):
        current_item = self.notes_combobox.read()
        self.items += current_item + '; '
        self.notes.update(self.items)


class TabEditor(BaseEditor):
    model_name = _('Comanda')
    model_type = SaleTab
    gladefile = 'SaleTabEditor'

    def __init__(self, conn, model, sale):
        self.sale = sale
        self.conn = conn
        BaseEditor.__init__(self, conn, model)

    def create_model(self, trans):
        return SaleTab(connection=trans,
                       sale=self.sale,
                       table_num=None,
                       tab_num=None,
                       color=None)

    def setup_proxies(self):
        # self.can_edit_tab_num = self.model.tab_num is None
        self._fill_color_combo()
        self.tab_num.grab_focus()
        # self.tab_num.set_sensitive(self.can_edit_tab_num)
        self.add_proxy(self.model, ['tab_num', 'table_num', 'color_cb'])

    def _fill_color_combo(self):
        statuses = [('Novo', '#06E902'), (u'Atenção', '#E9E902'), ('Fechar', '#FF0000'), ('Outros', '#0295E9')]

        self.color_cb.prefill(statuses)

    #
    # Kiwi Callbacks
    #

    def on_confirm(self):
        self.model.color = self.color_cb.get_selected()
        return self.model

    def on_tab_num__validate(self, widget, tabnum):
        tab = SaleTab.selectBy(tab_num=int(tabnum), status=SaleTab.STATUS_OPENED, connection=self.conn)
        results = [st for st in tab]
        # if self.model.tab_num ==
        if len(results) > 1:         # means that already exists an oppened tab, we cant have two tabs with STATUS_OPENED
            comandas = [c.tab_num for c in results[1:]]
            return ValidationError(u"Não pode editar esta comanda. Já existe %d comanda(s) "
                                   u"número %s com o mesmo número e aberta" % (len(comandas), comandas[0]))

    def on_cancel(self):
        return False
