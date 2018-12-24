# -*- coding: utf-8 -*-
import gtk
import os
import sys

import subprocess
import time
import platform
from kiwi.environ import environ
import datetime
from kiwi.log import Logger
from stoqlib.database.runtime import (get_connection, get_current_station, get_current_user, new_transaction)
from stoqlib.domain.payment.operation import register_payment_operations
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.events import StartApplicationEvent
from stoqlib.gui.stockicons import STOQ_DOLLAR
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.permissions import permission_required
from stoqlib.lib.pluginmanager import get_plugin_manager
from pdfbuilder_relatorio import (gerencial_report, salesperson_stock_report,
                                  salesperson_financial_report)
from relatoriodialog import DateDialog
log = Logger("stoq-relatorio-plugin")

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)


class RelatorioUI(object):
    manager = get_plugin_manager()

    def __init__(self):
        self.conn = get_connection()
        StartApplicationEvent.connect(self._on_StartApplicationEvent)
        register_payment_operations()

    def _on_StartApplicationEvent(self, appname, app):
        self._add_ui_menus(appname, app, app.main_window.uimanager)

    def _add_ui_menus(self, appname, app, uimanager):
        if appname == 'pos':
            self._add_pos_menus(uimanager)

    def _add_pos_menus(self, uimanager):
        ui_string = """<ui>
          <menubar name="menubar">
            <placeholder name="ExtraMenu">
              <menu action="RelatorioMenu">
                <menuitem action="RelatorioDeVendasNF" name="RelatorioDeVendasNF"/>
                <menuitem action="RelatorioDeVendasNF2" name="RelatorioDeVendasNF2"/>
                <menuitem action="RelatorioGerencial" name="RelatorioGerencial"/>
              </menu>
            </placeholder>
          </menubar>
        </ui>"""

        ag = gtk.ActionGroup('RelatorioMenuActions')
        ag.add_actions([
            ('RelatorioMenu', None, 'Relatórios'),
            ('RelatorioDeVendasNF', STOQ_DOLLAR, 'Relatorio de vendas de produtos',
             None, None, self._on_PrinterStockReportEvent),
            ('RelatorioDeVendasNF2', STOQ_DOLLAR, 'Relatorio de faturamento de caixa',
             None, None, self._on_PrinterFinancialReportEvent),
            ('RelatorioGerencial', STOQ_DOLLAR, 'Relatorio geral de faturamento  e produtos',
             None, None, self._on_PrinterGerencialReportEvent),
        ])
        uimanager.insert_action_group(ag, 0)
        uimanager.add_ui_from_string(ui_string)

    # def _get_default_printer(self):
    #     return Impnf.selectOneBy(is_default=True,
    #                              station=get_current_station(self.conn),
    #                              connection=self.conn)

    def print_file(self, filename):
        if platform.system() == 'Windows':
            self._print_on_spooler(filename)
        else:
            opener = "open" if sys.platform == "darwin" else "xdg-open"
            subprocess.call([opener, filename])

    def _print_on_spooler(self, filename):
        """
        :param filename:
        :return:
        usando agora o SumatraPDF
        https://www.sumatrapdfreader.org/docs/Command-line-arguments-0c53a79e91394eccb7535ef6fed0678e.html
        """
        (SUMATRA, LEITOR, DIALOGO) = range(1, 4)
        spooler_mode = sysparam(conn=self.conn).TIPO_IMPRESSAO_SPOOLER

        sumatra_path = environ.find_resource('sumatraPDF', 'SumatraPDF.exe')
        printer = self._get_default_printer()
        if not printer:
            # info('Nao tem impressora configurada')
            return
        time.sleep(2)

        if spooler_mode == LEITOR:
            return self._print_on_spooler2(filename)

        if os.path.exists(filename):
            cmd = '"{exe}" -print-to "{printer}" "{fname}"'.format(exe=sumatra_path,
                                                                   printer=printer.spooler_printer,
                                                                   fname=filename)
            if spooler_mode == DIALOGO:
                cmd = '"{exe}" -print-dialog "{fname}"'.format(exe=sumatra_path,
                                                               fname=filename)
            log.debug('executing command: {cmd}'.format(cmd=cmd))
            # https://docs.python.org/2/library/subprocess.html#subprocess.Popen
            proc = subprocess.Popen(cmd, shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    def _print_on_spooler2(self, filename):
        """
        :param filename:
        :return:
        """
        import win32api
        printer = self._get_default_printer()
        if not printer:
            info('Nao tem impressora configurada')
            return
        time.sleep(2)
        SW_HIDE = 0
        # SW_SHOWMINIMIZED = 2
        if os.path.exists(filename):
            retval = win32api.ShellExecute(
                0,
                "printto",
                filename,
                '"%s"' % printer,
                ".",
                SW_HIDE
            )
            # If succeeds, returns a value greater than 32.
            if retval <= 32:
                log.debug("ShellExecute Error: code: %s, printer: %s, filename: %s" %
                          (retval, printer, filename))

    def _print_sale(self, sale):
        filename = build_sale_document(sale, self.conn)
        self.print_file(filename)

    def _print_tab(self, sale):
        filename = build_tab_document(sale)
        self.print_file(filename)

    def _get_open_and_close_date(self):
        model = run_dialog(DateDialog, get_current_toplevel(), self.conn)
        if model:
            end_date, end_hour, start_date, start_hour = model.end_date, model.end_hour, \
                                                         model.start_date, model.start_hour

            open_date = start_date.strftime('%d/%m/%Y') + ' ' + start_hour
            close_date = end_date.strftime('%d/%m/%Y') + ' ' + end_hour
            od = datetime.datetime.strptime(open_date, '%d/%m/%Y %H:%M:%S')
            cd = datetime.datetime.strptime(close_date, '%d/%m/%Y %H:%M:%S')
            return od, cd
        return None

    def _on_PrinterStockReportEvent(self, arg):
        log.debug('{} solicitou relatorio de estoque'.format(get_current_user(self.conn).username))
        dates = self._get_open_and_close_date()
        if dates:
            open_date, close_date = dates
            filename = salesperson_stock_report(open_date, close_date, self.conn)
            self.print_file(filename)

    def _on_PrinterFinancialReportEvent(self, arg):
        log.debug('{} solicitou relatorio financeiro'.format(get_current_user(self.conn).username))
        dates = self._get_open_and_close_date()
        if dates:
            open_date, close_date = dates
            filename = salesperson_financial_report(open_date, close_date, self.conn)
            self.print_file(filename)

    @permission_required('nonfiscal_report')
    def _on_PrinterGerencialReportEvent(self, arg):
        log.debug('{} solicitou relatorio financeiro e estoque'.format(
            get_current_user(self.conn).username))
        dates = self._get_open_and_close_date()
        if dates:
            od, cd = dates
            filename = gerencial_report(od, cd, self.conn)
            self.print_file(filename)
