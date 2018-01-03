import datetime

from kiwi.python import Settable
from stoqlib.gui.editors.baseeditor import BaseEditor


class DatePicker(BaseEditor):
    gladefile = 'DateTimePicker'
    model_type = Settable
    title = u'Escolha uma data:'
    proxy_widgets = ('date', 'text')

    def __init__(self, conn, model):
        super(DatePicker, self).__init__(conn, model)

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    DatePicker.proxy_widgets)

    def create_model(self, trans):
        return Settable(date=datetime.date.today(),
                        text=u'',
                        connection=trans)
