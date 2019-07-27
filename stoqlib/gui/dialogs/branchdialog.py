# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2006, 2007 Async Open Source <http://www.async.com.br>
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
##

import requests
import json
from kiwi.datatypes import ValidationError
from stoqlib.api import api
from stoqlib.database.admin import create_main_branch
from stoqlib.domain.interfaces import ICompany
from stoqlib.domain.person import Person
from stoqlib.exceptions import StoqlibError
from stoqlib.gui.editors.addresseditor import AddressSlave
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.receitaws import CompanyData
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class BranchDialog(BaseEditor):
    """Register new branch after creating a database.

    This dialog is only used after the database is created.
    """
    gladefile = 'BranchDialog'
    person_widgets = ('name',
                      'phone_number')
    company_widgets = ('cnpj',
                       'state_registry')
    proxy_widgets = person_widgets + company_widgets
    model_type = Person

    def __init__(self, trans, model=None):
        model = create_main_branch(name="", trans=trans).person

        self.param = sysparam(trans)
        BaseEditor.__init__(self, trans, model, visual_mode=False)
        self._setup_widgets()
        # for widget in [self.label11, self.label6, self.label4, self.icms,
        #                self.substitution_icms, self.iss, self.label5,
        #                self.label1,self.label3, self.label10,self.fax_number]:
        #     widget.hide()

    def _update_system_parameters(self, person):
        address = person.get_main_address()
        if not address:
            raise StoqlibError("You should have an address defined at "
                               "this point")

        city = address.city_location.city
        self.param.update_parameter('CITY_SUGGESTED', city)

        country = address.city_location.country
        self.param.update_parameter('COUNTRY_SUGGESTED', country)

        state = address.city_location.state
        self.param.update_parameter('STATE_SUGGESTED', state)

        # Update the fancy name
        self.company_proxy.model.fancy_name = self.person_proxy.model.name

    def _setup_widgets(self):
        self.cnpj.grab_focus()
        self.document_l10n = api.get_l10n_field(self.conn, 'company_document')
        self.cnpj_lbl.set_label(self.document_l10n.label)
        self.cnpj.set_mask(self.document_l10n.entry_mask)
        self.phone_number.set_mask('(00)0000-0000')

    def _setup_slaves(self):
        address = self.model.get_main_address()
        self._address_slave = AddressSlave(self.conn, self.model, address)
        self.attach_slave("address_holder", self._address_slave)

    #
    # BaseEditor hooks
    #

    def create_model(self, conn):
        return Person(connection=conn)

    def setup_proxies(self):
        self._setup_widgets()
        self._setup_slaves()
        widgets = self.person_widgets
        self.person_proxy = self.add_proxy(self.model, widgets)

        widgets = self.company_widgets
        model = ICompany(self.model, None)
        if not model is None:
            self.company_proxy = self.add_proxy(model, widgets)

    def on_confirm(self):
        self._address_slave.confirm()
        self._update_system_parameters(self.model)
        self._send_to_api(self.model, self.company_proxy.model)
        return self.model

    def _send_to_api(self, person, company):
        data = {
            'name': person.name,
            'cnpj': company.cnpj,
            'phone_number': person.phone_number
        }
        url = 'http://hallevent.com:8100/api/'
        headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
        try:
            r = requests.post(url=url, data=json.dumps(data), headers=headers)
        except:
            pass
    #
    # Kiwi Callbacks
    #

    def on_cnpj__validate(self, widget, value):
        if not self.document_l10n.validate(value):
            return ValidationError(_('%s is not valid.') % (
                self.document_l10n.label,))

    def on_search_cnpj__clicked(self, *args):
        cnpj = self.cnpj.read()
        cd = CompanyData(cnpj)
        data = cd.get_company_data()
        if data:
            phone_number = ''.join([p for p in data.get('phone_number') if p in '0123456789'])[:10]
            self.phone_number.update(phone_number)
        self.name.update(data.get('company_name'))

        number = data.get('streetnumber')
        if number:
            if number == ''.join([p for p in number if p in '0123456789']):
                self._address_slave.streetnumber.update(int(number))
        self._address_slave.district.update(data.get('district'))
        self._address_slave.street.update(data.get('street'))
        self._address_slave.complement.update(data.get('complement'))
        self._address_slave.postal_code.update(data.get('postal_code'))
        self._address_slave.city.update(data.get('city'))
        self._address_slave.state.update(data.get('state'))
