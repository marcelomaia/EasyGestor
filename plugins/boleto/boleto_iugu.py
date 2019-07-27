# coding=utf-8

import os

from iugu.invoice import Invoice
from kiwi.log import Logger
from kiwi.ui.dialogs import error
from stoqlib.database.runtime import get_connection
from stoqlib.database.runtime import new_transaction
from stoqlib.domain.interfaces import IIndividual, ICompany, IClient
from stoqlib.domain.payment.bill import PaymentIuguBill
from stoqlib.domain.person import PersonAdaptToAffiliate
from stoqlib.lib.formatters import format_phone_number
from stoqlib.lib.parameters import sysparam

log = Logger("stoq-boleto-plugin")

conn = get_connection()
TOKEN = sysparam(conn).IUGU_ID
os.environ['IUGU_API_TOKEN'] = TOKEN
conn.close()
current_path = os.path.dirname(__file__)
certifi_path = os.path.join(current_path, 'data', 'cacert.pem')
os.environ['REQUESTS_CA_BUNDLE'] = certifi_path


class Boleto(object):

    def _get_items(self, payment):
        """
        create a array of dict, that indicates the bill value
        :param payment:
        :return: array
        """
        items_data = []
        price = getattr(payment, u'value')
        description = getattr(payment, u'description')
        notes = getattr(payment, u'notes')
        msg = "{}".format(description)
        if notes:
            msg = "{} ; {}".format(description, notes)
        item_data = {'description': msg,
                     'quantity': 1,
                     'price_cents': int(float(price * 100))}
        items_data.append(item_data)
        return items_data

    def _get_items_for_duplicate(self, payment, iugu_id):
        """
        :param payment: Payment object
        :param iugu_id: invoice id str format
        :return:
        """
        self._setup_environ_key(payment)
        items_data = []
        price = getattr(payment, u'value')
        description = getattr(payment, u'description')
        notes = getattr(payment, u'notes')
        msg = "{}".format(description)
        invoice = Invoice()
        bill = invoice.search(iugu_id)
        log.debug('verificadndo boleto para gerar duplicata: {}'.format(bill))
        bill_id = ''
        if notes:
            msg = "{} ; {}".format(description, notes)
        try:
            if not bill['items'][0]['id']:
                return None
            for b in bill['items']:
                if b['description'] == msg:
                    bill_id = b['id']
        except:
            return None
        item_data = {
            'id': bill_id,
            'description': msg,
            'quantity': 1,
            'price_cents': int(float(price * 100))}
        items_data.append(item_data)
        return items_data

    def _get_client_address(self, client):
        """
        extract address from a client
        :param client:
        :return: dict
        """
        addr = client.person.address
        address_data = {'zip_code': getattr(addr, u'postal_code'),
                        'street': getattr(addr, u'street'),
                        'number': getattr(addr, u'streetnumber') or 'SN',
                        'district': getattr(addr, u'district'),
                        'city': getattr(addr.city_location, u'city'),
                        'state': getattr(addr.city_location, u'state'),
                        'country': getattr(addr.city_location, u'country'),
                        'complement': getattr(addr, u'complement') or 'Nenhum'}
        return address_data

    def _extract_phone_prefix(self, txt):
        import re
        return re.search(r'\((.*?)\)', txt).group(1)

    def _get_payer_data(self, client):
        person = client.person
        phone_number = format_phone_number(getattr(person, u'phone_number'))
        cpf_cnpj = ''
        person = client.person
        individual = IIndividual(person, None)
        company = ICompany(person, None)
        if individual is not None:
            cpf_cnpj = ''.join([c for c in individual.cpf if c in '1234567890'])
        elif company is not None:
            cpf_cnpj = ''.join([c for c in company.cnpj if c in '1234567890'])

        payer_data = {'cpf_cnpj': cpf_cnpj,
                      'name': getattr(person, u'name'),
                      'phone_prefix': self._extract_phone_prefix(phone_number),
                      'phone': phone_number,
                      'email': getattr(person, u'email'),
                      'address': self._get_client_address(client)}
        return payer_data

    def _cancel_bill(self, payment, data):
        self._setup_environ_key(payment)
        i = Invoice()
        conn = get_connection()
        bill = PaymentIuguBill.selectOneBy(payment=payment, connection=conn)
        invoice_canceled = i.cancel(bill.iugu_id)
        log.debug('invoice_canceled: {}, data: {}'.format(invoice_canceled, data))
        conn.close()

    def _save_duplicate(self, payment, iugu_id, data):
        self._setup_environ_key(payment)
        i = Invoice()
        try:
            log.debug('criando duplicata do boleto: {}, data: {}'.format(iugu_id, data))
            invoice = i.duplicate(iugu_id, data)
            errors = ''
            log.debug('duplicata invoice criada: {}, data: {}'.format(invoice, data))
            if 'errors' not in invoice.keys():
                trans = new_transaction()
                bill = PaymentIuguBill.selectOneBy(payment=payment, connection=trans)
                bill.iugu_id = invoice.get('id')
                bill.secure_id = invoice.get('secure_id')
                bill.secure_url = invoice.get('secure_url')
                bill.due_date = payment.due_date
                bill.doc_pdf = invoice.get('secure_url') + '.pdf'
                trans.commit(close=True)
            else:
                for err in invoice['errors']:
                    errors += u'Erro: {} {}'.format(err, invoice['errors'][err])
                log.error(errors)
                error(u'Erro ao atualizar boleto, pagamento #{}'.format(payment.id),
                      u'Detalhe: {}'.format(errors))
        except Exception, e:
            msg = str(e)
            error('Erro', msg)

    def _save_bill(self, payment, data):
        self._setup_environ_key(payment)
        i = Invoice()
        try:
            invoice = i.create(data)
            errors = ''
            log.debug('invoice: {}, data: {}'.format(invoice, data))
            if 'errors' not in invoice.keys():
                trans = new_transaction()
                PaymentIuguBill(
                    iugu_id=invoice.get('id'),
                    secure_id=invoice.get('secure_id'),
                    secure_url=invoice.get('secure_url'),
                    due_date=payment.due_date,
                    doc_pdf=invoice.get('secure_url') + '.pdf',
                    payment=payment,
                    connection=trans)
                trans.commit(close=True)
            else:
                for err in invoice['errors']:
                    errors += u'Erro: {} {}'.format(err, invoice['errors'][err])
                log.error(errors)
                error(u'Erro ao criar boleto, pagamento #{}'.format(payment.id),
                      u'Detalhe: {}'.format(errors))
        except Exception, e:
            msg = str(e)
            error(u'Erro: vide detalhes', msg)

    def _update_bill(self, payment, data):
        self._setup_environ_key(payment)
        i = Invoice()
        try:
            invoice = i.create(data)
            errors = ''
            log.debug('invoice: {}, data: {}'.format(invoice, data))
            if 'errors' not in invoice.keys():
                trans = new_transaction()
                paymentbill = PaymentIuguBill.selectOneBy(payment=payment, connection=trans)
                paymentbill.iugu_id = invoice.get('id')
                paymentbill.secure_id = invoice.get('secure_id')
                paymentbill.secure_url = invoice.get('secure_url')
                paymentbill.due_date = payment.due_date
                paymentbill.doc_pdf = invoice.get('secure_url') + '.pdf'
                paymentbill.payment = payment
                paymentbill.status = PaymentIuguBill.STATUS_PENDING
                trans.commit(close=True)
            else:
                for err in invoice['errors']:
                    errors += u'Erro: {} {}'.format(err, invoice['errors'][err])
                log.error(errors)
                error(u'Erro ao criar boleto, pagamento #{}'.format(payment.id),
                      u'Detalhe: {}'.format(errors))
        except Exception, e:
            msg = str(e)
            error(u'Erro: ', msg)

    def _setup_environ_key(self, payment):
        """
        Muda a chave da iugu conforme o afiliado ou o principal se for sem afiliado
        :param payment: Payment object
        """
        affilite = payment.affiliate
        if affilite:
            if affilite.user_token and affilite.status == PersonAdaptToAffiliate.STATUS_APPROVED:
                # se tem user token e foi aprovado.
                os.environ['IUGU_API_TOKEN'] = affilite.user_token
                log.debug('Trocando p/ a chave de afiliado {}'.format(affilite.user_token))
        else:
            # se nao tem token de afiliado, aplica o token padrão da EBI
            conn = get_connection()
            TOKEN = sysparam(conn).IUGU_ID
            os.environ['IUGU_API_TOKEN'] = TOKEN
            log.debug('Trocando p/ a chave padrão {}'.format(TOKEN))
            conn.close()

    #
    # Public methods
    #

    def is_paid(self, bill_id, payment):
        self._setup_environ_key(payment)
        invoice = Invoice()
        bill = invoice.search(bill_id)
        log.debug('verificadndo boleto pago: {}'.format(bill))
        if bill['status'] == 'paid':
            return bill['paid_cents']
        return False

    def create_bills_from_sale(self, sale, conn):

        payments = sale.payments
        has_bills = any([p.method.method_name == 'bill'
                         for p in payments])
        assert has_bills
        assert sale.client
        for payment in payments:
            if payment.method.method_name == 'bill' \
                    and payment.is_inpayment() \
                    and not PaymentIuguBill.selectOneBy(payment=payment, connection=conn):
                items = self._get_items(payment)
                due_date = payment.due_date.strftime('%Y-%m-%d')
                email = sale.client.person.email
                payer = self._get_payer_data(sale.client)
                interest = float(payment.method.interest)
                data = dict(items=items, due_date=due_date, email=email,
                            payer=payer, late_payment_fine=interest,
                            payable_with='bank_slip',
                            per_day_interest=True, fines=True)
                self._save_bill(payment, data)

    def create_single_bill(self, payment, conn):
        client = IClient(payment.group.payer)
        items = self._get_items(payment)
        due_date = payment.due_date.strftime('%Y-%m-%d')
        email = client.person.email
        payer = self._get_payer_data(client)
        interest = float(payment.method.interest)
        data = dict(items=items, due_date=due_date, email=email,
                    payer=payer, late_payment_fine=interest,
                    payable_with='bank_slip',
                    per_day_interest=True, fines=True)
        if payment.method.method_name == 'bill' \
                and payment.is_inpayment() \
                and not PaymentIuguBill.selectOneBy(payment=payment, connection=conn):
            self._save_bill(payment, data)
        else:
            self._update_bill(payment, data)

    def create_duplicate(self, payment, conn):
        """Gera segunda via da fatura
        https://dev.iugu.com/v1.0/reference#gerar-segunda-via
        """
        # pegar o payment do iugu e substituir os ids. :D
        # no caso como é so um item, fica facil
        bill = PaymentIuguBill.selectOneBy(payment=payment, connection=conn)
        if payment.method.method_name == 'bill' \
                and payment.is_inpayment() \
                and bill:
            iugu_id = bill.iugu_id
            due_date = payment.due_date.strftime('%Y-%m-%d')
            items = self._get_items_for_duplicate(payment, iugu_id)
            if not items:
                error(u'Erro',
                      u'Detalhe: Não foi possível recuperar os itens da fatura.')
                return
            data = dict(id=iugu_id,
                        due_date=due_date,
                        ignore_due_email=False,
                        ignore_canceled_email=False,
                        items=items,
                        current_fines_option=True,  # manter os juros
                        keep_early_payment_discount=False, )
            payment.value = payment.value + payment.penalty
            trans = new_transaction()
            trans.commit(close=True)
            self._save_duplicate(payment, iugu_id, data)

    def cancel_bill(self, payment, conn):
        """Cancela a fatura
        https://dev.iugu.com/v1.0/reference#gerar-segunda-via
        """
        bill = PaymentIuguBill.selectOneBy(payment=payment, connection=conn)
        if payment.method.method_name == 'bill' \
                and payment.is_inpayment() \
                and bill:
            iugu_id = bill.iugu_id
            data = dict(id=iugu_id)
            self._cancel_bill(payment, data)

    def search_paid_bills(self, start_date, end_date):
        # https://dev.iugu.com/v1.0/reference#listar
        # AAAA-MM-DDThh:mm:ss-03:00
        invoice = Invoice()
        data = {'paid_at_from': start_date.strftime('%Y-%m-%dT%H:%M:%S-03:00'),
                'paid_at_to': end_date.strftime('%Y-%m-%dT%H:%M:%S-03:00'),
                'status_filter': 'paid'}
        try:
            bills = invoice.list(data)
            errors = ''
            log.debug('invoice: {}, data: {}'.format(invoice, data))

            if 'errors' not in bills.keys():
                return bills
            else:
                for err in bills['errors']:
                    errors += u'Erro: {} {}'.format(err, bills['errors'][err])
                log.error(errors)
                error(u'Erro',
                      u'Detalhe: {}'.format(errors))
                return False
        except Exception, e:
            msg = str(e)
            error('Erro:', msg)
            return False

    def search_bills(self, start_date, end_date):
        """
        Search for bills by create date
        https://dev.iugu.com/v1.0/reference#listar
        AAAA-MM-DDThh:mm:ss-03:00

        :param start_date: datetime
        :param end_date: datetime
        :return:
        """
        invoice = Invoice()
        data = {'created_at_from': start_date.strftime('%Y-%m-%dT%H:%M:%S-03:00'),
                'created_at_to': end_date.strftime('%Y-%m-%dT%H:%M:%S-03:00')}
        try:
            bills = invoice.list(data)
            errors = ''
            log.debug('invoice: {}, data: {}'.format(invoice, data))

            if 'errors' not in bills.keys():
                # log.debug('bills {}'.format(str(bills)))
                return bills
            else:
                for err in bills['errors']:
                    errors += u'Erro: {} {}'.format(err, bills['errors'][err])
                log.error(errors)
                error(u'Erro',
                      u'Detalhe: {}'.format(errors))
                return False
        except Exception, e:
            msg = str(e)
            error('Erro:', msg)
            return False

    def search_affiliate_bills(self, affiliate, start_date, end_date, conn):
        """
        :param affiliate:
        :param start_date:
        :param end_date:
        :param conn:
        :return:
        """
        if affiliate.user_token and affiliate.status == PersonAdaptToAffiliate.STATUS_APPROVED:
            os.environ['IUGU_API_TOKEN'] = affiliate.user_token
            log.debug('Trocando p/ a chave de afiliado {}'.format(affiliate.user_token))
            return self.search_bills(start_date, end_date)
        else:
            # se nao tem token de afiliado, aplica o token padrão da EBI
            TOKEN = sysparam(conn).IUGU_ID
            os.environ['IUGU_API_TOKEN'] = TOKEN
            log.debug('Trocando p/ a chave padrão {}'.format(TOKEN))
            return False
