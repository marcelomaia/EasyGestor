# coding=utf-8

import datetime
from kiwi.datatypes import ValidationError
from kiwi.log import Logger
from kiwi.python import Settable
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.translation import stoqlib_gettext


log = Logger("stoq-relatorio-plugin")
_ = stoqlib_gettext


class DateDialog(BaseEditor):
    title = "Relatório de fluxo do PDV"
    model_type = Settable
    gladefile = 'DateDialog'
    proxy_widgets = ('start_date',
                     'end_date',
                     'start_hour',
                     'end_hour')
    hour_mask = '00:00:00'

    def __init__(self, conn):
        BaseEditor.__init__(self, conn, model=None)

    #
    # BaseEditor
    #

    def setup_widgets(self):
        self.start_hour.set_mask(self.hour_mask)
        self.end_hour.set_mask(self.hour_mask)

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    DateDialog.proxy_widgets)
        self.setup_widgets()

    def create_model(self, conn):
        return Settable(start_date=datetime.datetime.today(),
                        end_date=datetime.datetime.today(),
                        start_hour=u'08:00:00',
                        end_hour=u'18:00:00')

    def on_confirm(self):
        end_hour_numbers = ''.join([p for p in self.end_hour.read() if p in '0123456789'])
        start_hour_numbers = ''.join([p for p in self.start_hour.read() if p in '0123456789'])
        if len(end_hour_numbers) != 6 or len(start_hour_numbers) != 6:
            return
        return self.model

    #
    # callbacks
    #

    def on_start_date__validate(self, widget, date):
        if date > datetime.date.today():
            return ValidationError(_("Start date must be less than today"))

    def on_end_date__validate(self, widget, date):
        if date > datetime.date.today():
            return ValidationError(_("End date must be less than today"))

    def on_start_hour__validate(self, widget, data):
        numbers = ''.join([p for p in data if p in '0123456789'])
        if len(numbers) == 6:
            hour, minute, second = data.split(':')
            if int(hour) < 0 or int(hour) > 23:
                return ValidationError("Hora deve estar entre 0 e 23")
            elif int(minute) < 0 or int(minute) > 59:
                return ValidationError("Minuto deve estar entre 0 e 59")
            elif int(second) < 0 or int(second) > 59:
                return ValidationError("Segundo deve estar entre 0 e 59")

    def on_end_hour__validate(self, widget, data):
        numbers = ''.join([p for p in data if p in '0123456789'])
        if len(numbers) == 6:
            hour, minute, second = data.split(':')
            if int(hour) < 0 or int(hour) > 23:
                return ValidationError("Hora deve estar entre 0 e 23")
            elif int(minute) < 0 or int(minute) > 59:
                return ValidationError("Minuto deve estar entre 0 e 59")
            elif int(second) < 0 or int(second) > 59:
                return ValidationError("Segundo deve estar entre 0 e 59")
