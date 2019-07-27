# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4
import gtk
from decimal import Decimal

from kiwi.currency import currency
from kiwi.enums import SearchFilterPosition
from kiwi.ui.objectlist import SearchColumn, Column
from stoqlib import api
from stoqlib.domain.interfaces import ISalesPerson, IEmployee
from stoqlib.domain.person import PersonAdaptToSalesPerson
from stoqlib.domain.sale import SaleItem
from stoqlib.domain.sellable import Sellable
from stoqlib.domain.views import SalesPerSalesPersonView
from stoqlib.gui.base.search import SearchDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.database.orm import AND, LIKE, func, ORMObject
from stoqlib.gui.editors.personeditor import EmployeeEditor
from stoqlib.gui.wizards.personwizard import run_person_role_dialog
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class SalesPersonTopSoldSlave(SearchDialog):
    table = SaleItem
    search_table = SalesPerSalesPersonView

    def __init__(self, conn, salesperson):
        self.salesperson = salesperson
        SearchDialog.__init__(self, conn)

    def create_filters(self):
        primary_filter = self.search.get_primary_filter()
        self.executer.add_filter_query_callback(primary_filter,
                                                self._get_salesperson_query)
        branch_filter = self.create_branch_filter(_('In branch:'))
        self.add_filter(branch_filter, columns=['branch'],
                        position=SearchFilterPosition.TOP)

    def _get_salesperson_query(self, state):
        text = '%%%s%%' % state.text.lower()
        return AND(PersonAdaptToSalesPerson.q.id == self.salesperson.id,
                   LIKE(func.LOWER(Sellable.q.description), text))

    def get_columns(self):
        return [SearchColumn("code", title=_("Code"), data_type=str, width=60),
                Column("description", title=_("Description"), data_type=str,
                       searchable=True),
                SearchColumn("quantity", title=_("Total quantity"),
                       data_type=Decimal, width=80, format_func=format_quantity),
                SearchColumn("average_price", title=_("Average Price"), width=90,
                             data_type=currency, justify=gtk.JUSTIFY_RIGHT, ),
                SearchColumn("total", title=_("Total value"), width=90,
                       data_type=currency, justify=gtk.JUSTIFY_RIGHT, )]


class SalesPersonDetailsDialog(BaseEditor):
    title = _(u"SalesPerson Details")
    hide_footer = True
    size = (880, 400)
    model_iface = ISalesPerson
    gladefile = "SalesPersonDetailsDialog"
    proxy_widgets = ('salesperson_name',)

    def __init__(self, conn, model):
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()

    def _setup_widgets(self):
        self._top_solds_slave = SalesPersonTopSoldSlave(self.conn, self.model)
        self.attach_slave('top_sold_items_holder', self._top_solds_slave)

    #
    # BaseEditor Hooks
    #

    def setup_proxies(self):
        self.add_proxy(self.model, self.proxy_widgets)

    #
    # Callbacks
    #

    def on_further_details_button__clicked(self, *args):
        # Este trecho foi baseado de
        # stoqlib.gui.base.search.py:693-702
        trans = api.new_transaction()
        employee = IEmployee(self.model.person, self.conn)
        retval = run_person_role_dialog(EmployeeEditor, self, trans, model=trans.get(employee))

        if api.finish_transaction(trans, retval):
            if isinstance(retval, ORMObject):
                retval = type(retval).get(retval.id, connection=self.conn)
        trans.close()
