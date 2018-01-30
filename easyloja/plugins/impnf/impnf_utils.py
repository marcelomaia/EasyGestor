# coding=utf-8
import unicodedata
from datetime import datetime

from kiwi.log import Logger
from stoqlib.database.orm import AND, OR, LIKE
from stoqlib.database.runtime import get_connection, get_current_user, get_current_station
from stoqlib.domain.interfaces import ICompany, ISalesPerson
from stoqlib.domain.payment.method import PaymentMethod
from stoqlib.domain.sale import Sale
from stoqlib.domain.till import Till
from stoqlib.gui.dialogs.tillhistory import TillFiscalOperationsView
from stoqlib.lib.formatters import format_phone_number
from stoqlib.lib.parameters import sysparam

from drivers.non_fiscal import NonFiscalPrinter
from impnfdomain import Impnf

log = Logger("stoq-impnf-plugin")


# TODO: tem uns DRY aqui pra resolver :S
# TODO: trocar o widget de data

def strip_accents(string):
    """Remove the accentuantion of a string

    Taken from http://www.python.org.br/wiki/RemovedorDeAcentos

    :param string: a string, either in str or unicode format
    :returns: the string without accentuantion
    """
    if isinstance(string, str):
        # unicode don't need this
        string = string.decode('utf-8')

    string = unicodedata.normalize('NFKD', string)
    return string.encode('ASCII', 'ignore').strip()


class PrintSolution(object):
    # TODO, usar template aqui nessa parada...
    line = "{}\n".format('_' * 38)

    def __init__(self, conn, sale):
        self.sale = sale
        self.conn = conn

    #
    # Public
    #

    def print_sale_on_default_printer(self):
        """Gets default printer and print!
       """
        printer_db = self._get_default_printer()
        if not printer_db:
            return
        header_txt = self._default_header()
        body_text = self._default_body()
        footer_text = self._default_footer()

        # Driver instance
        nfp = NonFiscalPrinter(brand=printer_db.brand,
                               model=printer_db.printer_model,
                               port=printer_db.port,
                               dll=printer_db.dll,
                               spooler_printer=printer_db.spooler_printer)
        log.debug("IMPRESSAO NF.: {}".format(header_txt + body_text + footer_text))
        txt = strip_accents(header_txt + body_text + footer_text)
        nfp.write_text(txt)
        nfp.cut_paper()
        nfp.close_port()

    def print_tab(self):
        locations = self._get_locations()
        for location in locations:
            self._print_tab_item(location)

    def print_sangria_suprimento(self, till, value, reason):
        printer_db = self._get_default_printer()
        if not printer_db:
            return
        # header_txt = self._default_header()
        body_text = self._sangria_suprimento_body(till, value, reason)
        footer_text = self._signature_footer()

        # Driver instance
        nfp = NonFiscalPrinter(brand=printer_db.brand,
                               model=printer_db.printer_model,
                               port=printer_db.port,
                               dll=printer_db.dll,
                               spooler_printer=printer_db.spooler_printer)
        log.debug("IMPRESSAO SANGRIA/SUPRIMENTO.: {}".format(body_text + footer_text))
        txt = strip_accents(body_text + footer_text)
        nfp.write_text(txt)
        nfp.cut_paper()
        nfp.close_port()

    def print_in_payment(self, payment):
        printer_db = self._get_default_printer()
        if not printer_db:
            return
        # header_txt = self._default_header()
        body_text = self._in_payment_body(payment)
        footer_text = self._signature_footer()

        # Driver instance
        nfp = NonFiscalPrinter(brand=printer_db.brand,
                               model=printer_db.printer_model,
                               port=printer_db.port,
                               dll=printer_db.dll,
                               spooler_printer=printer_db.spooler_printer)
        log.debug("IMPRESSAO CONTAS A PAGAR E RECEBER.: {}".format(body_text + footer_text))
        txt = strip_accents(body_text + footer_text)
        nfp.write_text(txt)
        nfp.cut_paper()
        nfp.close_port()

    def print_out_payment(self, payment):
        printer_db = self._get_default_printer()
        if not printer_db:
            return
        # header_txt = self._default_header()
        body_text = self._out_payment_body(payment)
        footer_text = self._signature_footer()

        # Driver instance
        nfp = NonFiscalPrinter(brand=printer_db.brand,
                               model=printer_db.printer_model,
                               port=printer_db.port,
                               dll=printer_db.dll,
                               spooler_printer=printer_db.spooler_printer)
        log.debug("IMPRESSAO CONTAS A PAGAR E RECEBER.: {}".format(body_text + footer_text))
        txt = strip_accents(body_text + footer_text)
        nfp.write_text(txt)
        nfp.cut_paper()
        nfp.close_port()

    def open_drawer(self):
        printer_db = self._get_default_printer()
        if not printer_db:
            return
            # Driver instance
        nfp = NonFiscalPrinter(brand=printer_db.brand,
                               model=printer_db.printer_model,
                               port=printer_db.port,
                               dll=printer_db.dll,
                               spooler_printer=printer_db.spooler_printer)
        log.debug("ABRINDO GAVETA NF.")
        nfp.open_drawer()
        nfp.close_port()

    #
    # Private
    #

    def _print_tab_item(self, location):
        printer_db = self._get_printer(name=location)
        if not printer_db:
            return
        header = self._tab_header()
        body = self._tab_body(location)
        # Driver instance
        nfp = NonFiscalPrinter(brand=printer_db.brand,
                               model=printer_db.printer_model,
                               port=printer_db.port,
                               dll=printer_db.dll,
                               spooler_printer=printer_db.spooler_printer)
        txt = strip_accents(header + body)
        nfp.write_text(txt)
        nfp.cut_paper()
        nfp.close_port()

    def _get_default_printer(self):
        return Impnf.selectOneBy(is_default=True,
                                 station=get_current_station(self.conn),
                                 connection=self.conn)

    def _get_printer(self, name):
        return Impnf.selectOneBy(name=name,
                                 station=get_current_station(self.conn),
                                 connection=self.conn)

    def _default_header(self):
        txt = self.line
        txt += "{}\n".format(self._get_branch_name())
        txt += "Endereço: {}\n".format(self._get_branch_address())
        txt += "Fone: {}\n".format(self._get_branch_phone())
        txt += "CNPJ: {}    IE: {}\n".format(self._get_cnpj(), self._get_state_registry())
        txt += self.line
        if self.sale.daily_code:
            txt += "Data: {} ID: {:03d}  P.V.Nº: {:03d}\n".format(self._get_current_date(),
                                                                  self.sale.id,
                                                                  self.sale.daily_code % 1000)
        else:
            txt += "Data: {}          ID: {:03d}\n".format(self._get_current_date(),
                                                           self.sale.id % 1000)
        txt += "Hora: {}\n".format(self._get_current_time())
        if self.sale.expire_date:
            txt += "Expira em: {}\n".format(self._get_expire_date())
        txt += self.line
        if self.sale.client:
            txt += "Cliente: {}\n".format(self.sale.get_client_name())
            txt += "Fone: {}\n".format(format_phone_number(self.sale.client.person.phone_number))
            txt += "Endereço: {}\n".format(self.sale.client.person.get_address_string())

        if self.sale.salesperson:
            txt += "Vendedor: {}\n".format(self.sale.salesperson.person.name)
        txt += "CUPOM NÃO FISCAL\n"
        txt += "Descrição\n\tQtd  P.Uni  Vr.Item\n"
        txt += self.line
        return txt

    def _tab_header(self):
        txt = self.line
        txt += "{}\n".format(self._get_branch_name())
        txt += self.line
        if self.sale.daily_code:
            txt += "Data: {} ID: {:03d}  P.V.Nº: {:03d}\n".format(self._get_current_date(),
                                                                  self.sale.id,
                                                                  self.sale.daily_code % 1000)
        else:
            txt += "Data: {}          ID: {:03d}\n".format(self._get_current_date(),
                                                           self.sale.id % 1000)
        txt += "Hora: {}\n".format(self._get_current_time())
        txt += self.line
        if self.sale.client:
            txt += "Cliente: {}\n".format(self.sale.get_client_name())
        if self.sale.salesperson:
            txt += "Vendedor: {}\n".format(self.sale.salesperson.person.name)
        txt += "COMANDA\n"
        txt += "QTDE   -   DESC.\n\tOBS.\n\n\n"
        txt += self.line
        return txt

    def _get_current_date(self):
        return datetime.now().strftime('%d/%m/%y')

    def _get_current_time(self):
        return datetime.now().strftime('%H:%M:%S')

    def _get_expire_date(self):
        return self.sale.expire_date.strftime('%d/%m/%y')

    def _get_branch_name(self):
        company = ICompany(self.sale.branch.person)
        return company.fancy_name

    def _get_branch_address(self):
        person = self.sale.branch.person
        return person.get_address_string()

    def _get_branch_phone(self):
        person = self.sale.branch.person
        return person.get_formatted_phone_number()

    def _get_cnpj(self):
        person = self.sale.branch
        company = ICompany(person, None)
        assert company is not None
        cnpj = ''.join([c for c in company.cnpj if c in '1234567890'])
        return cnpj

    def _get_state_registry(self):
        person = self.sale.branch
        company = ICompany(person, None)
        assert company is not None
        state_registry = ''.join([c for c in company.state_registry if c in '1234567890'])
        return state_registry

    def _default_body(self):
        txt = ''
        for sale_item in self.sale.get_items():
            description = sale_item.sellable.description
            quantity = sale_item.quantity
            price = sale_item.price
            total = sale_item.get_total()
            notes = sale_item.notes
            if notes is None:
                txt += "{}\n\t{} x R$ {}  R$ {} \n\n".format(description[:38], quantity, price, total)
            else:
                txt += "{}\n\t{} x R$ {}  R$ {} \nnotas: {}\n\n".format(description[:38], quantity, price, total, notes)
        txt += self.line
        return txt

    def _sangria_suprimento_body(self, till, value, reason):
        station = till.station
        txt = '{}\n'.format(reason)
        txt += 'Data da impressão {}\n'.format(self._get_current_time())
        txt += 'Valor: R${:.2f}\n'.format(value)
        txt += 'Computador: {}\n\n\n'.format(station.name)
        txt += self.line
        return txt

    def _in_payment_body(self, payment):
        client_name = payment.drawee
        client_phone = payment.drawee_phone
        client_cnpj = payment.client_cnpj
        client_cpf = payment.client_cpf
        id = payment.id
        description = payment.description
        value = payment.value
        method_description = payment.method_description
        category = payment.category
        station = get_current_station(self.conn)
        user = get_current_user(self.conn)

        txt = 'Pagamento (entrada) #{}\n'.format(id)
        txt += 'Usuário: {}\n'.format(user.username)
        txt += 'categoria: {}, pago em  {}: {}\n'.format(category, method_description, description)
        if client_name:
            txt += 'Cliente: {}\n'.format(client_name)
            txt += 'Documento: {}\n'.format(client_cnpj or client_cpf)
            txt += 'Fone: {}\n'.format(client_phone)
        txt += 'Valor: R${:.2f}\n'.format(value)
        txt += 'Computador: {}\n\n\n'.format(station.name)
        txt += 'Data/Hora {}\n'.format(datetime.now().strftime('%d/%m/%Y %H:%M:%S'))
        txt += self.line
        return txt

    def _out_payment_body(self, payment):
        supplier_name = payment.supplier_name
        supplier_phone = payment.supplier_phone
        client_cnpj = payment.client_cnpj
        client_cpf = payment.client_cpf
        id = payment.id
        description = payment.description
        value = payment.value
        method_description = payment.method_description
        category = payment.category
        station = get_current_station(self.conn)
        user = get_current_user(self.conn)

        txt = 'Pagamento (saída) #{}\n'.format(id)
        txt += 'Usuário: {}\n'.format(user.username)
        txt += 'categoria: {}, pago em  {}: {}\n'.format(category, method_description, description)
        if supplier_name:
            txt += 'Fornecedor: {}\n'.format(supplier_name)
            txt += 'Documento: {}\n'.format(client_cnpj or client_cpf)
            txt += 'Fone: {}\n'.format(supplier_phone)
        txt += 'Valor: R${:.2f}\n'.format(value)
        txt += 'Computador: {}\n\n\n'.format(station.name)
        txt += 'Data/Hora {}\n'.format(datetime.now().strftime('%d/%m/%Y %H:%M:%S'))
        txt += self.line
        return txt

    def _tab_body(self, location):
        txt = ''
        for sale_item in self.sale.get_items():
            product = sale_item.sellable.product
            if product:
                if product.location == location:
                    quantity = sale_item.quantity
                    description = sale_item.sellable.description
                    note = sale_item.notes or ""
                    txt += "%d   -   %s\n\t%s\n\n\n" % (quantity, description, note)
        return txt

    def _get_payments_descriptions(self):
        txt = ''
        for payment in self.sale.payments:
            if payment.is_inpayment():
                txt += '{}: R${}\n'.format(payment.method.description, payment.base_value)
        return txt

    def _default_footer(self):
        txt = self._get_payments_descriptions()
        txt += "TOTAL: R$ {}\n".format(self.sale.get_sale_subtotal())
        txt += "DESCONTO: R$ {}\n".format(self.sale.discount_value)
        txt += "TOTAL DA VENDA: R$ {}\n".format(self.sale.get_total_sale_amount())
        txt += "VALOR PAGO: R$ {}\n".format(self.sale.paid_value)
        txt += "TROCO: R$ {}\n".format(self.sale.change)
        if self.sale.notes:
            txt += "Observações: {}\n".format(self.sale.notes)
        txt += self.line
        txt += sysparam(self.conn).PROMOTIONAL_MESSAGE + '\n\n'
        if self.sale.client:
            txt += "Assinatura: {}\n".format('___________________________')
        txt += "EasyLoja Automação (91) 3226-5660\n"
        return txt

    def _signature_footer(self):
        txt = "ASSINATURA\n"
        txt += self.line
        txt += "EasyLoja Automação (91) 3226-5660\n"
        return txt

    def _get_locations(self):
        locations = []
        for sale_item in self.sale.get_items():
            product = sale_item.sellable.product
            if product:
                location = product.location
                if location not in locations:
                    locations.append(location)
        return locations


def salesperson_stock_report(open_date, close_date):
    # TODO refatorar isso aqui...
    od = open_date
    cd = close_date
    conn = get_connection()
    user = get_current_user(conn)
    station = get_current_station(conn)
    salesperson = ISalesPerson(user)

    sales = Sale.select(AND(Sale.q.open_date >= od,
                            Sale.q.confirm_date <= cd,
                            Sale.q.salesperson == salesperson,
                            OR(Sale.q.status == Sale.STATUS_CONFIRMED,
                               Sale.q.status == Sale.STATUS_PAID)),
                        connection=conn)
    sellable_qqtt_dict = {}

    # contadores de totais de itens
    for sale in sales:
        sale_items = sale.get_items()
        for si in sale_items:
            qtty = si.quantity
            sellalble = si.sellable
            if sellable_qqtt_dict.get(sellalble):
                sellable_qqtt_dict[sellalble] = sellable_qqtt_dict[sellalble] + qtty
            else:
                sellable_qqtt_dict[sellalble] = qtty

    sold_items = ""

    # sort items
    d_sorted_by_value = sorted(
        [(strip_accents(key.description), key.code, value) for (key, value) in sellable_qqtt_dict.items()])

    for sellable in d_sorted_by_value:
        produto = "%s\nCOD: %s\nQTDE: %.2f\n" % (sellable[0],
                                                 sellable[1],
                                                 sellable[2],)
        produto += "%s%s" % ('=' * 19, '\n')
        sold_items += produto
    s = "==RELATORIO DE CONTAGEM DE ESTOQUE==\n" \
        "Vendedor: {vendedor}\n" \
        "Estação: {estacao}\n" \
        "Início: {inicio}\n" \
        "Fim: {fim}\n".format(vendedor=salesperson.person.name,
                              estacao=station.name,
                              inicio=od.strftime('%d/%m/%y - %H:%M:%S'),
                              fim=cd.strftime('%d/%m/%y - %H:%M:%S'))
    s += "%s%s" % ('=' * 38, '\n')
    s += sold_items
    s += "%s%s" % ('=' * 38, '\n')
    s += "\n\t\tAssinatura"

    ps = PrintSolution(conn, '')
    printer_db = ps._get_default_printer()
    if not printer_db:
        return
    # Driver instance
    nfp = NonFiscalPrinter(brand=printer_db.brand,
                           model=printer_db.printer_model,
                           port=printer_db.port,
                           dll=printer_db.dll,
                           spooler_printer=printer_db.spooler_printer)
    despesa_src_str = strip_accents(s)
    log.debug("IMPRESSAO NF.: {}".format(despesa_src_str))
    nfp.write_text(despesa_src_str)
    nfp.cut_paper()
    nfp.close_port()


def salesperson_financial_report(open_date, close_date):
    """
    Relatorio financeiro para as vendas de um vendedor
    numa determinada estacao
    """
    od = open_date
    cd = close_date
    conn = get_connection()
    station = get_current_station(conn)
    user = get_current_user(conn)
    salesperson = ISalesPerson(user)
    # historico de caixa
    till_history = TillFiscalOperationsView.select(
        AND(TillFiscalOperationsView.q.date >= od,
            TillFiscalOperationsView.q.date <= cd,
            TillFiscalOperationsView.q.station_id <= station.id,
            TillFiscalOperationsView.q.salesperson_id == salesperson.id),
        connection=conn)

    quantidade_entrada = {}

    # contadores por tipo de pagamento
    for th in till_history:
        # sangria ou suprimento vem method name = None
        if not th.method_name:
            continue
        if quantidade_entrada.get(th.method_name):
            quantidade_entrada[th.method_name] = quantidade_entrada[th.method_name] + th.value
        else:
            quantidade_entrada[th.method_name] = th.value

    total = 0
    discounts = 0
    # total de valor
    for th in till_history:
        total += th.value or 0
        discounts += th.discount_value or 0

    payment_values = ""

    # sort payments
    d_sorted_by_value_payments = sorted([(strip_accents(key), value) for (key, value) in quantidade_entrada.items()])

    for payment in d_sorted_by_value_payments:
        payment_str = "{} : {}\n".format(payment[0],
                                         payment[1], )
        payment_str += "{}\n".format('-' * 19, '\n')
        payment_values += payment_str

    # Sangrias
    despesa_src_str = '%%%s%%' % 'Despesa:'
    sangria_valor = 0
    sangria_str = ''

    despesa_results = TillFiscalOperationsView.select(AND(LIKE(TillFiscalOperationsView.q.description, despesa_src_str),
                                                          TillFiscalOperationsView.q.date > open_date,
                                                          TillFiscalOperationsView.q.date <= close_date,
                                                          TillFiscalOperationsView.q.station_id <= station.id,
                                                          ))
    try:
        for value, description in [(p.value, p.description) for p in despesa_results]:
            sangria_valor += value
            sangria_str += '{description}: {value}\n'.format(description=description, value=value)
    except:
        pass
    sangria_str += "Total de Sangria %s\n" % sangria_valor

    suprimento_str = ''
    # Suprimentos
    suprimento_src_str = '%%%s%%' % 'Suprimento:'
    suprimento_valor = 0
    suprimento_results = TillFiscalOperationsView.select(AND(LIKE(TillFiscalOperationsView.q.description,
                                                                  suprimento_src_str),
                                                             TillFiscalOperationsView.q.date > open_date,
                                                             TillFiscalOperationsView.q.date <= close_date,
                                                             TillFiscalOperationsView.q.station_id <= station.id,
                                                             ))

    try:
        for value, description in [(p.value, p.description) for p in suprimento_results]:
            suprimento_valor += value
            suprimento_str += '{description}: {value}\n'.format(description=description, value=value)
    except:
        pass

    suprimento_str += "Total de Suprimento %s\n" % suprimento_valor

    last_till = Till.get_current(conn)
    caixa_iniciado_str = ''
    caixa_iniciado_vlr = 0
    if last_till:
        # Caixa iniciado
        caixa_iniciado_vlr = last_till.get_initial_cash_amount()
        caixa_iniciado_str = "Caixa iniciado com a quantia de %s\n" % caixa_iniciado_vlr

    s = "===RELATORIO DE MOVIMENTAÇÃO DE CAIXA==\n" \
        "Vendedor: {vendedor}\n" \
        "Estação: {estacao}\n" \
        "Início: {inicio}\n" \
        "Fim: {fim}\n".format(vendedor=salesperson.person.name,
                              estacao=station.name,
                              inicio=od.strftime('%d/%m/%y - %H:%M:%S'),
                              fim=cd.strftime('%d/%m/%y - %H:%M:%S'))
    s += '==========FORMAS DE PAGAMENTO==========\n'
    s += payment_values
    s += '===============TOTAIS==================\n'
    s += "Descontos efetuados: %.2f\n" % discounts
    s += "Total geral: %.2f\n" % total
    s += '==============SANGRIAS=================\n'
    s += sangria_str
    s += '=============SUPRIMENTOS===============\n'
    s += suprimento_str
    s += caixa_iniciado_str
    s += "%s" % '_' * 40
    s += "\nValor esperado na contagem: {}\n".format(total + suprimento_valor - abs(sangria_valor) + caixa_iniciado_vlr)
    s += "%s" % '_' * 40
    s += "\n\t\tAssinatura"

    ps = PrintSolution(conn, '')
    printer_db = ps._get_default_printer()
    if not printer_db:
        return
    # Driver instance
    nfp = NonFiscalPrinter(brand=printer_db.brand,
                           model=printer_db.printer_model,
                           port=printer_db.port,
                           dll=printer_db.dll,
                           spooler_printer=printer_db.spooler_printer)
    despesa_src_str = strip_accents(s)
    log.debug("IMPRESSAO NF.: {}".format(despesa_src_str))
    nfp.write_text(despesa_src_str)
    nfp.cut_paper()
    nfp.close_port()


def print_report3(till):
    if not till:
        return
    last_removal_date = till.get_last_removal_date()
    now = datetime.now()
    salesperson_financial_report(last_removal_date, now)


def gerencial_report(open_date, close_date):
    """Lista todas as vendas e todas as sangrias sem filtrar por vendedor e por estação"""
    od = open_date
    cd = close_date
    conn = get_connection()
    till_history = TillFiscalOperationsView.select(AND(TillFiscalOperationsView.q.date >= od,
                                                       TillFiscalOperationsView.q.date <= cd),
                                                   connection=conn)
    quantidade_entrada = {}

    # contadores por tipo de pagamento
    for th in till_history:
        if not th.method_name:
            continue
        if quantidade_entrada.get(th.method_name):
            quantidade_entrada[th.method_name] = quantidade_entrada[th.method_name] + th.value
        else:
            quantidade_entrada[th.method_name] = th.value

    total = 0
    discounts = 0
    # contadores de totais de itens
    for th in till_history:
        if not th.salesperson_id:
            continue
        total += th.value or 0
        discounts += th.discount_value or 0

    payment_values = ""

    # sort payments
    d_sorted_by_value_payments = sorted(
        [(key, value) for (key, value) in quantidade_entrada.items()])

    for payment in d_sorted_by_value_payments:
        produto = "{} : {}\n".format(payment[0],
                                     payment[1])
        produto += "%s%s" % ('=' * 19, '\n')
        payment_values += produto

    # Sangrias
    despesa_src_str = '%%%s%%' % 'Despesa:'
    quantia_removida_str = '%%%s%%' % 'Quantia removida'

    sangria_valor = 0
    sangria_str = ''

    despesa_results = TillFiscalOperationsView.select(
        AND(OR(
            LIKE(TillFiscalOperationsView.q.description, despesa_src_str),
            LIKE(TillFiscalOperationsView.q.description, quantia_removida_str)),
            TillFiscalOperationsView.q.date > open_date,
            TillFiscalOperationsView.q.date <= close_date))
    try:
        for value, description in [(p.value, p.description) for p in despesa_results]:
            sangria_valor += value
            sangria_str += '{description}: {value}\n'.format(description=description, value=value)
    except:
        pass
    sangria_str += "Total de Sangria %s\n" % sangria_valor

    suprimento_str = ''

    # Suprimentos
    suprimento_src_str = '%%%s%%' % 'Suprimento:'
    caixa_iniciado_str = '%%%s%%' % 'Caixa iniciado'
    suprimento_valor = 0
    suprimento_results = TillFiscalOperationsView.select(
        AND(OR
            (LIKE(TillFiscalOperationsView.q.description, suprimento_src_str),
             LIKE(TillFiscalOperationsView.q.description, caixa_iniciado_str)),
            TillFiscalOperationsView.q.date > open_date,
            TillFiscalOperationsView.q.date <= close_date))

    try:
        for value, description in [(p.value, p.description) for p in suprimento_results]:
            suprimento_valor += value
            suprimento_str += '{description}: {value}\n'.format(description=description, value=value)
    except:
        pass

    suprimento_str += "Total de Suprimento %s\n" % suprimento_valor

    sold_items = ""
    sellable_qqtt_dict = {}

    # contadores de totais de itens
    sales = Sale.select(AND(Sale.q.open_date >= od,
                            Sale.q.confirm_date <= cd,
                            OR(Sale.q.status == Sale.STATUS_CONFIRMED,
                               Sale.q.status == Sale.STATUS_PAID)),
                        connection=conn)
    for th in sales:
        sale_items = th.get_items()
        for si in sale_items:
            qtty = si.quantity
            sellalble = si.sellable
            if sellable_qqtt_dict.get(sellalble):
                sellable_qqtt_dict[sellalble] = sellable_qqtt_dict[sellalble] + qtty
            else:
                sellable_qqtt_dict[sellalble] = qtty
    # sort items
    d_sorted_by_value = sorted(
        [(strip_accents(key.description), key.code, value) for (key, value) in sellable_qqtt_dict.items()])

    for sellable in d_sorted_by_value:
        produto = "%s\nCOD: %s\nQTDE: %.2f\n" % (sellable[0],
                                                 sellable[1],
                                                 sellable[2],)
        produto += "%s%s" % ('=' * 19, '\n')
        sold_items += produto

    s = "===RELATORIO DE GERAL DOS CAIXAS==\n" \
        "Vendedor: {vendedor}\n" \
        "Estação: {estacao}\n" \
        "Início: {inicio}\n" \
        "Fim: {fim}\n".format(vendedor='TODOS',
                              estacao='TODAS',
                              inicio=od.strftime('%d/%m/%y - %H:%M:%S'),
                              fim=cd.strftime('%d/%m/%y - %H:%M:%S'))
    s += '======CONTADORES DE ITENS VENDIDOS=====\n'
    s += sold_items
    s += '\n\n==========FORMAS DE PAGAMENTO==========\n'
    s += payment_values
    s += '===============TOTAIS==================\n'
    s += "Descontos efetuados: %.2f\n" % discounts
    s += "Total geral: %.2f\n" % total
    s += '==============SANGRIAS=================\n'
    s += sangria_str
    s += '=============SUPRIMENTOS===============\n'
    s += suprimento_str
    s += "%s" % '_' * 40
    s += "\nValor esperado na contagem: {}\n".format(
        total + suprimento_valor - abs(sangria_valor))
    s += "%s" % '_' * 40
    s += "\n\t\tAssinatura"

    ps = PrintSolution(conn, '')
    printer_db = ps._get_default_printer()
    if not printer_db:
        return
    # Driver instance
    nfp = NonFiscalPrinter(brand=printer_db.brand,
                           model=printer_db.printer_model,
                           port=printer_db.port,
                           dll=printer_db.dll,
                           spooler_printer=printer_db.spooler_printer)
    despesa_src_str = strip_accents(s)
    log.debug("IMPRESSAO NF.: {}".format(despesa_src_str))
    nfp.write_text(despesa_src_str)
    nfp.cut_paper()
    nfp.close_port()
