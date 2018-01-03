# -*- coding: utf-8 -*-
from xml.dom import minidom
from pyexpat import ExpatError
import datetime

try:
    import xmltodict
except ImportError, e:
    print "xmltodict not found: => https://pypi.python.org/pypi/xmltodict <=",

# NFE
ROOT = 'nfeProc'
NFE = 'NFe'
NFE_INF = 'infNFe'
NFE_INFO = 'ide'

NFE_VERSION = 'versao'
EMISSION_DATE = 'dhEmi'
SERIE = 'serie'
OPERATION_NATURE = 'natOp'

#products
PRODUCTS_AND_SERVICE_LIST = 'det'
PRODUCT = 'prod'
PRODUCT_CODE = 'cProd'
PRODUCT_CEAN = 'cEAN'
PRODUCT_DESCRIPTION = 'xProd'
PRODUCT_NCM = 'NCM'
PRODUCT_CFOP = 'CFOP'
PRODUCT_COMMERCIAL_UNITY = 'uCom'
PRODUCT_COMMERCIAL_QUANTITY = 'qCom'
PRODUCT_UNITARY_TRADE_VALUE = 'vUnCom'
PRODUCT_TOTAL_GROSS_AMOUNT = 'vProd'
PRODUCT_CEANTRIB = 'cEANTrib'
PRODUCT_TAXABLE_UNITY = 'uTrib'
PRODUCT_TAXABLE_QUANTITY = 'qTrib'
PRODUCT_TAXABLE_UNITARY_VALUE = 'vUnTrib'
PRODUCT_TOTALIZE_INDEX = 'indTot'

# taxes
TAXES = 'imposto'
TAXES_TOTAL_VALUE = 'vTotTrib'
TAXES_ICMS = 'ICMS'
TAXES_ICMS40 = 'ICMS40'
TAXES_GOODS_ORIG = 'orig'           # 0 national, 1 stranger , 2 stranger
TAXES_CST = 'CST'                   # Tributação do ICMS
TAXES_IPI = 'IPI'
TAXES_CONTEXT_IPI = 'cEnq'
TAXES_IPINT = 'IPINT'
TAXES_PIS = 'PIS'
TAXES_PISNT = 'PISNT'
TAXES_CONFINS = 'COFINS'
TAXES_COFINSNT = 'COFINSNT'

# issuer
ISSUER = 'emit'

# document
CNPJ = 'CNPJ'
CPF = 'CPF'

# general
NAME = 'xNome'

# address
ADDRESS_ISSUER = 'enderEmit'
PLACE = 'xLgr'
CITY = 'xMun'
UF = 'UF'
DISTRICT = 'xBairro'
NUMBER = 'nro'

# receiver
RECEIVER = 'dest'


class NFeImportError(Exception):
    """Base exception for all nfe"""

    def __init__(self, error=''):
        Exception.__init__(self, error)


class NFeImporter(object):
    def __init__(self, xml_path):
        """ Before using this class, please, check out if the xml is valid,
        """
        try:
            self.xml = minidom.parse(xml_path).toxml()              # xml str value
            self.dict = xmltodict.parse(self.xml)
        except (ExpatError, AttributeError):
            pass

    #
    # General
    #

    def get_xml(self):
        return self.xml

    def get_nfe_info(self):
        return self.get_root()[NFE][NFE_INF]

    @property
    def nfe_id(self):
        return self.get_nfe_info()['@Id']

    def get_root(self):
        try:
            return self.dict[ROOT]
        except (KeyError, AttributeError), e:
            print "Error, could not get root from XML: %s" % e

    @property
    def emission_date(self):
        # TODO: Return a datetime
        try:
            tmp = self.get_nfe_info()[NFE_INFO][EMISSION_DATE]
            dt = datetime.datetime.strptime(tmp[:-6], '%Y-%m-%dT%H:%M:%S')
        except KeyError, e:
            tmp = self.get_nfe_info()[NFE_INFO]['dEmi']
            dt = datetime.datetime.strptime(tmp, '%Y-%m-%d')
        # 2015-12-22T14:19:00-03:00
        return dt.strftime('%d/%m/%y %H:%M:%S')

    @property
    def operation_nature(self):
        return self.get_nfe_info()[NFE_INFO][OPERATION_NATURE]

    @property
    def total_purchase_amount(self):
        total = 0
        for product in self.get_all_item_info():
            total += float(product[PRODUCT_TOTAL_GROSS_AMOUNT])
        return "%.2f" % total

    #
    # Issuer
    #

    def get_issuer_name(self):
        return self.get_nfe_info()[ISSUER][NAME]

    def get_issuer_address_root(self):
        return self.get_nfe_info()[ISSUER][ADDRESS_ISSUER]

    def get_issuer_address(self):
        addr_root = self.get_issuer_address_root()
        return addr_root[PLACE] + ', ' + addr_root[NUMBER] + ', ' + addr_root[DISTRICT]

    def get_issuer_UF_city(self):
        addr_root = self.get_issuer_address_root()
        return addr_root[CITY] + '/' + addr_root[UF]

    def get_issuer_cnpj(self):
        return self.get_nfe_info()[ISSUER][CNPJ]

    def get_issuer_cpf(self):
        return self.get_nfe_info()[ISSUER][CPF]

    def get_issuer_document(self):
        try:
            return self.get_issuer_cpf()
        except KeyError, e:
            return self.get_issuer_cnpj()

    #
    # Products
    #

    def get_product_details(self):
        return self.get_nfe_info()[PRODUCTS_AND_SERVICE_LIST]

    def get_all_item_info(self):
        """ Workarround method: Returns an array with info of product or service
        @rtype: List
        """
        products = []
        prod_details = self.get_product_details()
        try:
            for i in prod_details:
                products.append(i[PRODUCT])                     # appends the product info itself
        except TypeError, e:
            products.append(prod_details[PRODUCT])
        return products

    def get_product_tax(self):
        #TODO, do this method like self.get_product_info
        taxes = []
        for i in self.get_product_details():
            taxes.append(i[TAXES])                          # appends the tax of product info itself
        return taxes

    #
    # Receiver
    #

    def get_receiver_name(self):
        receiver_name = ''
        try:
            receiver_name = self.get_nfe_info()[RECEIVER][NAME]
        except KeyError, e:
            pass
        return receiver_name

    def get_receiver_cnpj(self):
        return self.get_nfe_info()[RECEIVER][CNPJ]

    def get_receiver_cpf(self):
        return self.get_nfe_info()[RECEIVER][CPF]

    def get_receiver_document(self):
        try:
            return self.get_receiver_cpf()
        except KeyError, e:
            return self.get_receiver_cnpj()
