# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2005-2011 Async Open Source <http://www.async.com.br>
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
""" Main interface definition for pos application.  """

import gettext
from decimal import Decimal

import pango
import gtk
from kiwi.datatypes import currency, converter
from kiwi.argcheck import argcheck
from kiwi.datatypes import ValidationError
from kiwi.environ import environ
from kiwi.log import Logger
from kiwi.python import Settable
from kiwi.ui.widgets.list import Column
from kiwi.ui.widgets.contextmenu import ContextMenu, ContextMenuItem
from stoq.gui.tab import NoteEditor2
from stoqdrivers.enum import UnitType
from stoqlib.api import api
from stoqlib.domain.interfaces import IDelivery, ISalesPerson, ICompany
from stoqlib.domain.devices import DeviceSettings
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.product import IStorable
from stoqlib.domain.sale import Sale, DeliveryItem
from stoqlib.domain.sellable import Sellable
from stoqlib.domain.till import Till
from stoqlib.drivers.scale import read_scale_info
from stoqlib.exceptions import StoqlibError, TaxError
from stoqlib.gui.editors.tilleditor import TillClosingEditor
from stoqlib.lib.barcode import parse_barcode, BarcodeInfo
from stoqlib.lib.defaults import quantize
from stoqlib.lib.message import warning, info, yesno, marker
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.gui.base.dialogs import push_fullscreen, pop_fullscreen, run_dialog
from stoqlib.gui.base.gtkadds import button_set_image_with_label
from stoqlib.gui.editors.deliveryeditor import DeliveryEditor
from stoqlib.gui.editors.serviceeditor import ServiceItemEditor
from stoqlib.gui.fiscalprinter import FiscalPrinterHelper, CLOSE_TILL_DB, CLOSE_TILL_ECF, CLOSE_TILL_BOTH, CLOSE_TILL_NONE, FiscalCoupon
from stoqlib.gui.keybindings import get_accels
from stoqlib.gui.search.personsearch import ClientSearch
from stoqlib.gui.search.productsearch import ProductSearch
from stoqlib.gui.search.salesearch import (SaleSearch, DeliverySearch,
                                           SoldItemsByBranchSearch)
from stoqlib.gui.search.sellablesearch import SellableSearch
from stoqlib.gui.search.servicesearch import ServiceSearch

from stoq.gui.application import AppWindow

_ = gettext.gettext
log = Logger('stoq.pos')


class _SaleItem(object):
    def __init__(self, sellable, quantity, price=None, notes=None):
        # Use only 3 decimal places for the quantity
        self.quantity = Decimal('%.3f' % quantity)
        self.sellable = sellable
        self.description = sellable.description
        self.unit = sellable.get_unit_description()
        self.code = sellable.code

        if not price:
            price = sellable.price
        self.price = price
        self.deliver = False
        self.estimated_fix_date = None
        self.notes = notes

    @property
    def total(self):
        # Sale items are suposed to have only 2 digits, but the value price
        # * quantity may have more than 2, so we need to round it.
        return quantize(currency(self.price * self.quantity))

    @property
    def quantity_unit(self):
        qtd_string = ''
        if (self.quantity * 100 % 100) == 0:
            qtd_string = '%.0f' % self.quantity
        else:
            qtd_string = '%s' % self.quantity.normalize()

        return '%s %s' % (qtd_string, self.unit)


LOGO_WIDTH = 91
LOGO_HEIGHT = 32


class TabposApp(AppWindow):

    app_name = _('Point of Sales')
    gladefile = "pos"
    embedded = True

    def __init__(self, app):
        AppWindow.__init__(self, app)
        self._delivery = None
        self.param = api.sysparam(self.conn)
        self.max_results = self.param.MAX_SEARCH_RESULTS
        self._coupon = None
        # Cant use self._coupon to verify if there is a sale, since
        # CONFIRM_SALES_ON_TILL doesnt create a coupon
        self._sale_started = False
        self._scale_settings = DeviceSettings.get_scale_settings(self.conn)
    #
    # Application
    #

    def create_actions(self):
        group = get_accels('app.pos')
        actions = [
            # File
            ("TillOpen", None, _("Open Till..."),
             group.get('till_open')),
            ("TillClose", None, _("Close Till..."),
             group.get('till_close')),

            # Order
            ("OrderMenu", None, _("Order")),
            ('ConfirmOrder', None, _('Confirm...'),
             group.get('order_confirm')),
            ('CancelOrder', None, _('Cancel...'),
             group.get('order_cancel')),
            ('NewDelivery', None, _('Create delivery...'),
             group.get('order_create_delivery')),

            # Search
            ("Sales", None, _("Sales..."),
             group.get('search_sales')),
            ("SoldItemsByBranchSearch", None, _("Sold Items by Branch..."),
             group.get('search_sold_items')),
            ("Clients", None, _("Clients..."),
             group.get('search_clients')),
            ("ProductSearch", None, _("Products..."),
             group.get('search_products')),
            ("ServiceSearch", None, _("Services..."),
             group.get('search_services')),
            ("DeliverySearch", None, _("Deliveries..."),
             group.get('search_deliveries')),
        ]
        self.pos_ui = self.add_ui_actions('', actions,
                                          filename='pos.xml')
        self.set_help_section(_("POS help"), 'app-pos')

    def create_ui(self):
        self.sale_items.set_columns(self.get_columns())
        self.sale_items.set_selection_mode(gtk.SELECTION_BROWSE)
        # Setting up the widget groups
        self.main_vbox.set_focus_chain([self.pos_vbox])

        self.pos_vbox.set_focus_chain([self.list_header_hbox, self.list_vbox])
        self.list_vbox.set_focus_chain([self.footer_hbox])
        self.footer_hbox.set_focus_chain([self.toolbar_vbox])

        # Setting up the toolbar area
        self.toolbar_vbox.set_focus_chain([self.toolbar_button_box])
        self.toolbar_button_box.set_focus_chain([self.checkout_button,
                                                 self.delivery_button,
                                                 self.edit_item_button,
                                                 self.remove_item_button])

        # Setting up the barcode area
        self.item_hbox.set_focus_chain([self.barcode, self.quantity,
                                        self.item_button_box])
        self.item_button_box.set_focus_chain([self.add_button,
                                              self.advanced_search])
        self._setup_printer()
        self._setup_widgets()
        self._setup_proxies()
        self._clear_order()

    def activate(self, params):
        # Admin app doesn't have anything to print/export
        for widget in (self.app.launcher.Print, self.app.launcher.ExportCSV):
            widget.set_visible(False)

        # Hide toolbar specially for pos
        self.uimanager.get_widget('/toolbar').hide()
        self.uimanager.get_widget('/menubar/ViewMenu/ToggleToolbar').hide()

        self.check_open_inventory()
        self._update_parameter_widgets()
        self._update_widgets()
        # This is important to do after the other calls, since
        # it emits signals that disable UI which might otherwise
        # be enabled.
        self._printer.check_till()

    def deactivate(self):
        self.uimanager.remove_ui(self.pos_ui)

        # Re enable toolbar
        self.uimanager.get_widget('/toolbar').show()
        self.uimanager.get_widget('/menubar/ViewMenu/ToggleToolbar').show()

    def setup_focus(self):
        self.barcode.grab_focus()

    def can_change_application(self):
        # Block POS application if we are in the middle of a sale.
        can_change_application = not self._sale_started
        if not can_change_application:
            if yesno(_('You must finish the current sale before you change to '
                       'another application.'),
                     gtk.RESPONSE_NO, _("Cancel sale"), _("Finish sale")):
                self._cancel_order(show_confirmation=False)
                return True

        return can_change_application

    def can_close_application(self):
        can_close_application = not self._sale_started
        if not can_close_application:
            if yesno(_('You must finish or cancel the current sale before you '
                       'can close the POS application.'),
                     gtk.RESPONSE_NO, _("Cancel sale"), _("Finish sale")):
                self._cancel_order(show_confirmation=False)
                return True
        return can_close_application

    def get_columns(self):
        return [Column('code', title=_('Reference'),
                       data_type=str, width=130, justify=gtk.JUSTIFY_RIGHT),
                Column('description',
                       title=_('Description'), data_type=str, expand=True,
                       searchable=True, ellipsize=pango.ELLIPSIZE_END),
                Column('price', title=_('Price'), data_type=currency,
                       width=110, justify=gtk.JUSTIFY_RIGHT),
                Column('quantity_unit', title=_('Quantity'), data_type=unicode,
                       width=110, justify=gtk.JUSTIFY_RIGHT),
                Column('total', title=_('Total'), data_type=currency,
                       justify=gtk.JUSTIFY_RIGHT, width=100)]

    def set_open_inventory(self):
        self.set_sensitive(self._inventory_widgets, False)

    #
    # Private
    #

    def _setup_printer(self):
        self._printer = FpHelper(self.conn,                         # WARNING, here we rewrote the class to ignore
                                 parent=self)                       # Events that interact with FiscalPrinter, EBI 2013
        self._printer.connect('till-status-changed',
                              self._on_PrinterHelper__till_status_changed)
        self._printer.connect('ecf-changed',
                              self._on_PrinterHelper__ecf_changed)
        self._printer.setup_midnight_check()

    def _set_product_on_sale(self):
        sellable = self._get_sellable()
        # If the sellable has a weight unit specified and we have a scale
        # configured for this station, go and check out what the printer says.
        if (sellable and sellable.unit and
            sellable.unit.unit_index == UnitType.WEIGHT and
            self._scale_settings):
            self._read_scale()

    def _setup_proxies(self):
        self.sellableitem_proxy = self.add_proxy(
            Settable(quantity=Decimal(1)), ['quantity'])

    def _update_parameter_widgets(self):
        self.delivery_button.props.visible = self.param.HAS_DELIVERY_MODE

        window = self.get_toplevel()
        if self.param.POS_FULL_SCREEN:
            window.fullscreen()
            push_fullscreen(window)
        else:
            pop_fullscreen(window)
            window.unfullscreen()

        for widget in (self.TillOpen, self.TillClose):
            widget.set_visible(not self.param.POS_SEPARATE_CASHIER)

        if self.param.CONFIRM_SALES_ON_TILL:
            confirm_label = _("_Close")
        else:
            confirm_label = _("_Checkout")
        button_set_image_with_label(self.checkout_button,
                                    gtk.STOCK_APPLY, confirm_label)

    def _setup_widgets(self):
        self._inventory_widgets = [self.Sales, self.barcode, self.quantity,
                                   self.sale_items, self.advanced_search,
                                   self.checkout_button]
        self.register_sensitive_group(self._inventory_widgets,
                                      lambda: not self.has_open_inventory())

        logo_file = environ.find_resource('pixmaps', 'tabpos_logo.png')
        logo = gtk.gdk.pixbuf_new_from_file_at_size(logo_file, LOGO_WIDTH,
                                                    LOGO_HEIGHT)
        self.stoq_logo.set_from_pixbuf(logo)

        self.till_status_label.set_size('xx-large')
        self.till_status_label.set_bold(True)

        self.order_total_label.set_size('xx-large')
        self.order_total_label.set_bold(True)
        self._create_context_menu()

        self.quantity.set_digits(3)

        if not api.sysparam(self.conn).EMPLOYERS_CAN_REMOVE_ITEMS:
            self.remove_item_button.hide()

    def _create_context_menu(self):
        menu = ContextMenu()

        item = ContextMenuItem(_('Notes'))
        item.connect('activate', self._on_context_notes__activate)
        menu.append(item)

        item = ContextMenuItem(gtk.STOCK_REMOVE)
        item.connect('activate', self._on_context_remove__activate)
        item.connect('can-disable', self._on_context_remove__can_disable)
        menu.append(item)

        self.sale_items.set_context_menu(menu)
        menu.show_all()

    def _update_totals(self):
        subtotal = currency(sum([item.total for item in self.sale_items]))
        text = _(u"Total: %s") % converter.as_string(currency, subtotal)
        self.order_total_label.set_text(text)

    def _update_added_item(self, sale_item, new_item=True):
        """Insert or update a klist item according with the new_item
        argument
        """
        if new_item:
            if self._coupon_add_item(sale_item) == -1:
                return
            self.sale_items.append(sale_item)
        else:
            self.sale_items.update(sale_item)
        self.sale_items.select(sale_item)
        self.barcode.set_text('')
        self.barcode.grab_focus()
        self._reset_quantity_proxy()
        self._update_totals()

    @argcheck(Sellable, bool)
    def _update_list(self, sellable, notify_on_entry=False):
        try:
            sellable.check_taxes_validity()
        except TaxError as strerr:
            # If the sellable icms taxes are not valid, we cannot sell it.
            warning(strerr)
            return

        quantity = self.sellableitem_proxy.model.quantity

        is_service = sellable.service
        if is_service and quantity > 1:
            # It's not a common operation to add more than one item at
            # a time, it's also problematic since you'd have to show
            # one dialog per service item. See #3092
            info(_("It's not possible to add more than one service "
                   "at a time to an order. So, only one was added."))

        sale_item = _SaleItem(sellable=sellable,
                              quantity=quantity)
        if is_service:
            rv = self.run_dialog(ServiceItemEditor, self.conn, sale_item)
            if not rv:
                return
        self._update_added_item(sale_item)

    def _get_sellable(self):
        barcode = self.barcode.get_text()
        if not barcode:
            raise StoqlibError("_get_sellable needs a barcode")

        fmt = api.sysparam(self.conn).SCALE_BARCODE_FORMAT

        # Check if this barcode is from a scale
        info = parse_barcode(barcode, fmt)
        if info:
            barcode = info.code
            weight = info.weight

        sellable = Sellable.selectOneBy(barcode=barcode,
                                        status=Sellable.STATUS_AVAILABLE,
                                        connection=self.conn)

        # If the barcode has the price information, we need to calculate the
        # corresponding weight.
        if info and sellable and info.mode == BarcodeInfo.MODE_PRICE:
            weight = info.price / sellable.price

        if info and sellable:
            self.quantity.set_value(weight)

        return sellable

    def _select_first_item(self):
        if len(self.sale_items):
            # XXX Probably kiwi should handle this for us. Waiting for
            # support
            self.sale_items.select(self.sale_items[0])

    def _set_sale_sensitive(self, value):
        # Enable/disable the part of the ui that is used for sales,
        # usually manipulated when printer information changes.
        widgets = [self.barcode, self.quantity, self.sale_items,
                   self.advanced_search]
        self.set_sensitive(widgets, value)

        if value:
            self.barcode.grab_focus()

    def _disable_printer_ui(self):
        self._set_sale_sensitive(False)

        # It's possible to do a Sangria from the Sale search,
        # disable it for now
        widgets = [self.TillOpen, self.TillClose, self.Sales]
        self.set_sensitive(widgets, False)

        text = _(u"POS operations requires a connected fiscal printer.")
        self.till_status_label.set_text(text)

    def _till_status_changed(self, closed, blocked):
        if closed:
            text = _(u"Till closed")
        elif blocked:
            text = _(u"Till blocked")
        else:
            text = _(u"Till open")
        self.till_status_label.set_text(text)

        self.set_sensitive([self.TillOpen], closed)
        self.set_sensitive([self.TillClose], not closed or blocked)

        self._set_sale_sensitive(not closed and not blocked)

    def _update_widgets(self):
        has_sale_items = len(self.sale_items) >= 1
        self.set_sensitive((self.checkout_button, self.remove_item_button,
                            self.NewDelivery,
                            self.ConfirmOrder), has_sale_items)
        # We can cancel an order whenever we have a coupon opened.
        self.set_sensitive([self.CancelOrder], self._sale_started)
        has_products = False
        has_services = False
        for sale_item in self.sale_items:
            if sale_item and sale_item.sellable.product:
                has_products = True
            if sale_item and sale_item.sellable.service:
                has_services = True
            if has_products and has_services:
                break
        self.set_sensitive([self.delivery_button], has_products)
        self.set_sensitive([self.NewDelivery], has_sale_items)
        sale_item = self.sale_items.get_selected()
        can_edit = bool(
            sale_item is not None and
            sale_item.sellable.service and
            sale_item.sellable.service != self.param.DELIVERY_SERVICE)
        self.set_sensitive([self.edit_item_button], can_edit)

        self.set_sensitive((self.checkout_button,
                            self.ConfirmOrder), has_products or has_services)
        self.till_status_box.props.visible = not self._sale_started
        self.sale_items.props.visible = self._sale_started

        self._update_totals()
        self._update_buttons()

    def _has_barcode_str(self):
        return self.barcode.get_text().strip() != ''

    def _update_buttons(self):
        has_barcode = self._has_barcode_str()
        has_quantity = self._read_quantity() > 0
        self.set_sensitive([self.add_button], has_barcode and has_quantity)
        self.set_sensitive([self.advanced_search], has_quantity)

    def _read_quantity(self):
        try:
            quantity = self.quantity.read()
        except ValidationError:
            quantity = 0

        return quantity

    def _read_scale(self, sellable):
        data = read_scale_info(self.conn)
        self.quantity.set_value(data.weight)

    def _run_advanced_search(self, search_str=None, message=None):
        sellable_view_item = self.run_dialog(
            SellableSearch,
            self.conn,
            selection_mode=gtk.SELECTION_BROWSE,
            search_str=search_str,
            sale_items=self.sale_items,
            quantity=self.sellableitem_proxy.model.quantity,
            double_click_confirm=True,
            info_message=message)
        if not sellable_view_item:
            self.barcode.grab_focus()
            return

        sellable = Sellable.get(sellable_view_item.id, connection=self.conn)
        self._update_list(sellable)
        self.barcode.grab_focus()

    def _reset_quantity_proxy(self):
        self.sellableitem_proxy.model.quantity = Decimal(1)
        self.sellableitem_proxy.update('quantity')
        self.sellableitem_proxy.model.price = None

    def _get_deliverable_items(self):
        """Returns a list of sale items which can be delivered"""
        return [item for item in self.sale_items
                        if item.sellable.product is not None]

    def _check_delivery_removed(self, sale_item):
        # If a delivery was removed, we need to remove all
        # the references to it eg self._delivery
        if sale_item.sellable == self.param.DELIVERY_SERVICE.sellable:
            self._delivery = None

    #
    # Sale Order operations
    #

    def _add_sale_item(self, search_str=None):
        quantity = self._read_quantity()
        if quantity == 0:
            return

        sellable = self._get_sellable()
        if not sellable:
            message = (_("The barcode '%s' does not exist. "
                         "Searching for a product instead...")
                       % self.barcode.get_text())
            self._run_advanced_search(search_str, message)
            return

        if not sellable.is_valid_quantity(quantity):
            warning(_(u"You cannot sell fractions of this product. "
                      u"The '%s' unit does not allow that") %
                      sellable.get_unit_description())
            return


        if sellable.product:
            # If the sellable has a weight unit specified and we have a scale
            # configured for this station, go and check what the scale says.
            if (sellable and sellable.unit and
                sellable.unit.unit_index == UnitType.WEIGHT and
                self._scale_settings):
                self._read_scale(sellable)

        storable = IStorable(sellable.product, None)
        if storable is not None:
            if not self._check_available_stock(storable, sellable):
                info(_("You cannot sell more items of product %s. "
                       "The available quantity is not enough." %
                        sellable.get_description()))
                self.barcode.set_text('')
                self.barcode.grab_focus()
                return

        self._update_list(sellable, notify_on_entry=True)
        self.barcode.grab_focus()

    def _check_available_stock(self, storable, sellable):
        branch = api.get_current_branch(self.conn)
        available = storable.get_full_balance(branch)
        added = sum([sale_item.quantity
                     for sale_item in self.sale_items
                         if sale_item.sellable == sellable])
        added += self.sellableitem_proxy.model.quantity
        return available - added >= 0

    def _clear_order(self):
        log.info("Clearing order")
        self._sale_started = False
        self.sale_items.clear()

        widgets = [self.search_box, self.list_vbox, self.CancelOrder]
        self.set_sensitive(widgets, True)

        self._delivery = None

        self._reset_quantity_proxy()
        self.barcode.set_text('')
        self._update_widgets()

    def _edit_sale_item(self, sale_item):
        if sale_item.sellable.service:
            delivery_service = self.param.DELIVERY_SERVICE
            if sale_item.sellable.service == delivery_service:
                self._edit_delivery()
                return
            model = self.run_dialog(ServiceItemEditor, self.conn, sale_item)
            if model:
                self.sale_items.update(sale_item)
        else:
            # Do not raise any exception here, since this method can be called
            # when the user activate a row with product in the sellables list.
            return

    def _cancel_order(self, show_confirmation=True):
        """
        Cancels the currently opened order.
        @returns: True if the order was canceled, otherwise false
        """
        if len(self.sale_items) and show_confirmation:
            if yesno(_("This will cancel the current order. Are you sure?"),
                     gtk.RESPONSE_NO, _("Don't cancel"), _(u"Cancel order")):
                return False

        log.info("Cancelling coupon")
        if not self.param.CONFIRM_SALES_ON_TILL:
            if self._coupon:
                self._coupon.cancel()
        self._coupon = None
        self._clear_order()

        return True

    def _create_delivery(self):
        delivery_sellable = self.param.DELIVERY_SERVICE.sellable
        if delivery_sellable in self.sale_items:
            self._delivery = delivery_sellable

        delivery = self._edit_delivery()
        if delivery:
            self._add_delivery_item(delivery, delivery_sellable)
            self._delivery = delivery

    def _edit_delivery(self):
        """Edits a delivery, but do not allow the price to be changed.
        If there's no delivery, create one.
        @returns: The delivery
        """
        #FIXME: Canceling the editor still saves the changes.
        return self.run_dialog(DeliveryEditor, self.conn,
                               self._delivery,
                               sale_items=self._get_deliverable_items())

    def _add_delivery_item(self, delivery, delivery_service):
        for sale_item in self.sale_items:
            if sale_item.sellable == delivery_service:
                sale_item.price = delivery.price
                sale_item.notes = delivery.notes
                delivery_item = sale_item
                new_item = False
                break
        else:
            delivery_item = _SaleItem(sellable=delivery_service,
                                      quantity=1,
                                      notes=delivery.notes,
                                      price=delivery.price)
            delivery_item.estimated_fix_date = delivery.estimated_fix_date
            new_item = True

        self._update_added_item(delivery_item,
                                new_item=new_item)

    def _create_sale(self, trans):
        user = api.get_current_user(trans)
        branch = api.get_current_branch(trans)
        salesperson = ISalesPerson(user.person)
        cfop = api.sysparam(trans).DEFAULT_SALES_CFOP
        group = PaymentGroup(connection=trans)
        sale = Sale(connection=trans,
                    branch=branch,
                    salesperson=salesperson,
                    group=group,
                    cfop=cfop,
                    coupon_id=None,
                    operation_nature=api.sysparam(trans).DEFAULT_OPERATION_NATURE)

        if self._delivery:
            address_string = self._delivery.address.get_address_string()
            sale.client = self._delivery.client

        for fake_sale_item in self.sale_items:
            sale_item = sale.add_sellable(fake_sale_item.sellable,
                                          price=fake_sale_item.price,
                                          quantity=fake_sale_item.quantity)
            sale_item.notes = fake_sale_item.notes
            sale_item.estimated_fix_date = fake_sale_item.estimated_fix_date

            if self._delivery and fake_sale_item.deliver:
                item = sale_item.addFacet(IDelivery,
                                          connection=trans)
                item.address = address_string
                DeliveryItem(sellable=fake_sale_item.sellable,
                             quantity=fake_sale_item.quantity,
                             delivery=item,
                             connection=trans)
        return sale

    def _checkout(self):
        assert len(self.sale_items) >= 1

        trans = api.new_transaction()
        sale = self._create_sale(trans)
        if not self.param.CONFIRM_SALES_ON_TILL:            # do not close sale, inverse of default
            sale.order()
            sale._set_sale_status(Sale.STATUS_QUOTE)        # change sale.status to quote
            trans.commit(close=True)
        else:
            assert self._coupon
            ordered = self._coupon.confirm(sale, trans)
            if not api.finish_transaction(trans, ordered):
                # FIXME: Move to TEF plugin
                manager = get_plugin_manager()
                if manager.is_active('tef'):
                    self._cancel_order(show_confirmation=False)
                trans.close()
                return

            log.info("Checking out")
            trans.close()

            # self.conn is infact a transaction, do a commit to bring
            # the objects from trans into self.conn
            self.conn.commit()
        self._coupon = None
        self._clear_order()

    def _remove_selected_item(self):
        sale_item = self.sale_items.get_selected()
        self._coupon_remove_item(sale_item)
        self.sale_items.remove(sale_item)
        self._check_delivery_removed(sale_item)
        self._select_first_item()
        self._update_widgets()
        self.barcode.grab_focus()

    def _add_note_selected_item(self):
        sale_item = self.sale_items.get_selected()
        if sale_item is None:
            raise StoqlibError("You should have a item selected "
                               "at this point")
        self.run_dialog(NoteEditor2, self.conn, sale_item, 'notes', title=_("Notes"))

    def _checkout_or_add_item(self):
        search_str = self.barcode.get_text()
        if search_str == '':
            if len(self.sale_items) >= 1:
                if yesno(_('Criar comanda?'), gtk.RESPONSE_YES, _("Yes"), _("No thanks")):
                    self._checkout()
                else:
                    pass
        else:
            self._add_sale_item(search_str)

    #
    # Coupon related
    #

    def _open_coupon(self):
        coupon = self._printer.create_coupon()

        if coupon:
            while not coupon.open():
                if not yesno(
                    _("It is not possible to start a new sale if the "
                      "fiscal coupon cannot be opened."),
                    gtk.RESPONSE_YES, _("Try again"), _("Cancel sale")):
                    self.app.shutdown()
                    break

        return coupon

    def _coupon_add_item(self, sale_item):
        """Adds an item to the coupon.

        Should return -1 if the coupon was not added, but will return None if
        CONFIRM_SALES_ON_TILL is true

        See L{stoqlib.gui.fiscalprinter.FiscalCoupon} for more information
        """
        self._sale_started = True
        if self.param.CONFIRM_SALES_ON_TILL:
            return

        if self._coupon is None:
            coupon = self._open_coupon()
            if not coupon:
                return -1
            self._coupon = coupon
        return self._coupon.add_item(sale_item)

    def _coupon_remove_item(self, sale_item):
        if self.param.CONFIRM_SALES_ON_TILL:
            return

        assert self._coupon
        self._coupon.remove_item(sale_item)

    def _close_till(self):
        if self._sale_started:
            if not yesno(_('You must finish or cancel the current sale before '
                       'you can close the till.'),
                     gtk.RESPONSE_NO, _("Cancel sale"), _("Finish sale")):
                return
            self._cancel_order(show_confirmation=False)
        self._printer.close_till()

    #
    # Actions
    #

    def on_CancelOrder__activate(self, action):
        self._cancel_order()

    def on_Clients__activate(self, action):
        self.run_dialog(ClientSearch, self.conn, hide_footer=True)

    def on_Sales__activate(self, action):
        self.run_dialog(SaleSearch, self.conn)

    def on_SoldItemsByBranchSearch__activate(self, action):
        self.run_dialog(SoldItemsByBranchSearch, self.conn)

    def on_ProductSearch__activate(self, action):
        self.run_dialog(ProductSearch, self.conn, hide_footer=True,
                        hide_toolbar=True, hide_cost_column=True)

    def on_ServiceSearch__activate(self, action):
        self.run_dialog(ServiceSearch, self.conn, hide_toolbar=True,
                        hide_cost_column=True)

    def on_DeliverySearch__activate(self, action):
        self.run_dialog(DeliverySearch, self.conn)

    def on_ConfirmOrder__activate(self, action):
        if yesno(_('Criar comanda?'), gtk.RESPONSE_YES, _("Yes"), _("No thanks")):
            self._checkout()
        else:
            pass

    def on_NewDelivery__activate(self, action):
        self._create_delivery()

    def on_TillClose__activate(self, action):
        self._close_till()

    def on_TillOpen__activate(self, action):
        self._printer.open_till()

    #
    # Other callbacks
    #

    def _on_context_notes__activate(self, menu_item):
        self._add_note_selected_item()

    def _on_context_remove__activate(self, menu_item):
        self._remove_selected_item()

    def _on_context_remove__can_disable(self, menu_item):
        selected = self.sale_items.get_selected()
        if selected:
            return False

        return True

    def on_advanced_search__clicked(self, button):
        self._run_advanced_search()

    def on_add_button__clicked(self, button):
        self._add_sale_item()

    def on_barcode__activate(self, entry):
        marker("enter pressed")
        self._checkout_or_add_item()

    def after_barcode__changed(self, editable):
        self._update_buttons()

    def on_quantity__activate(self, entry):
        self._checkout_or_add_item()

    def on_quantity__validate(self, entry, value):
        self._update_buttons()
        if value == 0:
            return ValidationError(_("Quantity must be a positive number"))

    def on_sale_items__selection_changed(self, sale_items, sale_item):
        self._update_widgets()

    def on_remove_item_button__clicked(self, button):
        self._remove_selected_item()

    def on_delivery_button__clicked(self, button):
        self._create_delivery()

    def on_checkout_button__clicked(self, button):
        if yesno(_('Criar comanda?'), gtk.RESPONSE_YES, _("Yes"), _("No thanks")):
            self._checkout()
        else:
            pass

    def on_edit_item_button__clicked(self, button):
        item = self.sale_items.get_selected()
        if item is None:
            raise StoqlibError("You should have a item selected "
                               "at this point")
        self._edit_sale_item(item)

    def on_sale_items__row_activated(self, sale_items, sale_item):
        self._edit_sale_item(sale_item)

    def _on_PrinterHelper__till_status_changed(self, printer, closed, blocked):
        self._till_status_changed(closed, blocked)

    def _on_PrinterHelper__ecf_changed(self, printer, has_ecf):
        # If we have an ecf, let the other events decide what to disable.
        if has_ecf:
            return

        # We dont have an ecf. Disable till related operations
        self._disable_printer_ui()


class FpHelper(FiscalPrinterHelper):
    
    def close_till(self, close_db=True, close_ecf=False):
        """Closes the till

        close_db and close_ecf should be different than True only when
        fixing an conflicting status: If the DB is open but the ECF is
        closed, or the other way around.

        @param close_db: If the till in the DB should be closed
        @param close_ecf: If the till in the ECF should be closed
        @returns: True if the till was closed, otherwise False
        """

        if not self._previous_day:
            if not self.time_to_Z():
                warning(u"Ainda Nao e Possivel Fechar o Caixa")
                return
            if not yesno(_("You can only close the till once per day. "
                           "You won't be able to make any more sales today.\n\n"
                           "Close the till?"),
                         gtk.RESPONSE_NO, _("Close Till"), _("Not now")):
                return
        else:
            # When closing from a previous day, close only what is needed.
            close_db = self._close_db
            #close_ecf = self._close_ecf

        if close_db:
            till = Till.get_last_opened(self.conn)
            assert till

        trans = api.new_transaction()
        model = run_dialog(TillClosingEditor, self._parent, trans,
                           previous_day=self._previous_day, close_db=close_db,
                           close_ecf=close_ecf)

        if not model:
            api.finish_transaction(trans, model)
            return

        # TillClosingEditor closes the till
        retval = api.finish_transaction(trans, model)
        trans.close()
        if retval:
            self._till_status_changed(closed=True, blocked=False)
        return retval
    
    def needs_closing(self):
        """Checks if the last opened till was closed and asks the
        user if he wants to close it

        @returns:
            - CLOSE_TILL_BOTH if both DB and ECF needs closing.
            - CLOSE_TILL_DB if only DB needs closing.
            - CLOSE_TILL_ECF if only ECF needs closing.
            - CLOSE_TILL_NONE if both ECF and DB are consistent (they may be
                  closed, or open for the current day)
        """
        ecf_needs_closing = False

        last_till = Till.get_last(self.conn)
        if last_till:
            db_needs_closing = last_till.needs_closing()
        else:
            db_needs_closing = False

        if db_needs_closing and ecf_needs_closing:
            return CLOSE_TILL_BOTH
        elif db_needs_closing and not ecf_needs_closing:
            return CLOSE_TILL_DB
        elif ecf_needs_closing and not db_needs_closing:
            return CLOSE_TILL_ECF
        else:
            return CLOSE_TILL_NONE

    def create_coupon(self):
        """ Creates a new fiscal coupon
        @returns: a new coupon
        """

        if sysparam(self.conn).DEMO_MODE:
            branch = api.get_current_branch(self.conn)
            company = ICompany(branch.person, None)
            if company and company.cnpj not in ['24.198.774/7322-35',
                                                '66.873.574/0001-82']:
                # FIXME: Find a better description for the warning bellow.
                warning(_("You are not allowed to sell in branches not "
                          "created by the demonstration mode"))
        coupon = FC(self._parent)

        # try:
        #     CouponCreatedEvent.emit(coupon)
        # except (DriverError, DeviceError):
        #     warning('Não foi possível abrir o cupom')
        #     coupon = None

        return coupon

    def _check_needs_closing(self):
        needs_closing = self.needs_closing()

        # DB and ECF are ok
        if needs_closing is CLOSE_TILL_NONE:
            self._previous_day = False
            # We still need to check if the till is open or closed.
            till = Till.get_current(self.conn)
            self._till_status_changed(closed=not till, blocked=False)
            return True

        close_db = needs_closing in (CLOSE_TILL_DB, CLOSE_TILL_BOTH)
        # close_ecf = needs_closing in (CLOSE_TILL_ECF, CLOSE_TILL_BOTH)
        close_ecf = False

        # DB or ECF is open from a previous day
        self._till_status_changed(closed=False, blocked=True)
        self._previous_day = True

        # Save this statuses in case the user chooses not to close now.
        self._close_db = close_db
        self._close_ecf = close_ecf

        manager = get_plugin_manager()
        if close_db and (close_ecf or not manager.is_active('ecf')):
            msg = _("You need to close the till from the previous day before "
                    "creating a new order.\n\nClose the Till?")
        elif close_db and not close_ecf:
            msg = _("The till in Stoq is opened, but in ECF "
                    "is closed.\n\nClose the till in Stoq?")
        elif close_ecf and not close_db:
            msg = _("The till in stoq is closed, but in ECF "
                    "is opened.\n\nClose the till in ECF?")

        if yesno(msg, gtk.RESPONSE_NO, _("Close Till"), _("Not now")):
            return self.close_till(close_db, close_ecf)

        return False

    # def check_till(self):
    #     try:
    #         self._check_needs_closing()
    #         self.emit('ecf-changed', True)
    #     except (DeviceError, DriverError), e:
    #         warning(e)
    #         self.emit('ecf-changed', False)


class FC(FiscalCoupon):
    """ Here we ignore events to ECF
    """

    #
    # Fiscal coupon related functions
    #

    def identify_customer(self, person):
        pass
        # self.emit('identify-customer', person)

    def is_customer_identified(self):
        pass
        # return self.emit('customer-identified')

    def open(self):
        pass
        # while True:
        #     log.info("opening coupon")
        #     try:
        #         self.emit('open')
        #         break
        #     except CouponOpenError:
        #         if not self.cancel():
        #             return False
        #     except OutofPaperError:
        #         if not yesno(
        #             _("The fiscal printer has run out of paper.\nAdd more paper "
        #               "before continuing."),
        #             gtk.RESPONSE_YES, _("Resume"), _("Confirm later")):
        #             return False
        #         return self.open()
        #     except PrinterOfflineError:
        #         if not yesno(
        #             (_(u"The fiscal printer is offline, turn it on and try "
        #                "again")),
        #             gtk.RESPONSE_YES, _(u"Resume"), _(u"Confirm later")):
        #             return False
        #         return self.open()
        #     except (DriverError, DeviceError), e:
        #         warning(_(u"It is not possible to emit the coupon"),
        #                 str(e))
        #         return False
        #
        # self._coo = self.emit('get-coo')
        # self.totalized = False
        # self.coupon_closed = False
        # self.payments_setup = False
        return True

    def confirm(self, sale, trans):
        # Actually, we are confirming the sale here, so the sale
        # confirmation process will be available to others applications
        # like Till and not only to the POS.
        # model = run_dialog(ConfirmSaleWizard, self._parent, trans, sale)
        #
        # if not model:
        #     CancelPendingPaymentsEvent.emit()
        #     api.finish_transaction(trans, False)
        #     return False
        # if sale.client and not self.is_customer_identified():
        #     self.identify_customer(sale.client.person)
        #
        # if not self.totalize(sale):
        #
        #     api.finish_transaction(trans, False)
        #     return False
        #
        # if not self.setup_payments(sale):
        #
        #     api.finish_transaction(trans, False)
        #     return False
        #
        # if not self.close(sale, trans):
        #     api.finish_transaction(trans, False)
        #     return False
        # sale.confirm()
        #
        # if not self.print_receipts(sale):
        #     warning('A venda foi cancelada')
        #     sale.cancel()
        #
        # # Only finish the transaction after everything passed above.
        # api.finish_transaction(trans, model)
        #
        # if sale.only_paid_with_money():
        #     sale.set_paid()
        # else:
        #     sale.group.pay_money_payments()
        #
        # print_cheques_for_payment_group(trans, sale.group)

        return True

    def print_receipts(self, sale):
        #supports_duplicate = self.emit('get-supports-duplicate-receipt')
        # Vamos sempre imprimir sempre de uma vez, para simplificar
        # supports_duplicate = False
        #
        # log.info('Printing payment receipts')
        #
        # # Merge card payments by nsu
        # card_payments = {}
        # for payment in sale.payments:
        #     if payment.method.method_name != 'card':
        #         continue
        #     operation = payment.method.operation
        #     card_data = operation.get_card_data_by_payment(payment)
        #     card_payments.setdefault(card_data.nsu, [])
        #     card_payments[card_data.nsu].append(payment)
        #
        # any_failed = False
        # for nsu, payment_list in card_payments.items():
        #     receipt = CardPaymentReceiptPrepareEvent.emit(nsu, supports_duplicate)
        #     if receipt is None:
        #         continue
        #
        #     value = sum([p.value for p in payment_list])
        #
        #     # This is BS, but if any receipt failed to print, we must print
        #     # the remaining ones in Gerencial Rports
        #     if any_failed:
        #         retval = self.reprint_payment_receipt(receipt)
        #     else:
        #         retval = self.print_payment_receipt(payment_list[0], value, receipt)
        #     while not retval:
        #         if not yesno(_(u"Erro na impressão. Deseja tentar novamente?"),
        #                  gtk.RESPONSE_YES,
        #                  _("Sim"), _(u"Não")):
        #             CancelPendingPaymentsEvent.emit()
        #             try:
        #                 GerencialReportCancelEvent.emit()
        #             except (DriverError, DeviceError), details:
        #                 log.info('Error canceling last receipt: %s' %
        #                             details)
        #                 warning(u'Não foi possível cancelar o último'
        #                          ' comprovante')
        #             return False
        #         any_failed = True
        #         _flush_interface()
        #         retval = self.reprint_payment_receipt(receipt,
        #                                               close_previous=True)
        #
        # # Only confirm payments receipt printed if *all* receipts wore
        # # printed.
        # for nsu in card_payments.keys():
        #     CardPaymentReceiptPrintedEvent.emit(nsu)

        return True

    def totalize(self, sale):
        # XXX: Remove this when bug #2827 is fixed.
        # if not self._item_ids:
        #     return True
        #
        # if self.totalized:
        #     return True
        #
        # log.info('Totalizing coupon')
        #
        # while True:
        #     try:
        #         self.emit('totalize', sale)
        #         self.totalized = True
        #         return True
        #     except (DriverError, DeviceError), details:
        #         log.info("It is not possible to totalize the coupon: %s"
        #                     % str(details))
        #         if not yesno(_(u"Erro na impressão. Deseja tentar novamente?"),
        #                  gtk.RESPONSE_YES,
        #                  _("Sim"), _(u"Não")):
        #             CancelPendingPaymentsEvent.emit()
        #             return False
        #         _flush_interface()
        return True

    def cancel(self):
        # log.info('Canceling coupon')
        # while True:
        #     try:
        #         self.emit('cancel')
        #         break
        #     except (DriverError, DeviceError), details:
        #         log.info("Error canceling coupon: %s" % str(details))
        #         if not yesno(_(u"Erro cancelando cupom. Deseja tentar novamente?"),
        #                  gtk.RESPONSE_YES,
        #                  _("Sim"), _(u"Não")):
        #             return False
        #         _flush_interface()
        return True

    # FIXME: Rename to add_payment_group(group)
    def setup_payments(self, sale):
        """ Add the payments defined in the sale to the coupon. Note that this
        function must be called after all the payments has been created.
        """
        # XXX: Remove this when bug #2827 is fixed.
        # if not self._item_ids:
        #     return True
        #
        # if self.payments_setup:
        #     return True
        #
        # log.info('Adding payments to the coupon')
        # while True:
        #     try:
        #         self.emit('add-payments', sale)
        #         self.payments_setup = True
        #         return True
        #     except (DriverError, DeviceError), details:
        #         log.info("It is not possible to add payments to the coupon: %s"
        #                     % str(details))
        #         if not yesno(_(u"Erro na impressão. Deseja tentar novamente?"),
        #                  gtk.RESPONSE_YES,
        #                  _("Sim"), _(u"Não")):
        #             CancelPendingPaymentsEvent.emit()
        #             return False
        #         _flush_interface()
        return True

    def close(self, sale, trans):
        # XXX: Remove this when bug #2827 is fixed.
        # if not self._item_ids:
        #     return True
        #
        # if self.coupon_closed:
        #     return True
        #
        # log.info('Closing coupon')
        # while True:
        #     try:
        #         coupon_id = self.emit('close', sale)
        #         sale.coupon_id = coupon_id
        #         self.coupon_closed = True
        #         return True
        #     except (DeviceError, DriverError), details:
        #         log.info("It is not possible to close the coupon: %s"
        #                     % str(details))
        #         if not yesno(_(u"Erro na impressão. Deseja tentar novamente?"),
        #                  gtk.RESPONSE_YES,
        #                  _("Sim"), _(u"Não")):
        #             CancelPendingPaymentsEvent.emit()
        #             return False
        #         _flush_interface()
        return True

    def print_payment_receipt(self, payment, value, receipt):
        """Print the receipt for the payment.

        This must be called after the coupon is closed.
        """

        # try:
        #     self.emit('print-payment-receipt', self._coo, payment, value, receipt)
        #     return True
        # except (DriverError, DeviceError), details:
        #     log.info("Error printing payment receipt: %s"
        #                 % str(details))
        #     return False
        return True

    def reprint_payment_receipt(self, receipt, close_previous=False):
        """Re-Print the receipt for the payment.
        """
        #
        # try:
        #     GerencialReportPrintEvent.emit(receipt, close_previous)
        #     return True
        # except (DriverError, DeviceError), details:
        #     log.info("Error printing gerencial report: %s"
        #                 % str(details))
        #     return False
        return True