# -*- coding: utf-8 -*-
from stoqlib.database.orm import BoolCol, UnicodeCol, ForeignKey
from stoqlib.domain.base import Domain
from stoqlib.domain.interfaces import IDescribable, IActive
from zope.interface.declarations import implements


class Impnf(Domain):
    implements(IActive, IDescribable)

    name = UnicodeCol(default=u'')
    brand = UnicodeCol(default=u'')
    printer_model = UnicodeCol(default=u'')
    dll = UnicodeCol(default=u'')
    port = UnicodeCol(default=u'')
    is_default = BoolCol(default=False)
    station = ForeignKey('BranchStation')

    def get_description(self):
        return 'Impressora: {}, marca: {}, porta {}'.format(self.name,
                                                            self.brand,
                                                            self.port)
