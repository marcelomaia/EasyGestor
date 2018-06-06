# -*- coding: utf-8 -*-
import os
import sys
import webbrowser

from kiwi.log import Logger
from stoqlib.database.runtime import get_connection
from stoqlib.database.runtime import new_transaction
from stoqlib.domain.events import CancelBillEvent, CreateAffiliateEvent, VerifySubaccountEvent
from stoqlib.domain.events import (PrintBillEvent, GenerateBillEvent,
                                   GenerateBatchBillEvent, CheckBillStatusEvent,
                                   CheckPendingBillEvent, CheckCreatedBillEvent, GenerateDuplicateEvent,
                                   CheckPaidBillEvent)
from stoqlib.domain.payment.bill import PaymentIuguBill
from stoqlib.domain.payment.payment import Payment
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.events import StartApplicationEvent
from stoqlib.gui.slaves.installmentslave import SaleInstallmentConfirmationSlave
from stoqlib.gui.stockicons import STOQ_BARCODE
from stoqlib.lib.message import info

from boleto_iugu import Boleto
from boleto_utils import create_affiliate, verify_subaccount

plugin_root = os.path.dirname(__file__)
sys.path.append(plugin_root)
log = Logger("stoq-nfe-plugin")


class BoletoUI(object):
    def __init__(self):
        self.conn = get_connection()
        StartApplicationEvent.connect(self._on_StartApplicationEvent)
        PrintBillEvent.connect(self._on_PrintBillEvent)
        GenerateBillEvent.connect(self._on_GenerateBillEvent)
        GenerateBatchBillEvent.connect(self._on_GenerateBatchBillEvent)
        CheckBillStatusEvent.connect(self._on_CheckBillStatusEvent)
        CheckPendingBillEvent.connect(self._on_CheckPendingBillEvent)
        CheckCreatedBillEvent.connect(self._on_CheckCreatedBillEvent)
        GenerateDuplicateEvent.connect(self._on_GenerateDuplicateEvent)
        CheckPaidBillEvent.connect(self._on_CheckPaidBillEvent)
        CancelBillEvent.connect(self._on_CancelBillEvent)
        CreateAffiliateEvent.connect(self._on_CreateAffiliateEvent)
        VerifySubaccountEvent.connect(self._on_VerifySubaccountEvent)

    def _on_StartApplicationEvent(self, appname, app):
        self._add_ui_menus(appname, app, app.main_window.uimanager)

    def _add_ui_menus(self, appname, app, uimanager):
        if appname == 'admin':
            app.main_window.tasks.add_item(
                'Boleto', 'remote-printer', STOQ_BARCODE,
                self._on_Configurebill__activate)

    def _on_Configurebill__activate(self):
        webbrowser.open('https://app.iugu.com/account')

    def _receive(self, payment):
        """
        Receives a list of items from a receivable_views, note that
        the list of receivable_views must reference the same sale
        @param payment: a list of receivable_views
        """
        assert payment.status == Payment.STATUS_PENDING

        trans = new_transaction()

        payments = [trans.get(payment)]

        retval = run_dialog(SaleInstallmentConfirmationSlave, get_current_toplevel(), trans,
                            payments=payments)

        trans.commit(close=True)

    def _on_GenerateBatchBillEvent(self, sale):
        b = Boleto()
        b.create_bills_from_sale(sale, self.conn)

    def _on_GenerateBillEvent(self, payment):
        b = Boleto()
        b.create_single_bill(payment, self.conn)
        bill = PaymentIuguBill.selectOneBy(payment=payment,
                                           connection=self.conn)
        if bill:
            webbrowser.open(bill.doc_pdf)

    def _on_PrintBillEvent(self, payment):
        bill = PaymentIuguBill.selectOneBy(payment=payment,
                                           status=PaymentIuguBill.STATUS_PENDING,
                                           connection=self.conn)
        if bill:
            webbrowser.open(bill.doc_pdf)

    def _on_CheckBillStatusEvent(self, payment):
        trans = new_transaction()
        bill = PaymentIuguBill.selectOneBy(payment=payment,
                                           connection=trans)
        b = Boleto()
        if not bill:
            info(u'Boleto não encontrado!')
        else:
            value_cents = b.is_paid(bill.iugu_id, payment)
            if bill.status == PaymentIuguBill.STATUS_PAID:
                info(u'Boleto está já foi pago pelo cliente')
            elif value_cents and bill.status == PaymentIuguBill.STATUS_PENDING:
                info(u'Boleto foi confirmado pelo banco!\n'
                     u'Valor com multa: R$ {}. \n'
                     u'Por favor confirme no Easygestor'.format(value_cents / 100.0))
                bill.status = PaymentIuguBill.STATUS_PAID
                trans.commit(close=True)
                return value_cents / 100.0
            else:
                info(u'Boleto ainda não foi pago')
        trans.commit(close=True)
        return False

    def _on_CheckPendingBillEvent(self, payments):
        for payment in payments:
            if payment.method.method_name == 'bill' \
                    and payment.is_inpayment() \
                    and not PaymentIuguBill.selectOneBy(payment=payment, connection=self.conn):
                return True
        return False

    def _on_CheckCreatedBillEvent(self, payments):
        for payment in payments:
            if payment.method.method_name == 'bill' \
                    and payment.is_inpayment() \
                    and PaymentIuguBill.selectOneBy(payment=payment, connection=self.conn):
                return True
        return False

    def _on_GenerateDuplicateEvent(self, payment):
        b = Boleto()
        b.create_duplicate(payment, self.conn)
        bill = PaymentIuguBill.selectOneBy(payment=payment,
                                           connection=self.conn)
        if bill:
            webbrowser.open(bill.doc_pdf)

    def _on_CancelBillEvent(self, payment):
        b = Boleto()
        b.cancel_bill(payment, self.conn)
        trans = new_transaction()
        bill = PaymentIuguBill.selectOneBy(payment=payment,
                                           connection=trans)
        bill.status = PaymentIuguBill.STATUS_CANCELED
        trans.commit(close=True)
        info('Boleto cancelado!')

    def _on_CreateAffiliateEvent(self, affiliateview):
        return create_affiliate(affiliateview)

    def _on_VerifySubaccountEvent(self, affiliateview):
        return verify_subaccount(affiliateview)

    def _on_CheckPaidBillEvent(self, start_date, end_date):
        # TODO, colocar um dialogo aqui com todos os boletos pendentes em confirmar no easygestor
        b = Boleto()
        data = b.search_paid_bills(start_date, end_date)
        if data:
            trans = new_transaction()
            # data['totalItems']
            items = data['items']
            for item in items:
                print item
                bill = PaymentIuguBill.selectOneBy(iugu_id=item['id'],
                                                   status=PaymentIuguBill.STATUS_PENDING,
                                                   connection=trans)
                if bill:
                    payment = trans.get(bill.payment)
                    paid_value = item['paid_cents'] / 100.0
                    if paid_value:
                        payment.penalty = float(paid_value) - float(payment.value)
                        payment.interest = float(0)
                        bill.status = PaymentIuguBill.STATUS_PAID
                        trans.commit()
                        self._receive(payment)
            trans.close()
