from reportlab.lib.styles import ParagraphStyle as PS
from reportlab.lib.units import mm
from reportlab.platypus import PageBreak
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT, TA_JUSTIFY
from reportlab.platypus.doctemplate import PageTemplate, BaseDocTemplate
from reportlab.platypus.frames import Frame
from reportlab.platypus.paragraph import Paragraph
from reportlab.platypus.tableofcontents import TableOfContents

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

    # Entries to the table of contents can be done either manually by
    # calling the addEntry method on the TableOfContents object or automatically
    # by sending a 'TOCEntry' notification in the afterFlowable method of
    # the DocTemplate you are using. The data to be passed to notify is a list
    # of three or four items countaining a level number, the entry text, the page
    # number and an optional destination key which the entry should point to.
    # This list will usually be created in a document template's method like
    # afterFlowable(), making notification calls using the notify() method
    # with appropriate data.

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

# Create an instance of TableOfContents. Override the level styles (optional)
# and add the object to the story

# toc = TableOfContents()
# toc.levelStyles = [
#     PS(fontName='Times-Bold', fontSize=12, name='TOCHeading1', leftIndent=20, firstLineIndent=-20, spaceBefore=10,
#        leading=16),
#     PS(fontSize=18, name='TOCHeading2', leftIndent=40, firstLineIndent=-20, spaceBefore=5, leading=12),
# ]
# story.append(toc)

story.append(Paragraph('<b>EMPRESA BRASILEIRA DE INFORMATICA LTDA ME SA...</b>', h1_centered))
story.append(Paragraph('AVENIDA JOSE BONIFACIO, 352, BELEM-PA', h1_centered))
story.append(Paragraph('(91)3226-5660', h1_centered))
story.append(ReportLine())
story.append(Paragraph('<b>CUPOM NAO FISCAL</b>', header_warning))
story.append(ReportLine())
story.append(Paragraph('<b>|COD|Descricao                              |QTD|X|VlrUnit|VlrTotal</b>'
                       .replace(' ', '&nbsp;'), header_items))
story.append(ReportLine())
for i in range(100):
    story.append(Paragraph('  201   Produto 1                                         4     X     13,50        54.00'
                           .replace(' ', '&nbsp;'), items))

story.append(ReportLine())
story.append(Paragraph('<b>Desconto R$ 0.00                              Valor total R$ 283.00</b>'
                       .replace(' ', '&nbsp;'), header_items))
story.append(ReportLine())
story.append(Paragraph('<b>Troco R$ 0.00                                     Valor pago R$ 283.00</b>'
                       .replace(' ', '&nbsp;'), header_items))
story.append(ReportLine())
story.append(Paragraph('Data 20/20/20                                                 Hora 10:10:10\n\n'
                       .replace(' ', '&nbsp;'), header_items))
story.append(Paragraph('<b>VOLTE SEMPRE, SO JESUS SALVA</b>', footer))
doc = MyDocTemplate('mintoc.pdf')
doc.multiBuild(story)
