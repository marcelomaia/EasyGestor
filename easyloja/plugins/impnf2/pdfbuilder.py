# -*- coding: utf-8 -*-
import os

from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.lib.styles import ParagraphStyle as PS
from reportlab.lib.units import mm
from reportlab.platypus import Image
from reportlab.platypus.doctemplate import PageTemplate, BaseDocTemplate
from reportlab.platypus.frames import Frame
from reportlab.platypus.paragraph import Paragraph
from stoqlib.database.orm import AND, OR, LIKE
from stoqlib.database.runtime import get_current_user, get_current_branch, get_current_station, get_connection
from stoqlib.domain.interfaces import IIndividual, ICompany, ISalesPerson
from stoqlib.domain.payment.payment import Payment
from stoqlib.domain.payment.views import CardPaymentView
from stoqlib.domain.person import PersonAdaptToCreditProvider
from stoqlib.domain.sale import Sale
from stoqlib.gui.dialogs.tillhistory import TillFiscalOperationsView
from stoqlib.lib.formatters import format_phone_number
from stoqlib.lib.osutils import get_application_dir
from stoqlib.lib.parameters import sysparam
from stoqlib.reporting.base.flowables import ReportLine
from stoqlib.database.orm import IN

width_doc = sysparam(get_connection()).IMPNF_WIDTH * mm
height_doc = sysparam(get_connection()).IMPNF_HEIGHT * mm
left_margin, right_margin = 0.3 * mm, 0.3 * mm
LEFT = 0
RIGHT = 1
CENTER = 2
logo_height = 12.1 * mm
logo_width = 35 * mm

h1_centered = PS(
    name='Heading1Center',
    fontSize=10,
    leading=12,
    alignment=TA_CENTER,
)

h1_left = PS(
    name='Heading1Left',
    fontSize=10,
    leading=12,
    alignment=TA_LEFT,
)

h2_centered = PS(
    name='Heading2Center',
    fontSize=8,
    leading=10,
    alignment=TA_CENTER,
)

header_warning = PS(name='Heading2',
                    fontSize=12,
                    leading=14,
                    alignment=TA_CENTER, )

header_items_l = PS(name='HeaderItems',
                    fontSize=8,
                    leading=8,
                    alignment=TA_LEFT,
                    )

header_items_l2 = PS(name='HeaderItems',
                     fontSize=13,
                     leading=17,
                     alignment=TA_LEFT,
                     )

header_items_r = PS(name='HeaderItems',
                    fontSize=8,
                    leading=8,
                    alignment=TA_RIGHT,
                    )

header_items_c = PS(name='HeaderItems',
                    fontSize=8,
                    leading=8,
                    alignment=TA_CENTER,
                    )

header_items_d = PS(name='HeaderItems',
                    fontSize=16,
                    leading=16,
                    alignment=TA_CENTER,
                    )

items_1 = PS(name='Items',
             fontSize=7,
             leading=10,
             alignment=TA_LEFT, )

items_2 = PS(name='Items',
             fontSize=7,
             leading=10,
             alignment=TA_RIGHT, )

items_3 = PS(name='Items',
             fontSize=13,
             leading=17,
             alignment=TA_LEFT, )

footer = PS(
    name='Footer',
    fontSize=13,
    leading=12,
    spaceBefore=10,
    alignment=TA_CENTER,
)


def align_text(text, size, alignment=LEFT, space_tag='&nbsp;'):
    """
    Serve para preencher espaços entre as strings, a fim de deixar esteticamente mais bonitos
    :param text:
    :param size:
    :param alignment:
    :param space_tag:
    :return:
    """
    if len(text) < size:
        complement = space_tag * (size - len(text))
        if alignment == LEFT:
            if size > 50:
                # para a descricao do produto encaixar no texto
                complement = ''
            text += complement
        elif alignment == RIGHT:
            text = complement + text
        else:
            complement = ' ' * (size - len(text))
            first_part = complement[:int(len(complement) / 2)]
            first_part = first_part.replace(' ', space_tag)
            last_part = complement[int(len(complement) / 2):]
            last_part = last_part.replace(' ', space_tag)
            text = first_part + text + last_part
    else:
        text = text[:size]
    return text


def get_logotype_path(conn):
    logofile = sysparam(conn).CUSTOM_LOGO_FOR_NFCE
    if logofile.is_valid():
        return str(logofile.image_path)
    else:
        return None


class PDFBuilder(BaseDocTemplate):
    def __init__(self, filename, **kw):
        self.allowSplitting = 0
        apply(BaseDocTemplate.__init__, (self, filename), kw)
        template = PageTemplate('normal',
                                [Frame(left_margin, right_margin, width_doc, height_doc, id='F1')],
                                pagesize=(width_doc, height_doc))
        self.addPageTemplates(template)

    def afterFlowable(self, flowable):
        "Registers TOC entries."
        if flowable.__class__.__name__ == 'Paragraph':
            text = flowable.getPlainText()
            style = flowable.style.name
            if style == 'Heading1':
                self.notify('TOCEntry', (0, text, self.page))
            if style == 'Heading2':
                self.notify('TOCEntry', (1, text, self.page))


def build_sale_document(sale, conn):
    branch = sale.branch
    company = ICompany(branch)
    # Build story.
    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_left))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_left))
    story.append(Paragraph('CNPJ: {cnpj} IE: {ie}'.format(cnpj=company.cnpj, ie=company.state_registry), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('<b>{header}</b>'.format(header=sysparam(conn).HEADER_MESSAGE), header_warning))
    story.append(ReportLine())
    story.append(Paragraph('<b>|COD|Descricao</b>'
                           .replace(' ', '&nbsp;'), header_items_l))
    story.append(Paragraph('<b>|QTD|X|VlrUnit|VlrTotal</b>'
                           .replace(' ', '&nbsp;'), header_items_r))
    story.append(ReportLine())
    for item in sale.get_items():
        sellable = item.sellable
        story.append(
            Paragraph('{code} {prod}'
                      .replace(' ', '&nbsp;').format(code=align_text(sellable.code, 10, LEFT),
                                                     prod=align_text(sellable.description,
                                                                     58, LEFT)), items_1))
        try:
            story.append(
                Paragraph('{qtd} X {unit_price} {total}'
                          .replace(' ', '&nbsp;').format(qtd=align_text('{}'.format(float(item.quantity)), 5, CENTER),
                                                         unit_price=align_text('{}'.format(float(item.price)), 9,
                                                                               CENTER),
                                                         total=align_text('<b>{}</b>'.format(float(item.get_total())),
                                                                          12,
                                                                          CENTER)),
                          items_2))
        except ValueError, e:
            # dá um erro de tag xml aqui em alguns produtos, erro exclusivo do ruindows
            story.append(
                Paragraph('{qtd} X {unit_price} {total}'
                          .replace(' ', '&nbsp;').format(qtd=align_text('{}'.format(float(item.quantity)), 5,
                                                                        CENTER),
                                                         unit_price=align_text('{}'.format(float(item.price)), 9,
                                                                               CENTER),
                                                         total=align_text('{}'.format(float(item.get_total())),
                                                                          12, CENTER)),
                          items_2))

    story.append(ReportLine())
    for payment in sale.payments:
        if payment.is_inpayment():
            story.append(
                Paragraph('{} R$ {}'.format(payment.method.description, payment.base_value),
                          header_items_l))
    if sale.discount_value:
        story.append(Paragraph('Desconto {}'.format(sale.discount_value)
                               .replace(' ', '&nbsp;'), header_items_l))
    story.append(Paragraph('<b>Valor total R$ {}</b>'.format(sale.get_total_sale_amount())
                           .replace(' ', '&nbsp;'), header_items_r))
    story.append(ReportLine())
    story.append(Paragraph('Situação: <b>{}</b>'.format(Sale.get_status_name(sale.status))
                           .replace(' ', '&nbsp;'), header_items_l))
    story.append(Paragraph('Troco R$ {}'.format(sale.change)
                           .replace(' ', '&nbsp;'), header_items_l))
    story.append(Paragraph('<b>Valor pago R$ {}</b>'.format(sale.paid_value)
                           .replace(' ', '&nbsp;'), header_items_r))
    story.append(ReportLine())
    if sale.client:
        client = sale.client
        individual = IIndividual(client, None)
        company = ICompany(client, None)
        story.append(Paragraph('Cliente: {client}'.format(client=client.person.name), header_items_l))
        if company:
            story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), header_items_l))
        else:
            story.append(Paragraph('CPF: {cpf}'.format(cpf=individual.cpf), header_items_l))
        story.append(ReportLine())
    if sale.status not in [Sale.STATUS_CONFIRMED, Sale.STATUS_PAID]:
        story.append(Paragraph('Data de abertura: {open_date}. Vence em: {expire_date}'
                               .format(open_date=sale.open_date.strftime('%d/%m/%Y %X'),
                                       expire_date=sale.expire_date or 'Indefinido')
                               .replace(' ', '&nbsp;'), header_items_l))
    else:
        story.append(Paragraph('Data do pagamento: {paid_date}'
                               .format(paid_date=sale.confirm_date.strftime('%d/%m/%Y %X'))
                               .replace(' ', '&nbsp;'), header_items_l))
    story.append(Paragraph('Venda: <b>#{sale_id}</b>'.format(sale_id=sale.id), header_items_c))
    story.append(Paragraph('Pedido: <b>#{daily_code}</b>'.format(daily_code=sale.daily_code), header_items_c))

    story.append(Paragraph('<b>{footer}</b>'.format(footer=sysparam(conn).FOOTER_MESSAGE), footer))
    filename = os.path.join(get_application_dir(), 'sale.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def build_tab_document(sale):
    story = []
    branch = sale.branch
    company = ICompany(branch)
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('<b>COMANDA: #{daily_code}</b>'.format(daily_code=sale.daily_code), header_items_d))
    story.append(Paragraph('Atendente: {salesperson}'.format(salesperson=sale.salesperson.person.name),
                           header_items_l))
    story.append(Paragraph('Data/Hora: {open_date}'
                           .format(open_date=sale.open_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(ReportLine())
    story.append(Paragraph('<b>|QTD|X|Descricao</b>'
                           .replace(' ', '&nbsp;'), header_items_l2))
    story.append(ReportLine())
    for item in sale.get_items():
        sellable = item.sellable
        notes = item.notes
        story.append(
            Paragraph('<b>{qtd} X {prod}</b>'
                      .replace(' ', '&nbsp;').format(qtd=align_text('{}'.format(item.quantity), 5, CENTER),
                                                     prod=align_text(sellable.description,
                                                                     58, LEFT)), items_3))
        if notes:
            story.append(
                Paragraph('-> {notes}'.replace(' ', '&nbsp;')
                          .format(notes=align_text(notes,
                                                   58, LEFT)), items_3))

    story.append(ReportLine())
    if sale.client:
        client = sale.client
        story.append(Paragraph('Cliente: {client}'.format(client=client.person.name), header_items_l))
        story.append(Paragraph('Fone: {phone}'.format(phone=client.person.phone_number), header_items_l))
        story.append(ReportLine())
    filename = os.path.join(get_application_dir(), 'tab.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def salesperson_stock_report(open_date, close_date, conn):
    user = get_current_user(conn)
    salesperson = ISalesPerson(user)

    sales = Sale.select(AND(Sale.q.open_date >= open_date,
                            Sale.q.confirm_date <= close_date,
                            Sale.q.salesperson == salesperson,
                            OR(Sale.q.status == Sale.STATUS_CONFIRMED,
                               Sale.q.status == Sale.STATUS_PAID)),
                        connection=conn)
    sellable_qqtt_dict = {}
    # contadores de totais de itens
    for sale in sales:
        sale_items = sale.get_items()
        for saler_item in sale_items:
            qtty = saler_item.quantity
            sellalble = saler_item.sellable
            if sellable_qqtt_dict.get(sellalble):
                sellable_qqtt_dict[sellalble] = sellable_qqtt_dict[sellalble] + qtty
            else:
                sellable_qqtt_dict[sellalble] = qtty
    # sort items
    d_sorted_by_value = sorted(
        [(sellable.description, sellable.code, quantity) for (sellable, quantity) in sellable_qqtt_dict.items()])

    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    branch = get_current_branch(conn)
    company = ICompany(branch)
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('<b>RELATORIO DE PRODUTOS VENDIDOS</b>',
                           header_items_d))
    story.append(Paragraph('Vendedor: {salesperson}'.format(salesperson=salesperson.person.name),
                           header_items_l))
    story.append(Paragraph('Início: {open_date}'
                           .format(open_date=open_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(Paragraph('Fim: {close_date}'
                           .format(close_date=close_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(ReportLine())
    story.append(Paragraph('<b>QTDE|X|Descricao-COD</b>', header_items_l))
    story.append(ReportLine())
    for sellable in d_sorted_by_value:
        desc, code, qtty = sellable
        story.append(
            Paragraph('{qtde} X {prod}-{code}'.format(code=align_text(code, 10, LEFT),
                                                      prod=align_text(desc, 58, LEFT),
                                                      qtde=align_text(str(float(qtty)), 10, LEFT)), items_1))
    filename = os.path.join(get_application_dir(), 'salespersonstock.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def salesperson_financial_report(open_date, close_date, conn):
    """
    Relatorio financeiro para as vendas de um vendedor
    numa determinada estacao
    """
    station = get_current_station(conn)
    user = get_current_user(conn)
    salesperson = ISalesPerson(user)
    branch = get_current_branch(conn)
    # historico de caixa
    till_history = TillFiscalOperationsView.select(
        AND(TillFiscalOperationsView.q.date >= open_date,
            TillFiscalOperationsView.q.date <= close_date,
            TillFiscalOperationsView.q.station_id == station.id,
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

    # detalhamento de cartao
    d_card = {}
    for p in PersonAdaptToCreditProvider.selectBy(connection=conn):
        total_cartao = CardPaymentView.select(AND(CardPaymentView.q.open_date >= open_date,
                                                  CardPaymentView.q.open_date <= close_date,
                                                  CardPaymentView.q.provider_id == p.id,
                                                  CardPaymentView.q.station_id == station.id,
                                                  IN(CardPaymentView.q.status,
                                                     (Payment.STATUS_PAID, Payment.STATUS_PENDING))
                                                  ),
                                              connection=conn).sum('value')
        if total_cartao:
            d_card[p.person.name] = total_cartao

    total = 0
    discounts = 0
    # total de valor
    for th in till_history:
        total += th.value or 0
        discounts += th.discount_value or 0
    company = ICompany(branch)
    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('<b>RELATORIO DE MOVIMENTAÇÃO DE CAIXA</b>', h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('Atendente: {salesperson}'.format(salesperson=salesperson.person.name),
                           header_items_d))
    story.append(Paragraph('Estação: {station}'.format(station=station.name),
                           header_items_d))
    story.append(Paragraph('Início: {open_date}'
                           .format(open_date=open_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(Paragraph('Fim: {close_date}'
                           .format(close_date=close_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(ReportLine())

    payment_total = 0
    # sort payments
    d_sorted_by_value_payments = sorted([(key, value) for (key, value) in quantidade_entrada.items()])
    story.append(Paragraph('FORMAS DE PAGAMENTO',
                           header_items_c))
    for payment in d_sorted_by_value_payments:
        payment_total += payment[1]
        story.append(Paragraph('{method} : <b>{value}</b>'.format(method=payment[0],
                                                                  value=payment[1]),
                               header_items_l))
    story.append(Paragraph('<b>Total: {total}</b>'.
                           format(total=payment_total),
                           header_items_l))
    story.append(ReportLine())
    # card details
    if d_card:
        card_details = sorted([(key, value) for (key, value) in d_card.items()])
        story.append(Paragraph('DETALHAMENTO DOS CARTOES',
                               header_items_c))
        for payment in card_details:
            story.append(Paragraph('{method} : <b>{value}</b>'.format(method=payment[0],
                                                                      value=payment[1]),
                                   header_items_l))
        story.append(ReportLine())
    # Sangrias
    despesa_src_str = '%%%s%%' % 'Despesa:'
    quantia_removida_src_str = '%%%s%%' % 'Quantia removida'
    sangria_valor = 0

    despesa_results = TillFiscalOperationsView.select(
        AND(
            OR(LIKE(TillFiscalOperationsView.q.description, despesa_src_str),
               LIKE(TillFiscalOperationsView.q.description, quantia_removida_src_str)),
            TillFiscalOperationsView.q.date > open_date,
            TillFiscalOperationsView.q.date <= close_date,
            TillFiscalOperationsView.q.station_id == station.id,
        ))
    story.append(Paragraph('SANGRIAS',
                           header_items_c))
    try:
        for value, description in [(p.value, p.description) for p in despesa_results]:
            sangria_valor += value
            story.append(Paragraph('{description}: <b>{value}</b>\n'.format(description=description, value=value),
                                   header_items_l))
    except:
        pass
    story.append(Paragraph('<b>Total de sangria: {total}</b>'.
                           format(total=sangria_valor),
                           header_items_l))

    # Suprimentos
    suprimento_src_str = '%%%s%%' % 'Suprimento:'
    caixa_iniciado_str = '%%%s%%' % 'Caixa iniciado'
    suprimento_valor = 0
    suprimento_results = TillFiscalOperationsView.select(
        AND(OR
            (LIKE(TillFiscalOperationsView.q.description, suprimento_src_str),
             LIKE(TillFiscalOperationsView.q.description, caixa_iniciado_str)),
            TillFiscalOperationsView.q.date > open_date,
            TillFiscalOperationsView.q.station_id == station.id,
            TillFiscalOperationsView.q.date <= close_date))
    story.append(ReportLine())
    story.append(Paragraph('SUPRIMENTOS',
                           header_items_c))
    try:
        for value, description in [(p.value, p.description) for p in suprimento_results]:
            suprimento_valor += value
            story.append(Paragraph('{description}: <b>{value}</b>\n'.
                                   format(description=description, value=value),
                                   header_items_l))
    except:
        pass
    story.append(Paragraph('<b>Total de suprimento: {total}</b>'.
                           format(total=suprimento_valor),
                           header_items_l))
    story.append(ReportLine())
    filename = os.path.join(get_application_dir(), 'salespersonfinancial.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def in_payment_report(paymentview, conn):
    client_name = paymentview.drawee
    client_phone = paymentview.drawee_phone
    client_cnpj = paymentview.client_cnpj
    client_cpf = paymentview.client_cpf
    open_date = paymentview.open_date
    id = paymentview.id
    description = paymentview.description
    value = paymentview.value
    method_description = paymentview.method_description
    category = paymentview.category
    station = get_current_station(conn)
    user = get_current_user(conn)
    branch = get_current_branch(conn)
    company = ICompany(branch)

    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('Usuário: {user}'.format(user=user.username),
                           header_items_l))
    story.append(Paragraph('Estação: {station}'.format(station=station.name),
                           header_items_l))
    story.append(Paragraph('Data/Hora {}'.format(open_date.strftime('%d/%m/%Y %H:%M:%S')),
                           header_items_l))
    story.append(Paragraph('<b>SUPRIMENTO #{sid}</b>'.format(sid=id), h1_centered))
    story.append(ReportLine())
    if client_name:
        story.append(Paragraph('Cliente: {client}'.format(client=client_name),
                               header_items_l))
        story.append(Paragraph('Documento: {doc}'.format(doc=client_cnpj or client_cpf),
                               header_items_l))
        story.append(Paragraph('Fone: {phone}'.format(phone=client_phone),
                               header_items_l))
        story.append(ReportLine())
    if category:
        story.append(Paragraph('{description}: pago em  {method}; categoria: <b>{category}</b>'
                               .format(category=category, method=method_description, description=description),
                               header_items_l))
    else:
        story.append(Paragraph('{description}: pago em {method}'
                               .format(method=method_description, description=description.capitalize()),
                               header_items_l))
    story.append(Paragraph('Valor: <b>R${:.2f}</b>'.format(value),
                           header_items_l))
    filename = os.path.join(get_application_dir(), 'inpayment.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def out_payment_report(paymentview, conn):
    supplier_name = paymentview.supplier_name
    supplier_phone = paymentview.supplier_phone
    client_cnpj = paymentview.client_cnpj
    client_cpf = paymentview.client_cpf
    open_date = paymentview.open_date
    id = paymentview.id
    description = paymentview.description
    value = paymentview.value
    method_description = paymentview.method_description
    category = paymentview.category
    station = get_current_station(conn)
    user = get_current_user(conn)
    branch = get_current_branch(conn)
    company = ICompany(branch)

    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('Usuário: {user}'.format(user=user.username),
                           header_items_l))
    story.append(Paragraph('Estação: {station}'.format(station=station.name),
                           header_items_l))
    story.append(Paragraph('Data/Hora {}'.format(open_date.strftime('%d/%m/%Y %H:%M:%S')),
                           header_items_l))
    story.append(Paragraph('<b>SANGRIA #{sid}</b>'.format(sid=id), h1_centered))
    story.append(ReportLine())
    if supplier_name:
        story.append(Paragraph('Fornecedor: {supplier}'.format(supplier=supplier_name),
                               header_items_l))
        story.append(Paragraph('Documento: {doc}'.format(doc=client_cnpj or client_cpf),
                               header_items_l))
        story.append(Paragraph('Fone: {phone}'.format(phone=supplier_phone),
                               header_items_l))
        story.append(ReportLine())
    if category:
        story.append(Paragraph('{description}: pago em  {method}; categoria: {category}'
                               .format(category=category, method=method_description, description=description),
                               header_items_l))
    else:
        story.append(Paragraph('{description}: pago em {method}'
                               .format(method=method_description, description=description.capitalize()),
                               header_items_l))
    story.append(Paragraph('Valor: R${:.2f}\n'.format(value),
                           header_items_l))
    filename = os.path.join(get_application_dir(), 'outpayment.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def gerencial_report(open_date, close_date, conn):
    """Lista todas as vendas e todas as sangrias sem filtrar por vendedor e por estação"""
    station = get_current_station(conn)
    user = get_current_user(conn)
    branch = get_current_branch(conn)
    company = ICompany(branch)
    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('<b>RELATORIO GERAL CAIXA+PRODUTOS VENDIDOS</b>', h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())

    till_history = TillFiscalOperationsView.select(
        AND(TillFiscalOperationsView.q.date >= open_date,
            TillFiscalOperationsView.q.date <= close_date),
        connection=conn)

    # detalhamento de cartao
    d_card = {}
    for p in PersonAdaptToCreditProvider.selectBy(connection=conn):
        total_cartao = CardPaymentView.select(AND(CardPaymentView.q.open_date >= open_date,
                                                  CardPaymentView.q.open_date <= close_date,
                                                  CardPaymentView.q.provider_id == p.id,
                                                  IN(CardPaymentView.q.status,
                                                     (Payment.STATUS_PAID, Payment.STATUS_PENDING))
                                                  ),
                                              connection=conn).sum('value')
        if total_cartao:
            d_card[p.person.name] = total_cartao

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
    payment_total = 0
    for payment in d_sorted_by_value_payments:
        payment_total += payment[1]
        story.append(Paragraph('{method} : <b>{value}</b>'.format(method=payment[0],
                                                                  value=payment[1]),
                               header_items_l))
    story.append(Paragraph('<b>Total: {total}</b>'.
                           format(total=payment_total),
                           header_items_l))
    story.append(ReportLine())
    if d_card:
        card_details = sorted([(key, value) for (key, value) in d_card.items()])
        story.append(Paragraph('DETALHAMENTO DOS CARTOES',
                               header_items_c))
        for payment in card_details:
            story.append(Paragraph('{method} : <b>{value}</b>'.format(method=payment[0],
                                                                      value=payment[1]),
                                   header_items_l))
        story.append(ReportLine())

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
    story.append(Paragraph('SANGRIAS',
                           header_items_c))
    try:
        for value, description in [(p.value, p.description) for p in despesa_results]:
            sangria_valor += value
            story.append(Paragraph('{description}: <b>{value}</b>\n'.format(description=description, value=value),
                                   header_items_l))
    except:
        pass
    story.append(Paragraph('<b>Total de sangria: {total}</b>'.
                           format(total=sangria_valor),
                           header_items_l))

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

    story.append(Paragraph('SUPRIMENTOS',
                           header_items_c))
    try:
        for value, description in [(p.value, p.description) for p in suprimento_results]:
            suprimento_valor += value
            story.append(Paragraph('{description}: <b>{value}</b>\n'.
                                   format(description=description, value=value),
                                   header_items_l))
    except:
        pass
    story.append(Paragraph('<b>Total de suprimento: {total}</b>'.
                           format(total=suprimento_valor),
                           header_items_l))
    story.append(ReportLine())

    sold_items = ""
    sellable_qqtt_dict = {}

    # contadores de totais de itens
    sales = Sale.select(AND(Sale.q.open_date >= open_date,
                            Sale.q.confirm_date <= close_date,
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
        [(key.description, key.code, value) for (key, value) in sellable_qqtt_dict.items()])
    story.append(Paragraph('<b>QTDE|X|Descricao-COD</b>', header_items_l))
    story.append(ReportLine())
    for sellable in d_sorted_by_value:
        desc, code, qtty = sellable
        story.append(
            Paragraph('{qtde} X {prod}-{code}'.format(code=align_text(code, 10, LEFT),
                                                      prod=align_text(desc, 58, LEFT),
                                                      qtde=align_text(str(float(qtty)), 10, LEFT)), items_1))

    story.append(ReportLine())
    filename = os.path.join(get_application_dir(), 'gerencial.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename


def in_out_payment_report(till, value, reason, conn):
    station = get_current_station(conn)
    user = get_current_user(conn)
    branch = get_current_branch(conn)
    open_date = till.opening_date
    company = ICompany(branch)

    logotype_path = get_logotype_path(conn)
    story = []
    if logotype_path:
        story.append(Image(logotype_path, width=logo_width, height=logo_height))
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(
        Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    story.append(Paragraph('Usuário: {user}'.format(user=user.username),
                           header_items_l))
    story.append(Paragraph('Estação: {station}'.format(station=station.name),
                           header_items_l))
    story.append(Paragraph('Data/Hora {}'.format(open_date.strftime('%d/%m/%Y %H:%M:%S')),
                           header_items_l))
    story.append(ReportLine())
    story.append(Paragraph('{description}'
                           .format(description=reason.capitalize()),
                           header_items_l))
    story.append(Paragraph('Valor: R${:.2f}\n'.format(value),
                           header_items_l))
    filename = os.path.join(get_application_dir(), 'inoutpayment.pdf')
    doc = PDFBuilder(filename)
    doc.multiBuild(story)
    return filename
