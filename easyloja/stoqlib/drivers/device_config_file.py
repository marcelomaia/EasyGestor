# -*- coding: utf-8 -*-
__author__ = 'marcelo'

import os
import platform

from configparser import NoSectionError
import configparser
from kiwi.log import Logger

from stoqlib.lib.translation import stoqlib_gettext


_ = stoqlib_gettext
logger = Logger('stoqlib.drivers.ecf_port_config')

# windows only
class WindowsDevicePortConfig():
    import win32api
    sysdir = win32api.GetSystemDirectory()          # can be system32 or SysWOW64
    bits, linkage = platform.architecture()
    if '64' in bits:                                # 64 bits
        bematech_config_file = os.path.join(sysdir, 'BemaFI64.ini')
    else:                                           # 32 bits
        bematech_config_file = os.path.join(sysdir, 'BemaFI32.ini')
    daruma_config_file = os.path.join(sysdir, 'DarumaFrameWork.xml')

    @classmethod
    def save_port(cls, brand, port):
        if brand == 'bematech':
            config = configparser.ConfigParser()
            try:
                config.read(cls.bematech_config_file)
                config.set('Sistema', 'Porta', port)
            except NoSectionError, e:
                logger.info(_("Invalid config file settings, got error '%s', of type '%s") % (e, type(e)))
            try:
                with open(cls.bematech_config_file, 'wb') as configfile:
                    config.write(configfile)
            except IOError, e:
                logger.info("ERROR: %s" % e)
        elif brand == 'daruma':
            from ctypes import windll
            try:
                dll = windll.LoadLibrary('DarumaFrameWork.dll')
                dll.regAlterarValor_Daruma('ECF\PortaSerial', port)
            except WindowsError, e:
                logger.info("ERROR: %s" % e)