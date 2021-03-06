# -*- coding: utf-8 -*-
from stoqlib.database.orm import BoolCol, UnicodeCol, ForeignKey
from stoqlib.domain.base import Domain
from stoqlib.domain.interfaces import IDescribable, IActive
from zope.interface.declarations import implements


class Impnf(Domain):
    implements(IActive, IDescribable)

    name = UnicodeCol(default=u'')
    is_default = BoolCol(default=False)
    station = ForeignKey('BranchStation')
    spooler_printer = UnicodeCol(default=u'')

    def get_description(self):
        return 'Impressora: {}, porta {}'.format(self.name,
                                                 self.spooler_printer)
