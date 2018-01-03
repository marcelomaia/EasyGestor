# coding=utf-8
from ctypes import windll

from interface import GenericPrinter


class Bematech(GenericPrinter):
    """ Interface para a lib MP2032.dll
    Suporta os modelos MP-2500 TH, MP-4000, MP-4200 TH e MP-100S TH
    5: MP-4000 TH
    7: MP-4200 TH
    8: MP-2500 TH
    """
    printer_model = None

    def __init__(self, port, dll):
        self._dll = windll.LoadLibrary(dll)
        if self.printer_model is not None:
            self._dll.ConfiguraModeloImpressora(self.printer_model)
        self._dll.IniciaPorta(str(port))
        self._load_methods()

    def _load_methods(self):
        self._ComandoTX = getattr(self._dll, 'ComandoTX')
        self._FechaPorta = getattr(self._dll, 'FechaPorta')
        self._IniciaPorta = getattr(self._dll, 'IniciaPorta')
        self._BematechTX = getattr(self._dll, 'BematechTX')
        self._ImprimeCodigoBarrasEAN13 = getattr(self._dll, 'ImprimeCodigoBarrasEAN13')
        self._FormataTX = getattr(self._dll, 'FormataTX')
        self._ImprimeCodigoQRCODE = getattr(self._dll, 'ImprimeCodigoQRCODE')

    def open_drawer(self):
        # Open drawer command
        cmd = chr(27) + chr(118) + chr(140)
        return self._ComandoTX(cmd, len(cmd))

    def close_port(self):
        return self._FechaPorta()

    def cut_paper(self):
        # cut paper command
        self.write_text('\n\n\n\n\n')
        cmd = chr(27) + chr(109)
        return self._ComandoTX(cmd, len(cmd))

    def write_text(self, txt):
        return self._BematechTX(txt)

    def write_formated_text(self, txt, bold=False, italic=False, underline=False, expand=False):
        TYPE = {True: 1, False: 0}
        return self._FormataTX(txt, 2, TYPE.get(italic), TYPE.get(underline), TYPE.get(expand), TYPE.get(bold))

    def qr_code(self, txt):
        """
        Nível de Restauração: variável INT para definir o nível de restauração do código, onde:
        0 - Aproximadamente 7% de restauração.
        1 - Aproximadamente 15% de restauração.
        2 - Aproximadamente 25% de restauração.
        3 - Aproximadamente 30% de restauração.

        Tamanho do módulo: variável INT para definir o tamanho do módulo do código, compreendido entre 1 e 127.
        Tipo: variável INT com o tipo do código, compreendido entre 0 e 1, onde 0 é para a impressão em tamanho
        normal e 1 para tamanho reduzido.
        Versão do código: variável INT para definir a versão do código QRCODE, compreendido entre 1 e 40.
        Formato do Código: variável INT para definir quais dados serão impressões no código QRCODE, onde:

        - Para o tamanho normal.

        0 &endash; Somente números até 7.089 caracteres.
        1 &endash; Alfanumérico com até 4.296 caracteres.
        2 &endash; Binário (8 bits) com até 2.953 bytes.
        3 &endash; Kanji com até 1.817 caracteres.

        - Para o tamanho reduzido.

        0 &endash; Somente números até 35 caracteres.
        1 &endash; Alfanumérico com até 21 caracteres.
        2 &endash; Binário (8 bits) com até 15 bytes.
        3 &endash; Kanji com até 9 caracteres.

        Código: variável STRING com os dados que serão impressos no código QRCODE.

        errorCorrectionLevel  := 1;
        moduleSize            := 10;
        codeType              := 0;
        QRCodeVersion         := 10;
        encodingModes         := 1;
        codeQr                := '123ABC';
        ImprimeCodigoQRCODE(errorCorrectionLevel, moduleSize, codeType, QRCodeVersion, encodingModes, pchar( codeQr ) );
        """
        return self._ImprimeCodigoQRCODE(1, 10, 0, 10, 1, txt)

    def test_printer(self):
        self.write_formated_text('TESTE ' * 100)
        # self.ean13('123456789012')
        self.qr_code('123456789012')
        self.cut_paper()
        self.open_drawer()
        self.close_port()


(model_mp4000,
 model_mp4200,
 model_mp2500,
 model_mp100s) = (5, 7, 8, None)


class MP4000TH(Bematech):
    printer_model = model_mp4000


class MP4200TH(Bematech):
    printer_model = model_mp4200


class MP2500TH(Bematech):
    printer_model = model_mp2500


class MP100STH(Bematech):
    printer_model = model_mp100s