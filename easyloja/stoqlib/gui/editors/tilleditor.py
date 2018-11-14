# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2007 Async Open Source <http://www.async.com.br>
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
""" Editors implementation for open/close operation on till operation"""

import gtk

import datetime
from kiwi.datatypes import ValidationError, currency
from kiwi.python import Settable
from kiwi.ui.objectlist import Column, ColoredColumn, SummaryLabel
from sqlobject import SQLObjectNotFound
from stoqdrivers.exceptions import DriverError
from stoqlib.api import api
from stoqlib.database.orm import const
from stoqlib.database.runtime import get_current_user
from stoqlib.domain.account import AccountTransaction
from stoqlib.domain.events import (TillOpenEvent, TillCloseEvent,
                                   TillAddTillEntryEvent,
                                   TillAddCashEvent, TillRemoveCashEvent)
from stoqlib.domain.interfaces import IEmployee
from stoqlib.domain.payment.views import BasePaymentView
from stoqlib.domain.person import Person
from stoqlib.domain.till import Till
from stoqlib.exceptions import DeviceError, TillError
from stoqlib.gui.editors.baseeditor import BaseEditor, BaseEditorSlave
from stoqlib.lib.message import warning
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


def _create_transaction(conn, till_entry):
    AccountTransaction(description=till_entry.description,
                       source_account=sysparam(conn).IMBALANCE_ACCOUNT,
                       account=sysparam(conn).TILLS_ACCOUNT,
                       value=-till_entry.value,
                       code=str(till_entry.id),
                       date=const.NOW(),
                       connection=conn,
                       payment=till_entry.payment)


class _TillOpeningModel(object):
    def __init__(self, till, value):
        self.till = till
        self.value = value

    def get_balance(self):
        return currency(self.till.get_balance() + self.value)


class _TillClosingModel(object):
    def __init__(self, till, value):
        self.till = till
        self.value = value

    def get_opening_date(self):
        return self.till.opening_date

    def get_cash_amount(self):
        return currency(self.till.get_cash_amount() - self.value)

    def get_balance(self):
        return currency(self.till.get_balance() - self.value)

    @property
    def initial_cash_amount(self):
        return self.till.initial_cash_amount

    def get_entries(self):
        return self.till.get_entries()


class _TillVerifyingModel(_TillClosingModel):
    def __init__(self, till, value):
        _TillClosingModel.__init__(self, till, value)

    def get_cash_amount(self):
        return currency(self.till.get_parcial_cash_amount() - self.value)

    def get_balance(self):
        return currency(self.till.get_parcial_balance() - self.value)

    @property
    def initial_cash_amount(self):
        return self.till.get_initial_cash_amount()

    def get_entries(self):
        return self.till.get_parcial_entries()


class TillOpeningEditor(BaseEditor):
    """An editor to open a till.
    You can add cash to the till in the editor and it also shows
    the balance of the till, after the cash has been added.

    Callers of this editor are responsible for sending in a valid Till object,
    which the method open_till() can be called.
    """
    title = _(u'Till Opening')
    model_type = _TillOpeningModel
    gladefile = 'TillOpening'
    confirm_widgets = ['value']
    proxy_widgets = ('value',
                     'balance')

    help_section = 'till-open'

    #
    # BaseEditorSlave
    #

    def create_model(self, conn):
        till = Till(connection=conn, station=api.get_current_station(conn))
        till.open_till()

        return _TillOpeningModel(till=till, value=currency(0))

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model, TillOpeningEditor.proxy_widgets)

    def on_confirm(self):
        till = self.model.till

        try:
            TillOpenEvent.emit(till=till)
        except (TillError, DeviceError), e:
            warning(str(e))
            return None
        username = get_current_user(self.conn).person.name
        value = self.proxy.model.value
        TillAddCashEvent.emit(till=till,
                              value=value,
                              reason=(_(u'Caixa iniciado por %s com a quantia de %s em %s') %
                                      (username, value, till.opening_date.strftime('%x'))))
        till_entry = till.add_credit_entry(value,
                                           (_(u'Caixa iniciado por %s com a quantia de %s em %s')
                                            % (username, value, till.opening_date.strftime('%x'))))
        _create_transaction(self.conn, till_entry)
        # The callsite is responsible for interacting with
        # the fiscal printer
        return self.model

    #
    # Kiwi callbacks
    #

    def on_value__validate(self, entry, data):
        if data < currency(0):
            self.proxy.update('balance', currency(0))
            return ValidationError(
                _("You cannot add a negative amount when opening the till."))
        if '.' not in str(data):
            return ValidationError(
                _("You should add two decimal values."))

    def after_value__content_changed(self, entry):
        self.proxy.update('balance')


class TillClosingEditor(BaseEditor):
    size = (500, 440)
    title = _(u'Closing Opened Till')
    model_type = _TillClosingModel
    gladefile = 'TillClosing'
    confirm_widgets = ['value']
    proxy_widgets = ('value',
                     'balance',
                     'opening_date')

    help_section = 'till-close'

    def __init__(self, conn, model=None, previous_day=False, close_db=True,
                 close_ecf=True):
        """
        Create a new TillClosingEditor object.
        @param previous_day: If the till wasn't closed previously
        """
        self._previous_day = previous_day
        self.till = Till.get_last(conn)
        assert self.till
        self._close_db = close_db
        self._close_ecf = close_ecf
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()

    def _setup_widgets(self):
        # We cant remove cash if closing till from a previous day
        self.value.set_sensitive(not self._previous_day)
        if self._previous_day:
            value = 0
        else:
            value = self.model.get_balance()
        self.value.update(value)

        self.day_history.set_columns(self._get_columns())
        self.day_history.connect('row-activated', lambda olist, row: self.confirm())
        self.day_history.add_list(self._get_day_history())
        summary_day_history = SummaryLabel(
            klist=self.day_history,
            column='value',
            label='<b>%s</b>' % _(u'Total balance:'))
        summary_day_history.show()
        self.day_history_box.pack_start(summary_day_history, False)

    def _get_day_history(self):
        day_history = {}
        day_history[_(u'Initial Amount')] = self.model.initial_cash_amount

        for entry in self.model.get_entries():
            # colocar um if pra ver se o pagamento é solitario aqui... se for, entao tratar como sangria e suprimento
            payment = entry.payment
            if payment is not None:
                try:
                    bpv = BasePaymentView.select(BasePaymentView.q.id == payment.id).getOne()
                except SQLObjectNotFound, e:
                    bpv = None
                if bpv:
                    if bpv.is_lonely():
                        if entry.value > 0:
                            default_desc = 'Suprimento'
                        else:
                            default_desc = 'Despesa'
                        pay_desc = bpv.description or default_desc
                        if bpv.category:
                            desc = "{}; {}".format(pay_desc, bpv.category)
                        else:
                            desc = "{}".format(pay_desc)
                    else:
                        desc = payment.method.get_description()
                else:
                    desc = payment.method.get_description()

            else:
                # o que nao tiver pagamento, é assumido como sangria  e suprimento
                desc = entry.description
                # if entry.value > 0:
                #     desc = _(u'Cash In')
                # else:
                #     desc = _(u'Cash Out')

            if desc in day_history.keys():
                day_history[desc] += entry.value
            else:
                day_history[desc] = entry.value

        for description, value in day_history.iteritems():
            yield Settable(description=description, value=value)

    def _get_columns(self):
        return [Column('description', title=_('Description'), data_type=str,
                       width=300, sorted=True),
                ColoredColumn('value', title=_('Amount'), data_type=currency,
                              color='red', data_func=lambda x: x < 0)]

    #
    # BaseEditorSlave
    #

    def create_model(self, trans):
        return _TillClosingModel(till=self.till, value=currency(0))

    def setup_proxies(self):
        if not self.till.get_balance():
            self.value.set_sensitive(False)
        self.proxy = self.add_proxy(self.model,
                                    TillClosingEditor.proxy_widgets)

    def on_confirm(self):
        till = self.model.till
        removed = abs(self.model.value)

        if removed > till.get_balance():
            raise ValueError("The amount that you want to remove is "
                             "greater than the current balance.")

        # assert self._close_ecf
        # We need to do this inside a new transaction, because if the
        # till closing fails further on, this still needs to be recorded
        # in the database
        trans = api.new_transaction()
        t_till = trans.get(till)
        username = get_current_user(self.conn).person.name
        TillRemoveCashEvent.emit(till=t_till,
                                 value=removed,
                                 reason=_(u'Quantia removida do caixa por %s referente ao dia %s') %
                                        (username, till.opening_date.strftime('%x')))
        till_entry = t_till.add_debit_entry(removed,
                                            _(u'Quantia removida do caixa por %s referente ao dia %s') %
                                            (username, till.opening_date.strftime('%x')))
        # Financial transaction
        _create_transaction(trans, till_entry)
        # DB transaction
        api.finish_transaction(trans, True)
        trans.close()

        if self._close_ecf:
            try:
                retval = TillCloseEvent.emit(till=till,
                                             previous_day=self._previous_day)
            except (TillError, DeviceError), e:
                warning(str(e))
                return None

            # If the event was captured and its return value is False, then we
            # should not close the till.
            if retval is False:
                return False

        if self._close_db:
            try:
                till.close_till()
            except ValueError as err:
                warning(str(err))
                return

        # The callsite is responsible for interacting with
        # the fiscal printer
        return self.model

    #
    # Kiwi handlers
    #

    def after_value__validate(self, widget, value):
        if not hasattr(self, 'proxy'):
            return
        if value < currency(0):
            self.proxy.update('balance', currency(0))
            return ValidationError(_("Value cannot be less than zero"))
        if value > self.till.get_balance():
            self.proxy.update('balance', currency(0))
            return ValidationError(_("You can not specify an amount "
                                     "removed greater than the "
                                     "till balance."))

    def after_value__content_changed(self, entry):
        self.proxy.update('balance')


class TillVerifyEditor(TillClosingEditor):
    title = _('Verificação do Caixa')
    model_type = _TillVerifyingModel
    help_section = 'till-verify'

    def __init__(self, store, model=None, previous_day=False,
                 close_db=False, close_ecf=False):
        assert not close_db and not close_ecf
        super(TillVerifyEditor, self).__init__(store, model=model,
                                               previous_day=previous_day,
                                               close_db=close_db,
                                               close_ecf=close_ecf)
        info_message = "Use este assistente para ajustar o caixa para o proximo usuário.\n Esta operação não irá de fechar o caixa ou emitir uma redução Z."
        self.add_message_bar(info_message, gtk.MESSAGE_INFO)

    def create_model(self, trans):
        return _TillVerifyingModel(till=self.till, value=currency(0))


class BaseCashSlave(BaseEditorSlave):
    """A slave representing two fields, which is used by Cash editors:

    Date:        YYYY-MM-DD
    Cash Amount: [        ]
    """

    model_type = Settable
    gladefile = 'BaseCashSlave'
    proxy_widgets = ('value', 'balance')

    #
    # BaseEditorSlave
    #

    def setup_proxies(self):
        self.proxy = self.add_proxy(self.model, BaseCashSlave.proxy_widgets)
        self.date.set_text(str(datetime.date.today()))
        self.proxy.update('value', currency(0))

    #
    # Kiwi handlers
    #

    def on_value__validate(self, widget, value):
        pass
        # zero = currency(0)
        # if value <= zero:
        #     return ValidationError(_("Value cannot be zero or less than zero"))


class RemoveCashSlave(BaseCashSlave):
    def on_value__validate(self, widget, value):
        if value <= currency(0):
            return ValidationError(_("Value cannot be zero or less than zero"))
        if value > self.model.balance:
            return ValidationError(
                _("Value cannot be more than the total Till balance"))


class CashAdvanceEditor(BaseEditor):
    """An editor which extends BaseCashSlave to include.
    It extends BaseCashSlave to include an employee combobox
    """

    model_name = _(u'Cash Advance')
    model_type = Settable
    gladefile = 'CashAdvanceEditor'

    def _get_employee(self):
        return self.employee_combo.get_selected_data()

    def _get_employee_name(self):
        return self.employee_combo.get_selected_label()

    def _setup_widgets(self):
        # FIXME: Implement and use IDescribable on PersonAdaptToEmployee
        employees = [(e.person.name, e)
                     for e in Person.iselect(IEmployee, connection=self.conn)]
        self.employee_combo.prefill(employees)
        self.employee_combo.set_active(0)

    #
    # BaseEditorSlave
    #

    def create_model(self, conn):
        till = Till.get_current(self.conn)
        return Settable(employee=None,
                        payment=None,
                        open_date=None,
                        till=till,
                        balance=till.get_balance(),
                        value=currency(0))

    def setup_slaves(self):
        self.cash_slave = RemoveCashSlave(self.conn,
                                          self.model)
        self.cash_slave.value.connect('content-changed',
                                      self._on_cash_slave__value_changed)
        self.attach_slave("base_cash_holder", self.cash_slave)
        self._setup_widgets()

    def validate_confirm(self):
        return self.cash_slave.validate_confirm()

    def on_confirm(self):
        valid = self.cash_slave.on_confirm()
        if valid:
            till = self.model.till
            value = abs(self.model.value)
            assert till
            try:
                TillRemoveCashEvent.emit(till=till,
                                         value=value,
                                         reason=(_(u'Cash advance paid to employee: %s') %
                                                 (self._get_employee_name(),)))
            except (TillError, DeviceError, DriverError), e:
                warning(str(e))
                return None
            till_entry = till.add_debit_entry(
                value, (_(u'Cash advance paid to employee: %s') % (
                    self._get_employee_name(),)))

            TillAddTillEntryEvent.emit(till_entry, self.conn)
            _create_transaction(self.conn, till_entry)
            return self.model

        return valid

    #
    # Callbacks
    #

    def _on_cash_slave__value_changed(self, entry):
        self.cash_slave.model.value = -abs(self.cash_slave.model.value)


class CashOutEditor(BaseEditor):
    """An editor to Remove cash from the Till
    It extends BaseCashSlave to include a reason entry.
    """

    model_name = _(u'Cash Out')
    model_type = Settable
    gladefile = 'CashOutEditor'
    title = _(u'Reverse Payment')

    help_section = 'till-remove-money'

    def __init__(self, conn):
        BaseEditor.__init__(self, conn)
        self.set_confirm_widget(self.reason)
        self.set_confirm_widget(self.cash_slave.value)

    #
    # BaseEditorSlave
    #

    def create_model(self, conn):
        till = Till.get_current(conn)
        return Settable(value=currency(0),
                        reason='',
                        till=till,
                        balance=till.get_balance())

    def setup_slaves(self):
        self.cash_slave = RemoveCashSlave(self.conn, self.model)
        self.cash_slave.value.connect('content-changed',
                                      self._on_cash_slave__value_changed)
        self.attach_slave("base_cash_holder", self.cash_slave)

    def validate_confirm(self):
        return self.cash_slave.validate_confirm()

    def on_confirm(self):
        valid = self.cash_slave.on_confirm()
        if valid:
            value = abs(self.model.value)
            till = self.model.till
            assert till
            try:
                TillRemoveCashEvent.emit(till=till,
                                         value=value,
                                         reason=(u'Despesa: %s' % (self.reason.get_text(),)))
            except (TillError, DeviceError, DriverError), e:
                warning(str(e))
                return None

            till_entry = till.add_debit_entry(
                value, (u'Despesa: %s' % (self.reason.get_text(),)))

            TillAddTillEntryEvent.emit(till_entry, self.conn)
            _create_transaction(self.conn, till_entry)
            return till_entry

        return valid

    def _on_cash_slave__value_changed(self, entry):
        self.cash_slave.model.value = -abs(self.cash_slave.model.value)


class CashInEditor(BaseEditor):
    """An editor to Add cash to the Till
    It uses BaseCashSlave without any extensions
    """

    model_name = _(u'Cash In')
    model_type = Settable
    gladefile = 'CashOutEditor'

    help_section = 'till-add-money'

    def __init__(self, conn):
        BaseEditor.__init__(self, conn)
        self.set_confirm_widget(self.reason)
        self.set_confirm_widget(self.cash_slave.value)

    #
    # BaseEditorSlave
    #

    def create_model(self, conn):
        till = Till.get_current(conn)
        return Settable(value=currency(0),
                        reason='',
                        till=till,
                        balance=till.get_balance())

    def setup_slaves(self):
        self.cash_slave = BaseCashSlave(self.conn, self.model)
        self.attach_slave("base_cash_holder", self.cash_slave)

    def validate_confirm(self):
        return self.cash_slave.validate_confirm()

    def on_confirm(self):
        valid = self.cash_slave.on_confirm()
        if valid:
            till = self.model.till
            assert till
            try:
                TillAddCashEvent.emit(till=till,
                                      value=self.model.value,
                                      reason=(u'Suprimento: %s' % (self.reason.get_text())))
            except (TillError, DeviceError, DriverError), e:
                warning(str(e))
                return None

            till_entry = till.add_credit_entry(
                self.model.value,
                (u'Suprimento: %s' % (self.reason.get_text(),)))

            TillAddTillEntryEvent.emit(till_entry, self.conn)
            _create_transaction(self.conn, till_entry)
            return till_entry

        return valid
