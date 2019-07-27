# coding=utf-8
import datetime
import sys

from kiwi.component import provide_utility
from stoq.lib.options import get_option_parser
from stoq.lib.startup import setup
from stoqlib.api import api
from stoqlib.database.admin import get_admin_user
from stoqlib.database.interfaces import ICurrentUser
from stoqlib.database.orm import AND, IN
from stoqlib.database.runtime import get_connection
from stoqlib.domain.payment.category import PaymentCategory
from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.person import PersonAdaptToCreditProvider
from stoqlib.lib.configparser import StoqConfig

ini = datetime.datetime(year=2017, month=06, day=1)
fim = datetime.datetime(year=2017, month=06, day=30, hour=23, minute=59, second=59)


def main(args):
    parser = get_option_parser()
    options, args = parser.parse_args(args)

    config = StoqConfig()
    config.load_default()
    setup(config, options, register_station=False, check_schema=False)
    conn = get_connection()
    provide_utility(ICurrentUser, get_admin_user(conn))
    # trans = api.new_transaction()
    from stoqlib.domain.payment.views import InPaymentView

    print '___(entradas)___'
    entra = 0
    for p in PaymentMethod.selectBy(conn):
        total = InPaymentView.select(AND(InPaymentView.q.open_date >= ini,
                                         InPaymentView.q.open_date <= fim,
                                         InPaymentView.q.method_id == p.id,
                                         IN(InPaymentView.q.status,
                                            (Payment.STATUS_PAID, Payment.STATUS_PENDING)),
                                         ),
                                     connection=conn).sum('value')
        if total:
            entra += total
            print 'Total em {}: R${}'.format(p.description, total)
    print '>>>Total de entrada R${}'.format(entra)
    entra_cat = 0
    print '__________Entradas (por categoria)_________________'
    for p in PaymentCategory.selectBy(connection=conn):
        total = InPaymentView.select(AND(InPaymentView.q.open_date >= ini,
                                         InPaymentView.q.open_date <= fim,
                                         InPaymentView.q.category_id == p.id,
                                         IN(InPaymentView.q.status,
                                            (Payment.STATUS_PAID, Payment.STATUS_PENDING)),
                                         ),
                                     connection=conn).sum('value')
        if total:
            entra += total
            entra_cat += total
            print 'Total em {}: R${}'.format(p.name, total)
    print '>>>Sem categoria {}'.format(entra-entra_cat)
    print '___saidas, vendas erradas, cancelamentos etc.___'
    for p in PaymentMethod.selectBy(conn):
        from stoqlib.domain.payment.views import OutPaymentView
        total = OutPaymentView.select(AND(OutPaymentView.q.open_date >= ini,
                                          OutPaymentView.q.open_date <= fim,
                                          OutPaymentView.q.method_id == p.id,
                                          IN(OutPaymentView.q.status,
                                             (Payment.STATUS_PAID, Payment.STATUS_PENDING)),
                                          ),
                                      connection=conn).sum('value')
        if total:
            print 'Total em {}: R${}'.format(p.description, total)
    print '__________Saídas (por categoria)_________________'
    for p in PaymentCategory.selectBy(connection=conn):
        total = OutPaymentView.select(AND(OutPaymentView.q.open_date >= ini,
                                         OutPaymentView.q.open_date <= fim,
                                         OutPaymentView.q.category_id == p.id,
                                         IN(InPaymentView.q.status,
                                            (Payment.STATUS_PAID, Payment.STATUS_PENDING)),
                                         ),
                                      connection=conn).sum('value')
        if total:
            entra += total
            print 'Total em {}: R${}'.format(p.name, total)
    print '___(cartões)___'
    t_car = 0
    for p in PersonAdaptToCreditProvider.selectBy(conn):
        from stoqlib.domain.payment.views import CardPaymentView
        total = CardPaymentView.select(AND(CardPaymentView.q.open_date >= ini,
                                           CardPaymentView.q.open_date <= fim,
                                           CardPaymentView.q.provider_id == p.id,
                                           IN(CardPaymentView.q.status,
                                              (Payment.STATUS_PAID, Payment.STATUS_PENDING))
                                           ),
                                       connection=conn).sum('value')

        if total:
            t_car += total
            print 'Total no cartao {}: R${}'.format(p.person.name, total)
    print 'soma cartoes R$ {}'.format(t_car)

if __name__ == '__main__':
    sys.exit(main(sys.argv))
