# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2009 Async Open Source <http://www.async.com.br>
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
##
""" Payments Renegotiation Wizard """

import datetime

from kiwi.datatypes import currency, ValidationError
from kiwi.ui.widgets.list import Column

from stoqlib.api import api
from stoqlib.domain.payment.operation import register_payment_operations
from stoqlib.domain.payment.renegotiation import PaymentRenegotiation
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.gui.base.wizards import WizardEditorStep, BaseWizard
from stoqlib.gui.wizards.salewizard import BaseMethodSelectionStep

_ = stoqlib_gettext


#
# Wizard Steps
#

class PaymentRenegotiationPaymentListStep(BaseMethodSelectionStep,
                                          WizardEditorStep):
    gladefile = 'PaymentRenegotiationPaymentListStep'
    model_type = PaymentRenegotiation
    proxy_widgets = ('surcharge_value', 'discount_value', 'total')

    def __init__(self, conn, wizard, model, groups, model_attr):
        self.model_attr = model_attr
        self.groups = groups
        WizardEditorStep.__init__(self, conn, wizard, model)
        BaseMethodSelectionStep.__init__(self)

    def _setup_widgets(self):
        self.total.set_sensitive(False)
        self.subtotal.set_sensitive(False)

        idt = getattr(self.groups[0].get_parent(), self.model_attr)
        self.identification.model_attribute = self.model_attr
        self.identification.prefill([(idt.person.name, idt)])
        self.identification.select(idt)
        self.identification.set_sensitive(False)

        self.payment_list.set_columns(self._get_columns())
        payments = []
        for group in self.groups:
            group.renegotiation = self.model
            group.get_parent().set_renegotiated()
            payments.extend(group.get_pending_payments())

        assert len(payments)
        self.payment_list.add_list(payments)

        subtotal = 0
        for payment in payments:
            subtotal += payment.value
            payment.cancel()

        self._subtotal = subtotal
        self.subtotal.update(self._subtotal)

    def _get_columns(self):
        return [Column('id', title=_('#'), data_type=str, format='%04d'),
                Column('description', title=_('Description'), data_type=str,
                       expand=True),
                Column('due_date', title=_('Due date'),
                       data_type=datetime.date, width=90),
                Column('status_str', title=_('Status'), data_type=str, width=80),
                Column('value', title=_('Value'), data_type=currency,
                       width=100)]

    def _update_totals(self):
        surcharge = self.model.surcharge_value or 0
        discount = self.model.discount_value or 0
        self.model.total = self._subtotal + surcharge - discount
        self.proxy.update('total')

    def _update_next_step(self, method):
        if method and method.method_name == 'money':
            self.wizard.enable_finish()
        else:
            self.wizard.disable_finish()

    #
    # WizardStep hooks
    #

    def post_init(self):
        self.model.group.clear_unused()
        self._update_next_step(self.pm_slave.get_selected_method())
        self.register_validate_function(self.wizard.refresh_next)
        self.force_validation()

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model,
                            PaymentRenegotiationPaymentListStep.proxy_widgets)
        self._update_totals()

    #
    #   Callbacks
    #

    def on_surcharge_value__validate(self, entry, value):
        if value < 0:
            return ValidationError(
                    _('Surcharge must be greater than 0'))

    def on_discount_value__validate(self, entry, value):
        if value < 0:
            return ValidationError(
                    _('Discount must be greater than 0'))
        if value >= self._subtotal:
            return ValidationError(
                    _('Discount can not be greater than total amount'))

    def after_surcharge_value__changed(self, entry):
        self._update_totals()

    def after_discount_value__changed(self, entry):
        self._update_totals()


#
# Main wizard
#


class PaymentRenegotiationWizard(BaseWizard):
    size = (550, 400)
    title = _('Payments Renegotiation Wizard')
    model_attr = None

    def __init__(self, conn, groups):
        register_payment_operations()
        self.groups = groups
        self._create_model(conn)
        first = PaymentRenegotiationPaymentListStep(conn, self, self.model,
                                                    self.groups, self.model_attr)
        BaseWizard.__init__(self, conn, first, self.model)

    def _create_model(self, conn):
        value = 0 # will be updated in the first step.
        branch = api.get_current_branch(conn)
        user = api.get_current_user(conn)
        extra = self.params_for_model(conn)
        self.model = PaymentRenegotiation(total=value,
                                          branch=branch,
                                          responsible=user,
                                          connection=conn,
                                          **extra)
        return self.model

    #
    # BaseWizard hooks
    #

    def finish(self):
        self.retval = True
        for payment in self.model.group.get_items():
            payment.set_pending()
        self.close()

    #
    # Hook Methods
    #

    def params_for_model(self, conn):
        raise Exception("This method must be override")

#
# Decorator Classes
#


class PayableRenegotiationWizard(PaymentRenegotiationWizard):
    model_attr = "supplier"

    def __init__(self, conn, groups):
        PaymentRenegotiationWizard.__init__(self, conn, groups)

    def params_for_model(self, conn):
        supplier = self.groups[0].get_parent().supplier
        group = PaymentGroup(recipient=supplier.person,
                             connection=conn)
        return {'supplier': supplier,
                'group': group}


class ReceivableRenegotiationWizard(PaymentRenegotiationWizard):
    model_attr = "client"

    def __init__(self, conn, groups):
        PaymentRenegotiationWizard.__init__(self, conn, groups)

    def params_for_model(self, conn):
        client = self.groups[0].get_parent().client
        group = PaymentGroup(payer=client.person,
                             connection=conn)
        return {'client': client,
                'group': group}