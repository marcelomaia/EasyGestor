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
""" Sale quote wizard"""

import datetime
import gtk
from decimal import Decimal

from kiwi.datatypes import currency, ValidationError
from kiwi.decorators import signal_block
from kiwi.python import Settable
from kiwi.ui.dialogs import info
from kiwi.ui.widgets.list import Column
from kiwi.utils import gsignal
from stoqlib.api import api
from stoqlib.database.orm import AND, OR
from stoqlib.domain.fiscal import CfopData
from stoqlib.domain.interfaces import ISalesPerson, IStorable, ITransporter, IIndividual, ICompany
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.payment.operation import register_payment_operations
from stoqlib.domain.person import Person, ClientCategory, PersonAdaptToClient
from stoqlib.domain.product import ProductStockItem
from stoqlib.domain.sale import Sale, SaleItem
from stoqlib.domain.sellable import Sellable
from stoqlib.domain.views import SellableFullStockView
from stoqlib.exceptions import TaxError
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.gtkadds import change_button_appearance
from stoqlib.gui.base.wizards import WizardEditorStep, BaseWizard
from stoqlib.gui.dialogs.clientcategorydialog import ClientCategoryChooser
from stoqlib.gui.dialogs.clientdetails import ClientDetailsDialog
from stoqlib.gui.dialogs.passworddialog import UserPassword
from stoqlib.gui.editors.baseeditor import BaseEditorSlave, BaseEditor
from stoqlib.gui.editors.discounteditor import SaleDiscountEditor
from stoqlib.gui.editors.fiscaleditor import CfopEditor
from stoqlib.gui.editors.nfeeditor import NFeVolumeListEditor
from stoqlib.gui.editors.noteeditor import NoteEditor
from stoqlib.gui.editors.personeditor import ClientEditor, TransporterEditor
from stoqlib.gui.editors.saleeditor import SaleQuoteItemEditor
from stoqlib.gui.search.personsearch import ClientSearch
from stoqlib.gui.stockicons import STOQ_PERCENT
from stoqlib.gui.wizards.abstractwizard import SellableItemStep
from stoqlib.gui.wizards.personwizard import run_person_role_dialog
from stoqlib.lib.formatters import format_quantity
from stoqlib.lib.formatters import get_price_format_str
from stoqlib.lib.message import marker
from stoqlib.lib.message import yesno, warning
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.validators import validate_cpf, validate_cnpj, validate_phone_number, validate_email

_ = stoqlib_gettext


#
# Wizard Steps
#


class StartSaleQuoteStep(WizardEditorStep):
    gladefile = 'SalesPersonStep'
    model_type = Sale
    proxy_widgets = ('client', 'salesperson', 'expire_date',
                     'operation_nature', 'client_category', 'transporter')
    cfop_widgets = ('cfop',)

    def _setup_widgets(self):
        # Hide discount
        self.subtotal_expander.hide()
        # Hide total and subtotal
        self.table1.hide()
        #        self.hbox4.hide()
        # Hide invoice number details
        self.invoice_number_label.hide()
        self.invoice_number.hide()

        # Salesperson combo
        salespersons = Person.iselect(ISalesPerson, connection=self.conn)
        items = [(s.person.name, s) for s in salespersons]
        self.salesperson.prefill(items)
        if not sysparam(self.conn).ACCEPT_CHANGE_SALESPERSON:
            self.salesperson.set_sensitive(False)
        else:
            self.salesperson.grab_focus()

        # CFOP combo
        if sysparam(self.conn).ASK_SALES_CFOP:
            cfops = [(cfop.get_description(), cfop)
                     for cfop in CfopData.select(connection=self.conn)]
            self.cfop.prefill(cfops)
        else:
            self.cfop_lbl.hide()
            self.cfop.hide()
            self.create_cfop.hide()

        self._fill_clients_category_combo()
        self._fill_clients_combo()
        self._fill_transporter_combo()

        # the maximum number allowed for an invoice is 999999999.
        # self.invoice_number.set_adjustment(
        #     gtk.Adjustment(lower=1, upper=999999999, step_incr=1))

        # if not self.model.invoice_number:
        #     new_invoice_number = Sale.get_last_invoice_number(self.conn) + 1
        #     self.model.invoice_number = new_invoice_number
        #     self.invoice_number.update(new_invoice_number)

        # nfe_hist = NFESaleHistory.selectBy(sale=self.model.id, connection=self.conn)
        # nfe_hist_list = [nfe for nfe in nfe_hist]
        # if len(nfe_hist_list) >= 1:
        #     self.invoice_number.set_sensitive(False)

    def _fill_clients_combo(self):
        if self.model.client:
            self.client.prefill([(self.model.client.person.name,
                                  self.model.client)])
            self.client.select(self.model.client)
            # clients = ClientView.get_active_clients(self.conn)
            # items = [(c.get_description(), c.client) for c in clients]
            # self.client.prefill(items)

    def _fill_transporter_combo(self):
        marker('Filling transporters')
        table = Person.getAdapterClass(ITransporter)
        transporters = table.get_active_transporters(self.conn)
        items = [(t.person.name, t) for t in transporters]
        self.transporter.prefill(items)
        self.transporter.set_sensitive(len(items))
        marker('Filled transporters')

    def _fill_clients_category_combo(self):
        cats = ClientCategory.select(connection=self.conn).orderBy('name')
        items = [(c.get_description(), c) for c in cats]
        items.insert(0, ['', None])
        self.client_category.prefill(items)

    def post_init(self):
        self.toogle_client_details()
        self.register_validate_function(self.wizard.refresh_next)
        self.force_validation()

    def next_step(self):
        return SaleQuoteItemStep(self.wizard, self, self.conn, self.model)

    def has_previous_step(self):
        return False

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model,
                                    StartSaleQuoteStep.proxy_widgets)
        if sysparam(self.conn).ASK_SALES_CFOP:
            self.add_proxy(self.model, StartSaleQuoteStep.cfop_widgets)

    def toogle_client_details(self):
        client = self.client.read()
        self.client_details.set_sensitive(bool(client))

    #
    #   Callbacks
    #

    def on_create_client__clicked(self, button):
        trans = api.new_transaction()
        client = run_person_role_dialog(ClientEditor, self.wizard, trans, None)
        retval = api.finish_transaction(trans, client)
        client = self.conn.get(client)
        trans.close()
        if not retval:
            return
        if client:
            self.client.prefill([(client.person.name,
                                  client)])
            self.client.select(client)

    def on_create_transporter__clicked(self, button):
        trans = api.new_transaction()
        transporter = trans.get(self.model.transporter)
        model = run_person_role_dialog(TransporterEditor, self.wizard, trans,
                                       transporter)
        rv = api.finish_transaction(trans, model)
        trans.close()
        if rv:
            self._fill_transporter_combo()
            self.transporter.select(model)

    def on_client__changed(self, widget):
        self.toogle_client_details()
        client = self.client.get_selected()
        if not client:
            return
        self.client_category.select(client.category)

    def _validate_person(self, person):
        validpn =validate_phone_number(person.phone_number)
        validemail = validate_email(person.email)
        if not validpn or not validemail:
            return False
        return True

    def on_client_search__clicked(self, widget):
        retval = run_dialog(ClientSearch, self.wizard, self.conn,
                            double_click_confirm=True,
                            hide_toolbar=True,
                            hide_footer=False,
                            selection_mode=gtk.SELECTION_BROWSE)
        self.model.client = getattr(retval, 'client', None)
        if self.model.client.status != PersonAdaptToClient.STATUS_SOLVENT:
            if not run_dialog(UserPassword, self, self.conn):
                return

        individual = IIndividual(self.model.client, None)
        company = ICompany(self.model.client, None)
        person = self.model.client.person

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

        if self.model.client:
            self.client.prefill([(self.model.client.person.name,
                                  self.model.client)])
            self.client.select(self.model.client)

    def on_client_details__clicked(self, button):
        client = self.model.client
        run_dialog(ClientDetailsDialog, self.wizard, self.conn, client)

    def on_expire_date__validate(self, widget, value):
        if value < datetime.date.today():
            msg = _(u"The expire date must be set to today or a future date.")
            return ValidationError(msg)

    def on_notes_button__clicked(self, *args):
        run_dialog(NoteEditor, self.wizard, self.conn, self.model, 'notes',
                   title=_("Additional Information"))

    def on_create_cfop__clicked(self, widget):
        cfop = run_dialog(CfopEditor, self.wizard, self.conn, None)
        if cfop:
            self.cfop.append_item(cfop.get_description(), cfop)
            self.cfop.select_item_by_data(cfop)


class SaleQuoteItemStep(SellableItemStep):
    """ Wizard step for purchase order's items selection """
    model_type = Sale
    item_table = SaleItem
    summary_label_text = "<b>%s</b>" % _('Total Ordered:')
    sellable = None
    sellable_view = SellableFullStockView

    def get_sellable_view_query(self):
        branch = api.get_current_branch(self.conn)
        branch_query = OR(ProductStockItem.q.branchID == branch.id,
                          ProductStockItem.q.branchID == None)
        return AND(branch_query,
                   Sellable.get_available_sellables_for_quote_query(self.conn))

    def setup_slaves(self):
        SellableItemStep.setup_slaves(self)
        self.hide_add_button()
        self.xml_button.hide()
        self.xml_label.hide()
        self.cost_label.set_label('Preço:')
        if not sysparam(self.conn).CAN_CHANGE_PRICE_IN_QUOTE:
            self.cost.set_editable(False)
        else:
            self.cost.set_editable(True)
        self.discount_btn = self.slave.add_extra_button(label=_("Apply discount"))
        self.discount_btn.connect('clicked', self.on_discount_btn_clicked)
        self.cfop_btn = self.slave.add_extra_button(label="Trocar CFOPs")
        self.cfop_btn.connect('clicked', self.on_cfop_btn_clicked)
        change_button_appearance(self.cfop_btn, gtk.STOCK_ABOUT, text="Trocar CFOPs")
        change_button_appearance(self.discount_btn, STOQ_PERCENT, text=_("Apply discount"))
        self.slave.klist.connect('has-rows', self._on_klist__has_rows)
        manager = get_plugin_manager()
        if not manager.is_active('nfe2'):
            self.cfop_btn.hide()

    def _update_summary_label(self, discount):
        column = self.summary._column
        attr = column.attribute
        get_attribute = column.get_attribute

        value = sum([get_attribute(obj, attr, 0) or 0 for obj in self.summary._klist],
                    column.data_type('0'))

        self.summary.set_value(column.as_string(value - discount))

    def _on_klist__has_rows(self, klist, has_rows):
        self.discount_btn.set_sensitive(has_rows)
        self.cfop_btn.set_sensitive(has_rows)

    #
    # SellableItemStep virtual methods
    #

    def _update_total(self):
        SellableItemStep._update_total(self)
        quantities = {}
        missing = {}
        lead_time = 0
        for i in self.slave.klist:
            sellable = i.sellable
            if sellable.service:
                continue

            quantities.setdefault(sellable, 0)
            quantities[sellable] += i.quantity
            if quantities[sellable] > i._stock_quantity:
                _lead_time = sellable.product.get_max_lead_time(
                    quantities[sellable], self.model.branch)
                max_lead_time = max(lead_time, _lead_time)
                missing[sellable] = Settable(
                    description=sellable.get_description(),
                    stock=i._stock_quantity,
                    ordered=quantities[sellable],
                    lead_time=_lead_time,
                )
        self.missing = missing

        if missing:
            msg = _('Not enough stock. '
                    'Estimated time to obtain missing items: %d days.') % max_lead_time
            self.slave.set_message('<b>%s</b>' % msg, self._show_missing_details)
        else:
            self.slave.clear_message()

    def get_order_item(self, sellable, price, quantity):
        price = self.cost.read()
        retval = self._validate_sellable_price(price)
        if sysparam(self.conn).CATEGORY_PRICE:
            client_category = run_dialog(ClientCategoryChooser, get_current_toplevel(), self.conn, None)
            if client_category:
                price = sellable.get_price_for_category(client_category)
        if retval is None:
            item = self.model.add_sellable(sellable, quantity, price)
            # Save temporarily the stock quantity and lead_time so we can show a
            # warning if there is not enough quantity for the sale.
            item._stock_quantity = self.proxy.model.stock_quantity
            return item

    def get_saved_items(self):
        items = self.model.get_items()
        for i in items:
            product = i.sellable.product
            if not product:
                continue
            storable = IStorable(product, None)
            if not storable:
                continue
            stock = storable.get_full_balance(self.model.branch)
            i._stock_quantity = stock

        return list(items)

    def get_columns(self):
        columns = [
            Column('sellable.description', title=_('Description'),
                   data_type=str, expand=True, searchable=True),
            Column('sellable.category_description', title=_('Category'),
                   data_type=str, expand=True, searchable=True),
            Column('quantity', title=_('Quantity'), data_type=float, width=60,
                   format_func=format_quantity),
            Column('sellable.unit_description', title=_('Unit'), data_type=str,
                   width=40)]

        if sysparam(self.conn).SHOW_COST_COLUMN_IN_SALES:
            columns.append(Column('sellable.cost', title=_('Cost'), data_type=currency,
                                  width=80))

        columns.extend([
            Column('price', title=_('Price'), data_type=currency, width=80),
            Column('nfe_cfop_code', title=_('CFOP'), data_type=str, width=40),
            Column('icms_info.v_bc', title=_('ICMS BC '), data_type=currency, width=70),
            Column('icms_info.v_icms', title=_('ICMS'), data_type=currency, width=70),
            Column('ipi_info.v_ipi', title=_('IPI'), data_type=currency, width=70),
            Column('total', title=_('Total'), data_type=currency, width=90),
        ])

        return columns

    def sellable_selected(self, sellable):
        SellableItemStep.sellable_selected(self, sellable)
        if sellable:
            price = sellable.get_price_for_category(
                self.model.client_category)
            self.cost.set_text("%s" % price)
            self.proxy.update('cost')

    #
    #  SellableWizardStep Hooks
    #

    def can_add_sellable(self, sellable):
        retval = True
        try:
            sellable.check_taxes_validity()
        except TaxError as strerr:
            # If the sellable icms taxes are not valid, we cannot sell it.
            warning(strerr)
            retval = False

        is_service = sellable.service is not None

        has_icms_template = sellable.product and sellable.product.icms_template
        manager = get_plugin_manager()
        nfe2_active = manager.is_active('nfe2')
        if nfe2_active and not has_icms_template and not is_service:
            warning("Você não pode vender este item antes de ter ICMS vinculado ao produto. "
                    "Se você não faz ideia do que isto significa, contacte o administrador do sistema.")
            retval = False

        return retval

    def sellable_selected(self, sellable):
        """This will be called when a sellable is selected in the combo.
        It can be overriden in a subclass if they wish to do additional
        logic at that point
        @param sellable: the selected sellable
        """

        minimum = Decimal(0)
        stock = Decimal(0)
        cost = currency(0)
        quantity = Decimal(0)
        description = u''

        if sellable:
            description = "<b>%s</b>" % sellable.get_description()
            cost = sellable.base_price
            quantity = Decimal(1)
            storable = IStorable(sellable.product, None)
            if storable:
                minimum = storable.minimum_quantity
                stock = storable.get_full_balance(self.model.branch)
        else:
            self.barcode.set_text('')

        model = Settable(quantity=quantity,
                         cost=cost,
                         sellable=sellable,
                         minimum_quantity=minimum,
                         stock_quantity=stock,
                         sellable_description=description)

        self.proxy.set_model(model)

        has_sellable = bool(sellable)
        self.add_sellable_button.set_sensitive(has_sellable)
        self.quantity.set_sensitive(has_sellable)
        if not sysparam(self.conn).CAN_CHANGE_PRICE_IN_QUOTE:
            self.cost.set_sensitive(False)
        else:
            self.cost.set_sensitive(has_sellable)

    #
    # WizardStep hooks
    #

    def post_init(self):
        SellableItemStep.post_init(self)
        self.slave.set_editor(SaleQuoteItemEditor)
        self._refresh_next()

    def has_next_step(self):
        return False

    #
    # Private API
    #

    def _show_missing_details(self, button):
        from stoqlib.gui.base.lists import SimpleListDialog
        columns = [Column('description', title=_(u'Product'),
                          data_type=str, expand=True),
                   Column('ordered', title=_(u'Ordered'),
                          data_type=int),
                   Column('stock', title=_(u'Stock'),
                          data_type=int),
                   Column('lead_time', title=_(u'Lead Time'),
                          data_type=int),
                   ]

        class MyList(SimpleListDialog):
            size = (500, 200)

        run_dialog(MyList, get_current_toplevel(), columns, self.missing.values(),
                   title=_("Missing products"))

    def _validate_sellable_price(self, price):
        s = self.proxy.model.sellable
        category = self.model.client_category
        if not s.is_valid_price(price, category):
            info = None
            if category:
                info = s.get_category_price_info(category)
            if not info:
                info = s
            return ValidationError(_(u'Max discount for this product is %.2f%%') % info.max_discount)

    #
    # Callbacks
    #

    def on_discount_btn_clicked(self, button):
        rv = run_dialog(SaleDiscountEditor, get_current_toplevel(), self.conn, self.model, Sale)
        if not rv:
            return
        self._update_summary_label(self.model.discount_value)

    def on_cfop_btn_clicked(self, button):
        rv = run_dialog(CFOPChooser, get_current_toplevel(), self.conn)
        if isinstance(rv, Settable) and getattr(rv, 'combo', None) is not None:
            cfop = rv.combo
            for sale_item in self.slave.klist:
                sale_item.cfop = cfop
            self._update_total()
        return rv

    def on_cost__validate(self, widget, value):
        if not self.proxy.model.sellable:
            return

        if value <= Decimal(0):
            return ValidationError(_(u"The price must be greater than zero."))
        return self._validate_sellable_price(value)


class CFOPChooser(BaseEditor):
    gladefile = 'ComboDataChooser'
    model_type = Settable
    title = 'Mudar CFOP em lote'
    proxy_widgets = ['combo']

    def __init__(self, conn):
        super(CFOPChooser, self).__init__(conn)
        self.setup_widgets()

    def create_model(self, trans):
        return Settable(combo=None)

    def setup_widgets(self):
        cfops = [(cfop.get_description(), cfop)
                 for cfop in CfopData.select(connection=self.conn)]
        self.combo.prefill(cfops)
        self.combo_label.set_text('CFOP: ')

    def setup_proxies(self):
        self.add_proxy(self.model, self.proxy_widgets)


#
# Main wizard
#


class SaleQuoteWizard(BaseWizard):
    size = (775, 400)
    help_section = 'sale-quote'

    def __init__(self, conn, model=None):
        title = self._get_title(model)
        model = model or self._create_model(conn)

        if model.status not in [Sale.STATUS_QUOTE, Sale.STATUS_ORDERED]:
            raise ValueError('Invalid sale status. It should '
                             'be STATUS_QUOTE or STATUS_ORDERED')

        register_payment_operations()
        first_step = StartSaleQuoteStep(conn, self, model)
        BaseWizard.__init__(self, conn, first_step, model, title=title,
                            edit_mode=False)

    def _get_title(self, model=None):
        if not model:
            return _('New Sale Quote')
        if model.daily_code:
            return _('Venda de N°%s do dia %s' % (model.daily_code,
                                                  model.open_date.strftime('%d/%m/%Y')))
        return _('Edit Sale Quote')

    def _create_model(self, conn):
        user = api.get_current_user(conn)
        salesperson = ISalesPerson(user.person)

        return Sale(coupon_id=None,
                    status=Sale.STATUS_QUOTE,
                    salesperson=salesperson,
                    branch=api.get_current_branch(conn),
                    daily_code=Sale.get_last_daily_code(conn),
                    group=PaymentGroup(connection=conn),
                    cfop=sysparam(conn).DEFAULT_SALES_CFOP,
                    operation_nature=sysparam(conn).DEFAULT_OPERATION_NATURE,
                    connection=conn)

    def _edit_nfe_volume(self, sale):
        if yesno(_('Você gostaria de editar detalhes de volume da venda?'),
                 gtk.RESPONSE_YES, _("Sim, por favor!"), _("Não, obrigado!")):
            run_dialog(NFeVolumeListEditor, get_current_toplevel(), self.conn, self.model.id)

    #
    # WizardStep hooks
    #

    def finish(self):
        self.retval = self.model
        self.close()
        # calling SaleStatusChangedEvent
        #        SaleStatusChangedEvent.emit(sale)
        manager = get_plugin_manager()
        if manager.is_active('nfe2'):
            self._edit_nfe_volume(self.model)


class SaleDiscountSlave(BaseEditorSlave):
    """A slave for discounts management
    """
    gladefile = 'SaleDiscountSlave'
    proxy_widgets = ('discount_value',
                     'discount_perc',)
    gsignal('discount-changed')

    def __init__(self, conn, model, model_type, visual_mode=False):
        self._proxy = None
        self.model_type = model_type
        self.max_discount = sysparam(conn).MAX_SALE_DISCOUNT
        BaseEditorSlave.__init__(self, conn, model, visual_mode=visual_mode)

    def setup_widgets(self):
        format_str = get_price_format_str()
        self.discount_perc.set_data_format(format_str)
        self.update_widget_status()

    def update_widget_status(self):
        discount_by_value = not self.discount_perc_ck.get_active()
        self.discount_value.set_sensitive(discount_by_value)
        self.discount_perc.set_sensitive(not discount_by_value)

    def update_sale_discount(self):
        if self._proxy is None:
            return
        if self.discount_perc_ck.get_active():
            self._proxy.update('discount_value')
        else:
            self._proxy.update('discount_percentage')

        self.emit('discount-changed')

    def _validate_percentage(self, value, type_text):
        if value >= 100:
            self.model.discount_percentage = 0
            return ValidationError(_(u'%s can not be greater or equal '
                                     'to 100%%.') % type_text)
        if value > self.max_discount:
            self.model.discount_percentage = 0
            return ValidationError(_("%s can not be greater then %d%%")
                                   % (type_text, self.max_discount))
        if value < 0:
            self.model.discount_percentage = 0
            return ValidationError(_("%s can not be less then 0")
                                   % type_text)
        self.update_sale_discount()

    def set_max_discount(self, discount):
        """Set the maximum percentage value for a discount.
        @param discount: the value for a discount.
        @type discount: L{int} in absolute value like 3
        """
        self.max_discount = discount

    #
    # BaseEditorSlave hooks
    #

    def setup_proxies(self):
        self.update_widget_status()
        self._proxy = self.add_proxy(self.model,
                                     SaleDiscountSlave.proxy_widgets)

    #
    # Kiwi callbacks
    #

    def on_discount_perc__validate(self, entry, value):
        return self._validate_percentage(value, _('Discount'))

    def on_discount_value__validate(self, entry, value):
        if self.model.get_total_sale_amount() == 0:
            return
        percentage = value * 100 / self.model.get_total_sale_amount()
        return self._validate_percentage(percentage, _(u'Discount'))

    @signal_block('discount_value.changed')
    def after_discount_perc__changed(self, *args):
        self.update_sale_discount()

    @signal_block('discount_perc.changed')
    def after_discount_value__changed(self, *args):
        self.update_sale_discount()

    def on_discount_value_ck__toggled(self, *args):
        self.update_widget_status()
