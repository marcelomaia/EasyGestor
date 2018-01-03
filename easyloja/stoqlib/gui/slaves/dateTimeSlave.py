import datetime

from kiwi.datatypes import ValidationError
from kiwi.python import Settable
from kiwi.utils import gsignal
from stoqlib.gui.editors.baseeditor import BaseEditorSlave


class DateTimeSlave(BaseEditorSlave):
    gladefile = 'DateTimeEditor'
    model_type = Settable
    proxy_widgets = ['date', 'time']
    gsignal('on-edit-item', object)

    def __init__(self, conn):
        super(DateTimeSlave, self).__init__(conn)
        self.time.update(self.model.time)
        self.date.update(self.model.date)

    def on_confirm(self):
        date = self.model.date
        time = self.model.time
        return datetime.datetime.combine(date, time)

    def create_model(self, trans):
        today = datetime.datetime.today()
        hour, minute, second = today.hour, today.minute, today.second
        return Settable(date=datetime.date.today(), time=datetime.time(hour, minute, second))

    def setup_proxies(self):
        self.add_proxy(self.model, self.proxy_widgets)

    def after_time__content_changed(self, widget):
        try:
            date = widget.read()
            if date:
                self._combine_date_time()
        except ValidationError, e:
            print e

    def after_date__content_changed(self, widget):
        try:
            date = widget.read()
            if date:
                self._combine_date_time()
        except ValidationError, e:
            print e

    def _combine_date_time(self):
        date = self.model.date
        time = self.model.time
        retval = datetime.datetime.combine(date, time)
        if retval is not None:
            self.emit('on-edit-item', retval)
