# -*- coding: utf-8 -*-
import os
try:
    import barcode
except ImportError, e:
    print 'You must install PyBarcode -> https://pypi.python.org/pypi/pyBarcode/0.7'
from barcode.errors import (IllegalCharacterError,
                            WrongCountryCodeError,
                            NumberOfDigitsError)
from barcode.writer import ImageWriter
from kiwi.argcheck import argcheck
from stoqlib.lib.osutils import get_application_dir


PROVIDED_BARCODES = barcode.PROVIDED_BARCODES
barcode_root = os.path.join(get_application_dir(), 'barcode')

if not os.path.exists(barcode_root):
    try:
        os.mkdir(barcode_root)
    except OSError:
        pass

for bc in PROVIDED_BARCODES:
    bc_dir = os.path.join(barcode_root, bc)
    if not os.path.exists(bc_dir):
        try:
            os.mkdir(bc_dir)
        except OSError:
            pass

@argcheck(str, str)
def generate_barcode(barcode_type, code):
    if barcode_type not in PROVIDED_BARCODES:
        return
    try:
        bc = barcode.get(barcode_type, code, ImageWriter())             # create barcode
        bc.save(os.path.join(barcode_root, barcode_type, code))         # saves image
    except (IllegalCharacterError,
            WrongCountryCodeError,
            NumberOfDigitsError,
            ValueError,
            KeyError,
            TypeError,
            OSError), e:
        print 'Barcode Error:', e