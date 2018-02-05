# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

""" Listing and importing applications """

from kiwi.component import implements
from stoqlib.lib.interfaces import IActionDescriptions

_ACTIONS = {
    'reprint_nfce': 'Reimprimir NFC-e',
    'cancel_nfce': 'Cancelar NFC-e',
    'reprint_nonfiscal': 'Reimpressao Nao Fiscal',
    'nonfiscal_reporter': 'Relatorio Nao Fiscal',
    'cancel_nonfiscal': 'Cancelamento N Fiscal',
    'cancel_order': 'Cancelar Venda',
    'cancel_order_item': 'Cancelar Item da Venda',
    'quit_pos': 'Sair do PDV'
}


def get_action_description(action):
    return _ACTIONS[action]


def get_actions_names():
    """Get a list of application names, useful for launcher programs

    @returns: application names
    """
    return _ACTIONS.keys()


class ActionDescriptions:

    implements(IActionDescriptions)

    def get_action_names(self):
        return get_actions_names()

    def get_descriptions(self):
        action_desc = []
        for name, description in _ACTIONS.items():
            action_desc.append((name, description))
        return action_desc