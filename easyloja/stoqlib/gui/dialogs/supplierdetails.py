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
""" Classes for supplier details """

import datetime

import gtk
from decimal import Decimal

from kiwi.enums import SearchFilterPosition
from kiwi.python import Settable
from kiwi.ui.objectlist import Column, ColoredColumn, SearchColumn
from kiwi.datatypes import currency
from kiwi.ui.widgets.list import SummaryLabel
from sqlobject.viewable import ViewableSelectResults

from stoqlib.api import api
from stoqlib.domain.interfaces import ISupplier
from stoqlib.domain.purchase import PurchaseOrder, PurchaseItem
from stoqlib.domain.sellable import Sellable
from stoqlib.gui.base.search import SearchDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.gui.editors.personeditor import SupplierEditor
from stoqlib.gui.wizards.personwizard import run_person_role_dialog
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.defaults import payment_value_colorize

from stoqlib.database.orm import Viewable, const, INNERJOINOn, AND, LIKE, func

_ = stoqlib_gettext


class ProductsPerSupplierView(Viewable):

    columns = dict(id=Sellable.q.id,
                   code=Sellable.q.code,
                   description=Sellable.q.description,
                   branch=PurchaseOrder.q.branchID,
                   qty=const.SUM(PurchaseItem.q.quantity),
                   total_value=const.COALESCE(const.SUM(PurchaseItem.q.quantity *
                                                  PurchaseItem.q.cost), 0)
                   )
    joins = [
        INNERJOINOn(None, PurchaseItem,
                    PurchaseItem.q.orderID == PurchaseOrder.q.id),
        INNERJOINOn(None, Sellable, Sellable.q.id == PurchaseItem.q.sellableID)
    ]

    hidden_columns = ['branch']

    @classmethod
    def select(cls, clause=None, clauseTables=None,
               orderBy='qty', limit=None,
               lazyColumns=False, reversed=True,
               distinct=False, connection=None,
               join=None, columns=None, having=None):
        if cls.clause:
            if clause:
                clause = AND(clause, cls.clause)
            else:
                clause = cls.clause
        if columns:
            cls.columns.update(columns)

        return ViewableSelectResults(cls, clause,
                                     clauseTables=clauseTables,
                                     orderBy=orderBy,
                                     limit=limit,
                                     lazyColumns=lazyColumns,
                                     reversed=reversed,
                                     distinct=distinct,
                                     connection=connection,
                                     join=cls.joins,
                                     having=having,
                                     ns=cls.columns)


class SupplierProductsSearchSlave(SearchDialog):

    table = PurchaseOrder
    search_table = ProductsPerSupplierView

    def __init__(self, conn, supplier):
        self.supplier = supplier
        SearchDialog.__init__(self, conn)

    def create_filters(self):
        primary_filter = self.search.get_primary_filter()
        self.executer.add_filter_query_callback(primary_filter,
                                                self._get_supplier_query)
        branch_filter = self.create_branch_filter(_('In branch:'))
        self.add_filter(branch_filter, columns=['branch'],
                        position=SearchFilterPosition.TOP)

    def _get_supplier_query(self, state):
        text = '%%%s%%' % state.text.lower()
        return AND(PurchaseOrder.q.supplierID == self.supplier.id,
                   LIKE(func.LOWER(Sellable.q.description), text))

    def get_columns(self):
        return [SearchColumn("code", title=_("Code"), data_type=str, width=60),
                Column("description", title=_("Description"), data_type=str,
                       expand=True, searchable=True),
                Column("qty", title=_("Total quantity"),
                       data_type=Decimal, width=80, format_func=format_quantity),
                Column("total_value", title=_("Total value"), width=90,
                       data_type=currency, justify=gtk.JUSTIFY_RIGHT, )]


class SupplierDetailsDialog(BaseEditor):
    """This dialog shows some important details about suppliers like:
        - history of purchases
        - all products tied with purchases
        - all payments already created
    """
    title = _(u"Supplier Details")
    hide_footer = True
    size = (880, 400)
    model_iface = ISupplier
    gladefile = "SupplierDetailsDialog"
    proxy_widgets = ('supplier',
                     'last_purchase_date',
                     'status')

    def __init__(self, conn, model):
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()

    def _build_data(self, purchases):
        self.payments = []
        product_dict = {}
        for purchase_view in purchases:
            purchase = PurchaseOrder.get(purchase_view.id, connection=self.conn)
            self.payments.extend(purchase.payments)
            for purchase_item in purchase.get_items():
                qty = purchase_item.quantity
                cost = purchase_item.cost
                total_value = cost * qty
                unit = purchase_item.sellable.get_unit_description()
                qty_str = '%s %s' % (qty, unit)
                product_codes = [item.code for item in product_dict.values()]
                sellable = purchase_item.sellable
                if not sellable.code in product_codes:
                    desc = sellable.description
                    obj = Settable(code=sellable.code, description=desc,
                                   _total_qty=qty, total_value=total_value,
                                   qty_str=qty_str, unit=unit, cost=cost)
                    product_dict[sellable] = obj
                else:
                    product_dict[sellable]._total_qty += qty
                    table = product_dict[sellable]
                    table.qty_str = '%s %s' % (table._total_qty, table.unit)
                    table.total_value = table._total_qty * table.cost
        self.products = product_dict.values()

    def _setup_widgets(self):
        self.purchases_list.set_columns(self._get_purchase_columns())
        self.payments_list.set_columns(self._get_payments_columns())

        purchases = self.model.get_supplier_purchases()
        self.purchases_list.add_list(purchases)

        self._build_data(purchases)
        self.payments_list.add_list(self.payments)

        value_format = '<b>%s</b>'
        total_label = "<b>%s</b>" % _("Total:")
        purchases_summary_label = SummaryLabel(klist=self.purchases_list,
                                              column='total',
                                              label=total_label,
                                              value_format=value_format)

        purchases_summary_label.show()
        self.purchases_vbox.pack_start(purchases_summary_label, False)

        self._products_slave = SupplierProductsSearchSlave(self.conn, self.model)
        self.attach_slave('products_holder', self._products_slave)

    def _get_purchase_columns(self):
        return [Column("id", title=_("#"),
                       data_type=int, justify=gtk.JUSTIFY_RIGHT,
                       format='%04d', width=90, sorted=True),
                Column("open_date", title=_("Date"), data_type=datetime.date,
                       justify=gtk.JUSTIFY_RIGHT, width=80),
                Column("status_str", title=_("Status"), width=80,
                      data_type=str),
                Column("total", title=_("Total"), justify=gtk.JUSTIFY_RIGHT,
                       data_type=currency, width=100)]

    def _get_payments_columns(self):
        return [Column("id", title=_("#"),
                       data_type=int, justify=gtk.JUSTIFY_RIGHT,
                       format='%04d', width=50),
                Column("method.description", title=_("Type"),
                       data_type=str, width=90),
                Column("description", title=_("Description"),
                       data_type=str, searchable=True, width=190,
                       expand=True),
                Column("due_date", title=_("Due date"), width=110,
                       data_type=datetime.date, sorted=True),
                Column("status_str", title=_("Status"), width=80,
                       data_type=str),
                ColoredColumn("base_value", title=_("Value"),
                              justify=gtk.JUSTIFY_RIGHT, data_type=currency,
                              color='red', width=100,
                              data_func=payment_value_colorize),
                Column("days_late", title=_("Days Late"), width=110,
                       format_func=(lambda days_late: days_late and
                                    str(days_late) or u""),
                       justify=gtk.JUSTIFY_RIGHT, data_type=str)]

    #
    # BaseEditor Hooks
    #

    def setup_proxies(self):
        self.add_proxy(self.model, self.proxy_widgets)

    #
    # Callbacks
    #

    def on_further_details_button__clicked(self, *args):
        trans = api.new_transaction()
        run_person_role_dialog(SupplierEditor, self, trans,
                               self.model, visual_mode=True)
        api.finish_transaction(trans, False)
