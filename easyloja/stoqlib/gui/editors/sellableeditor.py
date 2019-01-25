# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2011 Async Open Source <http://www.async.com.br>
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
""" Editors definitions for sellable"""

import gtk
import os
import platform
import sys
import webbrowser
from decimal import Decimal

from kiwi.datatypes import ValidationError, currency
from kiwi.log import Logger
from kiwi.ui.objectlist import Column
from stoqdrivers.enum import TaxType, UnitType
from stoqlib.api import api
from stoqlib.database.exceptions import IntegrityError
from stoqlib.domain.fiscal import CfopData
from stoqlib.domain.person import ClientCategory
from stoqlib.domain.sellable import (SellableCategory, Sellable,
                                     SellableUnit,
                                     SellableTaxConstant,
                                     ClientCategoryPrice, Recurrency)
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.lists import ModelListDialog
from stoqlib.gui.databaseform import DatabaseForm
from stoqlib.gui.editors.baseeditor import (BaseEditor,
                                            BaseRelationshipEditorSlave)
from stoqlib.gui.slaves.commissionslave import CommissionSlave
from stoqlib.gui.slaves.sellableslave import OnSaleInfoSlave
from stoqlib.lib.formatters import get_price_format_str, get_formatted_cost
from stoqlib.lib.message import info, yesno, warning
from stoqlib.lib.osutils import get_application_dir
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.validators import validate_sellable_description
from stoqlib.reporting.barcode_renderer import PROVIDED_BARCODES, generate_barcode

log = Logger('sellable.printing')
_system = platform.system()
_ = stoqlib_gettext

_DEMO_BAR_CODES = ['2368694135945', '6234564656756', '6985413595971',
                   '2692149835416', '1595843695465', '8596458216412',
                   '9586249534513', '7826592136954', '5892458629421',
                   '1598756984265', '1598756984265', '']
_DEMO_PRODUCT_LIMIT = 30


#
# Editors
#


class SellableTaxConstantEditor(BaseEditor):
    gladefile = 'SellableTaxConstantEditor'
    model_type = SellableTaxConstant
    model_name = _('Taxes and Tax rates')
    proxy_widgets = ('description',
                     'tax_value')

    def __init__(self, conn, model=None):
        BaseEditor.__init__(self, conn, model)

    #
    # BaseEditor
    #

    def create_model(self, conn):
        return SellableTaxConstant(tax_type=int(TaxType.CUSTOM),
                                   tax_value=None,
                                   description=u'',
                                   connection=conn)

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model,
                                    SellableTaxConstantEditor.proxy_widgets)


class SellableTaxConstantsDialog(ModelListDialog):
    # ModelListDialog
    model_type = SellableTaxConstant
    editor_class = SellableTaxConstantEditor
    size = (500, 300)
    title = _("Taxes")

    # ListDialog
    columns = [
        Column('description', _('Description'), data_type=str, expand=True),
        Column('value', _('Tax rate'), data_type=str, width=150),
    ]

    def selection_changed(self, constant):
        if constant is None:
            return
        is_custom = constant.tax_type == TaxType.CUSTOM
        self.listcontainer.remove_button.set_sensitive(is_custom)
        self.listcontainer.edit_button.set_sensitive(is_custom)

    def delete_model(self, model, trans):
        sellables = Sellable.selectBy(tax_constant=model, connection=trans)
        quantity = sellables.count()
        if quantity > 0:
            msg = _(u"You can't remove this tax, since %d products or "
                    "services are taxed with '%s'.") % (
                      quantity, model.get_description())
            info(msg)
        else:
            SellableTaxConstant.delete(model.id, connection=trans)


class BasePriceEditor(BaseEditor):
    gladefile = 'SellablePriceEditor'
    proxy_widgets = ('cost', 'markup', 'max_discount', 'price')

    def set_widget_formats(self):
        widgets = (self.markup, self.max_discount)
        for widget in widgets:
            widget.set_data_format(get_price_format_str())

    #
    # BaseEditor hooks
    #

    def get_title(self, *args):
        return _('Price settings')

    def setup_proxies(self):
        self.set_widget_formats()
        self.main_proxy = self.add_proxy(self.model, self.proxy_widgets)
        if self.model.markup is not None:
            return
        sellable = self.model.sellable
        self.model.markup = sellable.get_suggested_markup()
        self.main_proxy.update('markup')

    #
    # Kiwi handlers
    #

    def on_price__validate(self, entry, value):
        if value <= 0:
            return ValidationError(_("Price cannot be zero or negative"))

    def after_price__content_changed(self, entry_box):
        self.handler_block(self.markup, 'changed')
        self.main_proxy.update("markup")
        self.handler_unblock(self.markup, 'changed')

    def after_markup__content_changed(self, spin_button):
        self.handler_block(self.price, 'changed')
        self.main_proxy.update("price")
        self.handler_unblock(self.price, 'changed')


class BasePriceSuggestionEditor(BaseEditor):
    gladefile = 'Markup'
    proxy_widgets = ('cost', 'price', 'commission')
    model_type = Sellable

    def __init__(self, conn, model=None, visual_mode=False):
        super(BasePriceSuggestionEditor, self).__init__(conn, model, visual_mode)
        self.setup_widgets()

    def setup_widgets(self):
        tax_constant = self.model.tax_constant
        if tax_constant.tax_value is not None:
            self.icms.update(tax_constant.tax_value)
        else:
            self.icms.update(0)
        self.confins.update(0)
        self.gain.update(0)
        self.others.update(0)
        self.financial.update(0)
        self.simple.update(0)
        self.freight.update(0)
        # self.calculate_button.set_tooltip_text('Calcular...')
        self.price.set_data_format(get_price_format_str())

    #
    # BaseEditor hooks
    #

    def compute_final_price(self):
        # updates the value of  final price
        cost = self.cost.read()
        icms = self.icms.read()
        confins = self.confins.read()
        commission = self.commission.read()
        gain = self.gain.read()
        financial = self.financial.read()
        others = self.others.read()
        simple = self.simple.read()
        freight = self.freight.read()

        markup = Decimal(Decimal(100.00) - icms - confins - commission - gain - financial - others - simple - freight) / Decimal(100.00)
        print markup, 'markup'
        final = cost / markup

        self.price.update(final)

    def get_title(self, *args):
        return _('Ajuda no cálculo de preços')

    def setup_proxies(self):
        self.main_proxy = self.add_proxy(self.model, self.proxy_widgets)
        if self.model.markup is not None:
            return

    def on_confirm(self):
        price = self.price.read()
        gain = self.gain.read()
        txt = 'Preço final: R$ {}\n' \
              'Lucro: {}% = R$ {}'.format(price, gain, gain * price / Decimal(100.00))
        info(txt)
        return self.model

    def on_key_press(self, widget, event):
        pass

    #
    # Callbacks
    #

    # def on_calculate_button__clicked(self, button):
    #     icms = self.icms.read()
    #     confins = self.confins.read()
    #     commission = self.commission.read()
    #     gain = self.gain.read()
    #     financial = self.financial.read()
    #     others = self.others.read()
    #     if icms + confins + commission + gain + financial + others >= 100:
    #         info('A somatoria das porcentagens é maior que 100',
    #              'A somatória de icms, confins, commissão, lucro, custo, financeiro '
    #              'e outros não pode ser maior ou igual a 100')
    #         self.price.update(Decimal(0))
    #         return
    #     self.compute_final_price()

    def on_cost__changed(self, *args):
        self.compute_final_price()

    def on_icms__changed(self, *args):
        self.compute_final_price()

    def on_confins__changed(self, *args):
        self.compute_final_price()

    def on_commission__changed(self, *args):
        self.compute_final_price()

    def on_gain__changed(self, *args):
        self.compute_final_price()

    def on_financial__changed(self, *args):
        self.compute_final_price()

    def on_others__changed(self, *args):
        self.compute_final_price()

    def on_simple__changed(self, *args):
        self.compute_final_price()
        
    def on_freight__changed(self, *args):
        self.compute_final_price()

class SellablePriceEditor(BasePriceEditor):
    model_name = _(u'Product Price')
    model_type = Sellable

    def setup_slaves(self):
        slave = OnSaleInfoSlave(self.conn, self.model)
        self.attach_slave('on_sale_holder', slave)

        commission_slave = CommissionSlave(self.conn, self.model)
        self.attach_slave('on_commission_data_holder', commission_slave)
        if self.model.category:
            desc = self.model.category.description
            label = _('Calculate Commission From: %s') % desc
            commission_slave.change_label(label)

    def on_confirm(self):
        slave = self.get_slave('on_commission_data_holder')
        slave.confirm()
        return self.model


class CategoryPriceEditor(BasePriceEditor):
    model_name = _(u'Category Price')
    model_type = ClientCategoryPrice
    sellable_widgets = ('cost',)
    proxy_widgets = ('markup', 'max_discount', 'price')

    def setup_proxies(self):
        self.sellable_proxy = self.add_proxy(self.model.sellable,
                                             self.sellable_widgets)
        BasePriceEditor.setup_proxies(self)


#
# Slaves
#

class CategoryPriceSlave(BaseRelationshipEditorSlave):
    """A slave for changing the suppliers for a product.
    """
    target_name = _(u'Category')
    editor = CategoryPriceEditor
    model_type = ClientCategoryPrice

    def __init__(self, conn, sellable):
        self._sellable = sellable
        BaseRelationshipEditorSlave.__init__(self, conn)

    def get_targets(self):
        cats = ClientCategory.select(connection=self.conn).orderBy('name')
        return [(c.get_description(), c) for c in cats]

    def get_relations(self):
        return self._sellable.get_category_prices()

    def _format_markup(self, obj):
        return '%0.2f%%' % obj

    def get_columns(self):
        return [Column('category_name', title=_(u'Category'),
                       data_type=str, expand=True, sorted=True),
                Column('price', title=_(u'Price'), data_type=currency,
                       format_func=get_formatted_cost, width=150),
                Column('markup', title=_(u'Markup'), data_type=str,
                       width=100, format_func=self._format_markup),
                ]

    def create_model(self):
        sellable = self._sellable
        category = self.target_combo.get_selected_data()

        if sellable.get_category_price_info(category):
            product_desc = sellable.get_description()
            info(_(u'%s already have a price for category %s') % (product_desc,
                                                                  category.get_description()))
            return

        model = ClientCategoryPrice(sellable=sellable,
                                    category=category,
                                    price=sellable.price,
                                    max_discount=sellable.max_discount,
                                    connection=self.conn)
        return model


#
# Editors
#


class SellableEditor(BaseEditor):
    """This is a base class for ProductEditor and ServiceEditor and should
    be used when editing sellable objects. Note that sellable objects
    are instances inherited by Sellable."""

    # This must be be properly defined in the child classes
    model_name = None
    model_type = None

    gladefile = 'SellableEditor'
    confirm_widgets = ['description', 'cost', 'price']
    ui_form_name = None
    sellable_tax_widgets = ('tax_constant', 'tax_value',)
    sellable_widgets = ('code',
                        'barcode',
                        'description',
                        'category_combo',
                        'cost',
                        'price',
                        'statuses_combo',
                        'default_sale_cfop',
                        'unit_combo')
    proxy_widgets = (sellable_tax_widgets + sellable_widgets)

    def _get_sugestion_code(self, conn):
        # fonte: http://stackoverflow.com/questions/10518258/typecast-string-to-integer-postgres
        # retira a maior substring numerica da coluna code
        sql = "select " \
              "max(substring(REGEXP_REPLACE(COALESCE(code, '0'), '[^0-9]*' ,'0') FROM '[0-9]+')::numeric) " \
              "from sellable"
        data = conn.queryOne(sql)
        if data:
            return data[0] + 1
        return 0

    def __init__(self, conn, model=None):
        is_new = not model
        self._sellable = None
        self._demo_mode = sysparam(conn).DEMO_MODE
        self._requires_weighing_text = (
                "<b>%s</b>" % _("This unit type requires weighing"))

        if self.ui_form_name:
            self.db_form = DatabaseForm(conn, self.ui_form_name)
        else:
            self.db_form = None
        BaseEditor.__init__(self, conn, model)
        self.enable_window_controls()
        if self._demo_mode:
            self._add_demo_warning()

        # code suggestion
        edit_code_product = sysparam(self.conn).EDIT_CODE_PRODUCT
        self.code.set_sensitive(not edit_code_product)
        if not self.code.read():
            suggestion = self._get_sugestion_code(conn)
            code = u'%d' % suggestion
            self.code.update(code)

        self.description.grab_focus()
        self.table.set_focus_chain([self.code,
                                    self.barcode,
                                    self.default_sale_cfop,
                                    self.description,
                                    self.cost_hbox,
                                    self.price_hbox,
                                    self.consignment_box,
                                    self.statuses_combo,
                                    self.category_combo,
                                    self.tax_hbox,
                                    self.unit_combo,
                                    ])
        self.setup_widgets()

        if not is_new:
            if self._sellable.is_closed():
                self._add_reopen_button()
            elif self._sellable.can_close():
                self._add_close_button()

            if self._sellable.can_remove():
                self._add_delete_button()

        self.set_main_tab_label(self.model_name)
        price_slave = CategoryPriceSlave(self.conn, self.model.sellable)
        self.add_extra_tab(_(u'Category Prices'), price_slave)
        self._setup_ui_forms()
        # self.setup_recurrency_widget()
        self._setup_default_sales_cfop()

    def _setup_default_sales_cfop(self):
        if not self.default_sale_cfop.read():
            self.default_sale_cfop.select(sysparam(self.conn).DEFAULT_SALES_CFOP)

    def _add_demo_warning(self):
        self.add_message_bar(
            _("This is a demostration mode of Stoq, you cannot create more than %d products.\n"
              "To avoid this limitation, enable production mode.") % (
                _DEMO_PRODUCT_LIMIT))
        if Sellable.select(connection=self.conn).count() > _DEMO_PRODUCT_LIMIT:
            self.disable_ok()

    def _add_extra_button(self, label, stock=None,
                          callback_func=None, connect_on='clicked'):
        button = self.add_button(label, stock)
        if callback_func:
            button.connect(connect_on, callback_func, label)

    def _add_delete_button(self):
        self._add_extra_button(_('Remove'), gtk.STOCK_DELETE,
                               self._on_delete_button__clicked)

    def _add_close_button(self):
        if self._sellable.product:
            label = _('Close Product')
        else:
            label = _('Close Service')

        self._add_extra_button(label, None,
                               self._on_close_sellable_button__clicked)

    def _add_reopen_button(self):
        if self._sellable.product:
            label = _('Reopen Product')
        else:
            label = _('Reopen Service')

        self._add_extra_button(label, None,
                               self._on_reopen_sellable_button__clicked)

    def _setup_ui_forms(self):
        if not self.db_form:
            return

        self.db_form.update_widget(self.code, other=self.code_lbl)
        self.db_form.update_widget(self.barcode, other=self.barcode_lbl)
        self.db_form.update_widget(self.category_combo,
                                   other=self.category_lbl)

    # def _setup_recurrency_widgets(self):
    #     if self.model.sellable.has_recurrency():
    #         self.ck_recurrency.set_sensitive(False)

    #
    #  Public API
    #

    def set_main_tab_label(self, tabname):
        self.sellable_notebook.set_tab_label(self.sellable_tab,
                                             gtk.Label(tabname))

    def add_extra_tab(self, tabname, tabslave):
        self.sellable_notebook.set_show_tabs(True)
        self.sellable_notebook.set_show_border(True)

        event_box = gtk.EventBox()
        event_box.show()
        self.sellable_notebook.append_page(event_box, gtk.Label(tabname))
        self.attach_slave(tabname, tabslave, event_box)

    def set_widget_formats(self):
        for widget in (self.cost, self.price):
            widget.set_adjustment(gtk.Adjustment(lower=0, upper=sys.maxint,
                                                 step_incr=1))
        self.requires_weighing_label.set_size("small")
        self.requires_weighing_label.set_text("")
        self.status_unavailable_label.set_size("small")
        self.status_unavailable_label.set_text("")

    def edit_sale_price(self):
        sellable = self.model.sellable
        result = run_dialog(SellablePriceEditor, get_current_toplevel(), self.conn, sellable)
        if result:
            self.sellable_proxy.update('price')

    def edit_sale_price_suggested(self):
        sellable = self.model.sellable
        result = run_dialog(BasePriceSuggestionEditor, get_current_toplevel(), self.conn, sellable)
        if result:
            self.sellable_proxy.update('price')

    def setup_widgets(self):
        raise NotImplementedError

    def update_requires_weighing_label(self):
        unit = self._sellable.unit
        if unit and unit.unit_index == UnitType.WEIGHT:
            self.requires_weighing_label.set_text(self._requires_weighing_text)
        else:
            self.requires_weighing_label.set_text("")

    def _update_tax_value(self):
        if not hasattr(self, 'tax_proxy'):
            return
        self.tax_proxy.update('tax_constant.tax_value')

    def get_taxes(self):
        """Subclasses may override this method to provide a custom
        tax selection.

        @returns: a list of tuples containing the tax description and a
            L{stoqlib.domain.sellable.SellableTaxConstant} object.
        """
        return []

    #
    # BaseEditor hooks
    #
    def setup_recurrency_widget(self):
        if Recurrency.selectOneBy(sellable=self.model.sellable, connection=self.conn):
            self.ck_recurrency.set_sensitive(False)

    def setup_sellable_combos(self):
        self.setup_sellable_category_combo()

        self.statuses_combo.prefill(
            [(v, k) for k, v in Sellable.statuses.items()])
        self.statuses_combo.set_sensitive(False)

        cfop_items = [(item.get_description(), item)
                      for item in CfopData.select(connection=self.conn)]
        cfop_items.insert(0, ('', None))
        self.default_sale_cfop.prefill(cfop_items)

        self.setup_unit_combo()

    def setup_sellable_category_combo(self):
        category_list = SellableCategory.select(
            SellableCategory.q.categoryID != None,
            connection=self.conn).orderBy('description')

        items = [(cat.get_description(), cat) for cat in category_list]
        self.category_combo.prefill(items)

    def setup_unit_combo(self):
        units = SellableUnit.select(connection=self.conn)
        items = [(_("No unit"), None)]
        items.extend([(unit.description, unit) for unit in units])
        self.unit_combo.prefill(items)

    def setup_tax_constants(self):
        taxes = self.get_taxes()
        self.tax_constant.prefill(taxes)

    def setup_proxies(self):
        self.set_widget_formats()
        self._sellable = self.model.sellable

        self.setup_sellable_combos()
        self.setup_tax_constants()
        self.tax_proxy = self.add_proxy(self._sellable,
                                        SellableEditor.sellable_tax_widgets)

        self.sellable_proxy = self.add_proxy(self._sellable,
                                             SellableEditor.sellable_widgets)

        self.update_requires_weighing_label()

    #
    # Kiwi handlers
    #

    def _on_delete_button__clicked(self, button, parent_button_label=None):
        sellable_description = self._sellable.get_description()
        msg = (_("This will delete '%s' from the database. Are you sure?")
               % sellable_description)
        if not yesno(msg, gtk.RESPONSE_NO, _("Delete"), _("Keep")):
            return

        try:
            self._sellable.remove()
        except IntegrityError, details:
            warning(_("It was not possible to remove '%s'")
                    % sellable_description, str(details))
            return
        # We don't call self.confirm since it will call validate_confirm
        self.cancel()
        self.main_dialog.retval = True

    def _on_close_sellable_button__clicked(self, button,
                                           parent_button_label=None):
        msg = (_("Do you really want to close '%s'?\n"
                 "Please note that when it's closed, you won't be able to "
                 "commercialize it anymore.")
               % self._sellable.get_description())
        if not yesno(msg, gtk.RESPONSE_NO,
                     parent_button_label, _("Don't close")):
            return

        self._sellable.close()
        self.confirm()

    def _on_reopen_sellable_button__clicked(self, button,
                                            parent_button_label=None):
        msg = (_("Do you really want to reopen '%s'?\n"
                 "Note that when it's opened, you will be able to "
                 "commercialize it again.") % self._sellable.get_description())
        if not yesno(msg, gtk.RESPONSE_NO,
                     parent_button_label, _("Keep closed")):
            return

        self._sellable.set_unavailable()
        self.confirm()

    def on_tax_constant__changed(self, combo):
        self._update_tax_value()

    def on_unit_combo__changed(self, combo):
        self.update_requires_weighing_label()

    def on_sale_price_button__clicked(self, button):
        self.edit_sale_price()

    def on_sale_price_suggestion__clicked(self, button):
        self.edit_sale_price_suggested()

    # def on_ck_recurrency__toggled(self, *args, **kwargs):
    #     self.edit_recurrency()

    def on_code__validate(self, widget, value):
        if not value:
            return ValidationError(_(u'The code can not be empty.'))
        if self.model.sellable.check_code_exists(value):
            return ValidationError(_(u'The code %s already exists.') % value)
        if value.strip() != value:
            return ValidationError("Não pode ter espaços vazios no final")

    def on_barcode__validate(self, widget, value):
        if not value:
            self.model.sellable.generate_barcode()
            return
        if value and len(value) > 14:
            return ValidationError(_(u'Barcode must have 14 digits or less.'))
        if self.model.sellable.check_barcode_exists(value):
            return ValidationError(_('The barcode %s already exists') % value)
        if self._demo_mode and value not in _DEMO_BAR_CODES:
            return ValidationError(_("Cannot create new barcodes in "
                                     "demonstration mode"))
        if value.strip() != value:
            return ValidationError("Não pode ter espaços vazios no final")

    def on_price__validate(self, entry, value):
        if value <= 0:
            return ValidationError(_("Price cannot be zero or negative"))

    def on_cost__validate(self, entry, value):
        if value <= 0:
            return ValidationError(_("Cost cannot be zero or negative"))

    def on_description__validate(self, widget, description):
        if description == '':
            return
        if not validate_sellable_description(description):
            return ValidationError(u'A descrição {} é inválida'.format(description))


class BarcodeEditor(BaseEditor):
    size = (700, 400)
    model_name = _('Barcode')
    model_type = Sellable
    proxy_widgets = ['barcode']
    gladefile = 'BarcodeEditor'

    def __init__(self, conn, model=None, visual_mode=False):
        super(BarcodeEditor, self).__init__(conn, model, visual_mode)

    def can_generate_barcode(self):
        barcode = self.model.barcode
        return barcode != ''

    def setup_proxies(self):
        self.setup_widgets()
        self.add_proxy(self.model, self.proxy_widgets)
        super(BarcodeEditor, self).setup_proxies()

    def setup_widgets(self):
        self.barcode_type.prefill(PROVIDED_BARCODES)
        self.barcode_type.select('ean13')
        self.barcode.set_bold(True)
        self._refresh_barcode()

    def _refresh_barcode(self):
        if not self.can_generate_barcode():
            return
        barcode_type = self.barcode_type.read()
        image_pth = os.path.join(get_application_dir(), 'barcode', barcode_type, self.model.barcode + '.png')

        if self.model.barcode != '' and os.path.exists(image_pth):
            gtkimage = gtk.Image()
            gtkimage.set_from_file(image_pth)

            child = self.barcode_container.get_child()
            if child:
                self.barcode_container.remove(child)
            self.barcode_container.add(gtkimage)
            self.barcode_container.show_all()

    def print_barcode(self, filename):
        if _system == "Windows":
            log.info("Starting reader for %r" % (filename,))
            # Simply execute the file
            ret = os.startfile(filename)
        elif _system == "Linux":
            log.info("Starting reader for %r" % (filename,))
            webbrowser.open(filename)

    #
    # Callbacks
    #

    def on_print_image_bt__clicked(self, button):
        if not self.can_generate_barcode():
            return
        barcode_type = self.barcode_type.read()
        image_pth = os.path.join(get_application_dir(), 'barcode', barcode_type, self.model.barcode + '.png')
        if not os.path.exists(image_pth):
            return
        self.print_barcode(image_pth)

    def on_barcode_type__content_changed(self, cb):
        self._refresh_barcode()

    def on_create_img__clicked(self, bt):
        if not self.can_generate_barcode():
            return
        barcode_type = self.barcode_type.read()
        code = self.model.barcode
        generate_barcode(barcode_type, str(code))
        self._refresh_barcode()


class RecurrencyEditor(BaseEditor):
    model_name = _("Recorrencia")
    model_type = Recurrency
    gladefile = 'RecurrencyEditor'
    size = (450, 300)
    proxy_widgets = ('type_period', 'period', 'message', 'subject')

    # FIXME: the widget period always backs to 0, WHY god?
    # FIXME: the Recurrency is not saving in database, WHY god[2]?

    def __init__(self, conn, model=None, sellable=None, visual_mode=False):
        self.sellable = sellable
        self.conn = conn
        super(RecurrencyEditor, self).__init__(conn, model, visual_mode)

    def create_model(self, conn):
        return Recurrency(sellable=self.sellable,
                          connection=self.conn)

    def setup_proxies(self):
        self.setup_widgets()
        self.add_proxy(self.model, self.proxy_widgets)
        super(RecurrencyEditor, self).setup_proxies()

    def setup_widgets(self):
        self.type_period.prefill(Recurrency.TYPE_PERIOD.keys())
        self.use_default_ck.set_active(True)
        self.subject.set_sensitive(False)

    def on_use_default_ck__toggled(self, *args, **kwargs):
        if self.subject.is_sensitive():
            self.subject.set_sensitive(False)
        else:
            self.subject.set_sensitive(True)

    def on_confirm(self):
        if self.use_default_ck.get_active():
            self.model.subject = api.sysparam(api.get_connection()).DEFAULT_SUBJECT_RECURRENCY
        return self.model
