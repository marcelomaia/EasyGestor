# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

""" Listing and importing applications """

import gettext
import platform

from kiwi.component import implements
from stoqlib.lib.interfaces import IApplicationDescriptions
from stoqlib.gui.stockicons import (
    STOQ_ADMIN_APP, STOQ_CALENDAR_APP, STOQ_CALC, STOQ_INVENTORY_APP,
    STOQ_PAYABLE_APP, STOQ_POS_APP, STOQ_PRODUCTION_APP,
    STOQ_PURCHASE_APP, STOQ_BILLS, STOQ_SALES_APP, STOQ_STOCK_APP,
    STOQ_TILL_APP, STOQ_CHECKLIST, STOQ_EVENTS)

_ = gettext.gettext

_APPLICATIONS = {
    'admin': (_("Administrative"),
              _("Administer the branches, users, employees and configure system "
                "parameters."),
              STOQ_ADMIN_APP),
    'calendar': (_("Calendar"),
                _("Shows payments, orders and other things that will happen "
                  "in the future."),
                 STOQ_CALENDAR_APP),
    # 'financial': (_("Financial"),
    #               _("Control accounts and financial transactions."),
    #               STOQ_CALC),
    # 'inventory': (_("Inventory"),
    #               _("Audit and adjust the product stock."),
    #               STOQ_INVENTORY_APP),
    'payable': (_("Accounts Payable"),
                _("Manage payment that needs to be paid."),
                STOQ_PAYABLE_APP),
    'pos': (_("Point of Sales"),
            _("Terminal and cash register for selling products and services."),
            STOQ_POS_APP),
    'production': (_("Production"),
                   _("Manage the production process."),
                   STOQ_PRODUCTION_APP),
    'purchase': (_("Purchase"),
                 _("Create purchase orders and quotes"),
                 STOQ_PURCHASE_APP),
    'receivable': (_("Accounts Receivable"),
                   _("Manage payments that needs to be received."),
                   STOQ_BILLS),
    'sales': (_("Sales"),
              _("Quotes management and commission calculation."),
              STOQ_SALES_APP),
    'stock': (_("Stock"),
              _("Stock management, receive products and transfer them between branches."),
              STOQ_STOCK_APP),
    'till': (_("Till"),
             _("Control tills and their workflow."),
             STOQ_TILL_APP),
    'tab': (_("Modulo de comandas"),
            _("Controle de pedidos por comandas no seu restaurante!"),
            STOQ_CHECKLIST),
    'report': (_("Reports"),
               _("Acess to system reports."),
               STOQ_EVENTS),
    # 'services': (_("Services"),
    #              _("Perform services like maintenance, installation or repair."),
    #              STOQ_EVENTS),
}

del _APPLICATIONS['tab']


def get_application_names():
    """Get a list of application names, useful for launcher programs

    @returns: application names
    """
    return _APPLICATIONS.keys()


class ApplicationDescriptions:

    implements(IApplicationDescriptions)

    def get_application_names(self):
        return get_application_names()

    def get_descriptions(self):
        app_desc = []
        for name, (label, description, icon) in _APPLICATIONS.items():
            app_desc.append((name, label, icon, description))
        return app_desc


class Application(object):
    """
    Describes an application

    @ivar name: short name of application
    @ivar fullname: complete name of application
    @ivar icon: application icon
    @ivar description: long description of application
    """

    def __init__(self, name, fullname, icon, description):
        self.name = name
        self.fullname = fullname
        self.icon = icon
        self.description = description