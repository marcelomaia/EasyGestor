# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2006-2011 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##
##

"""Translation utilities for stoqlib"""

import gettext as gettext_


def stoqlib_gettext(message):
    return dgettext('stoq', message)


def stoqlib_ngettext(singular, plural, n):
    return gettext_.dngettext('stoq', singular, plural, n)


def dgettext(domain, message):
    is_unicode = False
    if type(message) == unicode:
        message = str(message)
        is_unicode = True
    retval = gettext_.dgettext(domain, message)
    if is_unicode:
        retval = unicode(retval, 'utf-8')
    return retval


def gettext(message):
    return unicode(gettext_.gettext(message), 'utf-8')


def N_(message):
    return message
