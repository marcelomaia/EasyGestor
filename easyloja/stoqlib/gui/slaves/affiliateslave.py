# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005, 2006 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##
""" Supplier editor slaves implementation"""

from stoqlib.domain.interfaces import IAffiliate
from stoqlib.gui.editors.baseeditor import BaseEditorSlave
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class AffiliateDetailsSlave(BaseEditorSlave):
    model_iface = IAffiliate
    gladefile = 'AffiliateDetailsSlave'
    proxy_widgets = (
        'bank',
        'account_type',
        'bank_ag',
        'bank_cc',
        'commission_percent',
        'physical_products',
        'business_type'
    )

    def setup_proxies(self):
        banks = [(value, constant)
                 for constant, value in self.model_type.banks.items()]
        account_types = [(value, constant)
                         for constant, value in self.model_type.account_types.items()]

        self.bank.prefill(banks)
        self.account_type.prefill(account_types)
        self.proxy = self.add_proxy(self.model,
                                    AffiliateDetailsSlave.proxy_widgets)
