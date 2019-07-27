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
##
""" Person role wizards definition """

from kiwi.python import Settable
from kiwi.argcheck import argcheck
from kiwi.ui.widgets.list import Column

from stoqlib.api import api
from stoqlib.database.orm import Transaction, AND
from stoqlib.domain.person import Person, PersonAdaptToIndividual, PersonAdaptToCompany
from stoqlib.gui.base.wizards import (WizardEditorStep, BaseWizard,
                                      BaseWizardStep)
from stoqlib.gui.base.dialogs import run_dialog
from stoqlib.gui.editors.personeditor import BranchEditor, UserEditor
from stoqlib.gui.templates.persontemplate import BasePersonRoleEditor
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.formatters import format_phone_number


_ = stoqlib_gettext

#
# Wizard Steps
#


class RoleEditorStep(BaseWizardStep):
    gladefile = 'HolderTemplate'

    def __init__(self, wizard, conn, previous, role_type, person=None,
                 document=None):
        BaseWizardStep.__init__(self, conn, wizard, previous=previous)
        role_editor = self.wizard.role_editor(self.conn,
                                              person=person,
                                              role_type=role_type)
        self.wizard.set_editor(role_editor)
        self.person_slave = role_editor.get_person_slave()
        if document is not None:
            company_slave = self.person_slave.get_slave('company_holder')
            if company_slave is not None:
                company_slave.set_cnpj(document)
            individual_slave = self.person_slave.get_slave('individual_holder')
            if individual_slave is not None:
                individual_slave.set_cpf(document)

        self.person_slave.get_toplevel().reparent(self.place_holder)

    def post_init(self):
        refresh_method = self.wizard.refresh_next
        self.person_slave.register_validate_function(refresh_method)
        self.person_slave.force_validation()

    def previous_step(self):
        # We don't want to create duplicate person objects when switching
        # steps.
        api.rollback_and_begin(self.conn)
        return BaseWizardStep.previous_step(self)

    def has_next_step(self):
        return False


class ExistingPersonStep(BaseWizardStep):
    gladefile = 'ExistingPersonStep'

    def __init__(self, wizard, conn, previous, role_type, person_list,
                 phone_number=''):
        self.phone_number = phone_number
        self.role_type = role_type
        BaseWizardStep.__init__(self, conn, wizard, previous=previous)
        self._setup_widgets(person_list)

    def _setup_widgets(self, person_list):
        role_name = self.wizard.get_role_name().lower()
        self.question_label.set_text(
            _("Does the %s already exist?") % role_name)
        self.existing_person_check.set_label(_("Yes"))
        self.new_person_check.set_label(
            _("No, it's a new %s") % role_name)
        self.question_label.set_size('large')
        self.question_label.set_bold(True)
        self.person_list.set_columns(self._get_columns())
        self.person_list.add_list(person_list)
        self.person_list.select(person_list[0])

    def _get_columns(self):
        return [Column('name', title=_('Name'), sorted=True,
                       data_type=str, width=220),
                Column('phone_number', title=_('Phone Number'),
                       data_type=str, width=120,
                       format_func=format_phone_number),
                Column('mobile_number', title=_('Mobile'), data_type=str,
                       format_func=format_phone_number,
                       width=120)]

    def on_existing_person_check__toggled(self, *args):
        self.person_list.set_sensitive(True)

    def on_new_person_check__toggled(self, *args):
        self.person_list.set_sensitive(False)

    def next_step(self):
        if self.existing_person_check.get_active():
            person = self.person_list.get_selected()
            phone_number = None
        else:
            person = None
            phone_number = self.phone_number
        return RoleEditorStep(self.wizard, self.conn, self,
                              self.role_type, person, phone_number)


class PersonRoleTypeStep(WizardEditorStep):
    gladefile = 'PersonRoleTypeStep'
    model_type = Settable
    CPF_MASK = '000.000.000-00'
    CNPJ_MASK = '00.000.000/0000-00'

    def __init__(self, wizard, conn):
        WizardEditorStep.__init__(self, conn, wizard)
        self._setup_widgets()

    def _setup_widgets(self):
        label = _('What kind of %s are you adding?')
        role_editor = self.wizard.role_editor
        if role_editor == BranchEditor or role_editor == UserEditor:
            self.company_check.set_sensitive(False)
            self.individual_check.set_sensitive(False)
            if role_editor == UserEditor:
                self.individual_check.set_active(True)
                self.document.set_mask(self.CPF_MASK)
                self.document.grab_focus()
                self.documentlbl.set_text("CPF:")
            else:
                label = _('Adding a %s')
                self.company_check.set_active(True)
                self.document.set_mask(self.CNPJ_MASK)
                self.document.grab_focus()
                self.documentlbl.set_text("CNPJ:")
        else:
            self.document.set_mask(self.CPF_MASK)
            self.document.grab_focus()
            self.documentlbl.set_text("CPF:")
        role_name = self.wizard.get_role_name().lower()
        self.person_role_label.set_text(label % role_name)
        self.person_role_label.set_size('large')
        self.person_role_label.set_bold(True)

    #
    # WizardStep hooks
    #

    def create_model(self, conn):
        return Settable(document=u'')

    def setup_proxies(self):
        self.add_proxy(self.model, ['document'])

    def next_step(self):
        document = self.model.document
        persons = None
        if document:
            if self.individual_check.get_active():
                role_type = Person.ROLE_INDIVIDUAL
                query = AND(Person.q.id == PersonAdaptToIndividual.q.originalID,
                            PersonAdaptToIndividual.q.cpf == document)
                persons = Person.select(query, connection=self.conn)
            else:
                role_type = Person.ROLE_COMPANY
                query = AND(Person.q.id == PersonAdaptToCompany.q.originalID,
                            PersonAdaptToCompany.q.cnpj == document)
                persons = Person.select(query, connection=self.conn)
        if persons:
            return ExistingPersonStep(self.wizard, self.conn, self,
                                      role_type, persons,
                                      phone_number=document)
        return RoleEditorStep(self.wizard, self.conn, self, role_type,
                              document=document)

    def has_previous_step(self):
        return False

    # Callbacks

    # def on_phone_number__activate(self, entry):
    #     self.wizard.go_to_next()
    def on_individual_check__toggled(self, entry):
        self.document.set_mask(self.CPF_MASK)
        self.documentlbl.set_text("CPF:")

    def on_company_check__toggled(self, entry):
        self.document.set_mask(self.CNPJ_MASK)
        self.documentlbl.set_text("CNPJ:")




#
# Main wizard
#


class PersonRoleWizard(BaseWizard):

    size = (650, 450)

    def __init__(self, conn, role_editor):
        if not issubclass(role_editor, BasePersonRoleEditor):
            raise TypeError('Editor %s must be BasePersonRoleEditor '
                            'instance' % role_editor)
        self.role_editor = role_editor

        BaseWizard.__init__(self, conn,
                            PersonRoleTypeStep(self, conn),
                            title=self.get_role_title())

        if role_editor.help_section:
            self.set_help_section(role_editor.help_section)

    def get_role_name(self):
        if not self.role_editor.model_name:
            raise ValueError('Editor %s must define a model_name attribute '
                             % self.role_editor)
        return self.role_editor.model_name

    def get_role_title(self):
        if not self.role_editor.title:
            raise ValueError('Editor %s must define a title attribute '
                             % self.role_editor)
        return self.role_editor.title

    def set_editor(self, editor):
        self.editor = editor

    #
    # WizardStep hooks
    #

    def finish(self):
        if not self.editor.validate_confirm():
            return
        self.editor.on_confirm()
        self.retval = self.editor.model
        self.close()


argcheck(BasePersonRoleEditor, object, Transaction, object)


def run_person_role_dialog(role_editor, parent, conn, model=None,
                           **editor_kwargs):
    if not model:
        return run_dialog(PersonRoleWizard, parent, conn, role_editor,
                          **editor_kwargs)
    return run_dialog(role_editor, parent, conn, model, **editor_kwargs)
