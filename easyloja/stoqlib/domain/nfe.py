# -*- coding: utf-8 -*-
import datetime

from stoqlib.database.orm import (ForeignKey, IntCol, UnicodeCol, BoolCol,
                                  ORMObject, DecimalCol,
                                  StringCol, DateTimeCol, BLOBCol)
from stoqlib.domain.base import Domain
from stoqlib.domain.interfaces import IDescribable
from stoqlib.exceptions import DatabaseInconsistency
from stoqlib.lib.translation import stoqlib_gettext
from zope.interface.declarations import implements

_ = stoqlib_gettext


class NFCEBranchSeries(Domain):
    """Indicates the series for a given station
    """
    SERIAL, SPOOLER = (0, 1)
    modes = {SERIAL: 'Serial',
             SPOOLER: 'Spooler'}

    (DARUMA,
     EPSON,
     MP4200TH,
     DARUMADT35,
     MP2500TH,
     MP100S,
     ELGINI9) = range(7)

    printers = {DARUMA: _('Daruma'),
                EPSON: _('Epson'),
                MP4200TH: _('MP4200 TH'),
                DARUMADT35: _('Daruma DT35'),
                MP2500TH: _('MP2500 TH'),
                MP100S: _('MP100S TH'),
                ELGINI9: _('Elgin i9')}

    implements(IDescribable)
    series = UnicodeCol(default=None)  # série
    number = IntCol(default=1)
    station = ForeignKey('BranchStation')
    is_active = BoolCol(default=True)
    mode = IntCol(default=SPOOLER)
    printer = IntCol(default=DARUMA)
    port = UnicodeCol(default='COM1')
    speed = IntCol(default=115200)
    spooler_printer = UnicodeCol(default='')

    def get_description(self):
        return u'Computador {}, série {}, número {}'.format(self.station.name, self.series, self.number)


class NFeProduct(Domain):
    """An Sellable linked to a Product in XML.

    @param product: the product code, in NFe, refers to => cProd
    @param sellable:
    @param supplier: a person in database
    @param notes:
    """

    product = StringCol(default=None)  # code from nfe
    description = StringCol(default=None)
    sellable = ForeignKey('Sellable', default=None)
    notes = StringCol(default=None)
    nfeentry = ForeignKey('NFeEntry', default=None)
    price = StringCol(default=None)
    quantity = StringCol(default=None)
    unity = StringCol(default=None)
    total = StringCol(default=None)

    @property
    def supplier(self):
        return self.nfeentry.supplier


class NFeEntry(Domain):
    """ This class refers to a NFe Entry, it is supposed to save all info from a NFe
    """
    entry_date = DateTimeCol(default=None)
    nfeid = StringCol(default=None)  # like NFe35130845170289000125550100000777701006666334
    supplier = ForeignKey('PersonAdaptToSupplier', default=None)
    notes = StringCol(default=None)

    # @argcheck(NFeProduct)
    def add_item(self, nfe_product):
        nfe_product.nfeentry = self

    def get_items(self):
        conn = self.get_connection()
        return NFeProduct.selectBy(nfeentry=self,
                                   connection=conn).orderBy(NFeProduct.q.id)

    # @argcheck(NFeProduct)
    def remove_item(self, nfe_product):
        NFeProduct.delete(nfe_product.id, connection=self.get_connection())


class SellableNfe(Domain):
    """ The docs...
    """
    sellable = ForeignKey('Sellable', default=None)
    code = StringCol(default=None)
    salesperson_doc = StringCol(default=None)

    @classmethod
    def get_sellable(cls, salesperson_doc, code):
        """ This method returns the sellable if exists 
        @param salesperson_doc: the document of salesperson
        @param code: the code of product on nfe
        @type salesperson_doc: str
        @type code: str
        """
        result = cls.selectOneBy(salesperson_doc=salesperson_doc,
                                 code=code)
        if result is not None:
            return result.sellable
        else:
            return False

    @classmethod
    def enty_exists(cls, salesperson_doc, code):
        """ This method returns the sellable if exists
        @param salesperson_doc: the document of salesperson
        @param code: the code of product on nfe
        @type salesperson_doc: str
        @type code: str
        @rtype: bool
        """
        return len(cls.selectOneBy(salesperson_doc=salesperson_doc,
                                   code=code)) > 0

    @classmethod
    def iselectOneBy(cls, iface, *args, **kwargs):
        return super(SellableNfe, cls).iselectOneBy(iface, *args, **kwargs)


class NFeCityData(ORMObject):
    """Information about Brazil states and cities.

    @ivar state_code: the unique code that represents a certain state.
    @ivar state_name: the name of the state.
    @ivar city_code: the unique code that represents a certain city.
    @ivar city_name: the name of the city.
    """
    state_code = IntCol()
    state_name = UnicodeCol()
    city_code = IntCol()
    city_name = UnicodeCol()


class NFeVolume(Domain):
    """
    Information about volume in NFe, useful when a transporter exists in a sale.
    """
    implements(IDescribable)

    quantity = IntCol(default=0)
    unit = UnicodeCol(default='caixa')
    brand = UnicodeCol(default='')
    number = UnicodeCol(default='')
    net_weight = DecimalCol(default=0)
    gross_weight = DecimalCol(default=0)
    sale = ForeignKey('Sale', default=None)

    # IDescribable

    def get_description(self):
        return "%s unidade(s) de %s" % (self.quantity, self.unit)


class NFeContract(Domain):
    """
    Information of contracts
    """
    implements(IDescribable)

    (NFE100,
     NFE200,
     NFCE300,
     NFCE600,
     NFE_LICENCIAMENTO,
     NCFE_LICENCIAMENTO) = range(6)

    contract_values = {NFE100: 100,
                       NFE200: 200,
                       NFCE300: 300,
                       NFCE600: 600,
                       NFE_LICENCIAMENTO: 10000,
                       NCFE_LICENCIAMENTO: 10000}

    contract_types = {
        NFE100: '100 -- NFes mensais',
        NFE200: '200 -- NFes mensais',
        NFCE300: '300 -- NFCes mensais',
        NFCE600: '600 -- NFCes mensais',
        NFE_LICENCIAMENTO: 'LICENCIAMENTO NFe',
        NCFE_LICENCIAMENTO: 'LICENCIAMENTO NFCe'
    }

    key = UnicodeCol(default='')
    contract = IntCol(default=2)
    company = ForeignKey('PersonAdaptToCompany')
    start_date = DateTimeCol(default=datetime.datetime.now())
    end_date = DateTimeCol(default=datetime.datetime.today() + datetime.timedelta(days=182))

    # IDescribable

    def get_description(self):
        return "Contrato {} de {}".format(self.contract, self.company.fancy_name)

    @classmethod
    def get_contract_name(cls, contract):
        if not contract in cls.contract_types:
            raise DatabaseInconsistency(_("Invalid status %d") % contract)
        return cls.contract_types[contract]


class NFESaleHistory(Domain):
    """
        Holds fiscal information about the sales.
    """
    sale = ForeignKey('Sale')

    number = IntCol(default=None)  # número
    series = UnicodeCol(default=None)  # série
    key = UnicodeCol(default=None)  # chave de acesso
    auth = UnicodeCol(default=None)  # protocolo de autorização
    send_date = DateTimeCol(default=None)
    cnpj_emit = UnicodeCol(default=None)
    description = UnicodeCol(default=None)
    code = UnicodeCol(default=None)
    xml64 = BLOBCol(default=None)
    pdf64 = BLOBCol(default=None)

    def has_confirmed(self):
        return self.code == '100'

    def can_cancel(self):
        # TODO: levantar a lista de statuses que podem ser liberados nesse caso
        return True
        # return self.has_confirmed()

    def can_issue_letter(self):
        # TODO: levantar a lista de statuses que podem ser liberados nesse caso
        return True
        # return self.code == NfeConfirmedStatus()

    def recipient_email(self):
        retval = self.sale.client.person.email
        return None if retval == '' else retval

    @property
    def status_description(self):
        return "%s - %s" % (self.code, self.description)

    @staticmethod
    def get_last_invoice_number(conn, branch):
        return conn.queryOne("""SELECT MAX(nfe.number) FROM nfe_sale_history nfe
            INNER JOIN sale ON nfe.sale_id=sale.id
            WHERE sale.branch_id=%s""" % (branch.id,))


class NFCESaleHistory(Domain):
    """Holds fiscal information about the sales.
    """
    sale = ForeignKey('Sale')

    number = IntCol(default=None)  # número
    series = UnicodeCol(default=None)  # série
    key = UnicodeCol(default=None)  # chave de acesso
    auth = UnicodeCol(default=None)  # protocolo de autorização
    send_date = DateTimeCol(default=None)

    @staticmethod
    def get_last_invoice_number(conn, branch):
        return conn.queryOne("""SELECT MAX(nfce.number) FROM nfce_sale_history nfce
                INNER JOIN sale ON nfce.sale_id=sale.id
                WHERE sale.branch_id=%s""" % (branch.id,))[0]


class NFeCartaCorrecao(Domain):
    """ This class refers to a NFeSaleHistory
    """
    sequence = IntCol()
    nfe_key = StringCol(default=None)
    nfe_sale_history = ForeignKey('NFESaleHistory', default=None)
    reason = StringCol(default=None)
    xml64 = BLOBCol(default=None)
    pdf64 = BLOBCol(default=None)

    @classmethod
    def get_last_sequence(cls, sale_hist, conn):
        return NFeCartaCorrecao.selectBy(nfe_sale_history=sale_hist, connection=conn).max('sequence') or 0