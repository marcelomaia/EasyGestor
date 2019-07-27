# -*- coding: utf-8 -*-
import gtk
from decimal import Decimal
from sys import maxint as MAXINT

from kiwi import ValueUnset
from kiwi.currency import currency
from kiwi.ui.dialogs import yesno
from kiwi.ui.listdialog import ListSlave
from kiwi.ui.objectlist import Column
from kiwi.ui.objectlist import ObjectList
from kiwi.ui.views import SlaveView
from stoqlib.api import api
from stoqlib.database.runtime import new_transaction
from stoqlib.domain.interfaces import IStorable
from stoqlib.domain.nfe import SellableNfe
from stoqlib.domain.product import Product
from stoqlib.domain.sellable import Sellable
from stoqlib.gui.base.dialogs import get_current_toplevel, run_dialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.gui.editors.producteditor import ProductEditor
from stoqlib.gui.search.sellablesearch import SellableSearch2
from stoqlib.lib.formatters import get_formatted_price, format_quantity
from stoqlib.lib.nfeimporter import (NFeImporter, PRODUCT_DESCRIPTION, PRODUCT_CEAN, PRODUCT_UNITARY_TRADE_VALUE,
                                     PRODUCT_COMMERCIAL_QUANTITY, PRODUCT_COMMERCIAL_UNITY, PRODUCT_TOTAL_GROSS_AMOUNT,
                                     PRODUCT_CODE, PRODUCT_NCM)
from stoqlib.lib.parameters import sysparam


class _Product():
    """An Sellable linked to a Product in XML.
    """
    product = ''  # code from nfe
    barcode = ''
    description = ''
    notes = ''
    price = ''
    quantity = ''
    unity = None
    total = ''
    nfeentry = ''
    sellable = None
    select = True

    def _compute_checksum(self, arg):
        """ Compute the checksum of bar code """
        # UPCA/EAN13
        weight = [1, 3] * 6
        magic = 10
        sum = 0

        for i in range(12):  # checksum based on first 12 digits.
            sum = sum + int(arg[i]) * weight[i]
        z = (magic - (sum % magic)) % magic
        if z < 0 or z >= magic:
            return None
        return z

    def validate_barcode(self, barcode):
        # if len == 12, calculate checksum
        if len(barcode) == 12:
            checksum = self._compute_checksum(barcode)
            if not checksum:
                return barcode
            barcode = barcode + str(checksum)
        return barcode

    def create_domain_product(self, conn):
        tax_constant = sysparam(conn).DEFAULT_PRODUCT_TAX_CONSTANT
        sellable = Sellable(description=self.description,
                            barcode=self.barcode,
                            tax_constant=tax_constant,
                            cost=self.price,
                            connection=conn)
        barcode = self.barcode if not sellable.check_barcode_exists(self.barcode) else ''
        sellable.code = self.product if not sellable.check_code_exists(self.product) else ''
        sellable.barcode = self.validate_barcode(barcode)
        sellable.unit = self.unity or sysparam(conn).SUGGESTED_UNIT
        retval = Product(connection=conn,
                         sellable=sellable,
                         ncm=self.ncm)
        retval.addFacet(IStorable, connection=conn)
        return retval

    def __str__(self):
        return "description: %s, " \
               "sellable %s" % (self.description,
                                str(self.sellable))


class ProductsListSlave(SlaveView):
    def __init__(self, xml_path):
        """ This class defines a table with various Product objects, these objects contains all data
        of a product extracted from a NFe.
        """
        self.products = []
        self.info = ObjectList([Column('description', data_type=str, title=u'Descrição', expand=True),
                                Column('barcode', data_type=str, title=u'Cod. barras'),
                                Column('product', data_type=str, title=u'id', ),
                                Column('price', data_type=currency, title=u'Preço', format_func=get_formatted_price),
                                Column('quantity', data_type=Decimal, title=u'Quantidade', format_func=format_quantity),
                                Column('unit', data_type=str, title=u'Un.'),
                                Column('total', data_type=currency, title=u'Total', format_func=get_formatted_price),
                                Column('split_parts', editable=True, data_type=float, title=u'Dividir em'),
                                Column('select', editable=True, data_type=bool, title=u'Selecionar')])

        try:
            xml = NFeImporter(xml_path)
            if xml.get_root():
                for prod_info in xml.get_all_item_info():
                    nfe_product = self.create_nfe_product(prod_info)  # creates an object from NFeProduct
                    self.info.append(nfe_product)  # the core
        except (IOError, AttributeError), e:
            pass
        SlaveView.__init__(self, self.info)

    def create_nfe_product(self, prod_info):
        nfe_product = _Product()
        barcode = prod_info[PRODUCT_CEAN]
        # somente digitos
        barcode = ''.join([p for p in barcode if p in '0123456789'])
        nfe_product.description = prod_info[PRODUCT_DESCRIPTION]
        nfe_product.barcode = barcode
        nfe_product.price = prod_info[PRODUCT_UNITARY_TRADE_VALUE]
        nfe_product.quantity = Decimal(prod_info[PRODUCT_COMMERCIAL_QUANTITY])
        nfe_product.unit = prod_info[PRODUCT_COMMERCIAL_UNITY]
        nfe_product.total = prod_info[PRODUCT_TOTAL_GROSS_AMOUNT]
        nfe_product.product = prod_info[PRODUCT_CODE]
        nfe_product.sell_price = 0
        nfe_product.ncm = prod_info[PRODUCT_NCM]
        nfe_product.split_parts = 1.0

        self.products.append(nfe_product)
        return nfe_product


class NewProductListSlave(ListSlave):
    model_type = _Product

    def __init__(self, products, xml, columns=None, conn=None,
                 orientation=gtk.ORIENTATION_VERTICAL):
        """
        Create a new ModelListDialog object.
        @param conn: A database connection
        """
        if not conn:
            conn = api.get_connection()
        self.conn = conn

        self._model_type = None
        self._reuse_transaction = False
        self._editor_class = None
        self.products = products
        self.xml = xml
        columns = columns or self.get_columns()
        ListSlave.__init__(self, columns, orientation)

    def get_columns(self):
        adj = gtk.Adjustment(upper=MAXINT, step_incr=1)
        colums = [Column('description', data_type=str, title=u'Descrição', expand=True,
                         sorted=True, editable=True),
                  Column('barcode', data_type=str, title=u'Cod. barras', editable=True),
                  Column('price', data_type=currency, title=u'Custo',
                         editable=True, spin_adjustment=adj, format_func=self._format_qty),
                  Column('sell_price', data_type=currency, title=u'Preço de venda',
                         editable=True, spin_adjustment=adj, format_func=self._format_qty),
                  Column('quantity', data_type=float, title=u'Estoque',
                         editable=True, spin_adjustment=adj, format_func=self._format_qty),
                  Column('unit', data_type=str, title=u'Un.'),
                  Column('ncm', data_type=str, title=u'ncm')]
        return colums

    def _format_qty(self, quantity):
        if quantity is ValueUnset:
            return None
        if quantity >= 0:
            return quantity

    def populate(self):
        return self.products

    def edit_item(self, item):
        return True


class ProductListSlave(ListSlave):
    model_type = _Product

    def __init__(self, products, xml, columns=None, conn=None,
                 orientation=gtk.ORIENTATION_VERTICAL):
        """
        Create a new ModelListDialog object.
        @param conn: A database connection
        """
        if not conn:
            conn = api.get_connection()
        self.conn = conn

        self._model_type = None
        self._reuse_transaction = False
        self._editor_class = None
        self.products = products
        self.xml = xml
        columns = columns or self.get_columns()
        ListSlave.__init__(self, columns, orientation)

    def get_columns(self):
        colums = [Column('description', data_type=str, title=u'Descrição', expand=True, sorted=True),
                  Column('price', data_type=currency, title=u'Preço'),
                  Column('barcode', data_type=str, title=u'Cod. barras'),
                  Column('quantity', data_type=float, title=u'Quantidade'),
                  Column('unit', data_type=str, title=u'Un.'),
                  Column('total', data_type=currency, title=u'Total'),
                  Column('product', data_type=str, title=u'Código NFe'),
                  Column('sellable.code', data_type=int, title=u'Código Easygestor')]
        return colums

    def populate(self):
        """ Must return an array of model_type
        """

        for item in self.products:
            # sellable can be a valid sellable result of False
            sellable = SellableNfe.get_sellable(salesperson_doc=self.xml.get_issuer_document(),
                                                code=item.product)
            if sellable:
                item.sellable = sellable
        return self.products

    def edit_item(self, item):
        sellable = None

        if yesno('Associar a Produto:', parent=get_current_toplevel(), default=gtk.RESPONSE_YES,
                 buttons=(('Existente', gtk.RESPONSE_YES), ('Novo', gtk.RESPONSE_NO))) == gtk.RESPONSE_YES:

            sellable_view_item = run_dialog(SellableSearch2, get_current_toplevel(),
                                            self.conn,
                                            selection_mode=gtk.SELECTION_BROWSE, quantity=1,
                                            double_click_confirm=True,
                                            info_message=u"Selecionar Item a ser vinculado à NFe",
                                            hide_footer=True)
            sellable = Sellable.get(sellable_view_item.id, connection=self.conn)

        else:
            with api.trans() as trans:
                model = item.create_domain_product(trans)
                product = run_dialog(ProductEditor, self, trans, model=model)
                sellable = product.sellable if hasattr(product, 'sellable') else None

        if not sellable:
            return False

        has_sellable = SellableNfe.get_sellable(salesperson_doc=self.xml.get_issuer_document(),
                                                code=item.product)
        if not has_sellable:
            # create entry on db
            trans = new_transaction()
            sellable_nfe = SellableNfe(connection=trans,
                                       sellable=sellable,
                                       code=item.product,
                                       salesperson_doc=self.xml.get_issuer_document())
            trans.commit(close=True)
        else:
            # update table
            sellable_nfe = SellableNfe.selectOneBy(connection=self.conn,
                                                   code=item.product,
                                                   salesperson_doc=self.xml.get_issuer_document())
            sellable_nfe.sellable = sellable  # changes te database row

        item.sellable = sellable  # links a sellable to a item
        return bool(sellable_view_item)

    def validate_linked(self):
        retval = True
        for product in self.products:
            try:
                if product.sellable is None:
                    retval = False
            except AttributeError, e:
                retval = False
        return retval


class NFeProductEditor(BaseEditor):
    """A base class for person role editors. This class can not be
    instantiated directly.
    """
    size = (700, -1)
    model_type = _Product
    gladefile = 'NFeProductEditor'
    widgets = ('product', 'description')

    def __init__(self, conn, model=None, visual_mode=True):
        BaseEditor.__init__(self, conn, model, visual_mode=visual_mode)

    #
    # BaseEditor hooks
    #

    def on_confirm(self):
        return self.model
