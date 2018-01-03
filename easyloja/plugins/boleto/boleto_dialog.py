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
## Author(s): George Kussumoto      <george@async.com.br>
##
##

from kiwi.datatypes import ValidationError

from stoqlib.gui.editors.baseeditor import BaseEditor

from tefdomain import TEFClient


class TEFClientDialog(BaseEditor):
    gladefile = 'TEFClientDialog'
    model_type = TEFClient
    model_name = _('TEF Client')
    proxy_widgets = ['path', 'host', 'port']
    size = (600, 200)

    #
    # BaseEditor
    #

    def create_model(self, conn):
        results = TEFClient.select(connection=conn).limit(1)
        if results:
            return results[0]
        return TEFClient(path='/', connection=conn)

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    TEFClientDialog.proxy_widgets)

    #
    # Callbacks
    #

    def on_filechooser_button__selection_changed(self, widget):
        filename = widget.get_filename()
        self.path.set_text(filename)

    def on_path__validate(self, widget, filename):
        if not filename:
            return
        if not filename.endswith('.bat'):
            return ValidationError('O Cliente TEF deve ser um .bat')
