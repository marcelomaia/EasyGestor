# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

import platform

program_name = "EasyGestor"
program_codename = 'Bacaba'
website = 'http://ebi.com.br'
major_version = 1
minor_version = 5
micro_version = 7
extra_version = 3
release_date = (2018, 10, 24)
stable = True

version = '%d.%d.%d' % (major_version, minor_version, micro_version)

if extra_version > 0:
    version += '_%s' % str(extra_version)

try:
    from kiwi.environ import Library
except ImportError:
    from stoq.lib.dependencies import check_dependencies
    check_dependencies()

# XXX: Use Application
library = Library('stoq')
if library.uninstalled:
    library.add_global_resource('xls', 'data/xls')
    library.add_global_resource('config', 'data/config')
    library.add_global_resource('csv', 'data/csv')
    library.add_global_resource('docs', '.')
    library.add_global_resource('fonts', 'data/fonts')
    library.add_global_resource('glade', 'data/glade')
    library.add_global_resource('html', 'data/html')
    library.add_global_resource('misc', 'data/misc')
    library.add_global_resource('pixmaps', 'data/pixmaps')
    library.add_global_resource('sql', 'data/sql')
    library.add_global_resource('template', 'data/template')
    library.add_global_resource('uixml', 'data/uixml')
    library.add_global_resource('sumatraPDF', 'data/SumatraPDF')
    library.add_resource('plugin', 'plugins')
else:
    library.add_global_resource('xls', 'data/xls')

library.set_application_domain('stoq')
library.enable_translation()

if platform.system() == 'Windows':
    library.enable_translation(domain="stoq", localedir='share/locale')
else:
    library.enable_translation(domain="stoq")
