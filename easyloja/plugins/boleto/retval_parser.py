# coding=utf-8
from stoqlib.database.orm import AND
from stoqlib.domain.payment.bill import PaymentIuguBill
from stoqlib.domain.payment.payment import Payment

from boleto_iugu import Boleto


def parse_retval(retval):
    print retval
    for item in retval['items']:
        print item['status'], item['id'], item['total_cents'], item['total_paid_cents'], \
            item['email'], item['secure_url'], item['total']
        for prod in item['items']:
            print prod['description']
        for log in item['logs']:
            print log['created_at'], log['description']
        print '____________________'


def check_paid_affiliate_bills(retval, iugu_id):
    # aqui deve verificar os boletos pagos no server da iugu.
    # available statuses
    # https://support.iugu.com/hc/pt-br/articles/213163706-Lista-de-status-de-fatura-e-seus-significados
    for item in retval['items']:
        if item['id'] == iugu_id and item['status'] == 'pending':
            print 'achou', item['status'], item['id'], item['total_paid_cents'], item['email'], item['secure_url']
            for prod in item['items']:
                print prod['description']
            for log in item['logs']:
                print log['created_at'], log['description']
            print '____________________'


def check_paid_bills(retval, conn):
    #   TODO: verificar os pagamentos da api que estão pagos e cruzar com os pendentes do banco de dados
    affiliate = retval.affiliate
    # filtra todos boletos da iugu com status pendente de um determinado afiliado
    payments = PaymentIuguBill.select(AND(PaymentIuguBill.q.paymentID == Payment.q.id,
                                          Payment.q.affiliate == affiliate,
                                          PaymentIuguBill.q.status == PaymentIuguBill.STATUS_PENDING),
                                      connection=conn)

    #   TODO: verificar todos pagamentos da ebi pendentes daquele afiliado
    b = Boleto()
    retval = b.search_affiliate_bills(retval.affiliate, retval.start_date, retval.end_date, conn)
    for payment in payments:
        check_paid_affiliate_bills(retval, payment.iugu_id)
