import os
import sys

from stoqlib.lib.interfaces import IPlugin
from stoqlib.lib.pluginmanager import register_plugin
from zope.interface import implements

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)
from relatorio_ui import RelatorioUI


class RelatorioPlugin():
    implements(IPlugin)
    name = "relatorio"
    has_product_slave = False

    def activate(self):
        self.ui = RelatorioUI()

    def get_migration(self):
        pass

    def get_tables(self):
        return


register_plugin(RelatorioPlugin)
