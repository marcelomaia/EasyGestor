# -*- coding: utf-8 -*-
import os

from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.lib.styles import ParagraphStyle as PS
from reportlab.lib.units import mm
from reportlab.platypus import Image
from reportlab.platypus.doctemplate import PageTemplate, BaseDocTemplate
from reportlab.platypus.frames import Frame
from reportlab.platypus.paragraph import Paragraph
from stoqlib.domain.interfaces import IIndividual, ICompany
from stoqlib.domain.sale import Sale
from stoqlib.lib.formatters import format_phone_number
from stoqlib.lib.osutils import get_application_dir
from stoqlib.lib.parameters import sysparam
from stoqlib.reporting.base.flowables import ReportLine

width_doc, height_doc = 81.0 * mm, 330.0 * mm
left_margin, right_margin = 1.1 * mm, 1.1 * mm
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

items_1 = PS(name='Items',
             fontSize=7,
             leading=10,
             alignment=TA_LEFT, )

items_2 = PS(name='Items',
             fontSize=7,
             leading=10,
             alignment=TA_RIGHT, )

footer = PS(
    name='Footer',
    fontSize=13,
    leading=12,
    spaceBefore=10,
    alignment=TA_CENTER,
)


def align_text(text, size, alignment=LEFT):
    if len(text) < size:
        complement = '&nbsp;' * (size - len(text))
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
            first_part = first_part.replace(' ', '&nbsp;')
            last_part = complement[int(len(complement) / 2):]
            last_part = last_part.replace(' ', '&nbsp;')
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


def build_sale(sale, conn):
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
        story.append(
            Paragraph('{qtd} X {unit_price} {total}'
                      .replace(' ', '&nbsp;').format(qtd=align_text('{}'.format(item.quantity), 5, CENTER),
                                                     unit_price=align_text('{}'.format(item.price), 9, CENTER),
                                                     total=align_text('<b>{}</b>'.format(item.get_total()), 12,
                                                                      CENTER)),
                      items_2))

    story.append(ReportLine())
    for payment in sale.payments:
        if payment.is_inpayment():
            story.append(
                Paragraph('{} {}'.format(payment.method.description, payment.base_value),
                          header_items_l))
    if sale.discount_value:
        story.append(Paragraph('Desconto {}'.format(sale.discount_value)
                               .replace(' ', '&nbsp;'), header_items_l))
    story.append(Paragraph('<b>Valor total {}</b>'.format(sale.get_total_sale_amount())
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
    doc = PDFBuilder(os.path.join(get_application_dir(), 'mintoc.pdf'))
    return doc.multiBuild(story)
