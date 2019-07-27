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

import hashlib
import locale
import platform

import rows
from dateutil import parser as date_parser
from kiwi.datatypes import ValidationError
from kiwi.python import Settable
from kiwi.ui.dialogs import open
from kiwi.utils import gsignal
from stoqlib.api import api
from stoqlib.domain.payment.category import PaymentCategory
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.domain.payment.payment import Payment, PaymentAdaptToInPayment, PaymentAdaptToOutPayment
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.colorutils import get_random_color

locale_language = 'portuguese_brazil'
if platform.system() != 'Windows':
    locale_language = 'pt_BR.UTF-8'


class PaymentImporter(BaseEditor):
    gladefile = 'CSVImporter'
    proxy_widgets = ('path', 'import_type')
    model_type = Settable
    title = 'Importar contas a pagar e receber'
    gsignal('progressbar_update', str, float)

    (CONTAS_PAGAR,
     CONTAS_RECEBER) = range(2)
    import_types = {'Contas a pagar': CONTAS_PAGAR,
                    'Contas a receber': CONTAS_RECEBER}

    valid_columns = ['field_0', 'comentarios', 'nome_fantasia', 'cpf', 'cnpj', 'sacado', 'descricao', 'valor_real',
                     'taxa', 'dt_abrt_venda', 'dt_confirm_venda', 'vencimento', 'data_do_pagamento', 'situacao', 'valor',
                     'na_filial', 'pago', 'categoria', 'forma_de_pagamento', 'data_de_abertura', 'fornecedor']

    def __init__(self, conn):
        self.trans = conn
        super(PaymentImporter, self).__init__(conn)
        self.connect("progressbar_update", self._update_progressbar)

    def _update_progressbar(self, arg, msg, fraction):
        self.progressbar.set_text(msg)
        self.progressbar.set_fraction(fraction)

    def setup_proxies(self):
        self.import_button.set_sensitive(False)
        self.import_type.prefill([(p, self.import_types.get(p)) for p in self.import_types.keys()])
        self.add_proxy(self.model, self.proxy_widgets)

    def create_model(self, trans):
        return Settable(path=u'', import_type=self.CONTAS_RECEBER)

    def _get_or_create_category(self, name, branch_name):
        trans = api.new_transaction()
        color = get_random_color()
        name = '{}_{}'.format(branch_name, name)
        category = PaymentCategory.selectOneBy(name=name, connection=trans)
        if category is None:
            category = PaymentCategory(name=name, color=color, connection=trans)
        trans.commit(close=True)
        return category

    def _get_status_code(self, payment_str):
        d = {u'Avaliação': 0,
             'A pagar': 1,
             'Pago': 2,
             u'Revisão': 3,
             'Confirmado': 4,
             'Cancelada': 5,
             'Atrasado': 6}
        status = d.get(payment_str)
        return status

    def _create_payment(self, data, payment_class, trans):
        group = PaymentGroup(connection=trans)
        h = hashlib.md5()
        h.update('{}{}{}'.format(data.get('id'), data.get('payment_description'), data.get('open_date')))
        payment_status = self._get_status_code(data.get('status'))
        if payment_status not in [Payment.STATUS_PAID, Payment.STATUS_CANCELLED, Payment.STATUS_PENDING]:
            return False
        payment = Payment(status=payment_status,
                          open_date=data.get('open_date'),
                          due_date=data.get('due_date'),
                          paid_date=data.get('paid_date'),
                          paid_value=data.get('paid_value'),
                          base_value=data.get('base_value'),
                          value=data.get('value'),
                          interest=data.get('interest', 0),
                          discount=data.get('discount', 0),
                          penalty=data.get('penalty', 0),
                          description="{} #id migrado: {}".format(data.get('description'), data.get('id')),
                          method=PaymentMethod.get_by_description(trans, data.get('payment_description')),
                          group=group,
                          till=None,
                          category=self._get_or_create_category(name=data.get('category'),
                                                                branch_name=data.get('in_branch')),
                          migrated_hash=h.hexdigest(),
                          connection=trans)
        payment_class(originalID=payment.id, connection=trans)
        return True

    def _get_file_path(self):
        path = open(title='Entre com o CSV ou Excel', patterns=['*.csv', '*.xls', '*.xlsx'])
        return path

    def _read_file(self, payment_file):
        payments = None
        with rows.locale_context(name=locale_language, category=locale.LC_NUMERIC):
            func = getattr(rows, 'import_from_csv')
            if 'xls' in payment_file:
                func = getattr(rows, 'import_from_xls')
            if 'xlsx' in payment_file:
                func = getattr(rows, 'import_from_xlsx')
            payments = func(payment_file,
                            force_types={'field_0': rows.fields.FloatField,
                                         'comentarios': rows.fields.TextField,
                                         'nome_fantasia': rows.fields.TextField,
                                         'cpf': rows.fields.TextField,
                                         'cnpj': rows.fields.TextField,
                                         'sacado': rows.fields.TextField,
                                         'descricao': rows.fields.TextField,
                                         'valor_real': rows.fields.FloatField,
                                         'taxa': rows.fields.FloatField,
                                         'dt_abrt_venda': rows.fields.TextField,
                                         'data_de_abertura': rows.fields.TextField,
                                         'vencimento': rows.fields.TextField,
                                         'data_do_pagamento': rows.fields.TextField,
                                         'situacao': rows.fields.TextField,
                                         'valor': rows.fields.FloatField,
                                         'na_filial': rows.fields.TextField,
                                         'pago': rows.fields.FloatField,
                                         'categoria': rows.fields.TextField,
                                         'forma_de_pagamento': rows.fields.TextField})
        self._get_branch_list(payments)
        return payments

    def import_products(self, path, payment_class, trans):
        payments_table = self._read_file(path)
        payments_quantity = len(payments_table)
        migrated = 0
        step = 0
        for payment_row in payments_table:
            for field_name, field_type in payments_table.fields.items():
                self._validate_column_name(field_name)
            payment_dict = self._parse_to_dict(payment_row)
            if not self._already_migrated(payment_dict, trans):
                if self._create_payment(payment_dict, payment_class, trans):
                    migrated += 1
            step += 1
            msg = '%s/%s' % (step, payments_quantity)
            fraction = float(step) / float(payments_quantity)
            self.emit('progressbar_update', msg, fraction)
        msg = 'importados %s de %s' % (migrated, payments_quantity)
        self.emit('progressbar_update', msg, 1)

    def _already_migrated(self, data, trans):
        h = hashlib.md5()
        h.update('{}{}{}'.format(data.get('id'), data.get('payment_description'), data.get('open_date')))
        payment_hash = h.hexdigest()
        return Payment.selectBy(migrated_hash=payment_hash, connection=trans).count() >= 1

    def _get_branch_list(self, payments):
        self.default_branch_name = list(set([p.na_filial for p in payments if p.na_filial != '']))[0]

    def _validate_column_name(self, field_name):
        if field_name not in self.valid_columns:
            raise Exception('Campo "{}" não é permitido. Use somente estes {}'.
                            format(field_name, self.valid_columns))

    def _parse_to_dict(self, product):
        data = dict(id=int(getattr(product, 'field_0', 0)),
                    coments=getattr(product, 'comentarios', ''),
                    fancy_name=getattr(product, 'nome_fantasia', ''),
                    cpf=getattr(product, 'cpf', ''),
                    cnpj=getattr(product, 'cnpj', ''),
                    client_name=getattr(product, 'sacado', ''),
                    description=getattr(product, 'descricao', ''),
                    real_value=getattr(product, 'valor_real', 0),
                    tax=getattr(product, 'taxa', 0),
                    sale_open_date=getattr(product, 'dt_abrt_venda', ''),
                    open_date=getattr(product, 'data_de_abertura', ''),
                    due_date=getattr(product, 'vencimento', ''),
                    paid_date=getattr(product, 'data_do_pagamento', ''),
                    status=getattr(product, 'situacao', ''),
                    value=getattr(product, 'valor', 0),
                    category=getattr(product, 'categoria', ''),
                    in_branch=getattr(product, 'na_filial', 'Sem filial'),
                    payment_description=getattr(product, 'forma_de_pagamento', 'Dinheiro'))
        return self._set_default_data(data)

    def _set_default_data(self, data):
        dt_abrt_venda = data['sale_open_date'] or None
        if dt_abrt_venda:
            data['sale_open_date'] = date_parser.parse(dt_abrt_venda)
        else:
            data['sale_open_date'] = None

        data_abertura = data['open_date'] or None
        if data_abertura:
            data['open_date'] = date_parser.parse(data_abertura)
        else:
            data['open_date'] = None

        data_do_pagamento = data['paid_date'] or None
        if data_do_pagamento:
            data['paid_date'] = date_parser.parse(data_do_pagamento)
        else:
            data['paid_date'] = None

        vencimento = data['due_date'] or None
        if vencimento:
            data['due_date'] = date_parser.parse(vencimento)
        else:
            data['due_date'] = None

        categoria = data['category'] or None
        if not categoria:
            data['category'] = ''

        na_filial = data['in_branch'] or None
        if not na_filial:
            data['in_branch'] = self.default_branch_name
        return data

    #
    # Callbacks
    #

    def on_import_button__clicked(self, widget):
        assert self.model.import_type == self.import_type.read()
        self.progressbar.set_fraction(0.0)
        self.progressbar.set_text('')
        if self.model.import_type == self.CONTAS_RECEBER:
            self.import_products(self.path.read(), PaymentAdaptToInPayment, self.trans)
        elif self.model.import_type == self.CONTAS_PAGAR:
            self.import_products(self.path.read(), PaymentAdaptToOutPayment, self.trans)

    def on_filechooserbutton__selection_changed(self, widget):
        self.progressbar.set_fraction(0.0)
        self.progressbar.set_text('')
        filename = widget.get_filename()
        self.path.set_text(filename)

    def on_path__validate(self, widget, filename):
        self.progressbar.set_fraction(0.0)
        self.progressbar.set_text('')
        if not filename:
            return
        if not filename.endswith('.csv') \
                and not filename.endswith('.xls') \
                and not filename.endswith('.xlsx'):
            self.import_button.set_sensitive(False)
            return ValidationError('O tipo de arquivo deve ser csv, xls ou xlsx')
        self.import_button.set_sensitive(True)
