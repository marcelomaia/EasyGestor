import os
import sys

from stoqlib.lib.interfaces import IPlugin
from stoqlib.lib.pluginmanager import register_plugin
from zope.interface import implements

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)

from boleto_ui import BoletoUI


class BoletoIuguPlugin():
    implements(IPlugin)
    name = "boleto"
    has_product_slave = False

    def activate(self):
        self.ui = BoletoUI()

    def get_migration(self):
        return

    def get_tables(self):
        return


register_plugin(BoletoIuguPlugin)
