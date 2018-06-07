# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2006-2009 Async Open Source <http://www.async.com.br>
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
""" Slaves for products """

import gtk
import sys

from kiwi.datatypes import ValidationError
from stoqlib.domain.fiscal import NcmData
from stoqlib.domain.interfaces import IStorable
from stoqlib.domain.product import Product
from stoqlib.domain.taxes import ProductTaxTemplate
from stoqlib.gui.base.dialogs import run_dialog
from stoqlib.gui.editors.baseeditor import BaseEditorSlave
from stoqlib.gui.search.fiscalsearch import NcmSearch, CestSearch
from stoqlib.gui.slaves.sellableslave import SellableDetailsSlave
from stoqlib.lib.cest_parser import find_cest
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


class ProductInformationSlave(BaseEditorSlave):
    gladefile = 'ProductInformationSlave'
    model_type = Product
    proxy_widgets = ['location', 'part_number', 'manufacturer', 'width', 'cest',
                     'height', 'depth', 'weight', 'ncm', 'ex_tipi', 'genero', 'weighable',
                     'scale'
                     ]
    storable_widgets = ['minimum_quantity', 'maximum_quantity']

    def __init__(self, conn, model, db_form):
        self.db_form = db_form
        BaseEditorSlave.__init__(self, conn, model)

    def _setup_unit_labels(self):
        unit = self.model.sellable.unit
        if unit is None:
            unit_desc = _(u'Unit(s)')
        else:
            unit_desc = unit.description

        for label in [self.min_unit, self.max_unit]:
            label.set_text(unit_desc)

    def _setup_widgets(self):
        self._setup_unit_labels()

        for widget in [self.minimum_quantity, self.maximum_quantity,
                       self.width, self.height, self.depth, self.weight]:
            widget.set_adjustment(
                gtk.Adjustment(lower=0, upper=sys.maxint, step_incr=1))

        if not self.db_form:
            return
        self.db_form.update_widget(self.height, other=self.height_lbl)
        self.db_form.update_widget(self.width, other=self.width_lbl)
        self.db_form.update_widget(self.depth, other=self.depth_lbl)
        self.db_form.update_widget(self.location, other=self.location_lbl)
        self.db_form.update_widget(self.weight, other=[self.weight_lbl,
                                                       self.kg_lbl])
        self.db_form.update_widget(self.manufacturer,
                                   other=self.manufacturer_lbl)
        self.db_form.update_widget(self.part_number,
                                   other=self.part_number_lbl)
        # Stock details
        self.db_form.update_widget(self.minimum_quantity,
                                   other=[self.min_lbl,
                                          self.min_unit])
        self.db_form.update_widget(self.maximum_quantity,
                                   other=[self.max_lbl,
                                          self.max_unit])
        if (not self.minimum_quantity.get_visible() and
                not self.maximum_quantity.get_visible()):
            self.stock_lbl.hide()

        # Mercosul
        self.db_form.update_widget(self.ncm, other=self.ncm_lbl)
        self.db_form.update_widget(self.ex_tipi, other=self.ex_tipi_lbl)
        self.db_form.update_widget(self.genero, other=self.genero_lbl)

        if (not self.ncm.get_visible() and
                not self.ex_tipi.get_visible() and
                not self.genero.get_visible()):
            self.mercosul_lbl.hide()

        p_type = Product.product_types
        self.product_type.prefill([(p_type[p], p) for p in p_type])

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(
            self.model, ProductInformationSlave.proxy_widgets)

        storable = IStorable(self.model, None)
        if storable is not None:
            self.storable_proxy = self.add_proxy(
                storable, ProductInformationSlave.storable_widgets)

    def hide_stock_details(self):
        self.stock_lbl.hide()
        self.min_lbl.hide()
        self.max_lbl.hide()
        self.min_hbox.hide()
        self.max_hbox.hide()

        self.part_number_lbl.hide()
        self.part_number.hide()
        self.manufacturer_lbl.hide()
        self.manufacturer.hide()

    #
    # Kiwi Callbacks
    #

    def _positive_validator(self, value):
        if not value:
            return
        if value and value < 0:
            return ValidationError(_(u'The value must be positive.'))

    def on_width__validate(self, widget, value):
        return self._positive_validator(value)

    def on_height__validate(self, widget, value):
        return self._positive_validator(value)

    def on_depth__validate(self, widget, value):
        return self._positive_validator(value)

    def on_weight__validate(self, widget, value):
        return self._positive_validator(value)

    def on_ncm__validate(self, widget, value):
        if len(value) not in (0, 8):
            return ValidationError(_(u'NCM must have 8 digits.'))
        elif value != '':
            manager = get_plugin_manager()
            if manager.is_active('nfce') or manager.is_active('nfe2'):
                if not NcmData.selectOneBy(code=value, is_active=True, connection=self.conn):
                    return ValidationError(_(u'NCM inválido ou inativo'))

    def on_ncm__content_changed(self, *args):
        """Quando o ncm mudar, busca um cest recomendado"""
        ncm = self.ncm.read()
        cest = find_cest(ncm)
        self.cest.update(cest)

    def on_cest__validate(self, widget, value):
        if len(value) not in (0, 7):
            return ValidationError(_(u'CEST must have 7 digits.'))

    def on_ex_tipi__validate(self, widget, value):
        if len(value) not in (0, 2, 3):
            return ValidationError(_(u'EX TIPI must have 2 or 3 digits.'))

    def on_genero__validate(self, widget, value):
        if len(value) not in (0, 2):
            return ValidationError(_(u'NCM must have 2 digits.'))

    def on_minimum_quantity__validate(self, widget, value):
        if value and value < 0:
            return ValidationError(_(u'Minimum value must be a positive value.'))

        maximum = self.maximum_quantity.read()
        if maximum and value > maximum:
            return ValidationError(_(u'Minimum must be lower than the '
                                     'maximum value.'))

    def on_location__validate(self, widget, value):
        if value.strip() != value:
            return ValidationError("Não pode ter espaços vazios no final")

    def on_maximum_quantity__validate(self, widget, value):
        if not value:
            return
        if value and value < 0:
            return ValidationError(_(u'Maximum value must be a positive value.'))

        minimum = self.minimum_quantity.read()
        if minimum and minimum > value:
            return ValidationError(_(u'Maximum must be greater than the '
                                     'minimum value.'))

    def on_ncm_search__clicked(self, button):
        retval = run_dialog(NcmSearch, self, self.conn,
                            double_click_confirm=True,
                            hide_toolbar=True,
                            hide_footer=False,
                            selection_mode=gtk.SELECTION_BROWSE)
        self.model.ncm = getattr(retval, 'code', '')
        self.ncm.set_text(self.model.ncm)

    def on_cest_search__clicked(self, button):
        retval = run_dialog(CestSearch, self, self.conn,
                            double_click_confirm=True,
                            hide_toolbar=True,
                            hide_footer=False,
                            selection_mode=gtk.SELECTION_BROWSE)
        self.model.cest = getattr(retval, 'code', '')
        self.cest.set_text(self.model.cest)


class ProductDetailsSlave(SellableDetailsSlave):
    def setup_slaves(self):
        self.setup_image_slave(self.model.product)
        self.info_slave = ProductInformationSlave(self.conn, self.model.product,
                                                  self.db_form)
        self.attach_slave('details_holder', self.info_slave)

    def hide_stock_details(self):
        self.info_slave.hide_stock_details()


class ProductTaxSlave(BaseEditorSlave):
    gladefile = 'ProductTaxSlave'
    model_type = Product
    proxy_widgets = ['icms_template', 'ipi_template', 'pis_template', 'cofins_template']

    def _fill_combo(self, combo, type):
        types = [(None, None)]
        types.extend([(t.name, t.get_tax_model()) for t in
                      ProductTaxTemplate.selectBy(tax_type=type,
                                                  connection=self.conn)])
        combo.prefill(types)

    def _setup_widgets(self):
        self._fill_combo(self.icms_template, ProductTaxTemplate.TYPE_ICMS)
        self._fill_combo(self.ipi_template, ProductTaxTemplate.TYPE_IPI)
        self._fill_combo(self.pis_template, ProductTaxTemplate.TYPE_PIS)
        self._fill_combo(self.cofins_template, ProductTaxTemplate.TYPE_COFINS)

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)
