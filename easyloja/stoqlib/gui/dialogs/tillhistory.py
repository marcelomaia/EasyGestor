# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2007 Async Open Source <http://www.async.com.br>
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
""" Implementation of classes related to till operations.  """

import gtk

import datetime
from kiwi.datatypes import currency
from kiwi.enums import ListType
from kiwi.ui.objectlist import SearchColumn
from kiwi.ui.search import DateSearchFilter, Today
from kiwi.ui.widgets.list import Column, ColoredColumn
from stoqlib.api import api
from stoqlib.database.orm import INNERJOINOn, Viewable, LEFTJOINOn
from stoqlib.domain.fiscal import CfopData
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.payment.method import PaymentMethod, CreditCardData
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.person import PersonAdaptToBranch, PersonAdaptToSalesPerson, Person, PersonAdaptToCreditProvider
from stoqlib.domain.sale import Sale
from stoqlib.domain.station import BranchStation
from stoqlib.domain.till import Till, DailyFlow
from stoqlib.domain.till import TillEntry
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.gtkadds import change_button_appearance
from stoqlib.gui.base.lists import ModelListDialog
from stoqlib.gui.base.search import SearchDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.gui.editors.tilleditor import (CashAdvanceEditor, CashInEditor,
                                            CashOutEditor)
from stoqlib.gui.printing import print_report
from stoqlib.gui.stockicons import (STOQ_MONEY, STOQ_MONEY_ADD,
                                    STOQ_MONEY_REMOVE)
from stoqlib.lib.defaults import payment_value_colorize
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.reporting.till import TillHistoryReport

_ = stoqlib_gettext


class TillFiscalOperationsView(Viewable):
    """Stores informations about till payment tables

    @ivar date:         the date when the entry was created
    @ivar description:  the entry description
    @ivar value:        the entry value
    @ivar station_name: the value of name branch_station name column
    """
    columns = dict(
        id=TillEntry.q.id,
        date=TillEntry.q.date,
        description=TillEntry.q.description,
        value=TillEntry.q.value,
        cfop=CfopData.q.code,
        station_name=BranchStation.q.name,
        station_id=BranchStation.q.id,
        branch_id=PersonAdaptToBranch.q.id,
        status=Till.q.status,
        salesperson_name=Person.q.name,
        salesperson_id=PersonAdaptToSalesPerson.q.id,
        discount_value=Sale.q.discount_value,
        # payment data
        method_id=PaymentMethod.q.id,
        method_name=PaymentMethod.q.description,
        card_type=CreditCardData.q.card_type,
        card_provider_name=PersonAdaptToCreditProvider.q.short_name,
    )

    joins = [
        LEFTJOINOn(None, Till,
                   Till.q.id == TillEntry.q.tillID),
        LEFTJOINOn(None, Payment,
                   Payment.q.id == TillEntry.q.paymentID),
        LEFTJOINOn(None, PaymentMethod,
                   PaymentMethod.q.id == Payment.q.methodID),
        LEFTJOINOn(None, CreditCardData,
                   CreditCardData.q.paymentID == Payment.q.id),
        LEFTJOINOn(None, PersonAdaptToCreditProvider,
                   CreditCardData.q.providerID == PersonAdaptToCreditProvider.q.id),
        INNERJOINOn(None, BranchStation,
                    BranchStation.q.id == Till.q.stationID),
        INNERJOINOn(None, PersonAdaptToBranch,
                    PersonAdaptToBranch.q.id == BranchStation.q.branchID),
        LEFTJOINOn(None, PaymentGroup,
                   PaymentGroup.q.id == Payment.q.groupID),
        LEFTJOINOn(None, Sale,
                   Sale.q.groupID == PaymentGroup.q.id),
        LEFTJOINOn(None, PersonAdaptToSalesPerson,
                   PersonAdaptToSalesPerson.q.id == Sale.q.salespersonID),
        LEFTJOINOn(None, Person,
                   Person.q.id == PersonAdaptToSalesPerson.q.originalID),
        LEFTJOINOn(None, CfopData,
                   CfopData.q.id == Sale.q.cfopID),
    ]


class TillHistoryDialog(SearchDialog):
    size = (900, -1)
    table = TillFiscalOperationsView
    selection_mode = gtk.SELECTION_MULTIPLE
    searchbar_labels = _('Till Entries matching:')
    title = _('Till history')

    #
    # SearchDialog
    #

    def get_columns(self, *args):
        return [Column('id', _('Number'), data_type=int, width=100,
                       format='%03d', sorted=True),
                SearchColumn('date', _('Date'),
                             data_type=datetime.date, width=110),
                Column('description', _('Description'), data_type=str,
                       expand=True,
                       width=300),
                SearchColumn('station_name', title=_('Station'), data_type=str,
                             width=120),
                SearchColumn('salesperson_name', title=_('Salesperson'), data_type=str,
                             width=120),
                SearchColumn('method_name', title=_('Forma de pagamento'), data_type=str,
                             width=120),
                ColoredColumn('value', _('Value'), data_type=currency,
                              color='red', data_func=payment_value_colorize,
                              width=140)]

    def _get_card_description(self, arg):
        return CreditCardData.types.get(arg)

    def create_filters(self):
        self.set_text_field_columns(['description'])

        date_filter = DateSearchFilter(_('Date:'))
        date_filter.select(Today)
        self.add_filter(date_filter, columns=['date'])
        # add summary label
        value_format = '<b>%s</b>'
        total_label = '<b>%s</b>' % _(u'Total:')
        self.search.set_summary_label('value', total_label, value_format)

    def setup_widgets(self):
        self.results.set_visible_rows(10)
        self.results.connect('has-rows', self._has_rows)

        self._add_editor_button(_('Cash _Add...'), CashAdvanceEditor,
                                STOQ_MONEY)
        self._add_editor_button(_('Cash _In...'), CashInEditor,
                                STOQ_MONEY_ADD)
        self._add_editor_button(_('Cash _Out...'), CashOutEditor,
                                STOQ_MONEY_REMOVE)

        self.print_button = gtk.Button(None, gtk.STOCK_PRINT, True)
        self.print_button.set_property("use-stock", True)
        change_button_appearance(self.print_button, gtk.STOCK_PRINT, 'Imprimir')
        self.print_button.connect('clicked', self._print_button_clicked)
        self.action_area.set_layout(gtk.BUTTONBOX_START)
        self.action_area.pack_end(self.print_button, False, False, 6)
        self.print_button.show()
        self.print_button.set_sensitive(False)

    #
    # Private API
    #

    def _add_editor_button(self, name, editor_class, stock):
        button = self.add_button(name, stock=stock)
        button.connect('clicked', self._run_editor, editor_class)
        button.show()

    def _print_button_clicked(self, button):
        till_entries = self.results.get_selected_rows() or list(self.results)
        print_report(TillHistoryReport, self.results, till_entries,
                     filters=self.search.get_search_filters())

    def _run_editor(self, button, editor_class):
        model = run_dialog(editor_class, get_current_toplevel(), self.conn)
        if api.finish_transaction(self.conn, model):
            self.search.refresh()
            self.results.unselect_all()
            if len(self.results):
                self.results.select(self.results[-1])

    def _has_rows(self, results, obj):
        self.print_button.set_sensitive(obj)


class DailyFlowEditor(BaseEditor):
    gladefile = 'DailyFlowEditor'
    model_type = DailyFlow
    model_name = 'Fluxo do dia'
    proxy_widgets = ('flow_date', 'balance')

    def create_model(self, trans):
        return DailyFlow(flow_date=datetime.date.today(),
                         balance=0.0,
                         connection=trans)

    def setup_proxies(self):
        self.add_proxy(self.model, DailyFlowEditor.proxy_widgets)


class DailyFlowListDialog(ModelListDialog):
    title = 'Caixa diário'
    size = (900, 350)
    editor_class = DailyFlowEditor
    model_type = DailyFlow

    columns = [
        Column('flow_date', title='Dia', data_type=datetime.date),
        Column('balance', title='Valor', data_type=str)
    ]

    def __init__(self):
        ModelListDialog.__init__(self)
        self.set_list_type(ListType.NORMAL)

    # ModelListDialog

    def populate(self):
        return DailyFlow.select(
            connection=self.conn)

    def edit_item(self, item):
        return ModelListDialog.edit_item(self, item)
