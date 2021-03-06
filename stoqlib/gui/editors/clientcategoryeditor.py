# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2010 Async Open Source <http://www.async.com.br>
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
"""Dialog for listing client categories"""

from kiwi.datatypes import ValidationError

from stoqlib.domain.person import ClientCategory
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class ClientCategoryEditor(BaseEditor):
    model_name = _('Client Category')
    model_type = ClientCategory
    gladefile = 'ClientCategoryEditor'
    confirm_widgets = ['name']

    def create_model(self, trans):
        return ClientCategory(name='', connection=trans)

    def setup_proxies(self):
        self.name.grab_focus()
        self.add_proxy(self.model, ['name'])

    #
    #Kiwi Callbacks
    #

    def on_name__validate(self, widget, new_name):
        if not new_name:
            return ValidationError(
                _(u"The client category should have a name."))
        if self.model.check_unique_value_exists('name', new_name):
            return ValidationError(
                _(u"The client category '%s' already exists.") % new_name)
