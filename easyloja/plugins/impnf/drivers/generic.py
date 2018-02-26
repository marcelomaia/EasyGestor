# coding=utf-8

import os
import serial
import subprocess
import tempfile

from kiwi.environ import environ
from kiwi.ui.dialogs import warning
from reportlab.pdfgen import canvas

from constants import BEEP, CD_KICK_2, CD_KICK_5
from interface import GenericPrinter
from non_fiscal_pdfgenerator import termal_paper, PDFGen


class VIRTUAL(GenericPrinter):
    """ somente mostra um warning
    """

    def __init__(self, port, dll):
        pass

    def open_drawer(self):
        return

    def close_port(self):
        return

    def write_text(self, txt):
        return warning(txt)

    def write_formated_text(self, txt, bold=False, italic=False, underline=False, expand=False):
        """
        suporta negrito, italico, sublinhado
        """
        d = {'<e>': '',
             '</e>': '',
             '<c>': '',
             '</c>': ''}
        _txt = self.replace_all(txt, d)
        self.write_text(_txt)

    def cut_paper(self):
        pass

    def test_printer(self):
        self.write_text('TESTE ' * 100)


class GENERICSERIAL(GenericPrinter):
    def __init__(self, port, dll):
        self.ser = serial.Serial(port, baudrate=115200)

    def write_text(self, txt):
        self.ser.write(txt)

    def open_drawer(self):
        self.write_text(CD_KICK_2 + '\n')
        self.write_text('\n')
        self.write_text(CD_KICK_5 + '\n')
        self.write_text('\n')

    def close_port(self):
        pass

    def test_printer(self):
        self.write_text('TESTE' * 100)
        self.write_text(BEEP + '\n')
        self.cut_paper()

    def cut_paper(self):
        self.write_text('\n\n\n\n\n')
        cmd = chr(27) + chr(109)
        self.write_text(cmd + '\n')


class GENERICSPOOLER(GenericPrinter):
    def __init__(self, port, spooler_printer):
        self.spooler_printer = spooler_printer
        self.sumatra_path = environ.find_resource('sumatraPDF', 'SumatraPDF.exe')

    def write_text(self, txt):
        tmp_file = tempfile.NamedTemporaryFile(delete=False)
        fname = tmp_file.name + '.pdf'
        can = canvas.Canvas(fname,
                            pagesize=termal_paper)
        pdfgen = PDFGen(nfce_text=txt, canvas=can)
        pdfgen.generate()
        pdfgen.save()
        self._print_on_spooler(filename=fname)

    def open_drawer(self):
        pass

    def test_printer(self):
        self.write_text('TESTE' * 50 + '\n' * 50)

    def cut_paper(self):
        pass

    def close_port(self):
        pass

    def _print_on_spooler(self, filename):
        """
        :param filename:
        :return:
        usando agora o SumatraPDF
        https://www.sumatrapdfreader.org/docs/Command-line-arguments-0c53a79e91394eccb7535ef6fed0678e.html
        """
        if os.path.exists(filename):
            cmd = '{exe} -print-to {printer} {fname}'.format(exe=self.sumatra_path,
                                                             printer=self.spooler_printer,
                                                             fname=filename)
            proc = subprocess.Popen(cmd.split(' '), shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
