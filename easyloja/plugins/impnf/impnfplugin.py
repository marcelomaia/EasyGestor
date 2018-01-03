import os
import sys

from kiwi.environ import environ
from stoqlib.lib.interfaces import IPlugin
from stoqlib.lib.pluginmanager import register_plugin
from zope.interface import implements

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)
from impnf_ui import ImpnfUI


class ImpnfPlugin():
    implements(IPlugin)
    name = "impnf"
    has_product_slave = False

    def activate(self):
        environ.add_resource('glade', os.path.join(plugin_root, 'glade'))
        self.ui = ImpnfUI()

    def get_migration(self):
        pass

    def get_tables(self):
        return [('impnfdomain', ["Impnf"])]


register_plugin(ImpnfPlugin)
