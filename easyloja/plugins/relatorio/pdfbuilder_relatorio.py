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
from kiwi.log import Logger

log = Logger('stoq-relatorio-plugin')

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


def _get_sales(open_date, close_date, salesperson, conn):
    sales = Sale.select(AND(Sale.q.open_date >= open_date,
                            Sale.q.confirm_date <= close_date,
                            Sale.q.salesperson == salesperson,
                            OR(Sale.q.status == Sale.STATUS_CONFIRMED,
                               Sale.q.status == Sale.STATUS_PAID)),
                        connection=conn)
    return sales


def _get_story(company, h1_text):
    story = []
    story.append(Paragraph('<b>{fancy_name}</b>'.format(fancy_name=company.fancy_name), h1_centered))
    story.append(Paragraph('<b>{}</b>'.format(h1_text), h1_centered))
    story.append(Paragraph('{address}'.format(address=company.person.get_address_string()), h1_centered))
    story.append(Paragraph('Fone: {phone}'.format(phone=format_phone_number(company.person.phone_number)), h1_centered))
    story.append(Paragraph('CNPJ: {cnpj}'.format(cnpj=company.cnpj), h1_left))
    story.append(ReportLine())
    return story


def _get_till_history(open_date, close_date, salesperson, conn):
    station = get_current_station(conn)
    till_history = TillFiscalOperationsView.select(
        AND(TillFiscalOperationsView.q.date >= open_date,
            TillFiscalOperationsView.q.date <= close_date,
            TillFiscalOperationsView.q.station_id == station.id,
            TillFiscalOperationsView.q.salesperson_id == salesperson.id),
        connection=conn)
    return till_history


def _set_card_details(story, open_date, close_date, conn):
    d_card = {}
    for p in PersonAdaptToCreditProvider.selectBy(connection=conn):
        total_cartao = CardPaymentView.select(AND(CardPaymentView.q.open_date >= open_date,
                                                  CardPaymentView.q.open_date <= close_date,
                                                  CardPaymentView.q.provider_id == p.id,
                                                  # CardPaymentView.q.station_id == station.id,
                                                  IN(CardPaymentView.q.status,
                                                     (Payment.STATUS_PAID, Payment.STATUS_PENDING))
                                                  ),
                                              connection=conn).sum('value')
        if total_cartao:
            d_card[p.person.name] = total_cartao
    if d_card:
        card_details = sorted([(key, value) for (key, value) in d_card.items()])
        story.append(Paragraph('DETALHAMENTO DOS CARTOES',
                               header_items_c))
        for payment in card_details:
            story.append(Paragraph('{method} : <b>{value}</b>'.format(method=payment[0],
                                                                      value=payment[1]),
                                   header_items_l))
        story.append(ReportLine())


def _get_entry_quantity(till_history):
    entry_quantity = {}
    for th in till_history:
        if not th.method_name:
            continue
        if th.method_name == 'Cartão':
            if th.card_type == 1 or th.card_type == 4:
                card_type = 'Cartão de Débito'
            else:
                card_type = 'Cartão de Crédito'
            if entry_quantity.get(card_type):
                entry_quantity[card_type] = entry_quantity[card_type] + th.value
            else:
                entry_quantity[card_type] = th.value
        else:
            if entry_quantity.get(th.method_name):
                entry_quantity[th.method_name] = entry_quantity[th.method_name] + th.value
            else:
                entry_quantity[th.method_name] = th.value
    return entry_quantity


def _set_payments_data(story, entry_quantity):
    payment_total = 0

    d_sorted_by_value_payments = sorted([(key, value) for (key, value) in entry_quantity.items()])
    story.append(Paragraph('FORMAS DE PAGAMENTO',
                           header_items_c))
    for payment in d_sorted_by_value_payments:
        payment_total += payment[1]
        story.append(Paragraph('{method} : <b>R$ {value}</b>'.format(method=payment[0],
                                                                  value=payment[1]),
                               header_items_l))
    story.append(Paragraph('<b>Total: {total}</b>'.
                           format(total=payment_total),
                           header_items_l))
    story.append(ReportLine())


def _set_sangrias(story, open_date, close_date, station):
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


def _set_suprimentos(story, open_date, close_date, station):
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


def salesperson_stock_report(open_date, close_date, conn):
    user = get_current_user(conn)
    salesperson = ISalesPerson(user)

    sellable_qqtt_dict = {}
    sales = _get_sales(open_date, close_date, salesperson, conn)
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
    story = _get_story(company, 'RELATORIO DE PRODUTOS VENDIDOS')

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
    till_history = _get_till_history(open_date, close_date, salesperson, conn)

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
    story = _get_story(company, 'RELATORIO DE MOVIMENTAÇÃO DE CAIXA')
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

    #set payments data
    entry_quantity = _get_entry_quantity(till_history)
    _set_payments_data(story, entry_quantity)

    # card details
    _set_card_details(story, open_date, close_date, conn)

    # sangrias
    _set_sangrias(story, open_date, close_date, station)

    # suprimentos
    _set_suprimentos(story, open_date, close_date, station)

    filename = os.path.join(get_application_dir(), 'salespersonfinancial.pdf')
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

    story = _get_story(company, 'RELATORIO GERAL CAIXA+PRODUTOS VENDIDOS')
    story.append(Paragraph('Início: {open_date}'
                           .format(open_date=open_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(Paragraph('Fim: {close_date}'
                           .format(close_date=close_date.strftime('%d/%m/%Y %X')),
                           header_items_l))
    story.append(ReportLine())
    till_history = TillFiscalOperationsView.select(
        AND(TillFiscalOperationsView.q.date >= open_date,
            TillFiscalOperationsView.q.date <= close_date),
        connection=conn)


    # contadores por tipo de pagamento
    entry_quantity = _get_entry_quantity(till_history)

    total = 0
    discounts = 0
    # contadores de totais de itens
    for th in till_history:
        if not th.salesperson_id:
            continue
        total += th.value or 0
        discounts += th.discount_value or 0

    #set payments
    _set_payments_data(story, entry_quantity)

    #card details
    _set_card_details(story, open_date, close_date, conn)

    # sangrias
    _set_sangrias(story, open_date, close_date, station)

    # suprimentos
    _set_suprimentos(story, open_date, close_date, station)

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
