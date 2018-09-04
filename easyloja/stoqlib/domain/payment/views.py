# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2007-2010 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##

import datetime

from kiwi.datatypes import converter
from sqlobject.viewable import ViewableSelectResults
from stoqlib.database.orm import AND, OR, const
from stoqlib.database.orm import Alias, LEFTJOINOn, INNERJOINOn
from stoqlib.database.orm import IN
from stoqlib.database.orm import Viewable
from stoqlib.database.runtime import get_connection
from stoqlib.domain.account import BankAccount
from stoqlib.domain.payment.bill import PaymentIuguBill
from stoqlib.domain.payment.category import PaymentCategory
from stoqlib.domain.payment.comment import PaymentComment
from stoqlib.domain.payment.costcenter import PaymentCostCenter
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.payment.method import (CheckData, CreditCardData)
from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.payment.payment import (PaymentAdaptToInPayment,
                                            PaymentAdaptToOutPayment,
                                            PaymentChangeHistory)
from stoqlib.domain.payment.renegotiation import PaymentRenegotiation
from stoqlib.domain.person import (Person, PersonAdaptToCreditProvider, PersonAdaptToIndividual, PersonAdaptToCompany,
                                   PersonAdaptToBranch, PersonAdaptToClient, PersonAdaptToAffiliate)
from stoqlib.domain.purchase import PurchaseOrder
from stoqlib.domain.sale import Sale
from stoqlib.domain.till import DailyFlow
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext
max_results = sysparam(get_connection()).MAX_SEARCH_RESULTS


class BasePaymentView(Viewable):
    columns = dict(
        # Payment
        id=Payment.q.id,
        description=Payment.q.description,
        due_date=Payment.q.due_date,
        status=Payment.q.status,
        paid_date=Payment.q.paid_date,
        open_date=Payment.q.open_date,
        value=Payment.q.value,
        paid_value=Payment.q.paid_value,
        payment_number=Payment.q.payment_number,
        group_id=Payment.q.groupID,
        notes=Payment.q.notes,

        # PaymentGroup
        renegotiated_id=PaymentGroup.q.renegotiationID,

        # PaymentMethod
        method_name=PaymentMethod.q.method_name,
        method_description=PaymentMethod.q.description,
        method_id=PaymentMethod.q.id,

        # PaymentCategory
        color=PaymentCategory.q.color,
        category=PaymentCategory.q.name,
        category_id=PaymentCategory.q.id,

        # PaymentCostCenter
        cost_center_color=PaymentCostCenter.q.color,
        cost_center=PaymentCostCenter.q.name,
        cost_center_id=PaymentCostCenter.q.id,

        # PaymentComment
        comments_number=const.COUNT(PaymentComment.q.id),

        # Sale
        sale_id=Sale.q.id,
        sale_open_date=Sale.q.open_date,
        sale_confirm_date=Sale.q.confirm_date,

        # Purchase
        purchase_id=PurchaseOrder.q.id,
        purchase_status=PurchaseOrder.q.status,
    )

    PaymentGroup_Sale = Alias(PaymentGroup, 'payment_group_sale')
    PaymentGroup_Purchase = Alias(PaymentGroup, 'payment_group_purchase')

    joins = [
        LEFTJOINOn(None, PaymentGroup,
                   PaymentGroup.q.id == Payment.q.groupID),
        LEFTJOINOn(None, PaymentCategory,
                   PaymentCategory.q.id == Payment.q.categoryID),
        INNERJOINOn(None, PaymentMethod,
                    Payment.q.methodID == PaymentMethod.q.id),
        LEFTJOINOn(None, PaymentComment,
                   PaymentComment.q.paymentID == Payment.q.id),

        # Purchase
        LEFTJOINOn(None, PaymentGroup_Purchase,
                   PaymentGroup_Purchase.q.id == Payment.q.groupID),
        LEFTJOINOn(None, PurchaseOrder,
                   PurchaseOrder.q.groupID == PaymentGroup_Purchase.q.id),

        # Sale
        LEFTJOINOn(None, PaymentGroup_Sale,
                   PaymentGroup_Sale.q.id == Payment.q.groupID),
        LEFTJOINOn(None, Sale,
                   Sale.q.groupID == PaymentGroup_Sale.q.id),

        # PaymentCostCenter
        LEFTJOINOn(None, PaymentCostCenter,
                   PaymentCostCenter.q.id == Payment.q.cost_centerID),
    ]

    def can_change_due_date(self):
        return self.status not in [Payment.STATUS_PAID,
                                   Payment.STATUS_CANCELLED]

    def can_cancel_payment(self):
        """Only  lonely payments and pending can be cancelled
        """
        if self.sale_id or self.purchase_id:
            return False

        return self.status == Payment.STATUS_PENDING

    def is_lonely(self):
        return not(self.sale_id or self.purchase_id)

    def get_status_str(self):
        return Payment.statuses[self.status]

    def get_days_late(self):
        if self.status in [Payment.STATUS_PAID, Payment.STATUS_CANCELLED]:
            return 0

        days_late = datetime.date.today() - self.due_date.date()
        if days_late.days < 0:
            return 0

        return days_late.days

    def is_paid(self):
        return self.status == Payment.STATUS_PAID

    @property
    def payment(self):
        return Payment.get(self.id, connection=self.get_connection())

    @property
    def group(self):
        return PaymentGroup.get(self.group_id, connection=self.get_connection())

    @property
    def purchase(self):
        if self.purchase_id:
            return PurchaseOrder.get(self.purchase_id)

    @property
    def sale(self):
        if self.sale_id:
            return Sale.get(self.sale_id)

    @classmethod
    def select_pending(cls, due_date=None, connection=None):
        query = cls.q.status == Payment.STATUS_PENDING

        if due_date:
            if isinstance(due_date, tuple):
                date_query = AND(const.DATE(cls.q.due_date) >= due_date[0],
                                 const.DATE(cls.q.due_date) <= due_date[1])
            else:
                date_query = const.DATE(cls.q.due_date) == due_date

            query = AND(query, date_query)

        return cls.select(query, connection=connection)

    @classmethod
    def select(cls, clause=None, clauseTables=None,
               orderBy='id', limit=max_results,
               lazyColumns=False, reversed=True,
               distinct=False, connection=None,
               join=None, columns=None, having=None):
        if cls.clause:
            if clause:
                clause = AND(clause, cls.clause)
            else:
                clause = cls.clause
        if columns:
            cls.columns.update(columns)

        return ViewableSelectResults(cls, clause,
                                     clauseTables=clauseTables,
                                     orderBy=orderBy,
                                     limit=limit,
                                     lazyColumns=lazyColumns,
                                     reversed=reversed,
                                     distinct=distinct,
                                     connection=connection,
                                     join=cls.joins,
                                     having=having,
                                     ns=cls.columns)


class InPaymentView(BasePaymentView):
    Person_Company = Alias(PersonAdaptToCompany, 'person_company')
    columns = BasePaymentView.columns.copy()
    columns.update(dict(
        drawee=Person.q.name,
        drawee_phone=Person.q.phone_number,
        person_id=Person.q.id,
        renegotiated_id=PaymentGroup.q.renegotiationID,
        renegotiation_id=PaymentRenegotiation.q.id,
        client_cpf=PersonAdaptToIndividual.q.cpf,
        client_cnpj=PersonAdaptToCompany.q.cnpj,
        client_fancy_name=PersonAdaptToCompany.q.fancy_name,
        fee_value=CreditCardData.q.fee_value,
        fee=CreditCardData.q.fee,
        branch=PersonAdaptToBranch.q.id,
        branch_name=Person_Company.q.fancy_name,
        card_type=CreditCardData.q.card_type))

    def get_card_type_str(self):
        return CreditCardData.types.get(self.card_type, None)

    @property
    def real_value(self):
        if not self.fee_value:
            return self.value
        return self.value - self.fee_value

    joins = BasePaymentView.joins[:]
    joins.extend([
        INNERJOINOn(None, PaymentAdaptToInPayment,
                    PaymentAdaptToInPayment.q.originalID == Payment.q.id),
        LEFTJOINOn(None, Person,
                   PaymentGroup.q.payerID == Person.q.id),
        LEFTJOINOn(None, PaymentRenegotiation,
                   PaymentRenegotiation.q.groupID == PaymentGroup.q.id),

        LEFTJOINOn(None, PersonAdaptToIndividual,
                   PersonAdaptToIndividual.q.originalID == BasePaymentView.PaymentGroup_Sale.q.payerID),
        LEFTJOINOn(None, PersonAdaptToCompany,
                   PersonAdaptToCompany.q.originalID == BasePaymentView.PaymentGroup_Sale.q.payerID),
        LEFTJOINOn(None, CreditCardData,
                   CreditCardData.q.paymentID == Payment.q.id),
        LEFTJOINOn(None, PersonAdaptToBranch,
                   PersonAdaptToBranch.q.id == Sale.q.branchID),
        LEFTJOINOn(None, Person_Company,
                   Person_Company.q.originalID == PersonAdaptToBranch.q.originalID),
    ])

    @property
    def renegotiation(self):
        if self.renegotiation_id:
            return PaymentRenegotiation.get(self.renegotiation_id,
                                            connection=self.get_connection())

    @property
    def renegotiated(self):
        if self.renegotiated_id:
            return PaymentRenegotiation.get(self.renegotiated_id,
                                            connection=self.get_connection())

    def get_parent(self):
        return self.sale or self.renegotiation


class OutPaymentView(BasePaymentView):
    Person_Branch = Alias(Person, 'person_branch')
    columns = BasePaymentView.columns.copy()
    columns.update(dict(
        supplier_name=Person.q.name,
        supplier_phone=Person.q.phone_number,
        client_cpf=PersonAdaptToIndividual.q.cpf,
        client_cnpj=PersonAdaptToCompany.q.cnpj,
        renegotiated_id=PaymentGroup.q.renegotiationID,
        renegotiation_id=PaymentRenegotiation.q.id,
        branch=Payment.q.branch,
        branch_name=Person_Branch.q.name,
    ))

    joins = BasePaymentView.joins[:]
    joins.extend([
        INNERJOINOn(None, PaymentAdaptToOutPayment,
                    PaymentAdaptToOutPayment.q.originalID == Payment.q.id),
        LEFTJOINOn(None, PaymentRenegotiation,
                   PaymentRenegotiation.q.groupID == PaymentGroup.q.id),
        LEFTJOINOn(None, Person,
                   Person.q.id == BasePaymentView.PaymentGroup_Sale.q.recipientID),
        LEFTJOINOn(None, PersonAdaptToIndividual,
                   PersonAdaptToIndividual.q.originalID == BasePaymentView.PaymentGroup_Sale.q.recipientID),
        LEFTJOINOn(None, PersonAdaptToCompany,
                   PersonAdaptToCompany.q.originalID == BasePaymentView.PaymentGroup_Sale.q.recipientID),
        LEFTJOINOn(None, PersonAdaptToBranch,
                   PersonAdaptToBranch.q.id == Payment.q.branchID),
        LEFTJOINOn(None, Person_Branch,
                   Person_Branch.q.id == PersonAdaptToBranch.q.originalID),
    ])

    @property
    def renegotiation(self):
        if self.renegotiation_id:
            return PaymentRenegotiation.get(self.renegotiation_id,
                                            connection=self.get_connection())

    @property
    def renegotiated(self):
        if self.renegotiated_id:
            return PaymentRenegotiation.get(self.renegotiated_id,
                                            connection=self.get_connection())

    def get_parent(self):
        return self.purchase or self.renegotiation


class CardPaymentView(Viewable):
    """A view for credit providers."""
    _DraweePerson = Alias(Person, "drawee_person")
    _ProviderPerson = Alias(Person, "provider_person")

    columns = dict(
        id=Payment.q.id,
        description=Payment.q.description,
        drawee_name=_DraweePerson.q.name,
        provider_name=_ProviderPerson.q.name,
        provider_id=_ProviderPerson.q.id,
        due_date=Payment.q.due_date,
        paid_date=Payment.q.paid_date,
        open_date=Payment.q.open_date,
        sale_id=Sale.q.id,
        sale_confirm_date=Sale.q.confirm_date,
        renegotiation_id=PaymentRenegotiation.q.id,
        status=Payment.q.status,
        value=Payment.q.value,
        fee=CreditCardData.q.fee,
        fee_calc=CreditCardData.q.fee_value, )

    joins = [
        INNERJOINOn(None, PaymentMethod,
                    PaymentMethod.q.id == Payment.q.methodID),
        INNERJOINOn(None, CreditCardData,
                    CreditCardData.q.paymentID == Payment.q.id),
        INNERJOINOn(None, PersonAdaptToCreditProvider,
                    PersonAdaptToCreditProvider.q.id == CreditCardData.q.providerID),
        INNERJOINOn(None, _ProviderPerson,
                    _ProviderPerson.q.id == PersonAdaptToCreditProvider.q.originalID),
        LEFTJOINOn(None, PaymentGroup,
                   PaymentGroup.q.id == Payment.q.groupID),
        LEFTJOINOn(None, _DraweePerson,
                   _DraweePerson.q.id == PaymentGroup.q.payerID),
        LEFTJOINOn(None, Sale,
                   Sale.q.groupID == PaymentGroup.q.id),
        LEFTJOINOn(None, PaymentRenegotiation,
                   PaymentRenegotiation.q.groupID == PaymentGroup.q.id),
        LEFTJOINOn(None, PersonAdaptToBranch,
                   Sale.q.branchID == PersonAdaptToBranch.q.id),
    ]

    def get_status_str(self):
        return Payment.statuses[self.status]

    @property
    def renegotiation(self):
        if self.renegotiation_id:
            return PaymentRenegotiation.get(self.renegotiation_id,
                                            connection=self.get_connection())

    @classmethod
    def select_by_provider(cls, query, provider, having=None, connection=None):
        if provider:
            provider_query = CreditCardData.q.providerID == provider.id
            if query:
                query = AND(query, provider_query)
            else:
                query = provider_query

        return cls.select(query, having=having, connection=connection)


class _BillandCheckPaymentView(Viewable):
    """A base view for check and bill payments."""
    PersonAffiliate = Alias(PersonAdaptToAffiliate, 'person_affiliate')
    columns = dict(
        id=Payment.q.id,
        due_date=Payment.q.due_date,
        paid_date=Payment.q.paid_date,
        paid_value=Payment.q.paid_value,
        status=Payment.q.status,
        value=Payment.q.value,
        payment_number=Payment.q.payment_number,
        bank_number=BankAccount.q.bank_number,
        branch=BankAccount.q.bank_branch,
        account=BankAccount.q.bank_account,
        method_description=PaymentMethod.q.description,
        iugu_id=PaymentIuguBill.q.iugu_id,
        client_name=Person.q.name,
        affiliate_name=PersonAffiliate.q.iugu_name,
        iugu_status=Payment.q.iugu_status,
        fancy_name=PersonAdaptToCompany.q.fancy_name,
    )

    joins = [
        LEFTJOINOn(None, CheckData, Payment.q.id == CheckData.q.paymentID),
        INNERJOINOn(None, PaymentMethod,
                    Payment.q.methodID == PaymentMethod.q.id),
        LEFTJOINOn(None, BankAccount,
                   BankAccount.q.id == CheckData.q.bank_accountID),
        LEFTJOINOn(None, PaymentIuguBill,
                   PaymentIuguBill.q.paymentID == Payment.q.id),

        LEFTJOINOn(None, PaymentGroup,
                   PaymentGroup.q.id == Payment.q.groupID),
        LEFTJOINOn(None, Person,
                   Person.q.id == PaymentGroup.q.payerID),
        LEFTJOINOn(None, PersonAdaptToCompany,
                   PersonAdaptToCompany.q.originalID == Person.q.id),
        LEFTJOINOn(None, PersonAffiliate,
                   Payment.q.affiliateID == PersonAffiliate.q.id),
    ]

    clause = OR(PaymentMethod.q.method_name == 'bill',
                PaymentMethod.q.method_name == 'check')

    def get_status_str(self):
        return Payment.statuses[self.status]

    @property
    def payment(self):
        return Payment.get(self.id, connection=self.get_connection())


class InCheckPaymentView(_BillandCheckPaymentView):
    """Stores information about bill and check receivings.
    """
    columns = _BillandCheckPaymentView.columns
    joins = _BillandCheckPaymentView.joins
    clause = AND(_BillandCheckPaymentView.clause,
                 PaymentAdaptToInPayment.q.originalID == Payment.q.id)


class OutCheckPaymentView(_BillandCheckPaymentView):
    """Stores information about bill and check payments.
    """
    columns = _BillandCheckPaymentView.columns
    joins = _BillandCheckPaymentView.joins
    clause = AND(_BillandCheckPaymentView.clause,
                 PaymentAdaptToOutPayment.q.originalID == Payment.q.id)


class PaymentChangeHistoryView(Viewable):
    """Holds information about changes to a payment.
    """

    columns = dict(
        id=PaymentChangeHistory.q.id,
        description=Payment.q.description,
        reason=PaymentChangeHistory.q.change_reason,
        change_date=PaymentChangeHistory.q.change_date,
        last_due_date=PaymentChangeHistory.q.last_due_date,
        new_due_date=PaymentChangeHistory.q.new_due_date,
        last_status=PaymentChangeHistory.q.last_status,
        new_status=PaymentChangeHistory.q.new_status,
    )

    joins = [
        INNERJOINOn(None, Payment,
                    Payment.q.id == PaymentChangeHistory.q.paymentID)
    ]

    @classmethod
    def select_by_group(cls, group, connection):
        return PaymentChangeHistoryView.select((Payment.q.groupID == group.id),
                                               connection=connection)

    @property
    def changed_field(self):
        """Return the name of the changed field."""

        if self.last_due_date:
            return _('Due Date')
        elif self.last_status:
            return _('Status')

    @property
    def from_value(self):
        if self.last_due_date:
            return converter.as_string(datetime.date, self.last_due_date)
        elif self.last_status:
            return Payment.statuses[self.last_status]

    @property
    def to_value(self):
        if self.new_due_date:
            return converter.as_string(datetime.date, self.new_due_date)
        elif self.new_status:
            return Payment.statuses[self.new_status]


class PaymentMethodView(Viewable):
    columns = dict(
        id=PaymentMethod.q.id,
        method_name=PaymentMethod.q.method_name,
        description=PaymentMethod.q.description,
        is_active=PaymentMethod.q.is_active
    )

    joins = []

    @classmethod
    def get_by_name(cls, conn, name):
        results = cls.select(PaymentMethod.q.method_name == name,
                             limit=2,
                             connection=conn)
        return results[0]

    @property
    def method(self):
        return PaymentMethod.get(self.id, connection=self.get_connection())


class InPaymentTotalPerClientView(Viewable):
    columns = dict(id=Person.q.id,
                   name=Person.q.name,
                   fancy_name=PersonAdaptToCompany.q.fancy_name,
                   total=const.COALESCE(
                       const.SUM(Payment.q.base_value)))

    joins = [INNERJOINOn(None, PaymentAdaptToInPayment,
                         PaymentAdaptToInPayment.q.originalID == Payment.q.id),
             INNERJOINOn(None, PaymentGroup,
                         PaymentGroup.q.id == Payment.q.groupID),
             INNERJOINOn(None, Person,
                         Person.q.id == PaymentGroup.q.payerID),
             INNERJOINOn(None, PersonAdaptToClient,
                         Person.q.id == PersonAdaptToClient.q.originalID),
             LEFTJOINOn(None, PersonAdaptToCompany,
                        Person.q.id == PersonAdaptToCompany.q.originalID),
             LEFTJOINOn(None, PersonAdaptToIndividual,
                        Person.q.id == PersonAdaptToIndividual.q.originalID)
             ]

    clause = (Payment.q.status == 1)


class FaturamentoSearch(object):
    def __init__(self, conn, start_date, end_date):
        self.conn = conn
        self.ini = start_date
        self.fim = end_date

    @property
    def saida(self):
        d_category = {}
        d_normal = {}
        for p in PaymentCategory.selectBy(connection=self.conn):
            total_saida = OutPaymentView.select(AND(OutPaymentView.q.open_date >= self.ini,
                                                    OutPaymentView.q.open_date <= self.fim,
                                                    OutPaymentView.q.category_id == p.id,
                                                    IN(OutPaymentView.q.status,
                                                       (Payment.STATUS_PAID,
                                                        Payment.STATUS_PENDING)),
                                                    ),
                                                connection=self.conn).sum('value')
            if total_saida:
                d_category[p.name] = total_saida
        for p in PaymentMethod.selectBy(self.conn):
            saida_total = OutPaymentView.select(AND(OutPaymentView.q.open_date >= self.ini,
                                                    OutPaymentView.q.open_date <= self.fim,
                                                    OutPaymentView.q.method_id == p.id,
                                                    IN(OutPaymentView.q.status,
                                                       (Payment.STATUS_PAID,
                                                        Payment.STATUS_PENDING)),
                                                    ),
                                                connection=self.conn).sum('value')
            if saida_total:
                d_normal[p.description] = saida_total
        return {
            'formas_pagamento': d_normal,
            'categoria': d_category
        }

    @property
    def entrada(self):
        d_normal = {}
        d_category = {}
        d_card = {}
        for p in PaymentCategory.selectBy(connection=self.conn):
            total_cartao = InPaymentView.select(AND(InPaymentView.q.open_date >= self.ini,
                                                    InPaymentView.q.open_date <= self.fim,
                                                    InPaymentView.q.category_id == p.id,
                                                    IN(InPaymentView.q.status,
                                                       (Payment.STATUS_PAID, Payment.STATUS_PENDING)),
                                                    ),
                                                connection=self.conn).sum('value')
            if total_cartao:
                d_category[p.name] = total_cartao
        for p in PaymentMethod.selectBy(self.conn):
            total_entrada = InPaymentView.select(AND(InPaymentView.q.open_date >= self.ini,
                                                     InPaymentView.q.open_date <= self.fim,
                                                     InPaymentView.q.method_id == p.id,
                                                     IN(InPaymentView.q.status,
                                                        (Payment.STATUS_PAID,
                                                         Payment.STATUS_PENDING)),
                                                     ),
                                                 connection=self.conn).sum('value')
            if total_entrada:
                d_normal[p.description] = total_entrada
        for p in PersonAdaptToCreditProvider.selectBy(self.conn):
            total_cartao = CardPaymentView.select(AND(CardPaymentView.q.open_date >= self.ini,
                                                      CardPaymentView.q.open_date <= self.fim,
                                                      CardPaymentView.q.provider_id == p.id,
                                                      IN(CardPaymentView.q.status,
                                                         (Payment.STATUS_PAID, Payment.STATUS_PENDING))
                                                      ),
                                                  connection=self.conn).sum('value')
            if total_cartao:
                d_card[p.person.name] = total_cartao
        return {'cartao': d_card,
                'formas_pagamento': d_normal,
                'categoria': d_category}


class DailyFaturamentoSearch(object):
    def __init__(self, conn, start_date, end_date):
        self.conn = conn
        self.ini = start_date
        self.fim = end_date

    @property
    def saida(self):
        d_category = {}
        d_normal = {}
        for p in PaymentCategory.selectBy(connection=self.conn):
            total_saida = OutPaymentView.select(AND(OutPaymentView.q.paid_date >= self.ini,
                                                    OutPaymentView.q.paid_date <= self.fim,
                                                    OutPaymentView.q.category_id == p.id,
                                                    IN(OutPaymentView.q.status,
                                                       (Payment.STATUS_PAID,
                                                        Payment.STATUS_CONFIRMED)),
                                                    ),
                                                connection=self.conn).sum('payment.paid_value')
            if total_saida:
                d_category[p.name] = total_saida
        for p in PaymentMethod.selectBy(self.conn):
            saida_total = OutPaymentView.select(AND(OutPaymentView.q.paid_date >= self.ini,
                                                    OutPaymentView.q.paid_date <= self.fim,
                                                    OutPaymentView.q.method_id == p.id,
                                                    IN(OutPaymentView.q.status,
                                                       (Payment.STATUS_PAID,
                                                        Payment.STATUS_CONFIRMED)),
                                                    ),
                                                connection=self.conn).sum('payment.paid_value')
            if saida_total:
                d_normal[p.description] = saida_total
        return {
            'formas_pagamento': d_normal,
            'categoria': d_category
        }

    @property
    def entrada(self):
        d_normal = {}
        d_category = {}
        d_card = {}
        for p in PaymentCategory.selectBy(connection=self.conn):
            total_cartao = InPaymentView.select(AND(InPaymentView.q.paid_date >= self.ini,
                                                    InPaymentView.q.paid_date <= self.fim,
                                                    InPaymentView.q.category_id == p.id,
                                                    IN(InPaymentView.q.status,
                                                       (Payment.STATUS_PAID,
                                                        Payment.STATUS_CONFIRMED)),
                                                    ),
                                                connection=self.conn).sum('payment.paid_value')
            if total_cartao:
                d_category[p.name] = total_cartao
        for p in PaymentMethod.selectBy(self.conn):
            total_entrada = InPaymentView.select(AND(InPaymentView.q.paid_date >= self.ini,
                                                     InPaymentView.q.paid_date <= self.fim,
                                                     InPaymentView.q.method_id == p.id,
                                                     IN(InPaymentView.q.status,
                                                        (Payment.STATUS_PAID,
                                                         Payment.STATUS_CONFIRMED)),
                                                     ),
                                                 connection=self.conn).sum('payment.paid_value')
            if total_entrada:
                d_normal[p.description] = total_entrada
        for p in PersonAdaptToCreditProvider.selectBy(self.conn):
            total_cartao = CardPaymentView.select(AND(CardPaymentView.q.paid_date >= self.ini,
                                                      CardPaymentView.q.paid_date <= self.fim,
                                                      CardPaymentView.q.provider_id == p.id,
                                                      IN(CardPaymentView.q.status,
                                                         (Payment.STATUS_PAID,
                                                          Payment.STATUS_CONFIRMED))
                                                      ),
                                                  connection=self.conn).sum('payment.paid_value')
            if total_cartao:
                d_card[p.person.name] = total_cartao
        return {'cartao': d_card,
                'formas_pagamento': d_normal,
                'categoria': d_category}

    @property
    def faturamento_ontem(self):
        ini = self.ini - datetime.timedelta(days=1)
        fim = self.fim - datetime.timedelta(days=1)
        daily_flow = DailyFlow.select(AND(DailyFlow.q.flow_date >= ini,
                                          DailyFlow.q.flow_date <= fim
                                          ), connection=self.conn)
        daily_flow = [p for p in daily_flow]
        if daily_flow:
            return daily_flow[0].balance
        return 0
