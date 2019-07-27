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
##  Author(s): Stoq Team <stoq-devel@async.com.br>
##

# TODO: Rename/Move parts to stoqlib/gui/editors/usereditor.py ?

""" User editor slaves implementation.  """

import gtk
import hashlib

from kiwi.datatypes import ValidationError
from stoqlib.api import api
from stoqlib.domain.interfaces import IEmployee, ISalesPerson, IUser
from stoqlib.domain.person import EmployeeRole
from stoqlib.domain.profile import UserProfile
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.editors.baseeditor import BaseEditor, BaseEditorSlave
from stoqlib.lib.defaults import MINIMUM_PASSWORD_CHAR_LEN
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class LoginInfo:
    """ This class is used by password editor only for validation of the
        fields.
    """
    current_password = None
    new_password = None
    confirm_password = None


class UserStatusSlave(BaseEditorSlave):
    gladefile = 'UserStatusSlave'
    model_iface = IUser
    proxy_widgets = ('active_check', )

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    UserStatusSlave.proxy_widgets)


class PasswordEditorSlave(BaseEditorSlave):
    """ A slave for asking (and confirming) password; Optionally, this slave
    can be used just to ask the password once, i.e, not displaying the entry
    for confirmation (see confirm_password parameter).
    """
    gladefile = 'PasswordEditorSlave'
    model_type = LoginInfo
    proxy_widgets = ('password',
                     'confirm_password')

    def __init__(self, conn, model=None, visual_mode=False,
                 confirm_password=True):
        BaseEditorSlave.__init__(self, conn, model, visual_mode=visual_mode)
        self._confirm_password = confirm_password
        self._setup_widgets()

    def _setup_widgets(self):
        if not self._confirm_password:
            self.confirm_password_lbl.hide()
            self.confirm_password.hide()

    def invalidate_password(self, message):
        self.password.set_invalid(message)

    def _check_passwords(self):
        if self.password.get_text() == self.confirm_password.get_text():
            self.password.set_valid()
            self.confirm_password.set_valid()

    #
    # Hooks
    #

    def set_password_labels(self, password_lbl, confirm_password):
        self.password_lbl.set_text(password_lbl)
        self.confirm_password_lbl.set_text(confirm_password)

    #
    # BaseEditorSlave Hooks
    #

    def create_model(self, conn):
        return LoginInfo()

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    PasswordEditorSlave.proxy_widgets)

    def on_password__validate(self, entry, password):
        if len(password) < MINIMUM_PASSWORD_CHAR_LEN:
            return ValidationError(_
                (u"Passwords must have at least %d characters")
                % MINIMUM_PASSWORD_CHAR_LEN)
        if ((self.model.confirm_password and self._confirm_password) and
               password != self.confirm_password.get_text()):
            return ValidationError(_(u"Passwords don't matches"))

    def on_password__content_changed(self, entry):
        self._check_passwords()

    def on_confirm_password__validate(self, entry, password):
        if len(password) < MINIMUM_PASSWORD_CHAR_LEN:
            return ValidationError(
                _(u"Passwords must have at least %d characters")
                 % MINIMUM_PASSWORD_CHAR_LEN)
        if password != self.password.get_text():
            return ValidationError(_(u"Passwords don't matches"))

    def on_confirm_password__content_changed(self, entry):
        self._check_passwords()


class PasswordEditor(BaseEditor):
    gladefile = 'PasswordEditor'
    model_type = LoginInfo
    proxy_widgets = ('current_password', )

    def __init__(self, conn, user, visual_mode=False):
        self.user = user
        self.old_password = self.user.password
        BaseEditor.__init__(self, conn, visual_mode=visual_mode)
        self._setup_widgets()

    def _setup_widgets(self):
        self.password_slave.set_password_labels(_('New Password:'),
                                                _('Retype New Password:'))
        if not self._needs_password_confirmation():
            self.current_password.hide()
            self.current_password_lbl.hide()

    def _needs_password_confirmation(self):
        current_user = api.get_current_user(self.conn)
        return current_user.profile.id != 1

    #
    # BaseEditorSlave Hooks
    #

    def get_title(self, model):
        title = _('Change "%s" Password') % self.user.username
        return title

    def create_model(self, conn):
        return LoginInfo()

    def setup_slaves(self):
        self.password_slave = PasswordEditorSlave(self.conn, self.model,
                                                  visual_mode=self.visual_mode)
        self.attach_slave('password_holder', self.password_slave)

        self._sizegroup = gtk.SizeGroup(gtk.SIZE_GROUP_HORIZONTAL)
        self._sizegroup.add_widget(self.current_password_lbl)
        self._sizegroup.add_widget(self.password_slave.password_lbl)
        self._sizegroup.add_widget(self.password_slave.confirm_password_lbl)

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    PasswordEditor.proxy_widgets)

    def validate_confirm(self):
        if not self._needs_password_confirmation():
            return True
        if self.model.current_password != self.old_password:
            msg = _(u"Password doesn't match with the stored one")
            self.current_password.set_invalid(msg)
            return False
        return True

    def on_confirm(self):
        self.password_slave.on_confirm()

        h = hashlib.new('sha256')
        h.update(self.user.username)
        h.update(self.model.new_password)

        self.user.password = h.hexdigest()
        return self.user


class UserDetailsSlave(BaseEditorSlave):
    gladefile = 'UserDetailsSlave'
    model_iface = IUser
    proxy_widgets = ('username',
                     'profile')

    def __init__(self, conn, model, show_password_fields=True,
                 visual_mode=False):
        self.show_password_fields = show_password_fields
        BaseEditorSlave.__init__(self, conn, model, visual_mode=visual_mode)

    def _setup_widgets(self):
        if self.show_password_fields:
            self._attach_slaves()
            self.change_password_button.hide()
        self._setup_profile_entry_completion()
        self._setup_role_entry_completition()

        employee = IEmployee(self.model, None)
        if employee is not None:
            self.role.select(employee.role)

    def _setup_profile_entry_completion(self):
        if self.model.profile is None:
            self.model.profile = UserProfile.get_default(conn=self.conn)
        profiles = UserProfile.select(connection=self.conn, orderBy='name')
        self.profile.prefill([(p.name, p) for p in profiles])

    def _setup_role_entry_completition(self):
        roles = EmployeeRole.select(connection=self.conn)
        items = [(role.name, role) for role in roles]
        items.insert(0, (_("No Role"), None))
        self.role.prefill(items)

    def _attach_slaves(self):
        self.password_slave = PasswordEditorSlave(self.conn)
        self.attach_slave('password_holder', self.password_slave)

        self._sizegroup = gtk.SizeGroup(gtk.SIZE_GROUP_HORIZONTAL)
        self._sizegroup.add_widget(self.username_lbl)
        self._sizegroup.add_widget(self.role_lbl)
        self._sizegroup.add_widget(self.profile)
        self._sizegroup.add_widget(self.role)
        self._sizegroup.add_widget(self.password_slave.password_lbl)
        self._sizegroup.add_widget(self.password_slave.confirm_password_lbl)

    #
    # BaseEditorSlave Hooks
    #

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model,
                                    UserDetailsSlave.proxy_widgets)

    def on_confirm(self):
        if self.show_password_fields:
            self.model.password = self.password_slave.model.new_password

        # FIXME:
        # 1) Move this hook into each instance of ProfileSettings
        # 2) Show some additional information in the user interface, which
        #    are related to the facets the current profile will add
        profile = self.profile.get_selected()
        person = self.model.person
        employee = IEmployee(person, None)
        if employee is None:
            person.addFacet(IEmployee, role=self.role.read(),
                            connection=self.conn)
        else:
            employee.role = self.role.read()

        # If the user can access POS then he/she can perform sales too
        can_access_pos = profile.check_app_permission("pos")
        can_access_sales = profile.check_app_permission("sales")
        can_do_sales = can_access_pos or can_access_sales
        if can_do_sales and not ISalesPerson(person, None):
            person.addFacet(ISalesPerson, connection=self.conn)

    #
    # Kiwi handlers
    #

    def on_username__map(self, widget):
        self.username.grab_focus()

    def on_username__validate(self, widget, value):
        if self.model.check_unique_value_exists('username', value,
                                                case_sensitive=False):
            return ValidationError('Username already exist')

    def on_change_password_button__clicked(self, button):
        run_dialog(PasswordEditor, get_current_toplevel(), self.conn, self.model)
