# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2006-2007 Async Open Source <http://www.async.com.br>
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
""" Search dialogs for services """
from decimal import Decimal
import gtk
import datetime

from kiwi.db.query import DateQueryState, DateIntervalQueryState
import pango
from kiwi.argcheck import argcheck
from kiwi.datatypes import currency
from kiwi.enums import SearchFilterPosition
from kiwi.ui.objectlist import SearchColumn, ObjectList, Column
from kiwi.ui.search import ComboSearchFilter, DateSearchFilter, Today
from kiwi.ui.views import SlaveView
from kiwi.ui.widgets.contextmenu import ContextMenu, ContextMenuItem
from stoqlib.domain.person import PersonAdaptToBranch
from stoqlib.domain.sale import Sale, SaleItem
from stoqlib.domain.views import SoldServiceView
from stoqlib.gui.base.dialogs import get_current_toplevel, run_dialog
from stoqlib.gui.dialogs.csvexporterdialog import CSVExporterDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.defaults import sort_sellable_code
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.domain.sellable import Sellable
from stoqlib.domain.service import Service, ServiceView
from stoqlib.reporting.product import ProductsSoldReport
from stoqlib.reporting.service import ServiceReport, ServicePriceReport
from stoqlib.gui.base.gtkadds import change_button_appearance
from stoqlib.gui.base.search import SearchEditor, SearchDialogPrintSlave, SearchDialog
from stoqlib.gui.editors.serviceeditor import ServiceEditor
from stoqlib.gui.printing import print_report
from stoqlib.database.orm import AND

_ = stoqlib_gettext


class ServiceSoldSearch(SearchDialog):
    title = _('Pesquisa de serviços vendidos')
    size = (850, 450)
    table = search_table = SoldServiceView
    advanced_search = False

    def __init__(self, conn):
        super(ServiceSoldSearch, self).__init__(conn)
        self.history_button = self.add_button('Historico', gtk.STOCK_ABOUT)
        self.history_button.connect('clicked', self.product_history_selected)
        self.history_button.show()

    def on_print_button_clicked(self, button):
        print_report(ProductsSoldReport, self.results, list(self.results),
                     filters=self.search.get_search_filters())

    #
    # SearchDialog Hooks
    #

    def _setup_context_menu(self):
        menu = ContextMenu()

        item = ContextMenuItem(_('History'), gtk.STOCK_ABOUT)
        item.connect('activate', self.product_history_selected)
        menu.append(item)

        self.results.set_context_menu(menu)
        menu.show_all()

    def product_history_selected(self, context):
        service_item_view = self.results.get_selected()
        if service_item_view:
            saleitems = SaleItem.select(AND(SaleItem.q.saleID == Sale.q.id,
                                            SaleItem.q.sellableID == service_item_view.id,
                                            Service.q.sellableID == service_item_view.id))
            run_dialog(ServiceHistoryView, get_current_toplevel(), saleitems, self.conn)

    def create_filters(self):
        self.set_text_field_columns(['description'])
        self.executer.set_query(self.executer_query)

        # Date
        date_filter = DateSearchFilter(_('Date:'))
        date_filter.select(Today)
        self.add_filter(date_filter)
        self.date_filter = date_filter

        # Branch
        branch_filter = self.create_branch_filter(_('In branch:'))
        branch_filter.select(None)
        self.add_filter(branch_filter, columns=[],
                        position=SearchFilterPosition.TOP)
        self.branch_filter = branch_filter

    def executer_query(self, query, having, conn):
        # We have to do this manual filter since adding this columns to the
        # view would also group the results by those fields, leading to
        # duplicate values in the results.
        branch = self.branch_filter.get_state().value
        if branch is not None:
            branch = PersonAdaptToBranch.get(branch, connection=conn)

        date = self.date_filter.get_state()
        if isinstance(date, DateQueryState):
            date = date.date
        elif isinstance(date, DateIntervalQueryState):
            date = (date.start, date.end)

        return self.table.select_by_branch_date(query, branch, date,
                                           connection=conn)
    #
    # SearchEditor Hooks
    #
    def format_data(self, data):
        # must return zero or report printed show None instead of 0
        if data is None:
            return 0
        return format_quantity(data)

    def get_columns(self):
        return [Column('code', title=_('Code'), data_type=str,
                       sorted=True, width=130),
                Column('description', title=_('Description'), data_type=str,
                       width=300),
                Column('quantity', title=_('Sold'),
                       format_func=self.format_data,
                       data_type=Decimal),
                Column('average_price', title=_('Preço médio'),
                       data_type=currency),
               ]


class _ServiceSearch(SearchDialog):
    title = _('Service Search')
    size = (-1, 450)
    search_table = ServiceView

    def __init__(self, conn):
        super(_ServiceSearch, self).__init__(conn)
        self._setup_context_menu()

    def create_filters(self):
        self.set_text_field_columns(['description', 'barcode'])
        items = [(v, k) for k, v in Sellable.statuses.items()]
        items.insert(0, (_('Any'), None))
        service_filter = ComboSearchFilter(_('Show services'),
                                           items)
        service_filter.select(None)
        self.add_filter(service_filter, SearchFilterPosition.TOP, ['status'])

    def service_history_selected(self, context):
        service_view = self.results.get_selected()
        saleitems = SaleItem.select(AND(SaleItem.q.saleID == Sale.q.id,
                                        SaleItem.q.sellableID == service_view.id,
                                        Service.q.sellableID == service_view.id))
        run_dialog(ServiceHistoryView, get_current_toplevel(), saleitems, self.conn)

    def _setup_context_menu(self):
        menu = ContextMenu()

        item = ContextMenuItem(_('History'), gtk.STOCK_ABOUT)
        item.connect('activate', self.service_history_selected)
        menu.append(item)

        self.results.set_context_menu(menu)
        menu.show_all()

    def get_columns(self):
        columns = [SearchColumn('code', title=_('Code'), data_type=str, sorted=True,
                                sort_func=sort_sellable_code, width=130),
                   SearchColumn('barcode', title=_('Barcode'), data_type=str,
                                visible=True, width=130),
                   SearchColumn('description', title=_('Description'),
                                data_type=str, expand=True),
                   SearchColumn('cost', _('Cost'), data_type=currency,
                                    width=80),
                   SearchColumn('price', title=_('Price'),
                                    data_type=currency, width=80)]

        return columns

    def setup_widgets(self):
        self.csv_button = self.add_button(label=_(u'Export CSV...'))
        self.csv_button.connect('clicked', self._on_export_csv_button__clicked)
        self.csv_button.show()
        self.csv_button.set_sensitive(False)
        self.results.connect('has_rows', self._on_results__has_rows)

    def _update_widgets(self, payment_view):
        pass

    def _on_export_csv_button__clicked(self, widget):
        run_dialog(CSVExporterDialog, get_current_toplevel(), self.conn, self.search_table,
                   self.results)

    #
    # Callbacks
    #
    def _on_results__has_rows(self, widget, has_rows):
        self.csv_button.set_sensitive(has_rows)

    def _on_results__selection_changed(self, results, payment_view):
        self._update_widgets(payment_view)


class ServiceSearch(SearchEditor):
    title = _('Service Search')
    table = Service
    search_table = ServiceView
    size = (-1, 450)
    editor_class = ServiceEditor
    model_list_lookup_attr = 'service_id'
    footer_ok_label = _('Add services')
    searchbar_result_strings = (_('service'), _('services'))

    def __init__(self, conn, hide_footer=True, hide_toolbar=False,
                 selection_mode=gtk.SELECTION_BROWSE,
                 hide_cost_column=False, use_product_statuses=None,
                 hide_price_column=False):
        self.hide_cost_column = hide_cost_column
        self.hide_price_column = hide_price_column
        self.use_product_statuses = use_product_statuses
        SearchEditor.__init__(self, conn, hide_footer=hide_footer,
                              hide_toolbar=hide_toolbar,
                              selection_mode=selection_mode)
        self.set_searchbar_labels(_('matching'))
        self._setup_print_slave()
        self._setup_context_menu()

    def _setup_context_menu(self):
        menu = ContextMenu()

        item = ContextMenuItem(_('History'), gtk.STOCK_ABOUT)
        item.connect('activate', self.service_history_selected)
        menu.append(item)

        self.results.set_context_menu(menu)
        menu.show_all()

    def service_history_selected(self, context):
        service_view = self.results.get_selected()
        saleitems = SaleItem.select(AND(SaleItem.q.saleID == Sale.q.id,
                                        SaleItem.q.sellableID == service_view.id,
                                        Service.q.sellableID == service_view.id))
        self.run_dialog(ServiceHistoryView, get_current_toplevel(), saleitems, self.conn)

    def _setup_print_slave(self):
        self._print_slave = SearchDialogPrintSlave()
        change_button_appearance(self._print_slave.print_price_button,
                                 gtk.STOCK_PRINT, _("Price table"))
        self.attach_slave('print_holder', self._print_slave)
        self._print_slave.connect('print', self.on_print_price_button_clicked)
        self._print_slave.print_price_button.set_sensitive(False)
        self.results.connect('has-rows', self._has_rows)

    def _has_rows(self, results, obj):
        SearchEditor._has_rows(self, results, obj)
        self._print_slave.print_price_button.set_sensitive(obj)

    #
    # SearchDialog Hooks
    #

    def create_filters(self):
        self.set_text_field_columns(['description', 'barcode'])
        items = [(v, k) for k, v in Sellable.statuses.items()]
        items.insert(0, (_('Any'), None))
        service_filter = ComboSearchFilter(_('Show services'),
                                          items)
        service_filter.select(None)
        self.executer.add_query_callback(self._get_query)
        self.add_filter(service_filter, SearchFilterPosition.TOP, ['status'])

    #
    # SearchEditor Hooks
    #

    @argcheck(ServiceView)
    def get_editor_model(self, model):
        return Service.get(model.service_id, connection=self.conn)

    def get_columns(self):
        columns = [SearchColumn('code', title=_('Code'), data_type=str, sorted=True,
                                sort_func=sort_sellable_code, width=130),
                   SearchColumn('barcode', title=_('Barcode'), data_type=str,
                                visible=True, width=130),
                   SearchColumn('description', title=_('Description'),
                                data_type=str, expand=True)]

        if not self.hide_cost_column:
            columns.append(SearchColumn('cost', _('Cost'), data_type=currency,
                                        width=80))

        if not self.hide_price_column:
            columns.append(SearchColumn('price', title=_('Price'),
                                        data_type=currency, width=80))

        return columns

    def _get_query(self, states):
        return ServiceView.q.service_id is not None

    def on_print_button_clicked(self, button):
        print_report(ServiceReport, self.results, list(self.results),
                     filters=self.search.get_search_filters())

    def on_print_price_button_clicked(self, button):
        print_report(ServicePriceReport, list(self.results),
                     filters=self.search.get_search_filters())


class SalesListSlave(SlaveView):
    def __init__(self, sale_items):
        self.info = ObjectList([Column('sale.id', data_type=str, title=_('#'), sorted=True),
                                Column('sale.client.person.name', data_type=str, title=_('Client'), format_func=self.format_client,
                                       ellipsize=pango.ELLIPSIZE_END),
                                Column('sale.salesperson.person.name', data_type=str, title=_('Salesperson'),
                                       format_func=self.format_client),
                                Column('price', title=_('Price'), data_type=currency),
                                Column('quantity', title=_('Quantity'), data_type=Decimal),
                                Column('sale.status', data_type=str, title=_('Status'),
                                       format_func=Sale.get_status_name),
                                Column('sale.branch.person.name', data_type=str, title=_('Branch'), format_func=self.format_client),
                                Column('sale.open_date', data_type=datetime.datetime, title=_('Open Date:')),
                                Column('sale.close_date', data_type=datetime.datetime, title=_('Close Date:'))])
        for si in sale_items:
            self.info.append(si)  # the core
        SlaveView.__init__(self, self.info)

    def format_client(self, arg):
        if not arg:
            return _(u'Not Specified')
        return arg


class ServiceHistoryView(BaseEditor):
    gladefile = 'HolderTemplate'
    model_type = SaleItem
    title = 'Histórico do serviço'
    size = (500, 300)
    hide_footer = True

    def __init__(self, sale_items, conn):
        """
            """
        super(ServiceHistoryView, self).__init__(conn, sale_items[0])
        self.sale_items_slave = SalesListSlave(sale_items)
        self.sale_items_slave.show()
        self.attach_slave('place_holder', self.sale_items_slave)
        self.setup_widgets()
        self.sale_items = sale_items

    def create_model(self, trans):
        return SaleItem(connection=self.conn,
                        coupon_id=0)

    def get_title(self, model):
        return 'Histórico do serviço %s' % self.model.sellable.description

    def setup_widgets(self):
        self.csv_button = self.add_button(label=_(u'Export CSV...'))
        self.csv_button.connect('clicked', self._on_export_csv_button__clicked)
        self.csv_button.show()
        self.csv_button.set_sensitive(True)

    def _on_export_csv_button__clicked(self, widget):
        run_dialog(CSVExporterDialog, get_current_toplevel(), self.conn,
                   self.model_type, self.sale_items_slave.info)
    #
    # Callbacks
    #
    def _on_results__has_rows(self, widget, has_rows):
        self.csv_button.set_sensitive(has_rows)


class ServiceHistoryView2(SearchDialog):
    title = 'Histórico do serviço'
    search_table = SaleItem

    def __init__(self, conn, items, service_view):
        self.service_view = service_view

        super(ServiceHistoryView2, self).__init__(conn)

    def create_filters(self):
        self.set_text_field_columns(['notes'])

    def executer_query(self, query, having, conn):
        # We have to do this manual filter since adding this columns to the
        # view would also group the results by those fields, leading to
        # duplicate values in the results.
        return SaleItem.select(AND(SaleItem.q.saleID == Sale.q.id,
                                   SaleItem.q.sellableID == self.service_view.id,
                                   Service.q.sellableID == self.service_view.id))

    def get_columns(self):
        columns = [Column('sale.id', data_type=str, title=_('#'), width=200, sorted=True),
                   Column('sale.client', data_type=str, title=_('Client'), format_func=self.format_client,
                          ellipsize=pango.ELLIPSIZE_END, width=300),
                   Column('sale.salesperson', data_type=str, title=_('Salesperson'), width=200,
                          format_func=self.format_client),
                   Column('price', title=_('Price'), width=200,
                          data_type=currency),
                   Column('quantity', title=_('Quantity'), width=200,
                          data_type=Decimal),
                   Column('sale.branch', data_type=str, title=_('Branch'), width=200,
                          format_func=self.format_client),
                   Column('sale.open_date', data_type=datetime.datetime, title=_('Open Date:'),
                          width=200),
                   Column('sale.close_date', data_type=datetime.datetime, title=_('Close Date:'),
                          width=200)]

        return columns

    def setup_widgets(self):
        self.csv_button = self.add_button(label=_(u'Export CSV...'))
        self.csv_button.connect('clicked', self._on_export_csv_button__clicked)
        self.csv_button.show()
        self.csv_button.set_sensitive(False)
        self.results.connect('has_rows', self._on_results__has_rows)

    def _update_widgets(self, payment_view):
        pass

    def _on_export_csv_button__clicked(self, widget):
        run_dialog(CSVExporterDialog, get_current_toplevel(), self.conn, self.search_table,
                   self.results)

    #
    # Callbacks
    #
    def _on_results__has_rows(self, widget, has_rows):
        self.csv_button.set_sensitive(has_rows)

    def _on_results__selection_changed(self, results, payment_view):
        self._update_widgets(payment_view)

    def format_client(self, arg):
        if not arg:
            return _(u'Not Specified')
        return arg.person.name