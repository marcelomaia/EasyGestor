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
import datetime
import gettext
import gtk
from decimal import Decimal

import pango
from kiwi.argcheck import argcheck
from kiwi.datatypes import ValidationError
from kiwi.datatypes import currency, converter
from kiwi.environ import environ
from kiwi.log import Logger
from kiwi.python import Settable
from kiwi.ui.delegates import GladeDelegate
from kiwi.ui.dialogs import error
from kiwi.ui.objectlist import ColoredColumn
from kiwi.ui.widgets.contextmenu import ContextMenu, ContextMenuItem
from kiwi.ui.widgets.list import Column
from kiwi.utils import gsignal
from sqlobject.main import SQLObjectIntegrityError
from stoq.gui.application import AppWindow
from stoqdrivers.enum import UnitType
from stoqlib.api import api
from stoqlib.database.orm import AND
from stoqlib.database.orm import STARTSWITH, LIKE, OR, LOWER
from stoqlib.database.runtime import get_current_branch, get_connection, new_transaction, get_current_station
from stoqlib.domain.devices import DeviceSettings
from stoqlib.domain.events import SalesNFCEEvent, SaleSEmitEvent, TillOpenDrawer, SalesNFCEReprintEvent, \
    ValidateItemNFCEEvent, CreatedOutPaymentEvent, CreatedInPaymentEvent, TillAddTillEntryEvent, SaleSLastEmitEvent
from stoqlib.domain.interfaces import IDelivery, ISalesPerson
from stoqlib.domain.nfe import NFCEBranchSeries
from stoqlib.domain.parameter import ParameterData
from stoqlib.domain.payment.group import PaymentGroup
from stoqlib.domain.product import IStorable, ProductAttribute, Product, ProductAdaptToStorable, ProductStockItem
from stoqlib.domain.renegotiation import RenegotiationData
from stoqlib.domain.sale import Sale, DeliveryItem
from stoqlib.domain.sellable import Sellable
from stoqlib.domain.service import Service
from stoqlib.domain.till import Till
from stoqlib.domain.views import ProductFullStockItemView
from stoqlib.drivers.scale import read_scale_info
from stoqlib.exceptions import StoqlibError, TaxError
from stoqlib.gui.base.dialogs import push_fullscreen, pop_fullscreen, RunnableView, run_dialog, get_current_toplevel
from stoqlib.gui.dialogs.clientcategorydialog import ClientCategoryChooser
from stoqlib.gui.dialogs.griddialog import ProductAttributeDialog
from stoqlib.gui.dialogs.passworddialog import UserPassword
from stoqlib.gui.editors.deliveryeditor import DeliveryEditor
from stoqlib.gui.editors.noteeditor import NoteEditor
from stoqlib.gui.editors.paymenteditor import InPaymentEditor, OutPaymentEditor
from stoqlib.gui.editors.producteditor import ProductStockEditor
from stoqlib.gui.editors.serviceeditor import ServiceItemEditor
from stoqlib.gui.editors.tilleditor import _create_transaction
from stoqlib.gui.fiscalprinter import FiscalPrinterHelper
from stoqlib.gui.keybindings import get_accels, get_accel
from stoqlib.gui.search.personsearch import ClientSearch
from stoqlib.gui.search.productsearch import ProductSearch
from stoqlib.gui.search.salesearch import (SaleSearch, DeliverySearch,
                                           SoldItemsByBranchSearch)
from stoqlib.gui.search.sellablesearch import SellableSearch
from stoqlib.gui.search.servicesearch import ServiceSearch
from stoqlib.gui.slaves.imageslaveslave import ImageEditor
from stoqlib.gui.slaves.installmentslave import SaleInstallmentConfirmationSlave
from stoqlib.gui.stockicons import STOQ_MONEY_REMOVE, STOQ_MONEY_ADD, STOQ_MONEY, STOQ_COLOR_PALETE
from stoqlib.lib.barcode import parse_barcode, BarcodeInfo
from stoqlib.lib.defaults import quantize
from stoqlib.lib.formatters import format_quantity, get_formatted_price
from stoqlib.lib.message import warning, info, yesno, marker
from stoqlib.lib.osutils import get_application_dir
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.pluginmanager import get_plugin_manager

_ = gettext.gettext
log = Logger('stoq.pos')
APPDIR = get_application_dir('stoq')
_pixbuf_converter = converter.get_converter(gtk.gdk.Pixbuf)


def color_variant(hex_color, brightness_offset=1):
    """ takes a color like #87c95f and produces a lighter or darker variant
    http://chase-seibert.github.io/blog/2011/07/29/python-calculate-lighterdarker-rgb-colors.html
    >>> color_variant('#ff0000', 200)  #lighter
    >>> color_variant('#ff0000', -200) #darker
    """
    if len(hex_color) != 7:
        raise Exception("Passed %s into color_variant(), needs to be in #87c95f format." % hex_color)
    rgb_hex = [hex_color[x:x + 2] for x in [1, 3, 5]]
    new_rgb_int = [int(hex_value, 16) + brightness_offset for hex_value in rgb_hex]
    new_rgb_int = [min([255, max([0, i])]) for i in new_rgb_int]  # make sure new values are between 0 and 255
    # hex() produces "0x88", we want just "88"
    return "#" + "".join([hex(i)[2:] for i in new_rgb_int])


def tohex(c):
    # Convert to hex string
    # little hack to fix bug
    s = ['#', hex(int(c[0] * 256))[2:].zfill(2), hex(int(c[1] * 256))[2:].zfill(2),
         hex(int(c[2] * 256))[2:].zfill(2)]
    for item in enumerate(s):
        if item[1] == '100':
            s[item[0]] = 'ff'
    return ''.join(s)


class SellableImageViewer(GladeDelegate, RunnableView):
    title = _("Sellable Image Viewer")
    domain = 'stoq'
    gladefile = "SellableImageViewer"
    position = (0, 0)
    gsignal('image_edited', object)

    def __init__(self, size):
        """
        :param tuple size: the size for this viewer as (x, y)
        """
        self._size = size

        GladeDelegate.__init__(self)
        self.toplevel.set_keep_above(True)
        self.toplevel.resize(*self._size)
        self.toplevel.move(*self.position)
        self.sellable = None
        self.toplevel.connect("configure-event", self._on_configure)

    #
    #  Public API
    #

    def set_sellable(self, sellable):
        self.sellable = sellable
        product = Product.selectOneBy(sellable=sellable, connection=get_connection())
        service = Service.selectOneBy(sellable=sellable, connection=get_connection())
        result = product
        if result is None:
            result = service
        if not self.sellable or not result.image:
            # set default image
            path = environ.find_resource('pixmaps', 'image_not_found.jpg')
            pixbuf = gtk.gdk.pixbuf_new_from_file(path)
            width, height = self._size
            pixbuf = pixbuf.scale_simple(width, height, gtk.gdk.INTERP_BILINEAR)
            self.image.set_from_pixbuf(pixbuf)
            return
        if hasattr(result, 'full_image'):
            image = result.full_image
        else:
            image = result.image

        pixbuf = _pixbuf_converter.from_string(image)
        width, height = self._size
        pixbuf = pixbuf.scale_simple(width, height, gtk.gdk.INTERP_BILINEAR)
        self.image.set_from_pixbuf(pixbuf)

    #
    #  Private
    #

    def _on_configure(self, window, event):
        self.position = event.x, event.y
        self._size = event.width, event.height
        self.set_sellable(self.sellable)

    def on_button__clicked(self, arg):
        trans = new_transaction()
        product = Product.selectOneBy(sellable=self.sellable, connection=trans)
        service = Service.selectOneBy(sellable=self.sellable, connection=trans)
        if product:
            run_dialog(ProductStockEditor, get_current_toplevel(), trans, product)
        elif service:
            run_dialog(ImageEditor, get_current_toplevel(), trans, service)
        trans.commit(True)
        self.emit('image_edited', '')


class FakeSaleItem(object):
    def __init__(self, sellable, quantity, price=None, notes=None, attribute_desc='', is_service=False,
                 category_name=''):
        # Use only 3 decimal places for the quantity
        self.quantity = Decimal('%.3f' % quantity)
        self.sellable = sellable
        self.description = sellable.description + ' ' + attribute_desc
        self.unit = sellable.get_unit_description()
        self.code = sellable.code
        self.is_service = is_service
        self.category_name = category_name

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
        if isinstance(self.quantity, unicode):
            self.quantity = Decimal(self.quantity.replace(',', '.'))
        return quantize(currency(self.price * self.quantity))


LOGO_WIDTH = 300
LOGO_HEIGHT = 110


def get_company_logotype_path(conn):
    logofile = api.sysparam(conn).CUSTOM_LOGO_FOR_POS
    if logofile.is_valid():
        logofile.resize((LOGO_WIDTH, LOGO_HEIGHT))
        return str(logofile.image_path)
    else:
        return environ.find_resource("pixmaps", "companylogo.jpg")


class PosApp(AppWindow):
    app_name = _('Point of Sales')
    gladefile = "pos2"
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
        self.pos_event_box.connect("key-press-event", self._key_press_event)
        pos_color = ParameterData.selectOneBy(field_name='POS_COLOR', connection=self.conn)
        self.eventbox_list_header_hbox.modify_bg(gtk.STATE_NORMAL, gtk.gdk.Color(pos_color.field_value))
        self.eventbox_list_vbox.modify_bg(gtk.STATE_NORMAL, gtk.gdk.Color(color_variant(pos_color.field_value, 20)))
        self.last_user_sale = ''
        self.TillVerify.set_sensitive(False)

    def _key_press_event(self, widget, event):
        self._update_time_label()
        keyval = event.keyval
        keyval_name = gtk.gdk.keyval_name(keyval)
        state = event.state
        ctrl = (state & gtk.gdk.CONTROL_MASK)
        curr = self._read_quantity()
        if ctrl and keyval_name == 'Delete':
            self._remove_selected_item()
        elif ctrl and keyval_name.upper() == 'L':
            self.barcode.grab_focus()
        elif ctrl and keyval_name.upper() == 'O':
            self.quantity.grab_focus()
        elif ctrl and keyval_name == 'KP_Add':
            self._update_quantity(curr + 1)
        elif ctrl and keyval_name == 'KP_Subtract':
            self._update_quantity(curr - 1)
        elif ctrl and keyval_name.upper() == 'Y':
            self._reprint_last_non_fiscal_sale()
        elif ctrl and keyval_name.upper() == 'R':
            self._reprint_last_fiscal_sale()
        elif ctrl and keyval_name in '0123456789':
            self._update_quantity(int(keyval_name))
        elif ctrl and keyval_name in ['KP_' + p for p in '0123456789']:
            numeric_part = ''.join([p for p in keyval_name if p in '0123456789'])
            self._update_quantity(int(numeric_part))

    #
    # Application
    #

    def create_actions(self):
        group = get_accels('app.pos')
        actions = [
            # File
            ("TillOpen", None, _("Open Till..."),
             group.get('till_open')),
            ('TillVerify', None, _("Verificar Caixa..."),
             None),
            ("TillClose", None, _("Close Till..."),
             group.get('till_close')),
            ('TillAddCash', STOQ_MONEY_ADD, _('Cash addition...'), ''),
            ('TillRemoveCash', STOQ_MONEY_REMOVE, _('Cash removal...'), ''),
            ('OpenDrawer', STOQ_MONEY, _('Abrir caixa registradora'), '<Control><Shift>g'),

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
            ("POSColor", STOQ_COLOR_PALETE, _("Cor do PDV"),
             group.get('search_deliveries')),
        ]
        self.pos_ui = self.add_ui_actions('', actions,
                                          filename='pos.xml')
        self.set_help_section(_("POS help"), 'app-pos')

        self.pos_ui = self.add_ui_actions('', actions,
                                          filename='pos.xml')
        toggle_actions = [
            ('DetailsViewer', None, _('Details viewer'),),
        ]
        self.add_ui_actions('', toggle_actions, 'ToggleActions', 'toggle')

    def create_ui(self):
        self.sale_items.set_columns(self.get_columns())
        self.sale_items.set_selection_mode(gtk.SELECTION_BROWSE)
        self.sale_items.connect('double-click', self._add_note_selected_item)
        self.sale_items.connect('cell-edited', self.update_lbls)
        # Setting up the widget groups
        # self.main_vbox.set_focus_chain([self.pos_vbox])
        #
        # self.pos_vbox.set_focus_chain([self.list_header_hbox, self.list_vbox])
        # self.list_header_hbox.set_focus_chain([self.quantity, self.barcode])
        # self.list_vbox.set_focus_chain([self.footer_hbox])
        # self.footer_hbox.set_focus_chain([self.toolbar_vbox])
        #
        # Setting up the toolbar area
        # self.toolbar_vbox.set_focus_chain([self.toolbar_button_box])
        # self.toolbar_button_box.set_focus_chain([self.checkout_button,
        #                                          self.cancel_button,
        #                                          self.delivery_button,
        #                                          self.edit_item_button,
        #                                          self.remove_item_button,
        #                                          self.sellable_search_button])

        # Setting up the barcode area
        # self.item_hbox.set_focus_chain([self.barcode, self.quantity])
        self._setup_printer()
        self._setup_widgets()
        self._setup_proxies()
        self._clear_order()

    def activate(self, params):
        # Admin app doesn't have anything to print/export
        for widget in (self.app.launcher.Print, self.app.launcher.ExportCSV):
            widget.set_visible(False)
        self.app.launcher.add_new_items([self.TillAddCash,
                                         self.TillRemoveCash,
                                         self.OpenDrawer])
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
        secure_mode = sysparam(self.conn).NFCE_SECURE_MODE
        if secure_mode:
            if not run_dialog(UserPassword, get_current_toplevel(), self.conn, UserPassword.ADM):
                return
        can_close_application = not self._sale_started
        if not can_close_application:
            if yesno(_('You must finish or cancel the current sale before you '
                       'can close the POS application.'),
                     gtk.RESPONSE_NO, _("Cancel sale"), _("Finish sale")):
                self._cancel_order(show_confirmation=False)
                return True
        return can_close_application

    def get_columns(self):
        can_edit_cell = api.sysparam(self.conn).DYNAMIC_PRICE
        font_big_size = 'sans bold 12'
        font_normal = 'sans 12'
        return [Column('code', title=_(u'Cód.'), font_desc=font_normal,
                       data_type=str, width=50, justify=gtk.JUSTIFY_RIGHT),
                Column('description',
                       title=_('Description'), format_func=self._upper_str, data_type=str, expand=True,
                       searchable=True, font_desc=font_big_size, ellipsize=pango.ELLIPSIZE_END),
                Column('category_name', title=u'Categoria', data_type=str,
                       width=80, font_desc=font_normal),
                Column('price', title=_('Price'), data_type=currency,
                       width=80, editable=can_edit_cell, justify=gtk.JUSTIFY_RIGHT, font_desc=font_normal),
                Column('quantity', title=_(u'Qtde.'), data_type=unicode, font_desc=font_normal,
                       width=70, editable=can_edit_cell, justify=gtk.JUSTIFY_RIGHT),
                Column('unit', title=_('Un'), data_type=unicode, font_desc=font_normal,
                       width=40, justify=gtk.JUSTIFY_RIGHT),
                ColoredColumn('total', title=_('Total'), data_type=currency,
                              font_desc=font_big_size, data_func=self.colorize,
                              color='#003300', justify=gtk.JUSTIFY_RIGHT, width=120), ]

    def _upper_str(self, word):
        return word.upper()

    def colorize(self, data):
        return True

    def set_open_inventory(self):
        self.set_sensitive(self._inventory_widgets, False)

    #
    # Private
    #

    def _setup_printer(self):
        self._printer = FiscalPrinterHelper(self.conn,
                                            parent=self)
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

    def _setup_widgets(self):
        self._inventory_widgets = [self.Sales, self.barcode, self.quantity,
                                   self.sale_items, self.advanced_search,
                                   self.checkout_button]
        self.register_sensitive_group(self._inventory_widgets,
                                      lambda: not self.has_open_inventory())

        logotype_path = get_company_logotype_path(self.conn)
        logo = gtk.gdk.pixbuf_new_from_file_at_size(logotype_path, LOGO_WIDTH * 2,
                                                    LOGO_HEIGHT * 2)
        self.stoq_logo.set_from_pixbuf(logo)

        self.quantity.set_digits(3)

        self.order_total_label.modify_font(pango.FontDescription('futura book 30'))
        self.order_total_label.set_color('#003300')
        self.order_total_label.set_bold(True)
        self._create_context_menu()

        self.quantity.set_digits(3)

        self._image_slave = SellableImageViewer(size=(175, 175))
        self._image_slave.connect('image_edited', self._update_sellable_details)
        self.attach_slave('image_holder', self._image_slave)
        self.details_lbl.set_ellipsize(pango.ELLIPSIZE_END)
        self.extra_details_lbl.set_ellipsize(pango.ELLIPSIZE_END)

        # self.details_box.set_visible(False)

        self.DetailsViewer.set_active(api.user_settings.get('pos-show-details-viewer', True))

        # if not api.sysparam(self.conn).EMPLOYERS_CAN_REMOVE_ITEMS:
        #     self.remove_item_button.hide()
        manager = get_plugin_manager()
        if not manager.is_active('impnf'):
            self.impnf_button.hide()
        if not manager.is_active('nfce'):
            self.nfce_button.hide()

        self.checkout_button_shortcut.update(self._replace_shortcut(get_accel('app.pos.order_confirm')))
        self.cancel_button_shortcut.update(self._replace_shortcut(get_accel('app.pos.order_cancel')))
        self.delivery_button_shortcut.update(self._replace_shortcut(get_accel('app.pos.order_create_delivery')))
        self.edit_item_button_shortcut.update(self._replace_shortcut(get_accel('app.pos.item_edit')))
        self.remove_item_button_shortcut.update(self._replace_shortcut(get_accel('app.pos.item_remove')))
        self.sellable_search_button_shortcut.update(self._replace_shortcut(get_accel('app.pos.search_products')))
        self.impnf_button_shortcut.update('CONTROL+Y')
        self.nfce_button_shortcut.update('CONTROL+R')
        [p.set_size('x-small') for p in [self.checkout_button_shortcut,
                                         self.cancel_button_shortcut,
                                         self.delivery_button_shortcut,
                                         self.edit_item_button_shortcut,
                                         self.remove_item_button_shortcut,
                                         self.sellable_search_button_shortcut,
                                         self.impnf_button_shortcut,
                                         self.nfce_button_shortcut]]
        self.expander.set_expanded(True)
        # barcode
        self.barcode.modify_font(pango.FontDescription('futura book 26'))

        barcode_completion = gtk.EntryCompletion()
        liststore = gtk.ListStore(str, object)
        barcode_completion.set_model(liststore)
        barcode_completion.set_text_column(0)
        barcode_completion.connect('match-selected', self.on_completion_match)
        barcode_completion.set_match_func(self.match_func, None)
        self.barcode.set_completion(barcode_completion)
        # quantity
        self.quantity.modify_font(pango.FontDescription('futura book 26'))
        self.aditional_info.modify_font(pango.FontDescription('futura book 12'))
        self.aditional_info.update(datetime.datetime.now().strftime("%A, %d de %B de %Y %H:%M"))
        self.aditional_info.set_bold(True)

        self.details_box.set_visible(True)
        self.vbox9.set_visible(False)

    def match_func(self, completion, key_string, iter, data):
        return True

    def on_completion_match(self, completion, model, iter):
        slug_field = model[iter][1].barcode or model[iter][1].description
        current_text = "%s" % slug_field
        self.barcode.set_text(current_text)
        self.barcode.activate()
        return True

    def on_barcode__changed(self, entry):
        value = entry.get_text()
        if len(value) < 2 or not sysparam(self.conn).AUTO_COMPLETE:
            return
        clause = OR(STARTSWITH(Sellable.q.code, value), STARTSWITH(Sellable.q.barcode, value),
                    LIKE(LOWER(Sellable.q.description), '%%%s%%' % value.lower(), escape='\\'))
        results = [item for item in ProductFullStockItemView.select(clause=clause,
                                                                    connection=get_connection())]
        model = gtk.ListStore(str, object)
        for sellable in results:
            label = '%s -- %s -- R$ %s' % (sellable.code, sellable.description, sellable.base_price)
            model.append((label, sellable))
        completion = self.barcode.get_completion()
        completion.set_model(model)

    def _update_time_label(self):
        dt_msg = datetime.datetime.now().strftime("%d/%m/%Y %H:%M")
        self.aditional_info.set_text('{} {}'.format(self.last_user_sale, dt_msg))

    def _replace_shortcut(self, arg):
        return arg.replace('<', '').replace('>', '+').upper()

    def _create_context_menu(self):
        menu = ContextMenu()

        item = ContextMenuItem(_('Notes'))
        item.connect('activate', self._on_context_notes__activate)
        menu.append(item)

        self.sale_items.set_context_menu(menu)
        menu.show_all()

    def _update_totals(self):
        subtotal = currency(sum([item.total for item in self.sale_items]))
        text = _(u"Total: %s") % converter.as_string(currency, subtotal)
        self.order_total_label.set_text(text)

    def update_lbls(self, obj_list, obj, attr):
        self._update_totals()
        self._update_sellable_details(quantity=obj.price, price=obj.quantity)

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

        sale_item = FakeSaleItem(sellable=sellable,
                                 quantity=quantity,
                                 is_service=is_service)

        if self.param.CATEGORY_PRICE:
            client_category = run_dialog(ClientCategoryChooser, get_current_toplevel(), self.conn, None)
            if client_category:
                price = sellable.get_price_for_category(client_category)

                sale_item = FakeSaleItem(sellable=sellable,
                                         quantity=quantity,
                                         is_service=is_service,
                                         price=price,
                                         category_name=client_category.name)

        attributes = ProductAttribute.selectBy(product=sellable.product,
                                               branch=get_current_branch(self.conn),
                                               connection=self.conn)

        if attributes:
            # here chooses an attribute
            msg = _("Gostaria de vender o item com grade?")
            if not yesno(msg, gtk.RESPONSE_NO,
                         _("Sell normally"),
                         _("Sell with grid")):
                attribute = self.run_dialog(ProductAttributeDialog, self.conn, sellable, attributes)
                if attribute:
                    sale_item = FakeSaleItem(sellable=sellable,
                                             quantity=quantity,
                                             price=attribute.price,
                                             attribute_desc=attribute.description,
                                             notes='grade:' + attribute.description)
                    attribute.quantity -= quantity
                    self.conn.commit()

        if is_service:
            rv = self.run_dialog(ServiceItemEditor, self.conn, sale_item)
            if not rv:
                return

        if sellable.product:
            if not sellable.product.is_composed:
                self._check_minimum_stock(quantity, sellable)

        self._update_added_item(sale_item)

    def _check_minimum_stock(self, quantity, sellable):
        storable = ProductAdaptToStorable.selectOneBy(originalID=sellable.product.id,
                                                      connection=self.conn)
        stock_item = ProductStockItem.selectOneBy(storable=storable,
                                                  branch=get_current_branch(self.conn),
                                                  connection=self.conn)
        current, minimum = stock_item.quantity, storable.minimum_quantity
        if current - quantity < minimum:
            warning(u"O produto {} está com quantidade no "
                    u"estoque abaixo do recomendado".format(sellable.description),
                    u"Quantidade atual: {:.2f}, "
                    u"estoque mínimo {:.2f}".format(current - quantity, minimum))

    def _get_sellable(self):
        barcode = self.barcode.get_text()
        if not barcode:
            raise StoqlibError("_get_sellable needs a barcode")
        barcode_data = barcode.split('*')
        if barcode_data[0] != barcode:
            barcode = barcode_data[1]

        fmt = api.sysparam(self.conn).SCALE_BARCODE_FORMAT

        # Check if this barcode is from a scale
        info = parse_barcode(barcode, fmt)
        if info:
            barcode = info.code
            weight = info.weight
        try:
            _or = OR(Sellable.q.barcode == barcode, Sellable.q.code == barcode, Sellable.q.description == barcode)
            _clause = AND(Sellable.q.status == Sellable.STATUS_AVAILABLE, _or)
            sellable = Sellable.selectOne(clause=_clause,
                                          connection=self.conn)

        except SQLObjectIntegrityError, e:
            _or = OR(Sellable.q.code == barcode, Sellable.q.description == barcode)
            _clause = AND(Sellable.q.status == Sellable.STATUS_AVAILABLE, _or)
            sellable = Sellable.selectOne(clause=_clause,
                                          connection=self.conn)

        # If the barcode has the price information, we need to calculate the
        # corresponding weight.
        if info and sellable and info.mode == BarcodeInfo.MODE_PRICE:
            weight = info.price / sellable.price

        if info and sellable:
            self.quantity.set_value(weight)
        if barcode_data[0] != barcode:
            quantity_str = barcode_data[0].replace(',', '.')
            quantity_str = ''.join([p for p in quantity_str if p in '0123456789.'])
            self.quantity.set_value(float(quantity_str))

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
        widgets = [self.TillAddCash, self.TillRemoveCash, self.OpenDrawer,
                   self.TillOpen, self.TillClose, self.Sales]
        self.set_sensitive(widgets, False)

    def _till_status_changed(self, closed, blocked):
        if closed:
            text = _(u"Till closed")
        elif blocked:
            text = _(u"Till blocked")
        else:
            text = _(u"Till open")
        self.aditional_info.set_text(text)

        self.set_sensitive([self.TillOpen], closed)
        self.set_sensitive([self.TillClose,
                            self.TillAddCash,
                            self.TillRemoveCash], not closed or blocked)

        self._set_sale_sensitive(not closed and not blocked)

    def _update_widgets(self):
        has_sale_items = len(self.sale_items) >= 1
        self.set_sensitive((self.checkout_button, self.cancel_button,
                            self.remove_item_button,
                            self.ConfirmOrder), has_sale_items)
        # We can cancel an order whenever we have a coupon opened.
        self.set_sensitive([self.CancelOrder, self.DetailsViewer], self._sale_started)
        has_products = False
        has_services = False
        for sale_item in self.sale_items:
            if sale_item and sale_item.sellable.product:
                has_products = True
            if sale_item and sale_item.sellable.service:
                has_services = True
            if has_products and has_services:
                break
        # self.set_sensitive([self.delivery_button], has_products)
        # self.details_box.set_visible(has_sale_items)
        # self.hseparator2.set_visible(has_sale_items)  # workaround
        self.vbox9.set_visible(has_sale_items)
        logotype_path = get_company_logotype_path(self.conn)
        if has_sale_items:
            logo = gtk.gdk.pixbuf_new_from_file_at_size(logotype_path, LOGO_WIDTH,
                                                        LOGO_HEIGHT)
        else:
            logo = gtk.gdk.pixbuf_new_from_file_at_size(logotype_path, LOGO_WIDTH * 2,
                                                        LOGO_HEIGHT * 2)
        self.stoq_logo.set_from_pixbuf(logo)

        # self.set_sensitive([self.NewDelivery], has_sale_items)
        sale_item = self.sale_items.get_selected()
        can_edit = bool(
            sale_item is not None and
            sale_item.sellable.service and
            sale_item.sellable.service != self.param.DELIVERY_SERVICE)
        self.edit_item_button.set_visible(can_edit)

        self.set_sensitive((self.checkout_button,
                            self.ConfirmOrder), has_products or has_services)
        # self.till_status_box.props.visible = not self._sale_started
        self.sale_items.props.visible = self._sale_started

        self._update_totals()
        self._update_buttons()
        self._update_sellable_details()

    def _update_sellable_details(self, quantity=None, price=None):
        sale_item = self.sale_items.get_selected()
        sellable = sale_item and sale_item.sellable
        if sellable:
            self._image_slave.set_sellable(sellable)
        else:
            return

        if sale_item:
            markup = '<b>%s</b>\n%s x %s' % (
                sale_item.description,
                format_quantity(sale_item.quantity),
                get_formatted_price(sale_item.price))

            if sellable.service:
                fix_date = (sale_item.estimated_fix_date.strftime('%x')
                            if sale_item.estimated_fix_date else '')
                extra_markup_parts = [
                    (_("Estimated fix date"), fix_date),
                    (_("Notes"), sale_item.notes)]
            elif sellable.product:
                product = sellable.product
                manufacturer = product.manufacturer or ''
                extra_markup_parts = [
                    (_("Manufacturer"), manufacturer),
                    (_("Width"), product.width or ''),
                    (_("Height"), product.height or ''),
                    (_("Weight"), product.weight or '')]

            extra_markup = '\n'.join(
                '<b>%s</b>: %s' % (label, str(text))
                for label, text in extra_markup_parts if text)
        else:
            markup = ''
            extra_markup = ''
        self.details_lbl.set_markup(markup)
        self.details_lbl.set_tooltip_markup(markup)

        self.extra_details_lbl.set_markup(extra_markup)
        self.extra_details_lbl.set_tooltip_markup(extra_markup)

    def _has_barcode_str(self):
        return self.barcode.get_text().strip() != ''

    def _update_buttons(self):
        has_barcode = self._has_barcode_str()
        has_quantity = self._read_quantity() > 0
        self.set_sensitive([self.advanced_search], has_quantity)

    def _read_quantity(self):
        try:
            quantity = self.quantity.read()
        except ValidationError:
            quantity = 0
        return quantity

    def _update_quantity(self, qtt):
        self.quantity.update(qtt)

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
        if sellable.product:
            if not self._validate_sellable(sellable):
                return
        self._update_list(sellable)
        self.barcode.grab_focus()

    def _validate_sellable(self, sellable):
        nfce_status = NFCEBranchSeries.selectOneBy(station=get_current_station(self.conn), connection=self.conn)
        if not nfce_status:
            return True
        if nfce_status.is_active:
            errors = ValidateItemNFCEEvent.emit(sellable)
            if not errors:
                return True
            if len(errors) >= 1:
                msg = u'\n'.join([err for err in errors])
                error(msg)
                return False
        return True

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
            if not self._validate_sellable(sellable):
                return

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
        if sysparam(self.conn).NEGATIVE_STOCK:
            return True
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
        # FIXME: Canceling the editor still saves the changes.
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
            delivery_item = FakeSaleItem(sellable=delivery_service,
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
                    daily_code=Sale.get_last_daily_code(trans),
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
            sale_item.category_name = fake_sale_item.category_name

            if self._delivery and fake_sale_item.deliver:
                item = sale_item.addFacet(IDelivery,
                                          connection=trans)
                item.address = address_string
                DeliveryItem(sellable=fake_sale_item.sellable,
                             quantity=fake_sale_item.quantity,
                             delivery=item,
                             connection=trans,
                             sale=sale)
        return sale

    def _checkout(self):

        assert len(self.sale_items) >= 1

        trans = api.new_transaction()
        sale = self._create_sale(trans)
        if sale.daily_code:
            msg = u'últ. venda #{} de {}'.format(sale.daily_code,
                                                 get_formatted_price(sale.get_total_sale_amount()))
        else:
            msg = u'últ. venda #{} de {}'.format(sale.id,
                                                 get_formatted_price(sale.get_total_sale_amount()))
        if self.param.CONFIRM_SALES_ON_TILL:
            sale.order()
            self.nf_coupon(sale)
            trans.commit(close=True)
        else:
            assert self._coupon
            ordered = self._coupon.confirm(sale, trans)
            try:
                self.nfce_coupon(sale)
            except Exception, e:
                log.info("NFCe error: %s" % e)
                self._cancel_nfce_sale(sale, trans)
            try:
                self.nf_coupon(sale)
            except Exception, e:
                log.info("NonFiscal error: %s" % e)
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
        self.last_user_sale = msg
        self._coupon = None
        self._clear_order()
        self._update_time_label()

    def _cancel_nfce_sale(self, sale, trans):
        if sale.status == Sale.STATUS_RETURNED:
            return
        sale = trans.get(sale)
        renegotiation = RenegotiationData(
            reason=_("Cancel last document"),
            paid_total=sale.total_amount,
            invoice_number=sale.id,
            penalty_value=0,
            sale=sale,
            responsible=sale.salesperson,
            new_order=None,
            connection=trans)
        sale.return_(renegotiation)

    def _remove_selected_item(self):
        if not api.sysparam(self.conn).EMPLOYERS_CAN_REMOVE_ITEMS:
            if not run_dialog(UserPassword, None, self.conn):
                return
        sale_item = self.sale_items.get_selected()
        # self._coupon_remove_item(sale_item)
        if not sale_item:
            return
        self.sale_items.remove(sale_item)
        self._check_delivery_removed(sale_item)
        self._select_first_item()
        self._update_widgets()
        self.barcode.grab_focus()

    def _reprint_last_non_fiscal_sale(self):
        sale = Sale.get_last_sale(self.conn)
        try:
            SaleSLastEmitEvent.emit(sale)
        except:
            pass

    def _reprint_last_fiscal_sale(self):
        try:
            SalesNFCEReprintEvent.emit(None)
        except:
            pass

    def _add_note_selected_item(self, object_list=None, item=None):
        sale_item = self.sale_items.get_selected()
        if sale_item is None:
            raise StoqlibError("You should have a item selected "
                               "at this point")
        self.run_dialog(NoteEditor, self.conn, sale_item, 'notes', title=_("Notes"))

    def _checkout_or_add_item(self):
        search_str = self.barcode.get_text()
        if search_str == '':
            if len(self.sale_items) >= 1:
                self._checkout()
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
        self._update_time_label()
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
        secure_mode = sysparam(self.conn).NFCE_SECURE_MODE
        if secure_mode:
            if not run_dialog(UserPassword, get_current_toplevel(), self.conn, UserPassword.ADM):
                return
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

    def on_POSColor__activate(self, action):
        trans = new_transaction()
        csd = gtk.ColorSelectionDialog('Escolha a cor do PDV')
        cs = csd.colorsel
        cs.set_current_alpha(65536)
        if csd.run() != gtk.RESPONSE_OK:
            return
        c = cs.get_current_color()
        color = tohex((c.red / 65536.0, c.green / 65536.0, c.blue / 65536.0))
        pos_color = ParameterData.selectOneBy(field_name='POS_COLOR', connection=trans)
        pos_color.field_value = color
        csd.hide()
        trans.commit()
        trans.close()
        # change pos color
        self.eventbox_list_header_hbox.modify_bg(gtk.STATE_NORMAL, gtk.gdk.Color(color))
        self.eventbox_list_vbox.modify_bg(gtk.STATE_NORMAL, gtk.gdk.Color(color_variant(color, 20)))

    def on_ConfirmOrder__activate(self, action):
        self._checkout()

    def on_NewDelivery__activate(self, action):
        self._create_delivery()

    def on_TillVerify__activate(self, action):
        self._printer.verify_till()

    def on_TillClose__activate(self, action):
        self._close_till()

    def on_DetailsViewer__activate(self, button):
        self.details_box.set_visible(button.get_active())
        self.expander.set_visible(button.get_active())
        self.aspectframe1.set_visible(button.get_active())

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

    def on_impnf_button__clicked(self, button):
        self._reprint_last_non_fiscal_sale()

    def on_nfce_button__clicked(self, button):
        self._reprint_last_fiscal_sale()

    def on_delivery_button__clicked(self, button):
        self._create_delivery()

    def on_checkout_button__clicked(self, button):
        self._checkout()

    def on_cancel_button__clicked(self, button):
        secure_mode = sysparam(self.conn).NFCE_SECURE_MODE
        if secure_mode:
            if not run_dialog(UserPassword, get_current_toplevel(), self.conn, UserPassword.ADM):
                return
        self._cancel_order()

    def on_sellable_search_button__clicked(self, button):
        self.run_dialog(ProductSearch, self.conn, hide_footer=True,
                        hide_toolbar=True, hide_cost_column=True)

    def on_TillAddCash__activate(self, action):
        secure_mode = sysparam(self.conn).NFCE_SECURE_MODE
        if secure_mode:
            if not run_dialog(UserPassword, get_current_toplevel(), self.conn, UserPassword.VENDEDOR):
                return
        trans = new_transaction()
        payment = run_dialog(InPaymentEditor, get_current_toplevel(), trans)
        if payment:
            till = Till.get_current(trans)
            category_name = ''
            payments = [payment]
            description = payment.description
            category = payment.category
            if category:
                category_name = category.name
            till_entry = till.add_credit_entry(
                payment.value, (u'Suprimento: {}-{}'.format(category_name, description)))

            TillAddTillEntryEvent.emit(till_entry, trans)
            _create_transaction(trans, till_entry)
            retval = run_dialog(SaleInstallmentConfirmationSlave, self, trans,
                                payments=payments)

            self._update_widgets()
            trans.commit(True)
            CreatedInPaymentEvent.emit(payment)
        else:
            trans.close()

    def on_TillRemoveCash__activate(self, action):
        secure_mode = sysparam(self.conn).NFCE_SECURE_MODE
        if secure_mode:
            if not run_dialog(UserPassword, get_current_toplevel(), self.conn, UserPassword.VENDEDOR):
                return
        trans = new_transaction()
        payment = run_dialog(OutPaymentEditor, get_current_toplevel(), trans)
        if payment:
            category_name = ''
            till = Till.get_current(trans)
            payments = [payment]
            description = payment.description
            category = payment.category
            if category:
                category_name = category.name
            retval = run_dialog(SaleInstallmentConfirmationSlave, self, trans,
                                payments=payments)
            till_entry = till.add_debit_entry(
                payment.value, (u'Despesa: {}-{}'.format(category_name, description)))

            TillAddTillEntryEvent.emit(till_entry, trans)
            _create_transaction(trans, till_entry)

            self._update_widgets()
            trans.commit(True)
            CreatedOutPaymentEvent.emit(payment)
        else:
            trans.close()

    def on_OpenDrawer__activate(self, action):
        TillOpenDrawer.emit('')

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

    def nfce_coupon(self, sale):
        SalesNFCEEvent.emit(sale)

    def nf_coupon(self, sale):
        # só dispara... nao da erro nenhum
        try:
            SaleSEmitEvent.emit(sale)
        except:
            pass
