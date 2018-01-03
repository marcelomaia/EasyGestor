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
## Author(s): Stoq Team <stoq-devel@async.com.br>
##
""" Search dialog for books """

from decimal import Decimal

from kiwi.datatypes import currency
from kiwi.enums import SearchFilterPosition
from kiwi.ui.objectlist import SearchColumn
from kiwi.ui.search import ComboSearchFilter
from stoqlib.domain.sellable import Sellable
from stoqlib.gui.search.productsearch import ProductSearch
from stoqlib.lib.formatters import format_quantity, get_formatted_cost
from stoqlib.lib.translation import stoqlib_gettext as _

from booksdomain import ProductBookFullStockView


class ProductBookSearch(ProductSearch):
    title = _('Book Search')
    search_table = ProductBookFullStockView

    def _setup_widgets(self):
        if not self.hide_cost_column:
            column = 'cost'
        elif not self.hide_price_column:
            column = 'price'
        self.search.set_summary_label(
            column, label=_(u'<b>Total:</b>'), format='<b>%s</b>')

    #
    # SearchDialog Hooks
    #

    def create_filters(self):
        self._setup_widgets()
        self.set_text_field_columns(['description', 'barcode',
                                     'category_description', 'author',
                                     'publisher', 'isbn'])
        self.executer.set_query(self.executer_query)

        # Branch
        branch_filter = self.create_branch_filter(_('In branch:'))
        branch_filter.select(None)
        self.add_filter(branch_filter, columns=[])
        self.branch_filter = branch_filter

        # Status
        statuses = [(desc, id) for id, desc in Sellable.statuses.items()]
        statuses.insert(0, (_('Any'), None))
        status_filter = ComboSearchFilter(_('with status:'), statuses)
        status_filter.select(None)
        self.add_filter(status_filter, columns=['status'],
                        position=SearchFilterPosition.TOP)

    #
    # SearchEditor Hooks
    #

    def get_columns(self):
        cols = [SearchColumn('barcode', title=_('Barcode'), data_type=str,
                             sorted=True, width=130),
                SearchColumn('code', title=_('Code'), data_type=str,
                             visible=False),
                SearchColumn('category_description', title=_(u'Category'),
                             data_type=str, width=100),
                SearchColumn('subject', title=_(u'Subject'), data_type=str),
                SearchColumn('description', title=_(u'Title'),
                             expand=True, data_type=str),
                SearchColumn('author', title=_(u'Author'),
                             expand=True, data_type=str),
                SearchColumn('publisher', title=_(u'Publisher'),
                             expand=True, data_type=str),
                SearchColumn('isbn', title=_(u'ISBN'), data_type=str),
                SearchColumn('volume', title=_(u'Volume'), data_type=str,
                             visible=False),
                SearchColumn('series', title=_(u'Series'), data_type=str,
                             visible=False),
                SearchColumn('language', title=_(u'Language'), data_type=str,
                             visible=False),
                SearchColumn('location', title=_("Location"), data_type=str,
                             width=100, visible=False),
                SearchColumn('stock', title=_('Quantity'),
                             data_type=Decimal, width=100),
                SearchColumn('base_price', title=_('Price'),
                             data_type=currency, width=100),
                SearchColumn('total_expected', title=_('Total esperado'),
                             data_type=currency, width=120),
                SearchColumn('unit', title=_("Unit"), data_type=str,
                             width=40, visible=False),
                SearchColumn('minimum', title=_(u"Mínimo"), data_type=float,
                             width=90, visible=True, searchable=False),
                SearchColumn('maximum', title=_(u"Máximo"), data_type=float,
                             width=90, visible=True, searchable=False)]
        # The price/cost columns must be controlled by hide_cost_column and
        # hide_price_column. Since the product search will be available across
        # the applications, it's important to restrict such columns depending
        # of the context.
        if not self.hide_cost_column:
            cols.append(SearchColumn('cost', _('Cost'), data_type=currency,
                                     format_func=get_formatted_cost, width=90))
        if not self.hide_price_column:
            cols.append(SearchColumn('price', title=_('Price'),
                                     data_type=currency, width=90))

        cols.append(SearchColumn('stock', title=_('Stock Total'),
                                 format_func=format_quantity,
                                 data_type=Decimal, width=100))
        return cols
