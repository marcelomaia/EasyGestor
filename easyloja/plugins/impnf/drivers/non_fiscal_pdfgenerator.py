# coding=utf-8
import os
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

from kiwi.environ import environ
from stoqlib.database.runtime import get_connection
from stoqlib.lib.osutils import get_application_dir
from stoqlib.lib.parameters import sysparam

appdir = get_application_dir()
NEW_LINE = '\n'


def to_utf8(txt, inputencode='iso-8859-1'):
    return txt.decode(inputencode).encode('utf-8')


MARGIN = 3 * mm
qr_height = 35 * mm
qr_width = 35 * mm
logo_height = 12.1 * mm
logo_width = 35 * mm
width_doc, height_doc = 81.0 * mm, 330.0 * mm
height_footer = 8 * mm
termal_paper = (width_doc, height_doc)
linespace = 4 * mm

fonts_dir = environ.get_resource_paths("fonts")[0]

pdfmetrics.registerFont(TTFont("Consola",
                               os.path.join(fonts_dir, "Consola.ttf")))
pdfmetrics.registerFont(TTFont("Consola-B",
                               os.path.join(fonts_dir, "Consola-B.ttf")))

DEFAULT_FONT = ('Consola', 7)
BOLD_FONT = ('Consola-B', 8)


def _get_logotype_path():
    conn = get_connection()
    logofile = sysparam(conn).CUSTOM_LOGO_FOR_NFCE
    conn.close()
    if logofile.is_valid():
        return str(logofile.image_path)
    else:
        return None


class PDFGen(object):
    """
    Receives a nfce text and returns a pdf
    Usage:
    """

    def __init__(self, nfce_text, canvas):
        self.text = nfce_text
        self.canvas = canvas

    #
    # Drawn sections
    #
    def draw_logo(self, x=width_doc / 2, y=height_doc):
        logo_path = _get_logotype_path()
        if logo_path is not None:
            y -= linespace
            self.draw_image_center(x - logo_width / 2, y - logo_height, logo_path, logo_width, logo_height)
            return y - logo_height
        return y

    def _draw_header1(self, text, x=0, y=height_doc):
        self.canvas.setFont(*DEFAULT_FONT)
        lines = text.split(NEW_LINE)
        for line in lines:
            y -= linespace
            self.draw_left_text(x, y, line)
        return y

    #
    # Drawn components
    #

    def draw_line(self, height):
        self.canvas.line(x1=MARGIN, y1=height + linespace / 2, x2=width_doc - MARGIN, y2=height + linespace / 2)

    def draw_left_text(self, x, y, text):
        self.canvas.drawString(x + MARGIN, y, text)

    def draw_center_text(self, x, y, text):
        self.canvas.drawCentredString(x, y, text)

    def draw_image_center(self, x, y, img, width=qr_width, height=qr_height):
        self.canvas.drawImage(img, x, y, width, height)

    #
    # Utils
    #

    def _set_check_spacing(self, y):
        #
        if y < height_footer:
            self.canvas.showPage()
            self.canvas.setFont(*DEFAULT_FONT)
            return height_doc
        return y

    def generate(self):
        height = self.draw_logo(x=width_doc / 2.0, y=height_doc)
        height = self._draw_header1(self.text, x=0, y=height)

    def save(self):
        self.canvas.save()


if __name__ == '__main__':
    from reportlab.pdfgen import canvas

    txt = "xxxx"
    canvas = canvas.Canvas('teste.pdf',
                           pagesize=termal_paper)
    pdfgen = PDFGen(nfce_text=txt, canvas=canvas)
    pdfgen.generate()
    pdfgen.save()
