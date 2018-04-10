# coding=utf-8
import datetime

from kiwi.python import Settable
from kiwi.ui.search import DateSearchFilter, LastMonth, LastWeek, Yesterday, Today
from stoqlib.gui.editors.baseeditor import BaseEditor


class PaymentRevenueDialog(BaseEditor):
    gladefile = 'PaymentFlowHistoryDialog'
    title = u'Faturamento por período'
    size = (600, 150)
    model_type = Settable

    def __init__(self, conn):
        self.conn = conn
        BaseEditor.__init__(self, conn, model=None)
        self._setup_widgets()

    def create_model(self, trans):
        return Settable(start_date=None,
                        end_date=None)

    def _setup_widgets(self):
        self._date_filter = DateSearchFilter(u'Date:')
        self._date_filter.clear_options()
        self._date_filter.add_custom_options()
        for option in [Today, Yesterday, LastWeek, LastMonth]:
            self._date_filter.add_option(option)
        self._date_filter.select(position=0)
        self.date_box.pack_start(self._date_filter, False, False)
        self._date_filter.show()

    def on_confirm(self):
        start_date = self._date_filter.get_start_date()
        end_date = self._date_filter.get_end_date()
        return Settable(start_date=datetime.datetime(year=start_date.year,
                                                     month=start_date.month,
                                                     day=start_date.day),
                        end_date=datetime.datetime(year=end_date.year,
                                                   month=end_date.month,
                                                   day=end_date.day,
                                                   hour=23,
                                                   minute=59))


class PaymentRevenueDialog2(BaseEditor):
    gladefile = 'PaymentFlowHistoryDialog'
    title = u'Livro Inventário'
    size = (600, 150)
    model_type = Settable

    def __init__(self, conn):
        self.conn = conn
        BaseEditor.__init__(self, conn, model=None)
        self._setup_widgets()

    def create_model(self, trans):
        return Settable(start_date=None,
                        end_date=None)

    def _setup_widgets(self):
        self._date_filter = DateSearchFilter(u'Date:')
        self._date_filter.clear_options()
        self.add_custom_options()
        self._date_filter.select(position=0)
        self.date_box.pack_start(self._date_filter, False, False)
        self._date_filter.show()

    def add_custom_options(self):
        """Adds the custom options 'Custom day' and 'Custom interval' which
        let the user define its own interval dates.
        """
        pos = len(self._date_filter.mode) + 1
        for name, option_type in [('Dia', DateSearchFilter.Type.USER_DAY)]:
            self._date_filter.mode.insert_item(pos, name, option_type)
            pos += 1

    def on_confirm(self):
        start_date = self._date_filter.get_start_date()
        start_date = datetime.datetime(year=start_date.year,
                                       month=start_date.month,
                                       day=start_date.day,
                                       hour=23,
                                       minute=59,
                                       second=59)
        return start_date
