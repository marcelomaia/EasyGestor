from ctypes import CDLL

from interface import GenericPrinter


class Elgin(GenericPrinter):
    """ Interface para a lib InterfaceEpsonNF.dll
    Exemplos de uso em:
        http://fivewin.com.br/index.php?/topic/21974-epsons-tm-t20/
    """

    def __init__(self, port, dll):
        self._dll = CDLL(dll)
        self._load_methods()

    def _load_methods(self):
        self._AbrePorta = getattr(self._dll, 'AbrePorta')
        self._AcionaGaveta = getattr(self._dll, 'AcionaGaveta')
        self._AcionaGuilhotina = getattr(self._dll, 'AcionaGuilhotina')
        self._FechaPorta = getattr(self._dll, 'FechaPorta')
        self._ImprimeTexto = getattr(self._dll, 'ImprimeTexto')
        self._ImprimeCodigoBarrasEAN13 = getattr(self._dll, 'ImprimeCodigoBarrasEAN13')
        self._ImprimeCodigoQRCODE = getattr(self._dll, 'ImprimeCodigoQRCODE')
        self._FormataTX = getattr(self._dll, 'FormataTX')
        self._AcionaGuilhotina = getattr(self._dll, 'AcionaGuilhotina')

    def open_drawer(self):
        retval = self._AcionaGaveta()
        return retval

    def close_port(self):
        return self._FechaPorta()

    def write_text(self, txt):
        return self._ImprimeTexto(txt)

    def cut_paper(self):
        self.write_text('\n\n\n\n\n')
        return self.write_text(PAPER_PART_CUT)

    def ean13(self, txt):
        return self._ImprimeCodigoBarrasEAN13(txt)

    def qr_code(self, txt):
        return self._ImprimeCodigoQRCODE(1, 10, 0, 10, 1, txt)

    def write_formated_text(self, txt, bold=False, italic=False, underline=False, expand=False):
        """
        FormataTX(cTexto AS LPSTR, nTipoLetra AS LONG, Nitalico AS LONG,;
        nSublin AS LONG, nExpan AS LONG, nEnfat AS LONG)
        AS LONG PASCAL;
        """
        TYPE = {True: 1, False: 0}
        return self._FormataTX(txt, 2, TYPE.get(italic), TYPE.get(underline), TYPE.get(expand), TYPE.get(bold))

    def test_printer(self):
        self.write_formated_text('TESTE ' * 100)
        # self.ean13('123456789012')
        self.qr_code('123456789012')
        self.cut_paper()
        self.open_drawer()
        self.close_port()


class I9(Elgin):
    pass
