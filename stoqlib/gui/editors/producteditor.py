# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

""" Editors definitions for products"""
import gtk
import sys
from decimal import Decimal

from kiwi import ValueUnset
from kiwi.datatypes import ValidationError, currency
from kiwi.ui.dialogs import warning, error
from kiwi.ui.widgets.list import Column, SummaryLabel
from stoq.gui.shell import get_shell
from stoqdrivers.enum import TaxType
from stoqlib.api import api
from stoqlib.database.exceptions import IntegrityError
from stoqlib.database.orm import AND
from stoqlib.database.runtime import get_current_branch, new_transaction
from stoqlib.domain.events import ProductStockUpdateEvent, BuscaProdutoEvent
from stoqlib.domain.interfaces import IStorable
from stoqlib.domain.person import PersonAdaptToSupplier
from stoqlib.domain.product import (ProductSupplierInfo, Product,
                                    ProductComponent,
                                    ProductQualityTest, GroupAttribute, Attribute, _ProductAttribute, ProductStockItem,
                                    ProductAttribute,
                                    ProductSerialNumber, ProductAdaptToStorable, ProductInitialStock)
from stoqlib.domain.sellable import (Sellable,
                                     SellableTaxConstant, SellableCategory)
from stoqlib.domain.views import ProductFullStockView
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.base.lists import ModelListSlave
from stoqlib.gui.base.search import SearchEditor
from stoqlib.gui.dialogs.initialstockdialog import InitialStockDialog, _TemporaryStorableItem
from stoqlib.gui.dialogs.progressdialog import ProgressDialog
from stoqlib.gui.editors.baseeditor import (BaseEditor, BaseEditorSlave,
                                            BaseRelationshipEditorSlave)
from stoqlib.gui.editors.categoryeditor import SellableCategoryEditor
from stoqlib.gui.editors.sellableeditor import SellableEditor
from stoqlib.gui.editors.sellableuniteditor import SellableUnitEditor
from stoqlib.gui.slaves.productslave import (ProductDetailsSlave,
                                             ProductTaxSlave)
from stoqlib.lib.formatters import get_formatted_cost, get_price_format_str
from stoqlib.lib.message import info, yesno
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.pluginmanager import get_plugin_manager
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext


#
# Slaves
#

class _TemporaryProductComponent(object):
    def __init__(self, product=None, component=None, quantity=Decimal(1),
                 design_reference=u''):
        self.product = product
        self.component = component
        self.quantity = quantity
        self.design_reference = design_reference

        if self.component is not None:
            # keep this values in memory in order to speed up the
            # data access
            sellable = self.component.sellable
            self.id = sellable.id
            self.description = sellable.get_description()
            self.category = sellable.get_category_description()
            self.unit = sellable.get_unit_description()
            self.production_cost = self.component.get_production_cost()

    def _get_product_component(self, connection):
        return ProductComponent.selectOneBy(
            product=self.product, component=self.component,
            connection=connection)

    #
    # Public API
    #

    def get_total_production_cost(self):
        return self.production_cost * self.quantity

    def delete_product_component(self, connection):
        component = self._get_product_component(connection)
        if component is not None:
            ProductComponent.delete(component.id,
                                    connection=connection)

    def add_or_update_product_component(self, connection):
        component = self._get_product_component(connection)
        if component is not None:
            # updating
            component.quantity = self.quantity
            component.design_reference = self.design_reference
        else:
            # adding
            ProductComponent(product=self.product,
                             component=self.component,
                             quantity=self.quantity,
                             design_reference=self.design_reference,
                             connection=connection)


class ProductComponentSlave(BaseEditorSlave):
    gladefile = 'ProductComponentSlave'
    model_type = _TemporaryProductComponent

    def __init__(self, conn, product=None):
        self._product = product
        self._remove_component_list = []
        BaseEditorSlave.__init__(self, conn, model=None)
        self._setup_widgets()

    def _get_columns(self):
        return [Column('id', title=_(u'Code'), data_type=int,
                       expander=True, sorted=True),
                Column('quantity', title=_(u'Quantity'),
                       data_type=Decimal),
                Column('unit', title=_(u'Unit'), data_type=str),
                Column('description', title=_(u'Description'),
                       data_type=str, expand=True),
                Column('category', title=_(u'Category'), data_type=str),
                # Translators: Ref. is for Reference (as in design reference)
                Column('design_reference', title=_(u'Ref.'), data_type=str),
                Column('production_cost', title=_(u'Production Cost'),
                       format_func=get_formatted_cost, data_type=currency),
                Column('total_production_cost', title=_(u'Total'),
                       format_func=get_formatted_cost, data_type=currency),
                ]

    def _setup_widgets(self):
        self.component_combo.prefill(list(self._get_products()))

        self.component_tree.set_columns(self._get_columns())
        self._populate_component_tree()
        self.component_label = SummaryLabel(klist=self.component_tree,
                                            column='total_production_cost',
                                            label='<b>%s</b>' % _(u'Total:'),
                                            value_format='<b>%s</b>')
        self.component_label.show()
        self.component_tree_vbox.pack_start(self.component_label, False)
        self._update_widgets()

    def _get_products(self, sort_by_name=True):
        # FIXME: This is a kind of workaround until we have the
        # SQLCompletion funcionality, then we will not need to sort the
        # data.
        if sort_by_name:
            attr = 'description'
        else:
            attr = 'sellable_category.description'

        products = []
        for product_view in ProductFullStockView \
                .select(connection=self.conn).orderBy(attr):
            if product_view.product is self._product:
                continue

            description = product_view.get_product_and_category_description()
            products.append((description, product_view.product))

        return products

    def _update_widgets(self):
        has_selected = self.component_combo.read() is not None
        self.add_button.set_sensitive(has_selected)
        has_selected = self.component_tree.get_selected() is not None
        self.edit_button.set_sensitive(has_selected)
        self.remove_button.set_sensitive(has_selected)

        # FIXME: This is wrong. Summary label already calculates the total. We
        # are duplicating this.
        value = self.get_component_cost()
        self.component_label.set_value(get_formatted_cost(value))

    def _populate_component_tree(self):
        self._add_to_component_tree()

    def _get_components(self, product):
        for component in ProductComponent.selectBy(product=product,
                                                   connection=self.conn):
            yield _TemporaryProductComponent(product=component.product,
                                             component=component.component,
                                             quantity=component.quantity,
                                             design_reference=component.design_reference)

    def _add_to_component_tree(self, component=None):
        parent = None
        if component is None:
            # load all components that already exists
            subcomponents = self._get_components(self._product)
        else:
            if component not in self.component_tree:
                self.component_tree.append(None, component)
            subcomponents = self._get_components(component.component)
            parent = component

        for subcomponent in subcomponents:
            self.component_tree.append(parent, subcomponent)
            # recursively add the children
            self._add_to_component_tree(subcomponent)

    def _can_add_component(self, component):
        if component.component.is_composed_by(self._product):
            return False
        return True

    def _run_product_component_dialog(self, product_component=None):
        update = True
        if product_component is None:
            update = False
            component = self.component_combo.get_selected_data()
            product_component = _TemporaryProductComponent(
                product=self._product, component=component)
            # If we try to add a component which is already in tree,
            # just edit it
            for component in self.component_tree:
                if component.component == product_component.component:
                    update = True
                    product_component = component
                    break

        if not self._can_add_component(product_component):
            product_desc = self._product.sellable.get_description()
            component_desc = product_component.description
            info(_(u'You can not add this product as component, since '
                   '%s is composed by %s' % (component_desc, product_desc)))
            return

        model = run_dialog(ProductComponentEditor, get_current_toplevel(), self.conn,
                           product_component)
        if not model:
            return

        if update:
            self.component_tree.update(model)
        else:
            self._add_to_component_tree(model)
        self._update_widgets()

    def _edit_component(self):
        # Only allow edit the root components, since its the component
        # that really belongs to the current product
        selected = self.component_tree.get_selected()
        root = self.component_tree.get_root(selected)
        self._run_product_component_dialog(root)

    def _totally_remove_component(self, component):
        descendants = self.component_tree.get_descendants(component)
        for descendant in descendants:
            # we can not remove an item twice
            if descendant not in self.component_tree:
                continue
            else:
                self._totally_remove_component(descendant)
        self.component_tree.remove(component)

    def _remove_component(self, component):
        # Only allow remove the root components, since its the component
        # that really belongs to the current product
        root_component = self.component_tree.get_root(component)

        msg = _("This will remove the component \"%s\". Are you sure?" %
                root_component.description)
        if not yesno(msg, gtk.RESPONSE_NO,
                     _("Remove component"),
                     _("Keep component")):
            return

        self._remove_component_list.append(root_component)
        self._totally_remove_component(root_component)
        self._update_widgets()

    #
    # BaseEditorSlave
    #

    def setup_proxies(self):
        self.proxy = self.add_proxy(self._product, ['production_time'])
        # FIXME:
        self.production_time.set_value(self._product.production_time)

    def create_model(self, conn):
        return _TemporaryProductComponent(product=self._product)

    def on_confirm(self):
        for component in self._remove_component_list:
            component.delete_product_component(self.conn)

        for component in self.component_tree:
            component.add_or_update_product_component(self.conn)

        return self.model

    def validate_confirm(self):
        return len(self.component_tree) > 0

    def get_component_cost(self):
        value = 0
        for component in self.component_tree:
            if self.component_tree.get_parent(component):
                continue
            value += component.get_total_production_cost()
        return value

    #
    # Kiwi Callbacks
    #

    def on_component_combo__content_changed(self, widget):
        self._update_widgets()

    def on_component_tree__selection_changed(self, widget, value):
        self._update_widgets()

    def on_component_tree__row_activated(self, widget, selected):
        self._edit_component()

    def on_component_tree__row_expanded(self, widget, value):
        self._update_widgets()

    def on_add_button__clicked(self, widget):
        self._run_product_component_dialog()

    def on_edit_button__clicked(self, widget):
        self._edit_component()

    def on_remove_button__clicked(self, widget):
        selected = self.component_tree.get_selected()
        self._remove_component(selected)

    def on_sort_components_check__toggled(self, widget):
        sort_by_name = not widget.get_active()
        self.component_combo.prefill(
            self._get_products(sort_by_name=sort_by_name))
        self.component_combo.select_item_by_position(0)


#
#   Quality Test Editor & Slave
#


class QualityTestEditor(BaseEditor):
    model_name = _('Quality Test')
    model_type = ProductQualityTest
    gladefile = 'QualityTestEditor'

    proxy_widgets = ['description', 'test_type']
    confirm_widgets = ['description']

    def __init__(self, conn, model, product):
        self._product = product
        BaseEditor.__init__(self, conn=conn, model=model)

    def _setup_widgets(self):
        self.sizegroup1.add_widget(self.decimal_value)
        self.sizegroup1.add_widget(self.boolean_value)
        self.test_type.prefill([(value, key)
                                for key, value in ProductQualityTest.types.items()])
        self.boolean_value.prefill([(_('True'), True), (_(('False')), False)])

        # Editing values
        if self.model.test_type == ProductQualityTest.TYPE_BOOLEAN:
            self.boolean_value.select(self.model.get_boolean_value())
        else:
            min_value, max_value = self.model.get_range_value()
            self.min_value.set_value(min_value)
            self.max_value.set_value(max_value)

    def create_model(self, conn):
        return ProductQualityTest(product=self._product, connection=conn)

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        if self.model.test_type == ProductQualityTest.TYPE_BOOLEAN:
            self.model.set_boolean_value(self.boolean_value.read())
        else:
            self.model.set_range_value(self.min_value.read(),
                                       self.max_value.read())
        return self.model

    #
    #   Callbacks
    #

    def on_test_type__changed(self, widget):
        if self.model.test_type == ProductQualityTest.TYPE_BOOLEAN:
            self.boolean_value.show()
            self.decimal_value.hide()
        else:
            self.boolean_value.hide()
            self.decimal_value.show()


class ProductQualityTestSlave(ModelListSlave):
    model_type = ProductQualityTest

    def __init__(self, conn, product):
        self._product = product
        ModelListSlave.__init__(self)
        self.set_reuse_transaction(self._product.get_connection())
        self.set_editor_class(QualityTestEditor)
        self.set_model_type(self.model_type)

    #
    #   ListSlave Implementation
    #

    def get_columns(self):
        return [Column('description', title=_(u'Description'),
                       data_type=str, expand=True),
                Column('type_str', title=_(u'Type'), data_type=str),
                Column('success_value_str', title=_(u'Success Value'), data_type=str),
                ]

    def populate(self):
        return self._product.quality_tests

    def run_dialog(self, dialog_class, *args, **kwargs):
        kwargs['product'] = self._product
        return ModelListSlave.run_dialog(self, dialog_class, *args, **kwargs)


#
#   Product Supplier Editor & Slave
#

class ProductSupplierEditor(BaseEditor):
    model_name = _('Product Supplier')
    model_type = ProductSupplierInfo
    gladefile = 'ProductSupplierEditor'

    proxy_widgets = ('base_cost', 'icms', 'notes', 'lead_time',
                     'minimum_purchase',)
    confirm_widgets = ['base_cost', 'icms', 'lead_time', 'minimum_purchase']

    def _setup_widgets(self):
        unit = self.model.product.sellable.unit
        if unit is None:
            description = _(u'Unit(s)')
        else:
            description = unit.description
        self.unit_label.set_text(description)
        self.base_cost.set_digits(sysparam(self.conn).COST_PRECISION_DIGITS)
        self.base_cost.set_adjustment(
            gtk.Adjustment(lower=0, upper=sys.maxint, step_incr=1))
        self.minimum_purchase.set_adjustment(
            gtk.Adjustment(lower=0, upper=sys.maxint, step_incr=1))

    #
    # BaseEditor hooks
    #

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def validate_confirm(self):
        return self.base_cost.read() > 0

    #
    # Kiwi handlers
    #

    def on_minimum_purchase__validate(self, entry, value):
        if not value or value <= Decimal(0):
            return ValidationError("Minimum purchase must be greater than zero.")

    def on_base_cost__validate(self, entry, value):
        if not value or value <= currency(0):
            return ValidationError("Value must be greater than zero.")

    def on_lead_time__validate(self, entry, value):
        if value < 1:
            return ValidationError("Lead time must be greater or equal one day")


class ProductSupplierSlave(BaseRelationshipEditorSlave):
    """A slave for changing the suppliers for a product.
    """
    target_name = _(u'Supplier')
    editor = ProductSupplierEditor
    model_type = ProductSupplierInfo

    def __init__(self, conn, product):
        self._product = product
        BaseRelationshipEditorSlave.__init__(self, conn)

        suggested = sysparam(conn).SUGGESTED_SUPPLIER
        if suggested is not None:
            self.target_combo.select(suggested)

    def get_targets(self):
        suppliers = PersonAdaptToSupplier.get_active_suppliers(self.conn)
        return [(s.person.name, s) for s in suppliers]

    def get_relations(self):
        return self._product.get_suppliers_info()

    def get_columns(self):
        return [Column('name', title=_(u'Supplier'),
                       data_type=str, expand=True, sorted=True),
                Column('lead_time_str', title=_(u'Lead time'), data_type=str),
                Column('minimum_purchase', title=_(u'Minimum Purchase'),
                       data_type=Decimal),
                Column('base_cost', title=_(u'Cost'), data_type=currency,
                       format_func=get_formatted_cost)]

    def create_model(self):
        product = self._product
        supplier = self.target_combo.get_selected_data()

        if product.is_supplied_by(supplier):
            product_desc = self._product.sellable.get_description()
            info(_(u'%s is already supplied by %s' % (product_desc,
                                                      supplier.person.name)))
            return

        model = ProductSupplierInfo(product=product,
                                    supplier=supplier,
                                    connection=self.conn)
        model.base_cost = product.sellable.cost
        return model


class GroupAttributeEditor(BaseEditor):
    gladefile = 'GroupAttributeEditor'
    model_type = GroupAttribute
    model_name = 'Grupo de Atributo'
    proxy_widgets = ('type', 'notes', 'description')
    size = (420, 250)

    def __init__(self, conn, model=None, visual_mode=False):
        super(GroupAttributeEditor, self).__init__(conn, model, visual_mode)

    def create_model(self, trans):
        return GroupAttribute(connection=self.conn)

    def setup_widgets(self):
        prefill = [('TEXTO', GroupAttribute.TYPE_TEXT),
                   ('COR', GroupAttribute.TYPE_COLOR),
                   ('BOOLEANO', GroupAttribute.TYPE_BOOLEAN)]
        self.type.prefill(prefill)

    def setup_proxies(self):
        self.setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        self.conn.commit()
        return self.model


class AttributeEditor(BaseEditor):
    gladefile = 'AttributeEditor'
    model_type = Attribute
    model_name = 'Atributo'
    proxy_widgets = ('description', 'value', 'notes', 'group_attribute')
    size = (420, 250)

    def create_model(self, trans):
        return Attribute(connection=self.conn)

    def setup_widgets(self):
        groups = GroupAttribute.selectBy(connection=self.conn).orderBy('description')
        items = [(a.description, a) for a in groups]
        self.group_attribute.prefill(items)
        self.colorbutton.hide()
        self.bool_button.hide()
        self.value.hide()

    def setup_proxies(self):
        self.setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        group = self.group_attribute.read()
        assert group
        self.model.group_attribute = group
        if group.type == GroupAttribute.TYPE_TEXT:
            self.model.value = self.description.read()
        elif group.type == GroupAttribute.TYPE_BOOLEAN:
            self.model.value = str(int(self.bool_button.read()))
        self.conn.commit()
        return self.model

    #
    # Callbacks
    #
    def on_colorbutton__color_set(self, button):
        self.model.value = button.get_color().to_string()  # string color #ff0000

    def on_bool_button__content_changed(self, button):
        bool_value = button.read()  # button.read() returns bool
        self.model.value = str(int(bool_value))  # 0 or 1 str value

    def on_group_attribute__validate(self, arg1, arg2):
        group = self.group_attribute.read()

        # This part show and hides the widgets according to the group type
        if group.type == GroupAttribute.TYPE_COLOR:
            self.value.hide()
            self.bool_button.hide()
            self.colorbutton.show()  # show only collor button
            if self.model is not None:
                self.colorbutton.set_color(gtk.gdk.Color(self.model.value))

        elif group.type == GroupAttribute.TYPE_TEXT:
            self.colorbutton.hide()
            self.bool_button.hide()
            self.value.hide()  # show only textview

        elif group.type == GroupAttribute.TYPE_BOOLEAN:
            self.colorbutton.hide()
            self.value.hide()
            self.bool_button.show()  # show only radio
            if self.model is not None:
                self.bool_button.update(int(self.model.value))


class _ProductAttributeEditor(BaseEditor):
    gladefile = 'ProductAttributeEditor'
    model_type = _ProductAttribute
    model_name = 'Atributo de produto'

    proxy_widgets = ('price', 'quantity', 'description')
    size = (420, 250)

    def _setup_widgets(self):
        self.price.set_data_format(get_price_format_str())
        self.quantity.set_data_format(get_price_format_str())
        self.product.hide()
        self.product_lbl.hide()
        self.product_img.hide()
        self.quantity.hide()
        self.quantity_lbl.hide()
        self.quantity_img.hide()

    def create_model(self, trans):
        return _ProductAttribute()

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        return self.model


class ProductAttributeEditor(BaseEditor):
    gladefile = 'ProductAttributeEditor'
    model_type = ProductAttribute
    model_name = 'Atributo de produto'

    proxy_widgets = ('price', 'quantity', 'description', 'product')
    size = (420, 250)

    def _setup_widgets(self):
        products = Product.select(
            connection=self.trans)
        try:
            list = [(self.model.product.sellable.description,
                     self.model.product)]
        except AttributeError:
            list = []
        list += [(p.sellable.description, p) for p in products]

        self.product.prefill(list)
        self.price.set_data_format(get_price_format_str())

        appname = get_shell()._appname
        # this is a hack
        if appname == 'purchase':
            self.quantity.hide()
            self.quantity_img.hide()
            self.quantity_lbl.hide()
        elif appname == 'stock':
            self.price.hide()
            self.image3.hide()
            self.kiwilabel3.hide()

    def create_model(self, trans):
        return ProductAttribute(connection=trans, branch=get_current_branch(self.conn))

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def on_confirm(self):
        assert self.model.product
        self.model.branch = get_current_branch(self.conn)
        return self.model


class GridSearch(SearchEditor):
    title = _('Busca por itens de grade')
    editor_class = ProductAttributeEditor
    table = ProductAttribute
    size = (800, 550)
    count = 0

    def get_columns(self):
        return [Column('product.sellable.description', _('Product'), data_type=str, width=120),
                Column('description', _('Description'), data_type=str, expand=True, sorted=True),
                Column('quantity', _('Quantity'), data_type=long),
                Column('price', _('Price'), data_type=Decimal, ),
                Column('branch.original.name', _('Branch'), data_type=str, width=90, visible=False)]

    def create_filters(self):
        self.set_searchbar_labels('Buscar por descrição')
        self.set_text_field_columns(['description'])

    def key_Delete(self):
        """ Why this method is called twice?
        """
        # TODO solve this bug... This try to recover a inexistent object on the second call.
        # Why it is called twice?
        self.count += 1  # this is a workaround
        if self.count == 2:
            obj = self.results.get_selected()  # here happens the bug :/

            if obj is None:
                raise AssertionError("There should be at least one item selected")
            else:
                if yesno(_("Isto irá apagar um item da grade, este está ligado a um produto Pai,"
                           "\nisto não afetará o estoque."
                           "\nDeseja continuar?"),
                         gtk.RESPONSE_NO,
                         _("Yes"),
                         _("No")):
                    try:
                        ProductAttribute.delete(obj.id, connection=self.conn)
                    except Exception, e:
                        print 'erro ao deletar item', e.message
                self.count = 0
                self.conn.commit()
                self.search.refresh()


class ProductGridSlave(BaseEditorSlave):
    """A slave for changing the product_attribute from product
    """
    gladefile = 'ProductGridSlave'
    model_type = Product
    has_grid = False

    def __init__(self, conn, model=None, visual_mode=False):
        super(ProductGridSlave, self).__init__(conn, model, visual_mode)
        self.combinations = []
        self.group_vec = []
        self.attrs = {}
        self.new_conn = new_transaction()
        self.stock_item = ProductStockItem.selectOneBy(storable=self.model.id,
                                                       branch=get_current_branch(self.conn),
                                                       connection=self.conn)
        self.setup_widgets()

    def setup_widgets(self):
        groups = GroupAttribute.selectBy(connection=self.new_conn).orderBy('description')
        items_group = [(a.description, a) for a in groups]
        self.group.prefill(items_group)
        # grid buttons
        self.new_button.set_tooltip_text('Novo item de grade')
        self.edit_button.set_tooltip_text('Editar item da grade')
        self.delete_button.set_tooltip_text('Excluir item da grade')

        # attribute buttons
        self.new_attribute.set_tooltip_text('Novo atributo')
        self.edit_attribute.set_tooltip_text('Editar atributo')
        self.delete_attribute.set_tooltip_text('Excluir atributo')

        # group buttons
        self.new_attribute_group.set_tooltip_text('Novo grupo')
        self.edit_attribite_group.set_tooltip_text('Editar grupo')
        self.delete_attribute_group.set_tooltip_text('Excluir grupo')
        self.create_grid.set_sensitive(False)
        attributes = ProductAttribute.selectBy(product=self.model, connection=self.conn)
        if attributes:
            self.has_grid = True
            self.add_to_grid_button.set_sensitive(False)

            items = []
            for attribute in attributes:
                items.append((attribute.description, attribute))
            self.combinations = items
            self.grid.prefill(self.combinations)

    def enable_delete_attribute_group_button(self):
        group = self.group.read()
        # if group has not attribute linked
        try:
            self.delete_attribute_group.set_sensitive(group.get_attributes().count() == 0)
        except AttributeError:
            pass

    def refresh(self):
        self.setup_widgets()

    def can_add_to_grid(self):
        return self.attribute.read()

    def do_combinations(self, attr_dict):
        """ Receives a dict, the dict keys are groups of class GroupAttribute
         the dict values are array of Attribute. So, this way, we can access
         all attributes linked to a group.
         --------------------------------------
         Returns a array of all combinations of attributes
        """

        columns = attr_dict.keys()
        aux = []
        comb = []
        for keys in columns:
            aux.append(attr_dict[keys])  # forms a matrix of attributes linked to a group

        if len(columns) == 1:  # matrix 1x1 handling
            for i in aux[0]:
                product = _ProductAttribute()
                product.description = i.description  # sets description

                comb.append((i.description, product))

        if len(columns) == 2:  # matrix 2x2 handling
            for i in aux[0]:
                for j in aux[1]:
                    product = _ProductAttribute()
                    product.description = i.description + '; ' + j.description

                    comb.append((i.description + '; ' + j.description, product))

        if len(columns) == 3:  # matrix 3x3 handling
            for i in aux[0]:
                for j in aux[1]:
                    for k in aux[2]:
                        product = _ProductAttribute()
                        product.description = i.description + '; ' + j.description + '; ' + k.description

                        comb.append((i.description + '; '
                                     + j.description + '; '
                                     + k.description, product))
        for desc, product in comb:
            try:
                product.quantity = long(self.stock_item.quantity / len(comb))
            except:
                product.quantity = long(0)
            product.price = self.model.sellable.base_price
        return comb

    def reset(self):
        self.group_vec = []
        self.attrs = {}
        self.new_conn.close()

    #
    # Callbacks
    #

    def on_group__content_changed(self, cb, ):
        self.attribute.clear()

        group = cb.read()
        attributes = Attribute.selectBy(group_attribute=group, connection=self.new_conn).orderBy('description')
        items_group = [(a.description, a) for a in attributes]
        self.attribute.prefill(items_group)
        self.enable_delete_attribute_group_button()

    def on_new_button__clicked(self, button):
        if self.has_grid:
            product = run_dialog(ProductAttributeEditor, get_current_toplevel(), self.conn, None)
            self.conn.commit()
        else:
            product = run_dialog(_ProductAttributeEditor, get_current_toplevel(), self.conn, None)
        if product:
            self.combinations.append((product.description, product))
            self.grid.prefill(self.combinations)

    def on_edit_button__clicked(self, button):
        model = self.grid.read()
        if self.has_grid:
            run_dialog(ProductAttributeEditor, get_current_toplevel(), self.conn, model)
            self.conn.commit()
        else:
            run_dialog(_ProductAttributeEditor, get_current_toplevel(), self.conn, model)

    def on_new_attribute__clicked(self, button):
        run_dialog(AttributeEditor, get_current_toplevel(), self.new_conn, None)
        self.new_conn.commit()
        self.refresh()

    def on_new_attribute_group__clicked(self, button):
        run_dialog(GroupAttributeEditor, get_current_toplevel(), self.new_conn, None)
        self.new_conn.commit()
        self.refresh()

    def on_edit_attribite_group__clicked(self, button):
        group = self.group.read()
        run_dialog(GroupAttributeEditor, get_current_toplevel(), self.new_conn, group)
        self.new_conn.commit()
        self.refresh()

    def on_edit_attribute__clicked(self, button):
        attribute = self.attribute.read()
        run_dialog(AttributeEditor, get_current_toplevel(), self.new_conn, attribute)
        self.new_conn.commit()
        self.refresh()

    def on_delete_attribute_group__clicked(self, button):
        group = self.group.read()
        try:
            GroupAttribute.delete(group.id, connection=self.conn)
        except IntegrityError, e:
            error('Não foi possível apagar o grupo. '
                  '\n Por favor, apague todos os atributos relacionados à este grupo', e.message)

        self.conn.commit()
        self.refresh()

    def on_delete_attribute__clicked(self, button):
        attribute = self.attribute.read()
        Attribute.delete(attribute.id, connection=self.conn)
        self.conn.commit()
        self.refresh()

    def on_add_to_grid_button__clicked(self, button):
        self.create_grid.set_sensitive(True)
        group = self.group.read()
        attributes = self.attrs

        if len(self.attrs) == 3 and group not in attributes:  # means that there are 3 groups and a new has arrived
            warning('Não pode fazer operação', 'O numero máximo de grupos na grade é 3', get_current_toplevel())
            self.add_to_grid_button.set_tooltip_text('O limite de tamanho da grade é 3 grupos diferentes!')

            items = []
            for group in self.attrs.keys():
                items.append((group.description, group))  # fill only the used groups
            self.group.prefill(items)

        elif self.can_add_to_grid():
            self.grid.popup()  # grid popup

            # Here happens the core of grid

            if not group in attributes:
                attributes[group] = [self.attribute.read()]  # create a dictionary entry
            else:
                attributes[group] += [self.attribute.read()]  # update

            self.combinations = self.do_combinations(attributes)
            self.grid.set_wrap_width(len(attributes))  # set number of columns
            self.grid.prefill(self.combinations)

    def on_delete_button__clicked(self, button):
        if yesno('Você quer realmente apagar essa combinação',
                 gtk.RESPONSE_NO, _("Yes"), _("No")):
            index = self.grid.get_active()
            if self.has_grid:
                pass  # not erasing yet
            else:
                self.combinations.pop(index)  # remove the entry
                self.grid.prefill(self.combinations)  # fill again

    def on_create_grid__clicked(self, button):
        if yesno('Você quer realmente criar a grade de produtos?',
                 gtk.RESPONSE_NO, _("Yes"), _("No")):
            self.add_to_grid_button.set_sensitive(False)
            self.create_grid.set_sensitive(False)
            for desc, product in self.combinations:
                ProductAttribute(connection=self.new_conn,  # create a product_attribute on database
                                 price=product.price,
                                 quantity=product.quantity,
                                 description=product.description,
                                 product=self.model.id,
                                 branch=get_current_branch(self.new_conn))
                self.new_conn.commit()

    def on_confirm(self):
        self.reset()
        return super(ProductGridSlave, self).on_confirm()

    def on_cancel(self):
        self.reset()
        return super(ProductGridSlave, self).on_cancel()


#
# Editors
#


class ProductComponentEditor(BaseEditor):
    gladefile = 'ProductComponentEditor'
    proxy_widgets = ['quantity', 'design_reference']
    title = _(u'Product Component')
    model_type = _TemporaryProductComponent

    def _setup_widgets(self):
        self.component_description.set_text(self.model.description)
        self.quantity.set_adjustment(
            gtk.Adjustment(lower=0, upper=sys.maxint, step_incr=1,
                           page_incr=10))
        # set a default quantity value for new components
        if not self.model.quantity:
            self.quantity.set_value(1)

    #
    # BaseEditor
    #

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(
            self.model, ProductComponentEditor.proxy_widgets)

    def validate_confirm(self):
        return self.quantity.read() > 0

    #
    # Kiwi Callbacks
    #

    def on_quantity__validate(self, widget, value):
        if not value > 0:
            # FIXME: value < upper bound
            return ValidationError(_(u'The component quantity must be '
                                     'greater than zero.'))


class ProductEditor(SellableEditor):
    model_name = _('Product')
    model_type = Product
    help_section = 'product'
    ui_form_name = 'product'

    _model_created = False

    def get_taxes(self):
        constants = SellableTaxConstant.select(connection=self.conn)
        return [(c.description, c) for c in constants
                if c.tax_type != TaxType.SERVICE]

    def update_status_unavailable_label(self):
        text = ''
        if self.statuses_combo.read() == Sellable.STATUS_UNAVAILABLE:
            text = ("<b>%s</b>"
                    % _("This status changes automatically when the\n"
                        "product is purchased or an inicial stock is added."))

        self.status_unavailable_label.set_text(text)

    def _get_plugin_tabs(self):
        manager = get_plugin_manager()
        tab_list = []

        for plugin_name in manager.active_plugins_names:
            plugin = manager.get_plugin(plugin_name)
            if plugin.has_product_slave:
                slave_class = plugin.get_product_slave_class()
                plugin_product_slave = slave_class(self.conn, self.model)
                tab_list.append((slave_class.title, plugin_product_slave))

        return tab_list

    #
    # BaseEditor
    #

    def setup_slaves(self):
        self.details_slave = ProductDetailsSlave(self.conn, self.model.sellable,
                                                 self.db_form)
        self.add_extra_tab(_(u'Details'), self.details_slave)

        for tabname, tabslave in self.get_extra_tabs():
            self.add_extra_tab(tabname, tabslave)

        storable = ProductAdaptToStorable.selectOneBy(original=self.model.id, connection=self.conn)
        self.stock_item = ProductStockItem.selectOneBy(storable=storable,
                                                       branch=get_current_branch(self.conn),
                                                       connection=self.conn)
        if self.stock_item is not None:
            self.stock_label.show()
            self.stock_label.update("%.2f itens em %s" % (self.stock_item.quantity,
                                                          self.stock_item.branch.person.name))
        else:
            self.stock_label.hide()

    def get_extra_tabs(self):
        extra_tabs = []
        extra_tabs.extend(self._get_plugin_tabs())

        suppliers_slave = ProductSupplierSlave(self.conn, self.model)
        extra_tabs.append((_(u'Suppliers'), suppliers_slave))

        tax_slave = ProductTaxSlave(self.conn, self.model)
        extra_tabs.append((_(u'Taxes'), tax_slave))

        storable = ProductAdaptToStorable.selectOneBy(original=self.model.id, connection=self.conn)
        self.stock_item = ProductStockItem.selectOneBy(storable=storable,
                                                       branch=get_current_branch(self.conn),
                                                       connection=self.conn)
        if self.stock_item is not None:
            grid_slave = ProductGridSlave(self.conn, self.model)
            extra_tabs.append((_(u'Grid'), grid_slave))
        return extra_tabs

    def setup_widgets(self):
        self.cost.set_digits(sysparam(self.conn).COST_PRECISION_DIGITS)
        self.consignment_yes_button.set_active(self.model.consignment)
        self.consignment_yes_button.set_sensitive(self._model_created)
        self.consignment_no_button.set_sensitive(self._model_created)
        self.update_status_unavailable_label()
        self.description.grab_focus()
        manager = get_plugin_manager()
        self.barcode_search.set_visible(False)
        if manager.is_active('busca_produto'):
            self.barcode.grab_focus()
            self.barcode_search.set_visible(True)
            self.barcode_search.set_tooltip_text('Clique para buscar o produto')
        if manager.is_active('ebiecf'):
            self.label9.show()
            self.tax_hbox.show()

    def create_model(self, conn):
        self._model_created = True
        tax_constant = sysparam(conn).DEFAULT_PRODUCT_TAX_CONSTANT
        sellable = Sellable(tax_constant=tax_constant,
                            connection=conn)
        sellable.unit = sysparam(self.conn).SUGGESTED_UNIT
        model = Product(connection=conn, sellable=sellable)
        model.addFacet(IStorable, connection=conn)
        return model

    def _barcode_search(self):
        barcode = self.barcode.read()
        product_data = BuscaProdutoEvent.emit(barcode)
        if product_data:
            category_desc = getattr(product_data, 'category')
            self.description.update(getattr(product_data, 'description'))
            self.details_slave.info_slave.manufacturer.update(getattr(product_data, 'brand'))
            self.details_slave.info_slave.ncm.update(getattr(product_data, 'ncm'))
            self.details_slave.notes.update(getattr(product_data, 'ncm_description'))
            img_pth = getattr(product_data, 'img_path')
            if category_desc != '':
                category = self.get_or_create_sellable_category(category_desc)
                self.setup_sellable_category_combo()
                self.category_combo.select(category)
            if img_pth:
                product_image = gtk.gdk.pixbuf_new_from_file_at_size(img_pth, 64, 64)
                self.details_slave.image_slave.image.set_from_pixbuf(product_image)
                f = open(img_pth, 'rb')
                img_bytes = f.read()
                self.model.image = img_bytes
                self.model.full_image = img_bytes
                f.close()
        else:
            info('Produto não encontrado na base',
                 description='Possuimos mais de 17 milhões de produtos cadastrados. '
                             'Infelizmente seu produto não foi encontrado. ')

    def on_consignment_yes_button__toggled(self, widget):
        self.model.consignment = widget.get_active()

    def on_confirm(self):
        storable = ProductAdaptToStorable.selectOneBy(original=self.model.id, connection=self.conn)
        if storable.get_stock_item(get_current_branch(self.conn)) is None:
            run_dialog(LightInitialStockDialog, get_current_toplevel(), storable, self.conn, self.trans)
        return self.model

    def get_or_create_sellable_category(self, desc):
        current_trans = api.new_transaction()
        cat = SellableCategory.selectOneBy(description=str(desc), connection=current_trans)
        if not cat:
            cat = SellableCategory(description=str(desc),
                                   category=api.sysparam(current_trans).DEFAULT_BASE_CATEGORY,
                                   connection=current_trans)
        current_trans.commit(True)
        return cat

    def on_barcode__activate(self, arg):
        self._barcode_search()

    def on_barcode_search__clicked(self, arg):
        self._barcode_search()

    def on_add_category__clicked(self, button):
        trans = api.new_transaction()
        category = run_dialog(SellableCategoryEditor, get_current_toplevel(), trans, model=None)
        trans.commit(close=True)
        if category:
            self.setup_sellable_category_combo()
            self.category_combo.select(category)

    def on_add_unit__clicked(self, button):
        trans = api.new_transaction()
        unit = run_dialog(SellableUnitEditor, get_current_toplevel(), trans)
        trans.commit(close=True)
        if unit:
            self.setup_unit_combo()
            self.unit_combo.select(unit)


class LightInitialStockDialog(InitialStockDialog):
    def __init__(self, storable, conn, trans, branch=None):
        if branch is None:
            self._branch = get_current_branch(conn)
        else:
            self._branch = branch
        self.trans = trans
        self.storable = storable
        BaseEditor.__init__(self, conn, model=object())
        self._setup_widgets()

    def _setup_widgets(self):
        # XXX: the branch should be in bold font
        self.branch_label.set_text(
            u"Registrando estoque inicial para o produto em %s" % self._branch.person.name)
        self.branch_label.set_bold(True)

        self._storables = [_TemporaryStorableItem(s)
                           for s in ProductAdaptToStorable.selectBy(id=self.storable.id,
                                                                    connection=self.conn)
                           if s.get_stock_item(self._branch) is None]

        self.slave.listcontainer.add_items(self._storables)

    def _add_initial_stock(self):
        for item in self._storables:
            self._validate_initial_stock_quantity(item, self.trans)

    def _validate_initial_stock_quantity(self, item, trans):
        positive = item.initial_stock > 0
        if item.initial_stock is not ValueUnset and positive:
            self.increase_stock(item.initial_stock, self._branch, self.storable.product)

    def increase_stock(self, quantity, branch, product):
        if quantity <= 0:
            raise ValueError(_("quantity must be a positive number"))
        stock_item = ProductStockItem.selectOneBy(storable=self.storable.id,
                                                  branch=branch,
                                                  connection=self.trans)
        if stock_item is None:
            # If the stock_item is missing create a new one
            stock_item = ProductStockItem(
                storable=self.storable.id,
                branch=branch,
                connection=self.trans)
            initial_stock = ProductInitialStock(
                storable=self.storable.id,
                branch=branch,
                initial_quantity=quantity,
                connection=self.trans)
        # If previously lacked quantity change the status of the sellable
        if not stock_item.quantity:
            sellable = product.sellable
            if sellable:
                # Rename see bug 2669
                sellable.can_sell()

        old_quantity = stock_item.quantity
        stock_item.quantity += quantity

        ProductStockUpdateEvent.emit(self.storable, branch, old_quantity,
                                     stock_item.quantity)


class ProductionProductEditor(ProductEditor):
    _cost_msg = _(u'Cost must be greater than the sum of the components.')

    def _is_valid_cost(self, cost):
        if hasattr(self, '_component_slave'):
            component_cost = self._component_slave.get_component_cost()
            return cost >= component_cost
        return True

    def create_model(self, conn):
        model = ProductEditor.create_model(self, conn)
        model.is_composed = True
        return model

    def get_extra_tabs(self):
        self._component_slave = ProductComponentSlave(self.conn, self.model)
        tax_slave = ProductTaxSlave(self.conn, self.model)
        quality_slave = ProductQualityTestSlave(self.conn, self.model)
        return [(_(u'Components'), self._component_slave),
                (_(u'Taxes'), tax_slave),
                (_(u'Quality'), quality_slave),
                ]

    def validate_confirm(self):
        if not self._is_valid_cost(self.cost.read()):
            info(self._cost_msg)
            return False

        confirm = self._component_slave.validate_confirm()
        if not confirm:
            info(_(u'There is no component in this product.'))
        return confirm

    def on_confirm(self):
        self._component_slave.on_confirm()
        storable = ProductAdaptToStorable.selectOneBy(original=self.model.id, connection=self.conn)
        branch = get_current_branch(self.conn)
        stock_item = ProductStockItem.selectOneBy(storable=storable.id,
                                                  branch=branch,
                                                  connection=self.trans)
        if stock_item is None:
            # permite vender e da estoque = 0
            stock_item = ProductStockItem(
                storable=storable.id,
                branch=branch,
                connection=self.trans,
                quantity=0)
            sellable = self.model.sellable
            if sellable:
                sellable.can_sell()
        return self.model

    def on_cost__validate(self, widget, value):
        if value <= 0:
            return ValidationError(_(u'Cost cannot be zero or negative.'))
        if not self._is_valid_cost(value):
            return ValidationError(self._cost_msg)


class ProductStockEditor(BaseEditor):
    model_name = _('Product')
    model_type = Product
    gladefile = 'HolderTemplate'

    def setup_slaves(self):
        details_slave = ProductDetailsSlave(self.conn, self.model.sellable)
        details_slave.hide_stock_details()
        self.attach_slave('place_holder', details_slave)


class ProductSerialNumberEditor(BaseEditor):
    model_name = _('Serial Number')
    model_type = ProductSerialNumber
    gladefile = 'ProductSerialNumber'
    proxy_widgets = ['notes', 'serial_number', 'product']
    size = (400, 450)

    def setup_proxies(self):
        self.setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def create_model(self, trans):
        branch = get_current_branch(self.conn)
        return ProductSerialNumber(connection=trans,
                                   product=None,
                                   sale=None,
                                   branch=branch, )

    def setup_widgets(self):
        products = Product.selectBy(connection=self.conn)
        items = [(p.sellable.description, p) for p in products]
        self.product.prefill(items)

    #
    # Callbacks
    #

    def on_product__validate(self, combo, product):
        """ This validation method counts the amount of
        ProductStockItem in stock and ProductSerialNumber with status IN_STOCK
        """
        product_with_serial_number = ProductSerialNumber.selectBy(connection=self.conn,
                                                                  product=product,
                                                                  status=ProductSerialNumber.IN_STOCK).count()

        product_stock = ProductStockItem.select(AND(ProductStockItem.q.storableID == ProductAdaptToStorable.q.id,
                                                    ProductAdaptToStorable.q.originalID == product.id))
        quantity_on_stock = 0
        for product in product_stock:
            quantity_on_stock += product.quantity

        if product_with_serial_number >= quantity_on_stock:  # can't create another entry of ProductSerialNumber
            return ValidationError(_("exists %d products in stock and %d products with serial number"
                                     % (quantity_on_stock, product_with_serial_number)))
