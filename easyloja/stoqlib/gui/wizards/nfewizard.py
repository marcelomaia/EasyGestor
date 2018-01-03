# -*- coding: utf-8 -*-
import tempfile
from kiwi.datatypes import ValidationError
from kiwi.enums import ListType
from kiwi.ui.dialogs import warning

from stoqlib.database.runtime import new_transaction
from stoqlib.domain.events import PurchaseNfeDownload
from stoqlib.domain.interfaces import ISupplier
from stoqlib.domain.person import Person
from stoqlib.domain.product import ProductAdaptToStorable, ProductStockItem, Product
from stoqlib.domain.sellable import Sellable, SellableUnit
from stoqlib.gui.base.dialogs import get_current_toplevel
from stoqlib.gui.base.wizards import BaseWizard, WizardEditorStep
from stoqlib.gui.slaves.nfeslaves import ProductsListSlave, NewProductListSlave, ProductListSlave
from stoqlib.lib.nfeimporter import NFeImporter
from stoqlib.lib.parameters import sysparam
from stoqlib.database.runtime import get_current_branch
from stoqlib.lib.translation import stoqlib_gettext

_ = stoqlib_gettext

class Entry():
    """An Sellable linked to a Product in XML.
    """
    entry_date = ''
    nfeid = ''
    supplier = ''
    notes = ''
    products = []


class NfeInfoDet(object):
    issuer_name = '...'
    issuer_doc = '...'
    issuer_address = '...'
    issuer_city = '...'
    emission = '...'
    op_nat = '...'
    total = '...'
    id = '...'
    receiver = '...'

    def __init__(self, *args, **kwargs):
        for arg in kwargs.keys():
            setattr(self, 'arg', kwargs.get('arg'))


class NFeProductsWizard(BaseWizard):
    # size = (600, 500)
    title = "Selecione uma NFE para dar entrada no Estoque!"

    def __init__(self, conn, model=None, edit_mode=False):
        self.conn = conn
        self.model = model
        self.retval = None
        self.first_step = NFeSelectStep(self, conn, model)
        BaseWizard.__init__(self, self.conn, self.first_step, model=self.model, edit_mode=edit_mode, title=self.title)

    def finish(self):
        # very heavy WOP, don't do it at home
        self.retval = self.first_step.next_step().model
        self.close()


class NFeSelectStep(WizardEditorStep):

    gladefile = 'NFeOrder'
    model_type = Entry
    products = ''
    xml = ''
    size = (950, 300)
    info_widgets = ('name_lbl', 'cnpj_lbl', 'address_lbl', 'city_lbl',
                    'emission_lbl', 'op_nat_lbl', 'total_lbl', 'id_lbl',
                    'receiver_lbl')

    def __init__(self, wizard, conn, model):
        self.xml = None
        self.nfe_info_det = NfeInfoDet()
        WizardEditorStep.__init__(self, conn, wizard, model)
        self.get_toplevel().set_size_request(*self.size)

    def insert_footer_msg(self, xml_path):
        try:
            self.xml = NFeImporter(xml_path)
            if self.xml.get_root():
                # suplier
                self.name_lbl.set_text(self.xml.get_issuer_name())               # issuer name
                self.cnpj_lbl.set_text(self.xml.get_issuer_document())           # cnpj cpf or ''
                self.address_lbl.set_text(self.xml.get_issuer_address())         # address
                self.city_lbl.set_text(self.xml.get_issuer_UF_city())            # city/uf
                # nf
                self.emission_lbl.set_text(self.xml.emission_date)
                self.op_nat_lbl.set_text(self.xml.operation_nature[:45])
                self.total_lbl.set_text(self.xml.total_purchase_amount)
                self.id_lbl.set_text(self.xml.nfe_id)
                self.receiver_lbl.set_text(self.xml.get_receiver_name())
        except IOError, e:
            pass

    def setup_slaves(self):
        import gtk
        # product slave
        products = self.create_products_slave('')

        # labels
        self.nf_label.set_bold(True)

        # filter
        filter = gtk.FileFilter()
        filter.set_name('XML')
        filter.add_pattern("*.xml")
        self.filechooserbutton.add_filter(filter)

    def create_products_slave(self, xml_path):
        products = ProductsListSlave(xml_path)
        products.show()
        #TODO it says that slave have been already attached, this is a WOP,
        self.attach_slave("placeholder", products)
        return products

    def reset_footer(self):
        dots = '...'
        self.name_lbl.set_text(dots)                # issuer name
        self.cnpj_lbl.set_text(dots)                # cnpj
        self.address_lbl.set_text(dots)             # address
        self.city_lbl.set_text(dots)                # city/uf
        # nf
        self.emission_lbl.set_text(dots)            # emission date
        self.op_nat_lbl.set_text(dots)              # emission date
        self.total_lbl.set_text(dots)               # emission date
        self.id_lbl.set_text(dots)                  # emission date

    def next_step(self):
        import datetime
        self.products = self.slaves['placeholder'].products                                        # update product list
        self.products = [product for product in self.products if product.select is True]           # filtra os marcados
        self.model.nfeid = self.xml.nfe_id
        self.model.entry_date = datetime.datetime.today()
        return NFeCommitStep(self.wizard, self.conn, self.model, self.products, self.xml)

    def has_previous_step(self):
        return False

    def validate_step(self):
        can_pass = len(self.slaves['placeholder'].info) > 0
        if not can_pass:
            warning(short='Precisa selecionar uma NFe antes', parent=get_current_toplevel())
        return can_pass

    def create_model(self, trans):
        return Entry()

    def get_xml_file(self):
        access_key = self.path.get_text()
        string_xml = PurchaseNfeDownload.emit(access_key)
        if not string_xml:
            return None
        filename = tempfile.mktemp(suffix='.xml', prefix='migrate_nfe')
        f = open(filename, 'wb')
        f.write(string_xml)
        f.close()

        return filename

    #
    # Callbacks
    #

    def on_filechooserbutton__selection_changed(self, widget):
        filename = widget.get_filename()
        self.path.set_text(filename)
        try:
            self.detach_slave("placeholder")                        # Workaround
        except LookupError:
            pass
        self.create_products_slave(xml_path=filename)
        self.insert_footer_msg(xml_path=filename)

    def on_path__activate(self, entry, *args, **kwargs):
        filename = self.get_xml_file()
        if not filename:
            return
        try:
            self.detach_slave("placeholder")                        # Workaround
        except LookupError:
            pass
        self.create_products_slave(xml_path=filename)
        self.insert_footer_msg(xml_path=filename)

    def on_path__validate(self, entry, value):
        if not value.isdigit():
            return ValidationError("Apenas numeros são permitidos na chave da NF-e")


class NFeCommitStep(WizardEditorStep):
    gladefile = 'NFeCommit'
    model_type = Entry

    def __init__(self, wizard, conn, model, products, xml):
        self.products = products
        self.xml = xml
        self.conn = conn
        WizardEditorStep.__init__(self, conn, wizard, model)

    def setup_slaves(self):
        prod_slave = ProductListSlave(self.products, self.xml, conn=self.conn)   # here is passed an array of Product() instance,
        prod_slave.set_list_type(ListType.UNADDABLE)
        self.attach_slave("placeholder", prod_slave)

    def has_next_step(self):
        return False

    def validate_confirm(self):
        return False

    def validate_step(self):
        slave = self.get_slave('placeholder')
        self.model.products = []

        if not slave.validate_linked():
            warning('Precisa vincular todos os itens',
                    'Clique duas vezes no item e selecione o item equivalente no estoque',
                    parent=get_current_toplevel())
        else:
            self.conn.commit()
            for product in slave.products:
                self.model.products.append(product)
            return True


class NFeProductBatchWizard(BaseWizard):
    title = "Cadastrar novos produtos através de NFe"

    def __init__(self, conn, first_step=None, model=None, title=None, size=None, edit_mode=False):
        first_step = NFeSelectStep2(self, conn, model)
        super(NFeProductBatchWizard, self).__init__(conn, first_step, model, title, size, edit_mode)

    def finish(self):
        # very heavy WOP, don't do it at home
        # self.retval = self.first_step.next_step().model
        self.retval = None
        self.close()


class NFeSelectStep2(NFeSelectStep):
    def next_step(self):
        import datetime
        self.products = self.slaves['placeholder'].products  # update product list
        self.products = [product for product in self.products if product.select is True]  # filtra os marcados
        self.model.nfeid = self.xml.nfe_id
        self.model.entry_date = datetime.datetime.today()
        return NFeImportProductsStep(self.wizard, self.conn, self.model, self.products, self.xml)


class NFeImportProductsStep(WizardEditorStep):
    gladefile = 'NFeCommit'
    model_type = Entry

    def __init__(self, wizard, conn, model, products, xml):
        self.products = products
        self.xml = xml
        self.conn = conn
        WizardEditorStep.__init__(self, conn, wizard, model)

    def setup_slaves(self):
        prod_slave = NewProductListSlave(self.products, self.xml, conn=self.conn)   # here is passed an array of Product() instance,
        prod_slave.set_list_type(ListType.READONLY)
        self.attach_slave("placeholder", prod_slave)

    def has_next_step(self):
        return False

    def validate_confirm(self):
        return False

    def validate_step(self):
        slave = self.get_slave('placeholder')
        self.model.products = []

        for product in slave.products:
            if product.sell_price <= 0:
                warning('Precisa colocar um preço de venda do produto',
                        parent=get_current_toplevel())
                return False
            if product.barcode == '' or product.barcode is None:
                warning('Precisa colocar um código de barras do produto',
                        parent=get_current_toplevel())
                return False
        for product in slave.products:
            has_sellable = False
            if product.barcode != '' and product.barcode is not None:
                has_sellable = Sellable.selectOneBy(barcode=product.barcode,
                                                    connection=self.conn)
            if has_sellable:
                warning('Produto %s \ncom cod. barras %s\n já está cadastrado no easyloja' %
                        (product.description, has_sellable.barcode),
                        parent=get_current_toplevel())
            else:
                self.create_product(product)
        return True

    def create_product(self, data):
        trans = new_transaction()
        default_tc = sysparam(self.conn).DEFAULT_PRODUCT_TAX_CONSTANT
        # suppliers = Person.iselect(ISupplier, connection=self.conn)
        unit = SellableUnit.selectOneBy(description=data.unit, connection=self.conn)
        if not unit:
            unit = SellableUnit(description=data.unit, connection=trans)

        # if not suppliers.count():
        #     raise ValueError('You must have at least one suppliers on your '
        #                      'database at this point.')
        quantity = float(data.quantity)
        status = Sellable.STATUS_UNAVAILABLE
        if quantity > 0:
            status = Sellable.STATUS_AVAILABLE

        sellable = Sellable(connection=trans,
                            status=status,
                            base_price=data.sell_price,
                            barcode=data.barcode,
                            description=data.description,
                            unit=unit,
                            cost=data.price,
                            tax_constant=default_tc)

        product = Product(sellable=sellable, ncm=data.ncm, connection=trans)
        storable = ProductAdaptToStorable(originalID=product,
                                          connection=trans)
        branch = get_current_branch(conn=self.conn)
        ProductStockItem(quantity=quantity, storable=storable, branch=branch, connection=trans)
        trans.commit(True)
        trans.close()