# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4
from stoqlib.gui.editors.baseeditor import BaseEditorSlave


class YearPeriodControl(BaseEditorSlave):

    gladefile = 'YearPeriodControl'
    proxy_widgets = ('initial_year',
                     'final_year',)

    def __init__(self, conn, model, chart):
        self._webview = chart
        self.model_type = model.__class__
        BaseEditorSlave.__init__(self, conn=conn, model=model)

    #
    # BaseEditorSlave Hooks
    #

    def _setup_widgets(self):
        self.fill_combos()
        self.gerar.set_sensitive(False)
        self.final_year.set_sensitive(False)

    def setup_proxies(self):
        self._setup_widgets()
        self.add_proxy(self.model, self.proxy_widgets)

    #
    # Controls Slave Duck Typing
    #

    def fill_combos(self):
        items = [(str(year), year) for year in range(2010, 2020)]
        self.initial_year.prefill(items)
        self.final_year.prefill(items)

    #
    # Callbacks
    #

    def on_initial_year__changed(self, *args, **kw):
        self.final_year.set_sensitive(True)

    def on_final_year__changed(self, *args, **kw):
        self.gerar.set_sensitive(self.model.validate_choice())

    def on_gerar__clicked(self, *args, **kwargs):
        print self.model
        results = self.model.query_for_results(self.conn)
        formated = self.model.format_data(results)
        self._webview.js_function_call('reloadChart', formated, self.model.legends)


class OneYearControl(BaseEditorSlave):

    gladefile = 'OneYearControl'
    proxy_widgets = ('choiced_year',)

    def __init__(self, conn, model, chart):
        self._webview = chart
        self.model_type = model.__class__
        BaseEditorSlave.__init__(self, conn=conn, model=model)

    #
    # BaseEditorSlave Hooks
    #

    def _setup_widgets(self):
        self.fill_combos()
        self.gerar.set_sensitive(False)

    def setup_proxies(self):
        self._setup_widgets()
        self.add_proxy(self.model, self.proxy_widgets)

    #
    # Controls Slave Duck Typing
    #

    def fill_combos(self):
        items = [(str(year), year) for year in range(2010, 2020)]
        self.choiced_year.prefill(items)

    def on_choiced_year__changed(self, *args, **kw):
         self.gerar.set_sensitive(self.model.validate_choice())

    def on_gerar__clicked(self, *args, **kwargs):
        results = self.model.query_for_results(self.conn)
        formated = self.model.format_data(results)
        self._webview.js_function_call('reloadChart', formated, self.model.legends)