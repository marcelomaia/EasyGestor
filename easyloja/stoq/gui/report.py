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
""" Main gui definition for admin application.  """

import gettext
import glib
import gtk

from kiwi.log import Logger
from stoq.gui.application import AppWindow
from stoqlib.chart.chartdialog import SalesChart, PaymentsChart
from stoqlib.gui.keybindings import get_accels
from stoqlib.gui.search.commissionsearch import CommissionSearch
from stoqlib.gui.search.payment_search import DelayedReceivableSearch, DelayedPayableSearch, InPaymentsTotalByClient
from stoqlib.gui.search.personsearch import BirthdaySearch, ClientSearch
from stoqlib.gui.search.productsearch import ProductsSoldSearch, ProductHistorySearch, ProductStockSearch, \
    ProductsRevenueSearch
from stoqlib.gui.search.purchasesearch import _PurchasedItemsSearch
from stoqlib.gui.search.salesearch import _SaleSearch, SalesPersonSearch
from stoqlib.gui.search.servicesearch import ServiceSoldSearch
from stoqlib.gui.stockicons import (
    STOQ_PAYABLE_APP, STOQ_CHECKLIST, STOQ_CLIENTS, STOQ_SALES_APP, STOQ_CALENDAR_APP,
    STOQ_STOCK_APP, STOQ_HR, STOQ_PURCHASE_APP, STOQ_DELAYED_RECEIVABLE, STOQ_DELAYED_PAYABLE, STOQ_COMISSION,
    STOQ_GRAPHIC, STOQ_PRODUCT_REVENUE, STOQ_PURCHASE_ITEMS, STOQ_STOCK_ITEMS, STOQ_SALE_SEARCH)

_ = gettext.gettext

logger = Logger('stoq.gui.report')

(COL_LABEL,
 COL_NAME,
 COL_PIXBUF,
 COL_ORDER) = range(4)


class Tasks(object):
    def __init__(self, app):
        self.app = app

        self.theme = gtk.icon_theme_get_default()

    def set_model(self, model):
        self.model = model
        self.model.clear()

    def add_defaults(self):
        items = [
            # financial
            (_('Delayed Receivable'), 'delayed_receivable', STOQ_DELAYED_RECEIVABLE),
            (_('Delayed Payable'), 'delayed_payable', STOQ_DELAYED_PAYABLE),
            (_('Search for Commissions'), 'commisions', STOQ_COMISSION),
            # people
            (_('Birthdays'), 'birthday_person', STOQ_CHECKLIST),
            (_('Client Search'), 'clients', STOQ_CLIENTS),
            (_('Search for Sales'), 'sale_search', STOQ_SALE_SEARCH),
            # products and services
            (_('Service Sold History'), 'service_sold_history', STOQ_CALENDAR_APP),
            (_('Product Sold History'), 'product_sold_history', STOQ_CALENDAR_APP),
            (_('Product History'), 'product_history', STOQ_HR),
            (_('Itens de estoque'), 'product_stock', STOQ_STOCK_ITEMS),
            (_('Itens de compra'), 'purchase_search', STOQ_PURCHASE_ITEMS),
            (_('Grafico de Vendas Anual'), 'annual_sales', STOQ_GRAPHIC),
            (_('Historico de Pagamentos'), 'annual_payments', STOQ_SALES_APP),
            (_('Receita por Produto'), 'product_revenue', STOQ_PRODUCT_REVENUE)
        ]

        for label, name, pixbuf in items:
            self.add_item(label, name, pixbuf)

    def add_item(self, label, name, pixbuf=None, cb=None):
        """
        @param label: Label to show in the interface
        @param name: Name to use to store internally and use by callbacks
        @param pixbuf: a pixbuf or stock-id/icon-name for the item
        @param cb: callback
        """
        if type(pixbuf) == str:
            try:
                pixbuf = self.theme.load_icon(pixbuf, 32, 0)
            except glib.GError:
                pixbuf = self.app.get_toplevel().render_icon(pixbuf, gtk.ICON_SIZE_DIALOG)
        self.model.append([label, name, pixbuf])
        if cb is not None:
            setattr(self, '_open_' + name, cb)

    def on_item_activated(self, view, path):
        name = self.model[path][COL_NAME]
        self.run_task(name)

    def hide_item(self, name):
        for row in self.model:
            if row[COL_NAME] == name:
                del self.model[row.iter]
                break

    def run_task(self, name):
        func = getattr(self, '_open_%s' % name, None)
        if not func:
            logger.info("Couldn't open dialog: %r" % (name,))
            return
        logger.info("Opening dialog: %r" % (name,))
        func()

    def _open_delayed_receivable(self):
        self.app.run_dialog(DelayedReceivableSearch, self.app.conn)

    def _open_delayed_payable(self):
        self.app.run_dialog(DelayedPayableSearch, self.app.conn)

    def _open_service_sold_history(self):
        self.app.run_dialog(ServiceSoldSearch, self.app.conn)

    def _open_birthday_person(self):
        self.app.run_dialog(BirthdaySearch, self.app.conn)

    def _open_product_sold_history(self):
        self.app.run_dialog(ProductsSoldSearch, self.app.conn)

    def _open_product_history(self):
        self.app.run_dialog(ProductHistorySearch, self.app.conn)

    def _open_product_stock(self):
        self.app.run_dialog(ProductStockSearch, self.app.conn)

    def _open_commisions(self):
        self.app.run_dialog(CommissionSearch, self.app.conn)

    def _open_clients(self):
        self.app.run_dialog(ClientSearch, self.app.conn)

    def _open_sale_search(self):
        self.app.run_dialog(_SaleSearch, self.app.conn)

    def _open_salesperson_search(self):
        self.app.run_dialog(SalesPersonSearch, self.app.conn)

    def _open_purchase_search(self):
        self.app.run_dialog(_PurchasedItemsSearch, self.app.conn)

    def _open_annual_sales(self):
        self.app.run_dialog(SalesChart, self.app.conn)

    def _open_annual_payments(self):
        self.app.run_dialog(PaymentsChart, self.app.conn)

    def _open_receivable_per_client(self):
        self.app.run_dialog(InPaymentsTotalByClient, self.app.conn)

    def _open_product_revenue(self):
        self.app.run_dialog(ProductsRevenueSearch, self.app.conn)


class FinancialTasks(Tasks):
    def add_defaults(self):
        items = [
            (_('Delayed Receivable'), 'delayed_receivable', STOQ_DELAYED_RECEIVABLE),
            (_('Delayed Payable'), 'delayed_payable', STOQ_DELAYED_PAYABLE),
            (_('Search for Commissions'), 'commisions', STOQ_COMISSION),
            (_('Grafico de Vendas Anual'), 'annual_sales', STOQ_GRAPHIC),
            (_('Historico de Pagamentos'), 'annual_payments', STOQ_SALES_APP),
            (_('A receber por Cliente'), 'receivable_per_client', STOQ_PAYABLE_APP)
        ]

        for label, name, pixbuf, in items:
            self.add_item(label, name, pixbuf)


class PeopleTasks(Tasks):
    def add_defaults(self):
        items = [
            # people
            (_('Birthdays'), 'birthday_person', STOQ_CHECKLIST),
            (_('Client Search'), 'clients', STOQ_CLIENTS),
            (_('Search for Sales'), 'sale_search', STOQ_SALES_APP),
            (_('SalesPerson Search'), 'salesperson_search', STOQ_CLIENTS)]

        for label, name, pixbuf in items:
            self.add_item(label, name, pixbuf)


class ProductAndServiceTasks(Tasks):
    def add_defaults(self):
        items = [
            # products and services
            (_('Service Sold History'), 'service_sold_history', STOQ_CALENDAR_APP),
            (_('Product Sold History'), 'product_sold_history', STOQ_CALENDAR_APP),
            (_('Product History'), 'product_history', STOQ_HR),
            (_('Itens de estoque'), 'product_stock', STOQ_STOCK_APP),
            (_('Itens de compra'), 'purchase_search', STOQ_PURCHASE_APP),
            (_('Custo de Mercadoria Vendida'), 'cmv', STOQ_STOCK_APP)
        ]

        for label, name, pixbuf in items:
            self.add_item(label, name, pixbuf)


class ReportApp(AppWindow):
    app_name = _('Reports')
    gladefile = "report"
    embedded = True

    #
    # Application
    #

    def create_actions(self):
        group = get_accels('app.admin')
        actions = [
        ]
        self.report_ui = self.add_ui_actions('', actions,
                                             filename='report.xml')
        self.set_help_section(_("Admin help"), 'app-admin')

    def create_ui(self):
        # all reports
        self.tasks = Tasks(self)
        self.tasks.set_model(self.model)
        self.tasks.add_defaults()
        self.model.set_sort_column_id(COL_NAME, gtk.SORT_ASCENDING)

        self._setup_iconview(self.tasks, self.iconview, self.model)

        # people reports
        self.peopletasks = PeopleTasks(self)
        p_model = gtk.ListStore(str, str, gtk.gdk.Pixbuf)
        self.peopletasks.set_model(p_model)
        self.peopletasks.add_defaults()
        p_model.set_sort_column_id(COL_NAME, gtk.SORT_ASCENDING)

        self._setup_iconview(self.peopletasks, self.people_iconview, p_model)

        # financial report
        self.financialtasks = FinancialTasks(self)
        f_model = gtk.ListStore(str, str, gtk.gdk.Pixbuf)
        self.financialtasks.set_model(f_model)
        self.financialtasks.add_defaults()
        f_model.set_sort_column_id(COL_NAME, gtk.SORT_ASCENDING)

        self._setup_iconview(self.financialtasks, self.financial_iconview, f_model)

        # product and service report
        self.prodandservicetasks = ProductAndServiceTasks(self)
        ps_model = gtk.ListStore(str, str, gtk.gdk.Pixbuf)
        self.prodandservicetasks.set_model(ps_model)
        self.prodandservicetasks.add_defaults()
        ps_model.set_sort_column_id(COL_NAME, gtk.SORT_ASCENDING)

        self._setup_iconview(self.prodandservicetasks, self.prod_serv_iconview, ps_model)

    def _setup_iconview(self, tasks, iconview, model):
        iconview.set_model(model)
        iconview.set_text_column(COL_LABEL)
        iconview.set_pixbuf_column(COL_PIXBUF)
        iconview.connect('item-activated', tasks.on_item_activated)
        iconview.select_path(model[0].path)

    def activate(self, params):
        for widget in (self.app.launcher.Print, self.app.launcher.ExportCSV,
                       self.app.launcher.SearchMenu, self.app.launcher.SearchToolItem,
                       self.app.launcher.SearchToolMenu, self.app.launcher.NewWindow,
                       self.app.launcher.NewToolItem, self.app.launcher.FileMenuNew,
                       self.app.launcher.NewMenu, self.app.launcher.NewToolMenu,
                       self.app.launcher.HelpMenu, self.app.launcher.HelpAbout,
                       self.app.launcher.EditMenu):
            widget.set_visible(False)

    def deactivate(self):
        for widget in (self.app.launcher.Print, self.app.launcher.ExportCSV,
                       self.app.launcher.SearchMenu, self.app.launcher.SearchToolItem,
                       self.app.launcher.SearchToolMenu, self.app.launcher.NewWindow,
                       self.app.launcher.NewToolItem, self.app.launcher.FileMenuNew,
                       self.app.launcher.NewMenu, self.app.launcher.NewToolMenu,
                       self.app.launcher.HelpMenu, self.app.launcher.HelpAbout,
                       self.app.launcher.EditMenu):
            widget.set_visible(True)
        self.uimanager.remove_ui(self.report_ui)

    def setup_focus(self):
        self.iconview.grab_focus()

    def new_activate(self):
        pass

    def search_activate(self):
        self.tasks.run_task('users')

        # Private

        #
        # Callbacks
        #

        # Search
