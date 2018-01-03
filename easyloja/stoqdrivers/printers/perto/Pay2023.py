# -*- Mode: Python; coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Stoqdrivers
## Copyright (C) 2005-2007 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
## USA.
##
## Author(s):   Henrique Romano <henrique@async.com.br>
##              Johan Dahlin <henrique@async.com.br>
##
"""
PertoPay 2023 driver implementation.
"""

from stoqdrivers.printers.fiscnet.FiscNetECF import FiscNetChequePrinter
from stoqdrivers.translation import stoqdrivers_gettext

_ = stoqdrivers_gettext


class Pay2023(FiscNetChequePrinter):
    log_domain = 'PertoPay2023'
    supported = True

    model_name = "Pertopay Fiscal 2023"

