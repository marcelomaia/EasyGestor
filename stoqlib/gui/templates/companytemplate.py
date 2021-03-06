# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2007 Async Open Source <http://www.async.com.br>
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
"""Company template editor"""
from stoqlib.database.orm import STARTSWITH, LIKE, OR, LOWER
from kiwi.datatypes import ValidationError
from kiwi.utils import gsignal
from stoqlib.api import api
from stoqlib.domain.interfaces import ICompany
from stoqlib.domain.person import Cnae
from stoqlib.gui.editors.baseeditor import BaseEditorSlave
from stoqlib.lib.receitaws import CompanyData
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.validators import (validate_phone_number,
                                    validate_email,
                                    validate_mobile_number,
                                    validate_fancy_name)
import logging
import gtk
from stoqlib.lib.parameters import sysparam
from kiwi.log import Logger
_ = stoqlib_gettext
log = Logger("stoq-companytemplate")

class CompanyDocumentsSlave(BaseEditorSlave):
    gsignal('cnpj_search', object)
    model_iface = ICompany
    gladefile = 'CompanyDocumentsSlave'
    proxy_widgets = ('cnpj',
                     'fancy_name',
                     'state_registry',
                     'city_registry',
                     'responsible_name',
                     'responsible_cpf',
                     'responsible_phone',
                     'responsible_mobile_phone',
                     'responsible_email',
                     'cnae',
                     'social_capital')

    def setup_proxies(self):
        self.document_l10n = api.get_l10n_field(self.conn, 'company_document')
        self.cnpj_lbl.set_label(self.document_l10n.label)
        self.cnpj.set_mask(self.document_l10n.entry_mask)
        self.responsible_cpf.set_mask('000.000.000-00')
        # self.cnae.set_mask('00.00-0-00')

        self.proxy = self.add_proxy(self.model,
                                    CompanyDocumentsSlave.proxy_widgets)
        if self.model.main_cnae:
            self.proxy.update('cnae', self.model.main_cnae.code)
        cnae_completion = gtk.EntryCompletion()
        liststore = gtk.ListStore(str, object)
        cnae_completion.set_model(liststore)
        cnae_completion.set_text_column(0)
        cnae_completion.connect('match-selected', self.on_completion_match)
        cnae_completion.set_match_func(self.match_func, None)
        self.cnae.set_completion(cnae_completion)

    def match_func(self, completion, key_string, iter, data):
        return True


    def on_completion_match(self, completion, model, iter):
        slug_field = model[iter][1].code or model[iter][1].description
        current_text = "%s" % slug_field
        self.cnae.set_text(current_text)
        self.cnae.activate()
        self._set_cnae(current_text)
        return True

    def on_cnae__changed(self, entry):

        value = entry.get_text()
        if len(value) < 2 or not sysparam(self.conn).AUTO_COMPLETE:
            return
        clause = OR(STARTSWITH(Cnae.q.code, value), LIKE(LOWER(Cnae.q.description), '%%%s%%' % value.lower(), escape='\\'))
        results = [item for item in Cnae.select(clause=clause, connection=self.conn)]
        model = gtk.ListStore(str, object)
        for cnae in results:
            label = '%s -- %s' % (cnae.code, cnae.description)
            model.append((label, cnae))
        completion = self.cnae.get_completion()
        completion.set_model(model)

    def _set_cnae(self, code):
        cnae = Cnae.selectOneBy(code=code, connection=self.conn)
        if cnae:
            self.model.main_cnae = cnae.id

    def set_cnpj(self, cnpj):
        import re
        cnpj = ''.join(re.findall('\d', str(cnpj)))

        if not cnpj or len(cnpj) != 14:
            return False
        self.model.cnpj = cnpj
        self.proxy.update('cnpj')

    def on_cnpj__validate(self, widget, value):
        # This will allow the user to use an empty value to this field
        if self.cnpj.is_empty():
            return

        if not self.document_l10n.validate(value):
            return ValidationError(_('%s is not valid.') % (
                self.document_l10n.label,))

        if self.model.check_cnpj_exists(value):
            return ValidationError(
                _('A company with this %s already exists') % (
                    self.document_l10n.label))

    def on_responsible_phone__validate(self, widget, value):
        if value == '':
            return
        if not validate_phone_number(value):
            return ValidationError(_('%s is not a valid phone') % value)

    def on_responsible_mobile_phone__validate(self, widget, value):
        if value == '':
            return
        if not validate_mobile_number(value):
            return ValidationError(_('%s is not a valid phone') % value)

    def on_responsible_email__validate(self, widget, value):
        if value == '':
            return
        if not validate_email(value):
            return ValidationError(_('%s is not a valid email') % value)

    def on_fancy_name__validate(self, widget, value):
        if value == '':
            return
        if not validate_fancy_name(value):
            return ValidationError(u'O nome fantasia {} é muito grande'.format(value))

    def on_cnae__validate(self, widget, value):
        if self.cnae.is_empty():
            return
        items = [cnae.code
                 for cnae in Cnae.select(connection=self.conn)]
        if value not in items:
            return ValidationError(_('%s is not a valid cnae') % value)

    def on_search_cnpj__clicked(self, *args):
        cnpj = self.cnpj.read()
        cnpj = ''.join([p for p in cnpj if p in '0123456789'])
        cd = CompanyData(cnpj)
        data = cd.get_company_data()
        if data:
            fancy_name = data.get('fancy_name')
            responsible = data.get('responsible_name')
            social_capital = data.get('social_capital')
            main_cnae_code = data.get('main_cnae_code')
            if not fancy_name:
                fancy_name = data.get('company_name')
            self.fancy_name.update(fancy_name)
            self.responsible_name.update(responsible)
            self.social_capital.update(social_capital)
            self.cnae.update(main_cnae_code)
            self._set_cnae(main_cnae_code)
            self.emit('cnpj_search', data)


class CompanyEditorTemplate(BaseEditorSlave):
    gsignal('cnpj_search', object)
    model_iface = ICompany
    gladefile = 'BaseTemplate'

    def __init__(self, conn, model=None, person_slave=None,
                 visual_mode=False):
        self._person_slave = person_slave
        BaseEditorSlave.__init__(self, conn, model, visual_mode=visual_mode)

    def get_person_slave(self):
        return self._person_slave

    def attach_person_slave(self, slave):
        self._person_slave.attach_slave('person_status_holder', slave)

    #
    # BaseEditor hooks
    #

    def setup_slaves(self):
        self.company_docs_slave = CompanyDocumentsSlave(
            self.conn, self.model, visual_mode=self.visual_mode)
        self.company_docs_slave.connect('cnpj_search', self.on_cnpj_search)
        self._person_slave.attach_slave('company_holder',
                                        self.company_docs_slave)

    def on_confirm(self, confirm_person=True):
        if confirm_person:
            self._person_slave.on_confirm()
        return self.model

    def on_cnpj_search(self, slave, data):
        self.emit('cnpj_search', data)
