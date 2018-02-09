# coding=utf-8
from reportlab.lib.enums import TA_LEFT, TA_CENTER
from reportlab.lib.styles import ParagraphStyle as PS
from reportlab.lib.units import mm
from reportlab.platypus.doctemplate import PageTemplate, BaseDocTemplate
from reportlab.platypus.frames import Frame
from reportlab.platypus.paragraph import Paragraph

from stoqlib.reporting.base.flowables import ReportLine

width_doc, height_doc = 81.0 * mm, 330.0 * mm
left_margin, right_margin = 1.1 * mm, 1.1 * mm


class MyDocTemplate(BaseDocTemplate):
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


centered = PS(name='centered',
              fontSize=30,
              leading=16,
              alignment=1,
              spaceAfter=20)

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

header_items = PS(name='HeaderItems',
                  fontSize=8,
                  leading=8,
                  alignment=TA_LEFT,
                  )

items = PS(name='Items',
           fontSize=7,
           leading=10,
           alignment=TA_LEFT, )

footer = PS(
    name='Footer',
    fontSize=14,
    leading=12,
    spaceBefore=10,
    alignment=TA_CENTER,
)

# Build story.
story = []
story.append(Paragraph('<b>EMPRESA BRASILEIRA DE INFORMATICA LTDA ME SA</b>', h1_centered))
story.append(Paragraph('AVENIDA JOSE BONIFACIO, 352, BELEM-PA', h1_left))
story.append(Paragraph('Fone: (91)3226-5660', h1_left))
story.append(Paragraph('CNPJ: 83.325.498/0001-90 IE154698031', h1_left))
story.append(ReportLine())
story.append(Paragraph('<b>CUPOM NAO FISCAL</b>', header_warning))
story.append(ReportLine())
story.append(Paragraph('<b>|COD|Descricao                              |QTD|X|VlrUnit|VlrTotal</b>'
                       .replace(' ', '&nbsp;'), header_items))
story.append(ReportLine())
for i in range(15):
    story.append(Paragraph('  201   Produto 1                                         4     X     13,50        54.00'
                           .replace(' ', '&nbsp;'), items))

story.append(ReportLine())
story.append(Paragraph('Cartão                                                                     R$ 100.00', header_items))
story.append(Paragraph('Cheque                                                                     R$ 100.00', header_items))
story.append(Paragraph('Dinheiro                                                                   R$ 83.00', header_items))
story.append(Paragraph('Desconto R$ 0.00                                <b>Valor total R$ 283.00</b>'
                       .replace(' ', '&nbsp;'), header_items))
story.append(ReportLine())
story.append(Paragraph('<b>Troco R$ 0.00                                     Valor pago R$ 283.00</b>'
                       .replace(' ', '&nbsp;'), header_items))
story.append(ReportLine())
story.append(Paragraph('Data 20/20/20                                                 Hora 10:10:10\n\n'
                       .replace(' ', '&nbsp;'), header_items))
story.append(Paragraph('Venda:     #78455'.replace(' ', '&nbsp;'), header_items))
story.append(Paragraph('Pedido:    #15'.replace(' ', '&nbsp;'), header_items))
story.append(Paragraph('<b>VOLTE SEMPRE, SO JESUS SALVA</b>', footer))
doc = MyDocTemplate('mintoc.pdf')
doc.multiBuild(story)
