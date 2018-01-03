# coding=utf-8
from ctypes import windll

from interface import GenericPrinter


class Daruma(GenericPrinter):
    """ Interface para a lib DarumaFramework.dll
    Check DarumaFramework.xml file for configuration
    """

    def __init__(self, port, dll):
        self._dll = windll.LoadLibrary(dll)
        self._load_methods()

    def _load_methods(self):
        self._iAcionarGaveta_DUAL_DarumaFramework = getattr(self._dll, 'iAcionarGaveta_DUAL_DarumaFramework')
        self._iImprimirTexto_DUAL_DarumaFramework = getattr(self._dll, 'iImprimirTexto_DUAL_DarumaFramework')

    def open_drawer(self):
        retval = self._iAcionarGaveta_DUAL_DarumaFramework()
        return retval

    def close_port(self):
        """
        DUAL/ControleAutomatico controls this part
        """
        pass

    def write_text(self, txt):
        n = 1999
        parts = [txt[i:i + n] for i in range(0, len(txt), n)]
        for txt in parts:
            retval = self._iImprimirTexto_DUAL_DarumaFramework(txt + '\n', 0)
        return retval

    def write_formated_text(self, txt, bold=False, italic=False, underline=False, expand=False):
        """
        <b></b>        Negrito 	    <b>Exemplo</b>
        <i></i>        Italico ** 	<i>Exemplo</i>     **
        <s></s>        Sublinhado 	<s>Exemplo</s>
        <e></e>        Expandido 	<e>Exemplo</e>
        <c></c>        Condensado 	<c>Exemplo</c>

        Se desejar Sublinhar apenas uma parte do Texto utilize a combinação:
        "<b><e>Teste de <s>Comunicação</s></e></b>"
        ja recebe texto nesse padrao :) nao precisa fazer nada
        """
        return self.write_text(txt)

    def cut_paper(self):
        cut = '<sl>05<sl><gui></gui>'
        retval = self._iImprimirTexto_DUAL_DarumaFramework(cut, 0)
        return retval

    def qr_code(self, txt):
        return self.write_text("<qrcode>%s</qrcode>" % txt)

    def ean13(self, txt):
        return self.write_text("<ean13>%s</ean13>" % txt)

    def test_printer(self):
        self.write_text('TESTE ' * 100)
        self.qr_code('12345698123')
        self.open_drawer()
        self.cut_paper()
        self.close_port()


class DR800(Daruma):
    pass


class DR700(Daruma):
    pass
