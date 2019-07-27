# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2007-2008 Async Open Source
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
##

import locale

import rows
from kiwi.ui.dialogs import open
from stoqlib.database.runtime import get_connection, get_current_branch
from stoqlib.domain.commission import CommissionSource
from stoqlib.domain.interfaces import IStorable, ISupplier
from stoqlib.domain.person import Person
from stoqlib.domain.product import Product, ProductStockItem, ProductAdaptToStorable
from stoqlib.domain.product import ProductSupplierInfo
from stoqlib.domain.sellable import (Sellable, SellableUnit)
from stoqlib.domain.sellable import (SellableCategory)
from stoqlib.gui.dialogs.progressdialog import ProgressDialog
from stoqlib.importers.csvimporter import CSVImporter
from stoqlib.lib.parameters import sysparam


class ProductImporter2(object):
    valid_columns = ['codigo', 'codigo_de_barras', 'ncm', 'categoria', 'imposto',
                     'descricao', 'localizacao', 'preco', 'custo', 'estoque', 'unidade']

    def _get_or_create_unit(self, unit_desc, trans):
        unit = SellableUnit.selectOneBy(description=unit_desc, connection=trans)
        if unit is None:
            unit = SellableUnit(description=unit_desc, connection=trans)
        return unit

    def _create_product(self, data, trans):
        conn = get_connection()
        default_tc = sysparam(conn).DEFAULT_PRODUCT_TAX_CONSTANT
        barcode = str(data.get('barcode', ''))
        unit = self._get_or_create_unit(data.get('unit'), trans)

        quantity = float(data.get('stock', 0))
        status = Sellable.STATUS_UNAVAILABLE
        if quantity > 0:
            status = Sellable.STATUS_AVAILABLE

        sellable = Sellable(connection=trans,
                            status=status,
                            base_price=data.get('price', 0),
                            code=str(data.get('code', '')),
                            barcode=barcode,
                            description=data.get('description', ''),
                            unit=unit,
                            commission=data.get('commission', 0),
                            notes=str(data.get('notes', '')),
                            tax_constant=default_tc)

        product = Product(sellable=sellable, ncm=str(data.get('ncm', '')), connection=trans)
        storable = ProductAdaptToStorable(originalID=product,
                                          minimum_quantity=data.get('minimum_quantity', 0),
                                          maximum_quantity=data.get('maximum_quantity', 0),
                                          connection=trans)
        branch = get_current_branch(conn=conn)
        ProductStockItem(quantity=quantity, storable=storable, branch=branch, connection=trans)
        conn.close()

    def import_products(self, trans):
        path = open(title='Entre com o CSV ou Excel', patterns=['*.csv', '*.xls', '*.xlsx'])
        if path is None:
            return
        d = ProgressDialog('Updating items')
        d.start(wait=0)

        with rows.locale_context(name='pt_BR.UTF-8', category=locale.LC_NUMERIC):
            func = getattr(rows, 'import_from_csv')
            if 'xls' in path:
                func = getattr(rows, 'import_from_xls')
            if 'xlsx' in path:
                func = getattr(rows, 'import_from_xlsx')
            products = func(path,
                            force_types={'codigo': rows.fields.TextField,
                                         'codigo_de_barras': rows.fields.TextField,
                                         'ncm': rows.fields.TextField,
                                         'categoria': rows.fields.TextField,
                                         'descricao': rows.fields.TextField,
                                         'localizacao': rows.fields.TextField,
                                         'preco': rows.fields.FloatField,
                                         'custo': rows.fields.FloatField,
                                         'estoque': rows.fields.FloatField,
                                         'unidade': rows.fields.TextField})
        for product in products:
            for field_name, field_type in products.fields.items():
                self._validate_column_name(field_name)
            product_dict = self._parse_to_dict(product)
            self._create_product(product_dict, trans)
            # d.pulse()
        d.stop()

    def _validate_column_name(self, field_name):
        if field_name not in self.valid_columns:
            raise Exception('Campo "{}" não é permitido. Use somente estes {}'.
                            format(field_name, self.valid_columns))

    def _parse_to_dict(self, product):
        data = dict(cost=getattr(product, 'custo', 0),
                    barcode=getattr(product, 'codigo_de_barras', ''),
                    code=getattr(product, 'codigo', ''),
                    description=getattr(product, 'descricao', ''),
                    location=getattr(product, 'localizacao', ''),
                    price=getattr(product, 'preco', 0),
                    unit=getattr(product, 'unidade', 'un'),
                    ncm=getattr(product, 'ncm', ''),
                    category=getattr(product, 'categoria', ''),
                    stock=getattr(product, 'estoque', 0))
        return data


class ProductImporter(CSVImporter):
    fields = ['base_category',
              'barcode',
              'category',
              'description',
              'price',
              'cost',
              'commission',
              'commission2',
              'markup',
              'markup2'
              ]

    optional_fields = [
        'unit',
    ]

    def __init__(self):
        super(ProductImporter, self).__init__()
        conn = get_connection()
        suppliers = Person.iselect(ISupplier, connection=conn)
        if not suppliers.count():
            raise ValueError('You must have at least one suppliers on your '
                             'database at this point.')
        self.supplier = suppliers[0]

        self.units = {}
        for unit in SellableUnit.select(connection=conn):
            self.units[unit.description] = unit

        self.tax_constant = sysparam(conn).DEFAULT_PRODUCT_TAX_CONSTANT

    def _get_or_create(self, table, trans, **attributes):
        obj = table.selectOneBy(connection=trans, **attributes)
        if obj is None:
            obj = table(connection=trans, **attributes)
        return obj

    def process_one(self, data, fields, trans):
        base_category = self._get_or_create(
            SellableCategory, trans,
            suggested_markup=int(data.markup),
            salesperson_commission=int(data.commission),
            category=None,
            description=data.base_category)

        # create a commission source
        self._get_or_create(
            CommissionSource, trans,
            direct_value=int(data.commission),
            installments_value=int(data.commission2),
            category=base_category)

        category = self._get_or_create(
            SellableCategory, trans,
            description=data.category,
            suggested_markup=int(data.markup2),
            category=base_category)

        if 'unit' in fields:
            if not data.unit in self.units:
                raise ValueError("invalid unit: %s" % data.unit)
            unit = self.units[data.unit]
        else:
            unit = None
        sellable = Sellable(connection=trans,
                            cost=float(data.cost),
                            code=data.barcode,
                            barcode=data.barcode,
                            category=category,
                            description=data.description,
                            price=int(data.price),
                            unit=unit,
                            tax_constant=self.tax_constant)
        product = Product(sellable=sellable, connection=trans)

        ProductSupplierInfo(connection=trans,
                            supplier=self.supplier,
                            is_main_supplier=True,
                            base_cost=float(data.cost),
                            product=product)
        product.addFacet(IStorable, connection=trans)
