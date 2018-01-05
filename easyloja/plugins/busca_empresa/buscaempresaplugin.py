import os
import sys

from stoqlib.lib.interfaces import IPlugin
from stoqlib.lib.pluginmanager import register_plugin
from zope.interface import implements

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)
from busca_empresa_ui import BuscaEmpresaUI


class BuscaEmpresaPlugin():
    implements(IPlugin)
    name = "mgv5"
    has_product_slave = False

    def activate(self):
        self.ui = BuscaEmpresaUI()

    def get_migration(self):
        pass

    def get_tables(self):
        pass


register_plugin(BuscaEmpresaPlugin)
