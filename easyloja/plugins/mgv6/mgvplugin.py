import os
import sys

from stoqlib.lib.interfaces import IPlugin
from stoqlib.lib.pluginmanager import register_plugin
from zope.interface import implements

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)
from mgv_ui import MGVUI


class MGVPlugin():
    implements(IPlugin)
    name = "mgv6"
    has_product_slave = False

    def activate(self):
        self.ui = MGVUI()

    def get_migration(self):
        pass

    def get_tables(self):
        pass


register_plugin(MGVPlugin)
