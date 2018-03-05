# -*- coding: utf-8 -*-
import datetime
import gtk
import os
import platform
import subprocess
import sys

from kiwi.environ import environ
from kiwi.log import Logger
from kiwi.ui.dialogs import info
from stoqlib.database.runtime import (get_connection, get_current_station, get_current_user, new_transaction)
from stoqlib.domain.events import (SaleSEmitEvent, CreatedOutPaymentEvent, CreatedInPaymentEvent,
                                   TillAddCashEvent, TillRemoveCashEvent, SaleSLastEmitEvent)
from stoqlib.domain.events import (TillOpenDrawer)
from stoqlib.domain.nfe import NFCEBranchSeries
from stoqlib.domain.payment.operation import register_payment_operations
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.payment.views import InPaymentView, OutPaymentView
from stoqlib.domain.renegotiation import RenegotiationData
from stoqlib.domain.sale import Sale
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.dialogs.passworddialog import UserPassword
from stoqlib.gui.events import StartApplicationEvent
from stoqlib.gui.stockicons import STOQ_FISCAL_PRINTER, STOQ_DOLLAR
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.permissions import permission_required
from stoqlib.lib.pluginmanager import get_plugin_manager

from impnfdialog import RemotePrinterListDialog, ReprintSaleDialog, DateDialog, CancelSaleDialog
from impnfdomain import Impnf
from pdfbuilder import (build_sale_document, in_out_payment_report, build_tab_document,
                        in_payment_report, gerencial_report, salesperson_stock_report,
                        salesperson_financial_report, out_payment_report)

log = Logger("stoq-impnf-plugin")

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)


class ImpnfUI(object):
    manager = get_plugin_manager()
    nfce_active = manager.is_active('nfce') or manager.is_active('nfce_bematech')

    def __init__(self):
        self.conn = get_connection()
        StartApplicationEvent.connect(self._on_StartApplicationEvent)
        SaleSEmitEvent.connect(self._on_SaleSEmitEvent)
        SaleSLastEmitEvent.connect(self._on_SaleSLastEmitEvent)
        TillOpenDrawer.connect(self._on_TillDrawerOpen)
        CreatedOutPaymentEvent.connect(self._on_CreatedOutPayment)
        CreatedInPaymentEvent.connect(self._on_CreatedInPayment)
        TillAddCashEvent.connect(self._on_TillDrawerOpen)
        TillRemoveCashEvent.connect(self._on_TillDrawerOpen)
        register_payment_operations()

    def _on_StartApplicationEvent(self, appname, app):
        self._add_ui_menus(appname, app, app.main_window.uimanager)

    def _add_ui_menus(self, appname, app, uimanager):
        if appname == 'admin':
            app.main_window.tasks.add_item(
                'Impressora não fiscal', 'remote-printer', STOQ_FISCAL_PRINTER,
                self._on_ConfigureRemotePrinter__activate)
        if appname == 'pos':
            self._add_pos_menus(uimanager)

    def _add_pos_menus(self, uimanager):
        ui_string = """<ui>
          <menubar name="menubar">
            <placeholder name="ExtraMenu">
              <menu action="ImpnfRemotaMenu">
                <menuitem action="ReimprimirNotaNF" name="ReimprimirNotaNF"/>
                <menuitem action="RelatorioDeVendasNF" name="RelatorioDeVendasNF"/>
                <menuitem action="RelatorioDeVendasNF2" name="RelatorioDeVendasNF2"/>
                <menuitem action="RelatorioGerencial" name="RelatorioGerencial"/>
                <menuitem action="CancelarVenda" name="CancelarVenda"/>
              </menu>
            </placeholder>
          </menubar>
        </ui>"""

        ag = gtk.ActionGroup('ImpnfMenuActions')
        ag.add_actions([
            ('ImpnfRemotaMenu', None, 'Módulo controle'),
            ('ReimprimirNotaNF', gtk.STOCK_PRINT, 'Reimprimir Nota',
             None, None, self._on_ReimprimirNotaNF__activate),
            ('RelatorioDeVendasNF', STOQ_DOLLAR, 'Relatorio de vendas de produtos',
             None, None, self._on_PrinterStockReportEvent),
            ('RelatorioDeVendasNF2', STOQ_DOLLAR, 'Relatorio de faturamento de caixa',
             None, None, self._on_PrinterFinancialReportEvent),
            ('RelatorioGerencial', STOQ_DOLLAR, 'Relatorio geral de faturamento  e produtos',
             None, None, self._on_PrinterGerencialReportEvent),
            ('CancelarVenda', gtk.STOCK_CANCEL, 'Cancelar nota',
             None, None, self._on_CancelarNota__activate),
        ])
        uimanager.insert_action_group(ag, 0)
        uimanager.add_ui_from_string(ui_string)

    def _get_default_printer(self):
        return Impnf.selectOneBy(is_default=True,
                                 station=get_current_station(self.conn),
                                 connection=self.conn)

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
        sumatra_path = environ.find_resource('sumatraPDF', 'SumatraPDF.exe')
        printer = self._get_default_printer()
        if os.path.exists(filename):
            cmd = '{exe} -print-to {printer} {fname}'.format(exe=sumatra_path,
                                                             printer=printer.spooler_printer,
                                                             fname=filename)
            log.debug('executing command: {cmd}'.format(cmd=cmd))
            proc = subprocess.Popen(cmd.split(' '), shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

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

    #
    # Callbacks
    #

    def _on_SaleSEmitEvent(self, sale):
        nfce_status = NFCEBranchSeries.selectOneBy(station=get_current_station(self.conn),
                                                   connection=self.conn)
        if not nfce_status:
            self._print_sale(sale)
        elif not nfce_status.is_active:
            self._print_sale(sale)
        elif not self.nfce_active:
            self._print_sale(sale)
        if sysparam(self.conn).RESTAURANT_MODE:
            self._print_tab(sale)

    def _on_SaleSLastEmitEvent(self, sale):
        secure_mode = sysparam(self.conn).NFCE_SECURE_MODE
        log.debug('{} solicitou impressao vendas ou reimpressao do ultimo pedido'.format(
            get_current_user(self.conn).username))
        if secure_mode:
            if not run_dialog(UserPassword, None, self.conn):
                return
        self._print_sale(sale)
        if sysparam(self.conn).RESTAURANT_MODE:
            self._print_tab(sale)

    @permission_required('reprint_nonfiscal')
    def _on_ReimprimirNotaNF__activate(self, args):
        log.debug('{} solicitou reimpressao de venda'.format(
            get_current_user(self.conn).username))
        model = run_dialog(ReprintSaleDialog, get_current_toplevel(), self.conn)
        if model is not None:
            sale = Sale.selectOneBy(id=int(model.number), connection=self.conn)
            if sale:
                self._print_sale(sale)

    @permission_required('cancel_nonfiscal')
    def _on_CancelarNota__activate(self, arg):
        log.debug('{} solicitou cancelamento de venda'.format(
            get_current_user(self.conn).username))
        sid = run_dialog(CancelSaleDialog, parent=None, conn=self.conn)
        if sid:
            self._cancel_nfce_sale(Sale.get(sid.number, connection=self.conn))

    def _cancel_nfce_sale(self, sale):
        trans = new_transaction()
        if sale.status == Sale.STATUS_RETURNED:
            return
        sale = trans.get(sale)
        renegotiation = RenegotiationData(
            reason="Cancelar o documento",
            paid_total=sale.total_amount,
            invoice_number=sale.id,
            penalty_value=0,
            sale=sale,
            responsible=sale.salesperson,
            new_order=None,
            connection=trans)
        sale.return_(renegotiation)
        info("Documento #{} foi cancelado".format(sale.id))
        trans.commit()
        trans.close()

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

    def _on_ConfigureRemotePrinter__activate(self):
        run_dialog(RemotePrinterListDialog, None)

    def _on_TillDrawerOpen(self, till=None, value=None, reason=None):
        log.debug('{} abriu ou fechou o caixa'.format(get_current_user(self.conn).username))
        filename = in_out_payment_report(till, value, reason, self.conn)
        self.print_file(filename)

    def _on_CreatedInPayment(self, payment):
        log.debug('{} solicitou conta a receber'.format(get_current_user(self.conn).username))
        pv = [p for p in InPaymentView.select(Payment.q.id == payment.id, connection=self.conn)]
        if pv:
            pv = pv[0]
            filename = in_payment_report(pv, self.conn)
            self.print_file(filename)

    def _on_CreatedOutPayment(self, payment):
        log.debug('{} solicitou conta a pagar'.format(get_current_user(self.conn).username))
        pv = [p for p in OutPaymentView.select(Payment.q.id == payment.id, connection=self.conn)]
        if pv:
            pv = pv[0]
            filename = out_payment_report(pv, self.conn)
            self.print_file(filename)
