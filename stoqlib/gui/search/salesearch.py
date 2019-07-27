# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2007 Async Open Source <http://www.async.com.br>
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
""" Search dialogs for sale objects """

import datetime
import gtk
from decimal import Decimal

import pango
from kiwi.datatypes import currency
from kiwi.db.query import DateQueryState, DateIntervalQueryState
from kiwi.enums import SearchFilterPosition
from kiwi.ui.objectlist import SearchColumn, Column
from kiwi.ui.search import ComboSearchFilter, DateSearchFilter
from stoqlib.domain.person import PersonAdaptToBranch, SalesPersonView
from stoqlib.domain.sale import Sale, SaleView, DeliveryView
from stoqlib.domain.views import SoldItemsByBranchView
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.search import SearchDialog, SearchEditor
from stoqlib.gui.dialogs.csvexporterdialog import CSVExporterDialog
from stoqlib.gui.dialogs.salespersondetails import SalesPersonDetailsDialog
from stoqlib.gui.printing import print_report
from stoqlib.gui.search.personsearch import BasePersonSearch
from stoqlib.gui.slaves.saleslave import SaleListToolbar
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.reporting.sale import SoldItemsByBranchReport

_ = stoqlib_gettext


class SaleSearch(SearchDialog):
    title = _("Search for Sales")
    size = (-1, 450)
    search_table = SaleView
    searching_by_date = True

    #
    # SearchDialog Hooks
    #

    def create_filters(self):
        self.set_text_field_columns(['client_name', 'salesperson_name'])
        self.set_searchbar_labels(_('matching:'))
        items = [(value, key) for key, value in Sale.statuses.items()]
        items.insert(0, (_('Any'), None))

        # Date
        date_filter = DateSearchFilter(_('Date Started'))
        date_filter.mode.select_item_by_position(1)
        self.add_filter(date_filter, columns=['open_date'])

        status_filter = ComboSearchFilter(_('Show sales with status'), items)
        self.add_filter(status_filter, SearchFilterPosition.TOP, ['status'])

    def get_columns(self):
        return [SearchColumn('id', title=_('#'), width=50, data_type=int,
                             sorted=True, order=gtk.SORT_DESCENDING),
                SearchColumn('open_date', title=_('Date Started'), width=110,
                             data_type=datetime.date, justify=gtk.JUSTIFY_RIGHT),
                SearchColumn('client_name', title=_('Client'),
                             data_type=str, expand=True,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('salesperson_name', title=_('Salesperson'),
                             data_type=str, width=150),
                SearchColumn('total_quantity', title=_('Items'),
                             data_type=Decimal, width=60,
                             format_func=format_quantity),
                SearchColumn('total', title=_('Total'), data_type=currency,
                             width=90)]

    def setup_widgets(self):
        self._sale_toolbar = SaleListToolbar(self.conn, self.results, self)
        self._sale_toolbar.connect('sale-returned', self._on_sale__returned)
        self._sale_toolbar.update_buttons()
        self.attach_slave("extra_holder", self._sale_toolbar)
        self.results.connect(
            'selection-changed', self._on_results__selection_changed)

        self.search.set_summary_label('total', label=_(u'Total:'),
                                      format='<b>%s</b>')

    def _update_widgets(self, sale_view):
        if sale_view is None:
            return

        sale = sale_view.sale
        can_return = sale.can_return() or sale.can_cancel()
        self._sale_toolbar.return_sale_button.set_sensitive(can_return)

    #
    # Callbacks
    #

    def _on_results__selection_changed(self, results, sale_view):
        self._update_widgets(sale_view)

    def _on_sale__returned(self, slave, sale_returned):
        if sale_returned:
            self._update_widgets(self.results.get_selected())


class _SaleSearch(SaleSearch):
    def setup_widgets(self):
        self._sale_toolbar = SaleListToolbar(self.conn, self.results, self)
        self._sale_toolbar.return_sale_button.hide()
        self._sale_toolbar.update_buttons()
        self.attach_slave("extra_holder", self._sale_toolbar)
        self.results.connect(
            'selection-changed', self._on_results__selection_changed)

        self.search.set_summary_label('total', label=_(u'Total:'),
                                      format='<b>%s</b>')


class DeliverySearch(SearchDialog):
    title = _(u'Delivery Search')
    table = search_table = DeliveryView
    searching_by_date = True
    size = (750, 450)

    def create_filters(self):
        self.set_text_field_columns(['description'])
        self.set_searchbar_labels(_('Items matching:'))

    def get_columns(self):
        return [SearchColumn('id', title=_('#'), data_type=int,
                             order=gtk.SORT_DESCENDING),
                SearchColumn('description', title=_('Item'),
                             data_type=str, expand=True),
                SearchColumn('client_name', title=_('Client'),
                             data_type=str,
                             ellipsize=pango.ELLIPSIZE_END,
                             visible=False),
                SearchColumn('address', title=_('Address'),
                             data_type=str, width=250,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('estimated_fix_date', title=_('Estimated'),
                             data_type=datetime.date, justify=gtk.JUSTIFY_RIGHT),
                SearchColumn('quantity', title=_('Qty'), data_type=Decimal,
                             format_func=format_quantity),
                ]


class SoldItemsByBranchSearch(SearchDialog):
    title = _(u'Sold Items by Branch')
    search_table = SoldItemsByBranchView
    searching_by_date = True
    size = (800, 450)

    def setup_widgets(self):
        self.csv_button = self.add_button(label=_(u'Export CSV...'))
        self.csv_button.connect('clicked', self._on_export_csv_button__clicked)
        self.csv_button.show()
        self.csv_button.set_sensitive(False)

        self.results.connect('has_rows', self._on_results__has_rows)
        self.search.set_summary_label('total', label=_(u'Tot.:'),
                                      format='<b>%s</b>')

    def create_filters(self):
        self.set_text_field_columns(['description'])
        self.set_searchbar_labels(_('Items matching:'))
        self.executer.set_query(self.executer_query)

        # Date
        date_filter = DateSearchFilter(_('Date:'))
        date_filter.mode.select_item_by_position(1)
        self.search.add_filter(date_filter)
        self.date_filter = date_filter

        # Branch
        branch_filter = self.create_branch_filter(_('In Branch:'))
        branch_filter.select(None)
        self.add_filter(branch_filter, columns=[])
        self.branch_filter = branch_filter

    def get_columns(self):
        return [SearchColumn('code', title=_('Code'), data_type=str,
                             sorted=True, order=gtk.SORT_DESCENDING),
                SearchColumn('description', title=_('Product'), data_type=str,
                             expand=True),
                SearchColumn('category', title=_('Category'), data_type=str,
                             visible=False),
                SearchColumn('client_category', title=_('Categoria da venda'), data_type=str),
                SearchColumn('branch_name', title=_('Branch'), data_type=str,
                             width=200),
                Column('quantity', title=_('Quantity'), data_type=Decimal,
                       format_func=format_quantity, width=100),
                Column('total', title=_('Total'), data_type=currency, width=80)
                ]

    def executer_query(self, query, having, conn):
        branch = self.branch_filter.get_state().value
        if branch is not None:
            branch = PersonAdaptToBranch.get(branch, connection=conn)

        date = self.date_filter.get_state()
        if isinstance(date, DateQueryState):
            date = date.date
        elif isinstance(date, DateIntervalQueryState):
            date = (date.start, date.end)

        return self.search_table.select_by_branch_date(query, branch, date,
                                                       connection=conn)

    def _print_report(self):
        print_report(SoldItemsByBranchReport, self.results, list(self.results),
                     filters=self.search.get_search_filters())

    #
    # Callbacks
    #

    def on_print_button_clicked(self, widget):
        self._print_report()

    def _on_export_csv_button__clicked(self, widget):
        run_dialog(CSVExporterDialog, get_current_toplevel(), self.conn, self.search_table,
                   self.results)

    def _on_results__has_rows(self, widget, has_rows):
        self.csv_button.set_sensitive(has_rows)


class SalesPersonSearch(BasePersonSearch):
    title = _('SalesPerson Search')
    table = SalesPersonView
    result_strings = _('salesperson'), _('salespersons')
    hide_toolbar = True
    size = (750, 400)

    def __init__(self, conn, **kwargs):
        SearchEditor.__init__(self, conn, hide_toolbar=True, **kwargs)

    #
    # SearchDialog hooks
    #

    def create_filters(self):
        self.set_text_field_columns(['name', 'email',
                                     'mobile_number', 'phone_number'])

    def get_columns(self):
        return [Column('name', title=_('Name'), data_type=str, width=90),
                SearchColumn('phone_number', title=_('Phone Number'), data_type=str, width=60),
                SearchColumn('mobile_number', title=_('Mobile Number'), data_type=str, width=60),
                SearchColumn('email', title=_('E-mail'), data_type=str, width=90)]

    #
    # Callbacks
    #

    def on_details_button_clicked(self, *args):
        selected = self.results.get_selected()
        run_dialog(SalesPersonDetailsDialog, get_current_toplevel(), self.conn, selected.sales_person)
