""" Search dialogs for payment objects """
import datetime
import gtk

from kiwi.db.query import DateQueryState, DateIntervalQueryState
from kiwi.ui.gadgets import render_pixbuf
import pango
from kiwi.enums import SearchFilterPosition
from kiwi.ui.search import ComboSearchFilter, DateSearchFilter, LastMonth
from kiwi.ui.objectlist import SearchColumn, Column
from stoqlib.database.orm import AND

from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.payment.views import InPaymentView, OutPaymentView, InPaymentTotalPerClientView
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.dialogs.csvexporterdialog import CSVExporterDialog
from stoqlib.lib.formatters import format_phone_number
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.gui.base.search import SearchDialog
from kiwi.datatypes import currency

_ = stoqlib_gettext


class DelayedReceivableSearch(SearchDialog):
    title = _("Pesquisa de contas a receber atrasadas")
    size = (-1, 450)
    search_table = InPaymentView
    searching_by_date = True

    #
    # SearchDialog Hooks
    #

    def create_filters(self):
        self.set_text_field_columns(['drawee', 'description'])
        self.set_searchbar_labels(_('matching:'))

        # Status
        items = [(value, key) for key, value in [(Payment.STATUS_PENDING, u'A pagar')]]
        status_filter = ComboSearchFilter(_(u'Mostrar pagamentos com status'), items)
        self.add_filter(status_filter, SearchFilterPosition.TOP, ['status'])

        # Date
        date_filter = DateSearchFilter(_('Vencimento:'))
        date_filter.select(LastMonth)
        self.add_filter(date_filter, columns=['due_date'])

    def executer_query(self, query, having, conn):
        # We have to do this manual filter since adding this columns to the
        # view would also group the results by those fields, leading to
        # duplicate values in the results.
        date = self.date_filter.get_state()
        if isinstance(date, DateQueryState):
            date = date.date
        elif isinstance(date, DateIntervalQueryState):
            date = (date.start, date.end)

        return self.table.select_by_date(query, date,
                                         connection=conn)

    def get_columns(self):
        return [SearchColumn('id', title=_('#'), width=50, data_type=int,
                             sorted=True, order=gtk.SORT_DESCENDING),
                Column('color', title=_('Description'), width=20,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                SearchColumn('due_date', title=_('Due Date'), width=110,
                             data_type=datetime.date, justify=gtk.JUSTIFY_RIGHT,
                             searchable=False,),
                SearchColumn('description', title=_('Description'),
                             data_type=str, width=200, column='color'),
                SearchColumn('drawee', title=_('Client'),
                             data_type=str, expand=True,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('drawee_phone', title=_('Phone Number'),
                             data_type=str, width=140, searchable=False,
                             format_func=format_phone_number,),
                SearchColumn('value', title=_('Total'), data_type=currency,
                             width=140),
                SearchColumn('category', title=_('Category'), data_type=str,
                             long_title=_('Payment category'), width=110,
                             visible=False)]

    def setup_widgets(self):
        self.search.set_summary_label('value', label=_(u'Total:'),
                                      format='<b>%s</b>')
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


class DelayedPayableSearch(SearchDialog):
    title = _("Pesquisa de contas a pagar atrasadas")
    size = (-1, 450)
    search_table = OutPaymentView
    searching_by_date = True

    def create_filters(self):
        self.set_text_field_columns(['supplier_name', 'description'])
        self.set_searchbar_labels(_('matching:'))

        # Status
        items = [(value, key) for key, value in [(Payment.STATUS_PENDING, u'A pagar')]]
        status_filter = ComboSearchFilter(_(u'Mostrar pagamentos com status'), items)
        self.add_filter(status_filter, SearchFilterPosition.TOP, ['status'])

        # Date
        date_filter = DateSearchFilter(_('Vencimento:'))
        date_filter.select(LastMonth)
        self.add_filter(date_filter, columns=['due_date'])

    def executer_query(self, query, having, conn):
        # We have to do this manual filter since adding this columns to the
        # view would also group the results by those fields, leading to
        # duplicate values in the results.
        date = self.date_filter.get_state()
        if isinstance(date, DateQueryState):
            date = date.date
        elif isinstance(date, DateIntervalQueryState):
            date = (date.start, date.end)

        return self.table.select_by_date(query, date,
                                         connection=conn)

    def get_columns(self):
        return [SearchColumn('id', title=_('#'), width=50, data_type=int,
                             sorted=True, order=gtk.SORT_DESCENDING),
                Column('color', title=_('Description'), width=20,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                SearchColumn('due_date', title=_('Due Date'), width=110,
                             data_type=datetime.date, justify=gtk.JUSTIFY_RIGHT,
                             searchable=False,),
                SearchColumn('description', title=_('Description'),
                             data_type=str, width=200, column='color'),
                SearchColumn('supplier_name', title=_('Supplier'),
                             data_type=str, expand=True,
                             ellipsize=pango.ELLIPSIZE_END),
                SearchColumn('supplier_phone', title=_('Phone Number'),
                             data_type=str, width=140, searchable=False,
                             format_func=format_phone_number,),
                SearchColumn('value', title=_('Total'), data_type=currency,
                             width=140),
                SearchColumn('category', title=_('Category'), data_type=str,
                             long_title=_('Payment category'), width=110,
                             visible=False)]

    def setup_widgets(self):
        self.search.set_summary_label('value', label=_(u'Total:'),
                                      format='<b>%s</b>')
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


class InPaymentsTotalByClient(SearchDialog):
    title = _("Total A receber por Cliente")
    size = (900, 400)
    table = Payment
    search_table = InPaymentTotalPerClientView
    searching_by_date = True

    def __init__(self, conn):
        SearchDialog.__init__(self, conn)

    def create_filters(self):
        self.set_text_field_columns(['name', 'fancy_name'])
        date_filter = DateSearchFilter(_('Vencimento:'))
        date_filter.select(LastMonth)
        self.add_filter(date_filter, callback=self._get_due_date_query)

    def setup_widgets(self):
        self.search.set_summary_label('total', label=_(u'Total:'),
                                      format='<b>%s</b>')
        self.csv_button = self.add_button(label=_(u'Export CSV...'))
        self.csv_button.connect('clicked', self._on_export_csv_button__clicked)
        self.csv_button.show()
        self.csv_button.set_sensitive(False)
        self.results.connect('has_rows', self._on_results__has_rows)

    def get_columns(self):
        return [Column('id', title=_('#'), width=30, data_type=int,
                             sorted=True, order=gtk.SORT_ASCENDING),
                Column('name', title=_('Razao Social'), width=100,
                       data_type=str, justify=gtk.JUSTIFY_CENTER),
                Column('fancy_name', title=_('Fancy Name'), width=100,
                             data_type=str, justify=gtk.JUSTIFY_CENTER),
                SearchColumn('total', title=_('Total value'),
                             data_type=currency, width=90),
                ]

    def _get_due_date_query(self, date):
        if isinstance(date, DateQueryState):
            return Payment.q.due_date == date.date
        elif isinstance(date, DateIntervalQueryState):
            return AND(Payment.q.due_date >= date.start,
                             Payment.q.due_date <= date.end)

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
