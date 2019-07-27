# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2011 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##

""" Chart Generation Dialog """
import gettext
from kiwi.log import Logger
from stoqlib.chart.controls import YearPeriodControl, OneYearControl
from stoqlib.chart.dataprovider import AnnualSalesDataChart, PaymentsDataChart
from stoqlib.gui.editors.baseeditor import BaseEditor

from stoqlib.api import api
from stoqlib.lib.daemonutils import start_daemon
from stoqlib.gui.webview import WebView

_ = gettext.gettext
log = Logger(__name__)


class BaseChartView(WebView):

    def __init__(self, template):
        self.template_html = template
        self._loaded = False
        WebView.__init__(self)
        self.get_view().connect(
            'load-finished',
            self._on_view__document_load_finished)

    def _load_finished(self):
        self._loaded = True

    def _load_daemon_path(self, path):
        uri = '%s/%s' % (self._daemon_uri, path)
        self.load_uri(uri)

    #
    # Public API
    #

    def load(self):
        self._load_daemon_path('web/static/'+self.template_html)

    def set_daemon_uri(self, uri):
        self._daemon_uri = uri

    def load_uri(self, uri):
        log.info("Loading uri: %s" % (uri, ))
        self._view.load_uri(uri)

    def refresh(self):
        self.load()

    #
    # Callbacks
    #

    def _on_view__document_load_finished(self, view, frame):
        self._load_finished()


class ChartDialog(BaseEditor):
    """
     Child class must have the 'gerar' widget, a GtkButton
    """
    gladefile = 'BaseChartDialog'
    controls_slave = None
    model_type = None
    hide_footer = True
    template = ''

    size = (1335, 750)

    def __init__(self, conn):
        self._chart = BaseChartView(self.template)
        BaseEditor.__init__(self, conn=conn)
        self.setup_webview()

    def setup_webview(self):
        # Webview Configuration
        self.main_vbox.pack_end(self._chart)
        self._setup_daemon()
        self._chart.show()
        self._setup_widgets()

    @api.async
    def _setup_daemon(self):
        daemon = yield start_daemon()
        self._chart.set_daemon_uri(daemon.base_uri)

        proxy = daemon.get_client()
        yield proxy.callRemote('start_webservice')
        self._chart.load()

    #
    # BaseEditor Hooks
    #

    def _setup_widgets(self):
        self.disable_ok()

    def setup_slaves(self):
        self.attach_slave("controls_holder",
                          self.controls_slave(self.conn,
                                              self.model,
                                              self._chart))

    def on_confirm(self):
        return True


class SalesChart(ChartDialog):
    title = _("Relatorio Vendas Por Ano")
    model_type = AnnualSalesDataChart
    controls_slave = YearPeriodControl
    template = 'sales-report.html'

    def __init__(self, conn):
        ChartDialog.__init__(self, conn=conn)

    def create_model(self, trans):
        return AnnualSalesDataChart()


class PaymentsChart(ChartDialog):
    title = _("Relatorio de Pagamentos Por Ano")
    model_type = PaymentsDataChart
    controls_slave = OneYearControl
    template = 'payments-report.html'

    def __init__(self, conn):
        ChartDialog.__init__(self, conn=conn)

    def create_model(self, trans):
        return PaymentsDataChart()