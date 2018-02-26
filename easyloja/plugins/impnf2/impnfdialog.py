# coding=utf-8

import datetime
import gtk
import os
import subprocess
from gtk import keysyms

from kiwi.datatypes import ValidationError
from kiwi.enums import ListType
from kiwi.environ import environ
from kiwi.python import Settable
from kiwi.ui.objectlist import Column
from stoqlib.database.runtime import get_current_station
from stoqlib.domain.station import BranchStation
from stoqlib.gui.base.lists import ModelListDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.osutils import get_application_dir
from stoqlib.lib.translation import stoqlib_gettext

from impnfdomain import Impnf

_ = stoqlib_gettext


class ImpnfEditor(BaseEditor):
    gladefile = 'ImpnfEditor'
    model_type = Impnf
    size = (600, 300)
    model_name = 'Impressora não fiscal'
    proxy_widgets = ('name', 'is_default', 'station', 'spooler_printer')

    def create_model(self, trans):
        impnf = Impnf(name=u'BALCAO',
                      is_default=False,
                      spooler_printer='EasyGestor',
                      station=get_current_station(self.conn),
                      connection=trans)
        return impnf

    def setup_proxies(self):
        for widget in [self.kiwilabel5, self.port, self.kiwilabel4, self.dll,
                       self.kiwilabel3, self.printer_model, self.kiwilabel2,
                       self.brand, self.filechooser_button]:
            widget.hide()
        stations = [(p.name, p) for p in BranchStation.selectBy(connection=self.conn)]
        self.station.prefill(stations)
        self.add_proxy(self.model, ImpnfEditor.proxy_widgets)

    def _print_on_spooler(self, filename):
        """
        :param filename:
        :return:
        usando agora o SumatraPDF
        https://www.sumatrapdfreader.org/docs/Command-line-arguments-0c53a79e91394eccb7535ef6fed0678e.html
        """
        sumatra_path = environ.find_resource('sumatraPDF', 'SumatraPDF.exe')
        printer = self.spooler_printer.read()
        if os.path.exists(filename):
            cmd = '{exe} -print-to {printer} {fname}'.format(exe=sumatra_path,
                                                             printer=printer,
                                                             fname=filename)

            proc = subprocess.Popen(cmd.split(' '), shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    #
    # Callbacks
    #

    def on_is_default__content_changed(self, widget):
        icon_dict = {True: gtk.STOCK_OK,
                     False: gtk.STOCK_CANCEL}
        value = widget.read()
        self.image_default.set_from_stock(icon_dict.get(value), gtk.ICON_SIZE_BUTTON)

    def on_test_button__clicked(self, widget):
        filename = os.path.join(get_application_dir(), 'stoq.conf')
        self._print_on_spooler(filename)


class RemotePrinterListDialog(ModelListDialog):
    title = 'Impressoras Remotas'
    size = (900, 350)
    editor_class = ImpnfEditor
    model_type = Impnf

    columns = [
        Column('name', title='Nome', data_type=unicode),
        Column('brand', title='Marca', data_type=unicode),
        Column('printer_model', title='Modelo', data_type=unicode),
        Column('dll', title='dll', data_type=unicode, expand=True),
        Column('port', title='Porta', data_type=unicode),
        Column('is_default', title='Padrão', data_type=bool),
        Column('station.name', title='Computador', data_type=str)
    ]

    def __init__(self):
        ModelListDialog.__init__(self)
        self.set_list_type(ListType.NORMAL)

    # ModelListDialog

    def populate(self):
        return Impnf.select(
            connection=self.conn)

    def edit_item(self, item):
        return ModelListDialog.edit_item(self, item)


class ReprintSaleDialog(BaseEditor):
    """"""
    title = u"Reimprimir uma venda"
    hide_footer = False
    model_type = Settable
    gladefile = "ReprintNote"
    proxy_widgets = ("number",)

    def __init__(self, conn):
        self.model = self._create_model()
        BaseEditor.__init__(self, conn, self.model)
        self.main_dialog.update_keyactions({keysyms.Return: self.confirm,
                                            keysyms.KP_Enter: self.confirm})
        self._setup_widgets()

    def _create_model(self):
        return Settable(number=0, )

    def _setup_widgets(self):
        pass

    #
    # BaseEditor
    #

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        return self.model

    def on_cancel(self):
        return None


class CancelSaleDialog(BaseEditor):
    """"""
    title = u"Cancelar uma venda"
    hide_footer = False
    model_type = Settable
    gladefile = "ReprintNote"
    proxy_widgets = ("number",)

    def __init__(self, conn):
        self.model = self._create_model()
        BaseEditor.__init__(self, conn, self.model)
        self.main_dialog.update_keyactions({keysyms.Return: self.confirm,
                                            keysyms.KP_Enter: self.confirm})
        self._setup_widgets()

    def _create_model(self):
        return Settable(number=0, )

    def _setup_widgets(self):
        pass

    #
    # BaseEditor
    #

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        return self.model

    def on_cancel(self):
        return None


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
