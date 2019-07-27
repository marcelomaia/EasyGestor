# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2013 Async Open Source
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU Lesser General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
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
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##

from kiwi.datatypes import ValidationError
from kiwi.utils import gsignal
from kiwi.decorators import signal_block
from stoqlib.gui.base.dialogs import run_dialog
from stoqlib.gui.dialogs.passworddialog import UserPassword

from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.formatters import get_price_format_str
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.translation import stoqlib_gettext


_ = stoqlib_gettext


class SaleDiscountEditor(BaseEditor):
    """A slave for discounts management
    """
    gladefile = 'SaleDiscountSlave'
    proxy_widgets = ('discount_value',
                     'discount_perc', )
    gsignal('discount-changed')

    def __init__(self, conn, model, model_type, visual_mode=False):
        self._proxy = None
        self.model_type = model_type
        self.max_discount = sysparam(conn).MAX_SALE_DISCOUNT
        BaseEditor.__init__(self, conn, model, visual_mode=visual_mode)

    def setup_widgets(self):
        format_str = get_price_format_str()
        self.discount_perc.set_data_format(format_str)
        self.update_widget_status()

    def update_widget_status(self):
        discount_by_value = not self.discount_perc_ck.get_active()
        self.discount_value.set_sensitive(discount_by_value)
        self.discount_perc.set_sensitive(not discount_by_value)

    def update_sale_discount(self):
        if self._proxy is None:
            return
        if self.discount_perc_ck.get_active():
            self._proxy.update('discount_value')
        else:
            self._proxy.update('discount_percentage')

        self.emit('discount-changed')

    def _validate_percentage(self, value, type_text):
        if value >= 100:
            self.model.discount_percentage = 0
            return ValidationError(_(u'%s can not be greater or equal '
                                     'to 100%%.') % type_text)
        if value > self.max_discount:
            if not run_dialog(UserPassword, self, self.conn):
                self.model.discount_percentage = 0
                return ValidationError(_("%s can not be greater then %d%%")
                                       % (type_text, self.max_discount))
        if value < 0:
            self.model.discount_percentage = 0
            return ValidationError(_("%s can not be less then 0")
                                   % type_text)
        self.update_sale_discount()

    def set_max_discount(self, discount):
        """Set the maximum percentage value for a discount.
        @param discount: the value for a discount.
        @type discount: L{int} in absolute value like 3
        """
        self.max_discount = discount

    #
    # BaseEditorSlave hooks
    #

    def setup_proxies(self):
        self.update_widget_status()
        self._proxy = self.add_proxy(self.model,
            SaleDiscountEditor.proxy_widgets)

    #
    # Kiwi callbacks
    #

    def on_discount_perc__validate(self, entry, value):
        return self._validate_percentage(value, _('Discount'))

    def on_discount_value__validate(self, entry, value):
        if self.model.get_total_sale_amount() == 0:
            return
        percentage = value * 100 / self.model.get_total_sale_amount()
        return self._validate_percentage(percentage, _(u'Discount'))

    @signal_block('discount_value.changed')
    def after_discount_perc__changed(self, *args):
        self.update_sale_discount()

    @signal_block('discount_perc.changed')
    def after_discount_value__changed(self, *args):
        self.update_sale_discount()

    def on_discount_value_ck__toggled(self, *args):
        self.update_widget_status()
