# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2007-2011 Async Open Source <http://www.async.com.br>
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
## Foundation, Outc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##
##
""" Editor for payments descriptions and categories"""

import gtk

import datetime
import pango
from dateutil.relativedelta import relativedelta
from kiwi.datatypes import currency, ValidationError, ValueUnset
from kiwi.ui.dialogs import info
from kiwi.ui.gadgets import render_pixbuf
from kiwi.ui.widgets.list import Column
from stoqlib.api import api
from stoqlib.domain.interfaces import (IInPayment, IOutPayment, IClient,
                                       ISupplier, IIndividual, ICompany)
from stoqlib.domain.payment.category import PaymentCategory
from stoqlib.domain.payment.costcenter import PaymentCostCenter
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.payment.views import PaymentChangeHistoryView, BasePaymentView
from stoqlib.domain.person import PersonAdaptToClient, PersonAdaptToSupplier, PersonCategoryPaymentInfo, \
    PersonAdaptToBranch, PersonAdaptToAffiliate, AffiliateView
from stoqlib.domain.sale import SaleView
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.search import SearchEditor
from stoqlib.gui.dialogs.purchasedetails import PurchaseDetailsDialog
from stoqlib.gui.dialogs.renegotiationdetails import RenegotiationDetailsDialog
from stoqlib.gui.dialogs.saledetails import SaleDetailsDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.gui.editors.paymentcategoryeditor import PaymentCategoryEditor
from stoqlib.gui.editors.paymentcostcentereditor import PaymentCostCenterEditor
from stoqlib.gui.editors.personeditor import ClientEditor, SupplierEditor
from stoqlib.gui.search.personsearch import ClientSearch, SupplierSearch
from stoqlib.gui.wizards.personwizard import run_person_role_dialog
from stoqlib.lib.defaults import (INTERVALTYPE_WEEK,
                                  INTERVALTYPE_MONTH)
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.validators import validate_cpf, validate_cnpj, validate_phone_number, validate_email
from stoqlib.domain.till import Till
from stoqlib.domain.person import PersonCategoryPaymentInfo
from stoq.gui.shell import get_shell


_ = stoqlib_gettext
INTERVALTYPE_ONCE = -1
INTERVALTYPE_BIWEEKLY = 10
INTERVALTYPE_QUARTERLY = 11


class PaymentEditor(BaseEditor):
    gladefile = "PaymentEditor"
    model_type = Payment
    person_editor = None
    person_class = None
    person_iface = None
    title = _("Payment")
    confirm_widgets = ['due_date']
    proxy_widgets = ['value',
                     'description',
                     'due_date',
                     'open_date',
                     'category',
                     'cost_center',
                     'notes',
                     'affiliate',
                     'branch']

    def __init__(self, conn, model=None):
        """ A base class for additional payments

        @param conn: a database connection
        @param model: a L{stoqlib.domain.payment.payment.Payment} object or None

        """
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()

    #
    # BaseEditor hooks
    #

    def create_model(self, trans):
        group = PaymentGroup(connection=trans)
        money = PaymentMethod.get_by_name(trans, 'money')
        # Set status to PENDING now, to avoid calling set_pending on
        # on_confirm for payments that shoud not have its status changed.
        return Payment(open_date=datetime.date.today(),
                       status=Payment.STATUS_PENDING,
                       description='',
                       value=currency(0),
                       base_value=currency(0),
                       due_date=None,
                       method=money,
                       group=group,
                       till=None,
                       category=None,
                       cost_center=None,
                       branch=None,
                       connection=trans)

    def setup_proxies(self):
        self._fill_category_combo()
        self._fill_cost_center_combo()
        self._fill_method_combo()
        self._populate_person()
        self._populate_branch()
        self._populate_afiliate()
        self.repeat.prefill([
            (_('Once'), INTERVALTYPE_ONCE),
            (_('Weekly'), INTERVALTYPE_WEEK),
            (_('Biweekly'), INTERVALTYPE_BIWEEKLY),
            (_('Monthly'), INTERVALTYPE_MONTH),
            (_('Quarterly'), INTERVALTYPE_QUARTERLY)])
        self.add_category.set_tooltip_text(_("Add a new payment category"))
        self.edit_category.set_tooltip_text(_("Edit the selected payment category"))
        if self.person_iface == ISupplier:
            self.add_person.set_tooltip_text(_("Add a new supplier"))
            self.edit_person.set_tooltip_text(_("Edit the selected supplier"))
        else:
            self.add_person.set_tooltip_text(_("Add a new client"))
            self.edit_person.set_tooltip_text(_("Edit the selected client"))
        self.add_proxy(self.model, PaymentEditor.proxy_widgets)

    def validate_confirm(self):
        if (self.repeat.get_selected() != INTERVALTYPE_ONCE and
                not self._validate_date()):
            return False
        # FIXME: the kiwi view should export it's state and it should
        #        be used by default
        return bool(self.model.description and
                    self.model.due_date and
                    self.model.value)

    def can_edit_details(self):
        widgets = [self.value, self.due_date,
                   self.add_person, self.repeat, self.method,
                   self.affiliate, self.affiliate_lbl]
        bill = PaymentMethod.get_by_name(self.conn, 'bill')
        if get_plugin_manager().is_active('boleto') and self.model.method == bill:
            if self.value in widgets:
                widgets.remove(self.value)
        for widget in widgets:
            widget.set_sensitive(True)
        self.details_button.hide()
        self.edit_person.set_sensitive(bool(self.person.get_selected()))
        self._populate_person()

    # Private
    def _populate_branch(self):
        self.branch.prefill([(str(p.person.name), p) for p in PersonAdaptToBranch.selectBy(connection=self.conn)])

    def _populate_afiliate(self):
        # preenche somente com os afiliados aprovados.
        self.affiliate.prefill([(str(p.name), p.affiliate) for p in
                                AffiliateView.select(AffiliateView.q.status ==
                                                     PersonAdaptToAffiliate.STATUS_APPROVED,
                                                     connection=self.conn).orderBy('name')])

    def _populate_person(self):
        person = getattr(self.model.group, self.person_attribute)
        if person:
            facet = self.person_iface(person)
            self.person.prefill([(facet.person.name, facet)])
            self.person.select(facet)
            categories = PersonCategoryPaymentInfo.selectBy(connection=self.conn, person=facet.person.id)
            if categories:
                for category in categories:
                    if category.is_default:
                        self.category.update(category)
            return
        if self.person_class == PersonAdaptToSupplier:
            facets = self.person_class.get_active_suppliers(self.trans)
            if facets:
                self.person.prefill(sorted([(f.get_description(),
                                             getattr(f, 'client', None) or f)
                                            for f in facets]))
                #            facets = SupplierView.get_active_suppliers(self.conn)
                #         else:
                #            facets = self.person_class.get_active_clients(self.trans)
                #             facets = PersonAdaptToClient.get_active_clients(self.conn)
                # if facets:
                #     self.person.prefill(sorted([(f.get_description(),
                #                                  getattr(f, 'client', None) or f)
                #                                 for f in facets]))
                # self.person.set_sensitive(bool(facets))

    def _run_payment_category_editor(self, category=None):
        trans = api.new_transaction()
        category = trans.get(category)
        model = run_dialog(PaymentCategoryEditor, get_current_toplevel(), trans, category)
        rv = api.finish_transaction(trans, model)
        trans.close()
        if rv:
            self._fill_category_combo()
            self.category.select(model)

    def _run_cost_center_editor(self, cost_center=None):
        trans = api.new_transaction()
        cost_center = trans.get(cost_center)
        model = run_dialog(PaymentCostCenterEditor, get_current_toplevel(), trans, cost_center)
        rv = api.finish_transaction(trans, model)
        trans.close()
        if rv:
            self._fill_cost_center_combo()
            self.cost_center.select(model)

    def _run_person_editor(self, person=None):
        trans = api.new_transaction()
        person = trans.get(person)
        model = run_person_role_dialog(self.person_editor, self, trans, person)
        rv = api.finish_transaction(trans, model)
        trans.close()
        if rv:
            self._populate_person()
            self.person.select(model)

    def _fill_cost_center_combo(self):
        cost_centers = PaymentCostCenter.select(
            connection=self.trans).orderBy('name')
        self.cost_center.set_sensitive(bool(cost_centers))
        cost_centers = [(c.name, c) for c in cost_centers]
        cost_centers.insert(0, (_('Sem centro de custo'), None))
        self.cost_center.prefill(cost_centers)
        self.cost_center.select(self.model.cost_center)
        self.edit_cost_center.set_sensitive(False)

    def _fill_category_combo(self):
        categories = PaymentCategory.select(
            connection=self.trans).orderBy('name')
        self.category.set_sensitive(bool(categories))
        categories = [(c.name, c) for c in categories]
        categories.insert(0, (_('No category'), None))
        self.category.prefill(categories)
        self.category.select(self.model.category)
        self.edit_category.set_sensitive(False)

    def _fill_method_combo(self):
        methods = PaymentMethod.select(
            connection=self.trans).orderBy('description')
        bpv = [p for p in BasePaymentView.select(BasePaymentView.q.id == self.model.id,
                                                 connection=self.conn)]
        try:
            bpv = bpv[0]
            if bpv.is_lonely():
                self.method.set_sensitive(True)
            else:
                self.method.set_sensitive(False)
        except:
            self.method.set_sensitive(False)
        self.method.prefill([(m.description, m) for m in methods])
        self.method.select(self.model.method)

    def _setup_widgets(self):
        self.person_lbl.set_label(self._person_label)
        widgets = [self.value, self.repeat, self.end_date,
                   self.affiliate, self.affiliate_lbl]
        if self.model.group.sale:
            label = _("Sale details")
        elif self.model.group.purchase:
            label = _("Purchase details")
        elif self.model.group._renegotiation:
            label = _("Details")
        else:
            label = _("Details")
            if self.model.status != Payment.STATUS_PAID:
                widgets = [self.repeat, self.end_date]
        self.details_button = self.add_button(label)
        self.details_button.connect('clicked',
                                    self._on_details_button__clicked)
        bill = PaymentMethod.get_by_name(self.conn, 'bill')
        if get_plugin_manager().is_active('boleto') and self.model.method == bill:
            if self.value in widgets:
                widgets.remove(self.value)
        for widget in widgets:
            widget.set_sensitive(False)
        # se já tem pessoa nao permite a sua edição, por padrão vem habilitado
        person = getattr(self.model.group, self.person_attribute)
        if person:
            for widget in [self.person, self.edit_person, self.add_person, self.person_search]:
                widget.set_sensitive(False)
        self.payment_value = self.model.value
        if not sysparam(self.conn).CAN_CHANGE_OPEN_DATE:
            self.open_date.set_sensitive(False)

    def _show_order_dialog(self):
        group = self.model.group
        if group.sale:
            sale_view = SaleView.select(SaleView.q.id == group.sale.id)[0]
            run_dialog(SaleDetailsDialog, get_current_toplevel(), self.conn, sale_view)
        elif group.purchase:
            run_dialog(PurchaseDetailsDialog, get_current_toplevel(), self.conn, group.purchase)
        elif group._renegotiation:
            run_dialog(RenegotiationDetailsDialog, get_current_toplevel(), self.conn,
                       group._renegotiation)
        else:
            run_dialog(LonelyPaymentDetailsDialog, get_current_toplevel(), self.conn, self.model)

    def _validate_date(self):
        if not self.end_date.props.sensitive:
            return True
        end_date = self.end_date.get_date()
        due_date = self.due_date.get_date()
        if end_date and due_date:
            if end_date < due_date:
                self.end_date.set_invalid(_("End date must be before start date"))
            else:
                self.end_date.set_valid()
                self.refresh_ok(self.is_valid)
                return True
        elif not end_date:
            self.end_date.set_invalid(_("Date cannot be empty"))
        elif not due_date:
            self.due_date.set_invalid(_("Date cannot be empty"))
        self.refresh_ok(False)
        return False

    def _create_repeated_payments(self):
        start_date = self.model.due_date.date()
        end_date = self.end_date.get_date()
        repeat_type = self.repeat.get_selected()
        if repeat_type == INTERVALTYPE_WEEK:
            delta = relativedelta(weeks=1)
        elif repeat_type == INTERVALTYPE_BIWEEKLY:
            delta = relativedelta(weeks=2)
        elif repeat_type == INTERVALTYPE_MONTH:
            # Check if we're on the last day of month and make
            # sure the payment will always be the last day of the
            # month.
            next_date = start_date + relativedelta(days=1)
            if start_date.month != next_date.month:
                # This really means: last day of month, it'll never
                # cross month boundaries even if there are less than
                # 31 days.
                delta = relativedelta(months=1, day=31)
            else:
                delta = relativedelta(months=1, day=start_date.day)
        elif repeat_type == INTERVALTYPE_QUARTERLY:
            delta = relativedelta(months=3)
        else:
            raise AssertionError(repeat_type)

        next_date = start_date + delta
        dates = []
        while next_date < end_date:
            dates.append(next_date)
            next_date = next_date + delta
        if not dates:
            return
        n_dates = len(dates) + 1
        description = self.model.description
        self.model.description = '1/%d %s' % (n_dates, description)
        for i, date in enumerate(dates):
            p = Payment(open_date=self.model.open_date,
                        status=self.model.status,
                        description='%d/%d %s' % (i + 2, n_dates,
                                                  description),
                        affiliate=self.model.affiliate,
                        value=self.model.value,
                        base_value=self.model.base_value,
                        due_date=date,
                        method=self.model.method,
                        group=self.model.group,
                        till=self.model.till,
                        category=self.model.category,
                        cost_center=self.model.cost_center,
                        connection=self.conn)
            if self.model.is_inpayment():
                p.addFacet(IInPayment, connection=self.conn)
            elif self.model.is_outpayment():
                p.addFacet(IOutPayment, connection=self.conn)

    def _refresh_payment_category(self, person):
        if not person.get_selected():
            return
        categories = PersonCategoryPaymentInfo.get_payments(person.get_selected().person,
                                                            self.conn)
        if categories:
            categories = [(c.name, c) for c in categories]
            self.category.prefill(categories)
        else:
            self._fill_category_combo()

    def on_confirm(self):
        if not self.model.category and sysparam(self.conn).NFCE_SECURE_MODE:
            info('Deve selecionar uma categoria!')
            return False
        return self.model

    #
    # Kiwi Callbacks
    #

    def on_value__validate(self, widget, newvalue):
        appname = get_shell()._appname
        if appname == 'pos':
            till = Till.get_current(self.conn)
            if till:
                if newvalue > till.get_cash_amount():
                    return ValidationError(_("You can not specify an amount "
                                             "removed greater than the "
                                             "till balance."))
        if newvalue is None or newvalue <= 0:
            return ValidationError(_("The value must be greater than zero."))

        

    def on_repeat__content_changed(self, repeat):
        self.end_date.set_sensitive(repeat.get_selected() != INTERVALTYPE_ONCE)
        self._validate_date()

    def on_due_date__content_changed(self, due_date):
        self._validate_date()

    def on_end_date__content_changed(self, end_date):
        self._validate_date()

    def on_category__content_changed(self, category):
        self.edit_category.set_sensitive(bool(self.category.get_selected()))

    def on_cost_center__content_changed(self, cost_center):
        self.edit_cost_center.set_sensitive(bool(self.cost_center.get_selected()))

    def on_person__content_changed(self, person):
        self.edit_person.set_sensitive(bool(self.person.get_selected()))
        self._refresh_payment_category(person)

    def on_category_search__clicked(self, arg):
        category = run_dialog(PaymentCategorySearch, get_current_toplevel(), self.conn)
        if category:
            self.category.select(category)

    def on_add_category__clicked(self, widget):
        self._run_payment_category_editor()

    def on_add_cost_center__clicked(self, widget):
        self._run_cost_center_editor()

    def on_edit_cost_center__clicked(self, widget):
        self._run_cost_center_editor(self.cost_center.get_selected())

    def on_cost_center_search__clicked(self, arg):
        cost_center = run_dialog(PaymentCostCenterSearch, get_current_toplevel(), self.conn)
        if cost_center:
            self.cost_center.select(cost_center)

    def on_edit_category__clicked(self, widget):
        self._run_payment_category_editor(self.category.get_selected())

    def on_add_person__clicked(self, widget):
        self._run_person_editor()

    def on_edit_person__clicked(self, widget):
        self._run_person_editor(self.person.get_selected())

    def _on_details_button__clicked(self, widget):
        self._show_order_dialog()


class InPaymentEditor(PaymentEditor):
    person_attribute = 'payer'
    person_editor = ClientEditor
    person_class = PersonAdaptToClient
    person_iface = IClient
    _person_label = _("Payer:")
    help_section = 'account-receivable'

    def __init__(self, conn, model=None):
        """ This dialog is responsible to create additional payments with
        IInPayment facet.

        @param conn: a database connection
        @param model: a L{stoqlib.domain.payment.payment.Payment} object
                      or None
        """
        PaymentEditor.__init__(self, conn, model)
        if model is None or not model.is_inpayment():
            self.model.addFacet(IInPayment, connection=self.conn)
            self.can_edit_details()
        self.branch_label.hide()
        self.branch.hide()

    def _validate_person(self, person):
        validpn = validate_phone_number(person.phone_number)
        validemail = validate_email(person.email)
        if not validpn or not validemail:
            return False
        return True

    def on_person_search__clicked(self, arg):
        retval = run_dialog(ClientSearch, get_current_toplevel(), self.conn,
                            double_click_confirm=True,
                            hide_toolbar=True,
                            hide_footer=False,
                            selection_mode=gtk.SELECTION_BROWSE)
        client = getattr(retval, 'client', None)
        if client:
            individual = IIndividual(client, None)
            company = ICompany(client, None)
            person = client.person

            if individual is not None and sysparam(self.conn).COMPLETE_REGISTER_INDIVIDUAL:
                if not validate_cpf(individual.cpf):
                    return info('cpf invalido')
                elif not self._validate_person(person):
                    return info('dados incompletos do cliente PF')
            elif company is not None and sysparam(self.conn).COMPLETE_REGISTER_COMPANY:
                if not validate_cnpj(company.cnpj):
                    return info('cnpj invalido')
                elif not self._validate_person(person):
                    return info('dados incompletos do cliente PJ')

            items = [(client.person.name, client)]
            self.person.prefill(items)
            self.person.select(client)

    def on_confirm(self):
        self.model.base_value = self.model.value
        person = self.person.get_selected_data()
        if person is not None and person is not ValueUnset:
            setattr(self.model.group,
                    self.person_attribute,
                    person.person)
        self.model.category = self.category.get_selected()
        method = self.method.get_selected()
        if method is not None:
            self.model.method = method
        if self.repeat.get_selected() != INTERVALTYPE_ONCE:
            self._create_repeated_payments()

        return self.model


class OutPaymentEditor(PaymentEditor):
    person_attribute = 'recipient'
    person_editor = SupplierEditor
    person_class = PersonAdaptToSupplier
    person_iface = ISupplier
    _person_label = _("Recipient:")
    help_section = 'account-payable'

    def __init__(self, conn, model=None):
        """ This dialog is responsible to create additional payments with
        IOutPayment facet.

        @param conn: a database connection
        @param model: a L{stoqlib.domain.payment.payment.Payment} object
                      or None
        """
        PaymentEditor.__init__(self, conn, model)
        if model is None or not model.is_outpayment():
            self.model.addFacet(IOutPayment, connection=self.conn)
            self.can_edit_details()

    def on_person_search__clicked(self, arg):
        retval = run_dialog(SupplierSearch, get_current_toplevel(), self.conn,
                            double_click_confirm=True,
                            hide_toolbar=True,
                            hide_footer=False,
                            selection_mode=gtk.SELECTION_BROWSE
                            )
        supplier = getattr(retval, 'supplier', None)
        if supplier:
            items = [(supplier.person.name, supplier)]
            self.person.prefill(items)
            self.person.select(supplier)

    def on_confirm(self):
        self.model.base_value = self.model.value
        person = self.person.get_selected_data()
        if person is not None and person is not ValueUnset:
            setattr(self.model.group,
                    self.person_attribute,
                    person.person)
        self.model.category = self.category.get_selected()
        method = self.method.get_selected()
        if method is not None:
            self.model.method = method
        if self.repeat.get_selected() != INTERVALTYPE_ONCE:
            self._create_repeated_payments()

        return self.model


class LonelyPaymentDetailsDialog(BaseEditor):
    gladefile = 'LonelyPaymentDetailsDialog'
    model_type = Payment
    size = (550, 350)
    proxy_widgets = ['value',
                     'interest',
                     'paid_value',
                     'penalty',
                     'description',
                     'discount',
                     'due_date',
                     'paid_date',
                     'status']

    def __init__(self, conn, payment):
        BaseEditor.__init__(self, conn, payment)
        self._setup_widgets()

    def _setup_widgets(self):
        self.payment_info_list.set_columns(self._get_columns())
        changes = PaymentChangeHistoryView.select_by_group(self.model.group,
                                                           connection=self.conn)
        self.payment_info_list.add_list(changes)

        # workaround to improve the dialog looking
        if self.model.paid_value:
            penalty = self._get_penalty()
            self.penalty.update(penalty)
            self.interest.update(self.model.interest)
        else:
            self.paid_value.update(currency(0))

    def _get_penalty(self):
        penalty = (self.model.paid_value -
                   (self.model.value - self.model.discount + self.model.interest))

        return currency(penalty)

    def _get_columns(self):
        return [Column('change_date', _("When"),
                       data_type=datetime.date, sorted=True, ),
                Column('description', _("Payment"),
                       data_type=str, expand=True,
                       ellipsize=pango.ELLIPSIZE_END),
                Column('changed_field', _("Changed"),
                       data_type=str, justify=gtk.JUSTIFY_RIGHT),
                Column('from_value', _("From"),
                       data_type=str, justify=gtk.JUSTIFY_RIGHT),
                Column('to_value', _("To"),
                       data_type=str, justify=gtk.JUSTIFY_RIGHT),
                Column('reason', _("Reason"),
                       data_type=str, expand=True,
                       ellipsize=pango.ELLIPSIZE_END)]

    #
    # BaseEditor
    #

    def setup_proxies(self):
        self._proxy = self.add_proxy(
            self.model, LonelyPaymentDetailsDialog.proxy_widgets)

    def get_title(self, model):
        if model is None:
            return

        if model.is_inpayment():
            return _('Receiving Details')

        if model.is_outpayment():
            return _('Payment Details')


def get_dialog_for_payment(payment):
    if payment is None:
        raise TypeError(payment)

    if payment.is_inpayment():
        return InPaymentEditor

    if payment.is_outpayment():
        return OutPaymentEditor

    raise TypeError(payment)


class PaymentCategorySearch(SearchEditor):
    title = _(u"Category Search")
    size = (750, 500)
    search_table = PaymentCategory
    searchbar_result_strings = _(u"name")
    search_by_date = False
    advanced_search = False
    editor_class = PaymentCategoryEditor

    def __init__(self, conn):
        SearchEditor.__init__(self, conn, self.search_table, title=self.title,
                              hide_footer=True, selection_mode=None,
                              double_click_confirm=True, hide_toolbar=False)
        self.enable_ok()

    def create_filters(self):
        self.set_text_field_columns(['name'])
        self.set_searchbar_labels(_('matching:'))

    def get_columns(self):
        return [Column('name', title=_('Category'), data_type=str, expand=True, sorted=True),
                Column('color', title=_('Color'), width=20,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                Column('color', data_type=str, width=120,
                       column='color')]


class PaymentCostCenterSearch(SearchEditor):
    title = _(u"Busca de centro de custo")
    size = (750, 500)
    search_table = PaymentCostCenter
    searchbar_result_strings = _(u"name")
    search_by_date = False
    advanced_search = False
    editor_class = PaymentCostCenterEditor

    def __init__(self, conn):
        SearchEditor.__init__(self, conn, self.search_table, title=self.title,
                              hide_footer=True, selection_mode=None,
                              double_click_confirm=True, hide_toolbar=False)
        self.enable_ok()

    def create_filters(self):
        self.set_text_field_columns(['name'])
        self.set_searchbar_labels(_('matching:'))

    def get_columns(self):
        return [Column('name', title=_('Category'), data_type=str, expand=True, sorted=True),
                Column('color', title=_('Color'), width=20,
                       data_type=gtk.gdk.Pixbuf, format_func=render_pixbuf),
                Column('color', data_type=str, width=120,
                       column='color')]
