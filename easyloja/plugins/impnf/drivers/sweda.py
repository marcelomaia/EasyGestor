# coding=utf-8
from ctypes import CDLL

from interface import GenericPrinter


class Sweda(GenericPrinter):
    """
    """
    def __init__(self, port, dll):
        # a porta está configurada em um arquivo .ini
        self._dll = CDLL(dll)
        self._load_methods()

    def _load_methods(self):
        """
        SI300_eBuscarPortaVelocidade();
        SI300_rConsultaStatusImpressora(string indice, string retorno, ref string ret);
        SI300_rStatusGuilhotina();
        SI300_rStatusDocumento();
        SI300_fecharPorta();

        # region Gaveta
        SI300_regModoGaveta(string status);
        SI300_iAcionarGaveta();

        #region Impressão de Texto
        SI300_iImprimirTexto(string texto, int tamanho);
        SI300_iImprimirImagem(string arq);
        SI300_iCarregarBMPMemoria(string pszpath, int tipo);
        SI300_iImprimirBMPMemoria();
        """
        # Text area

        self._SI300_iAcionarGaveta = getattr(self._dll, 'SI300_iAcionarGaveta')
        self._SI300_iImprimirTexto = getattr(self._dll, 'SI300_iImprimirTexto')
        self._SI300_fecharPorta = getattr(self._dll, 'SI300_fecharPorta')

    def open_drawer(self):
        self._SI300_iImprimirTexto("<sl>1</sl>", 0)
        self._SI300_iAcionarGaveta()

    def close_port(self):
        self._SI300_fecharPorta()

    def cut_paper(self):
        self._SI300_iImprimirTexto("<sl>1</sl>" + "<gui></gui>", 0)

    def write_text(self, txt):
        self._SI300_iImprimirTexto(txt, len(txt))

    def write_formated_text(self, txt, bold=False, italic=False, underline=False, expand=False):
        return self.write_text(txt)

    def qr_code(self, txt):
        self.write_text("<qrcode>" + txt + "</qrcode>")

    def ean13(self, txt):
        self.write_text("<ean13>" + txt + "</ean13>")

    def test_printer(self):
        self.write_formated_text('TESTE ' * 100)
        self.ean13('123456789012')
        self.qr_code('123456789012')
        self.cut_paper()
        self.open_drawer()
        self.close_port()


class SI300S(Sweda):
    pass
