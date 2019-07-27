# -*- coding: utf-8 -*-
from stoqlib.domain.product import ProductSerialNumber
from stoqlib.domain.sellable import Sellable
from stoqlib.gui.editors.baseeditor import BaseEditor


class ProductAttributeDialog(BaseEditor):
    gladefile = "ProductAttributeDialog"
    title = "Selecione um atributo"
    model_type = Sellable
    proxy_widgets = ("description",)

    def __init__(self, conn, model, attributes, visual_mode=False):
        self.model = model
        self.conn = conn
        self.attributes = attributes
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()

    def _setup_widgets(self):
        attributes = []
        for attribute in self.attributes:
            attributes.append((attribute.description, attribute))
        self.description.prefill(sorted(attributes))
        self.description.grab_focus()

    def on_description__changed(self, cb):
        attribute = cb.read()
        if attribute is not None:
            self.quantity.update(attribute.quantity)
            self.price.update(attribute.price)

    def on_confirm(self):
        attribute = self.description.read()
        assert attribute
        return attribute


class ProductSerialDialog(BaseEditor):
    gladefile = "ProductSerialDialog"
    title = "Serial Number"
    model_type = Sellable

    def __init__(self, conn, model, sale, product_serials):
        self.model = model
        self.conn = conn
        self.sale = sale
        self.attributes = product_serials
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()

    def _setup_widgets(self):
        #TODO colocar o label do desc do sale item
        attributes = []
        for attribute in self.attributes:
            attributes.append((attribute.serial_number, attribute))
        self.description = self.model.description
        self.serial_number.prefill(sorted(attributes))
        self.serial_number.grab_focus()

    def on_confirm(self):
        attribute = self.serial_number.read()
        attribute.sale = self.sale
        assert attribute
        return attribute