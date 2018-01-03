# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2007 Async Open Source <http://www.async.com.br>
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
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
##
##  Author(s): Stoq Team <stoq-devel@async.com.br>
##
"""Invoice domain classes; field, layout and printer
"""
from zope.interface import implements

from stoqlib.database.orm import ForeignKey, IntCol, StringCol, UnicodeCol
from stoqlib.domain.base import Domain
from stoqlib.domain.interfaces import IDescribable


class InvoicePrinter(Domain):
    """An invoice printer is a representation of a physical printer
    connected to a branch station.
    It has a layout assigned which will be used to format the data sent
    to the printer
    @param device_name: a operating system specific identifier for the
      device used to send the printer job, /dev/lpX on unix
    @param description: a human friendly description of the printer, this
      will appear in interfaces
    @param station: the station this printer is connected to
    @param layout: the layout used to format the invoices
    """
    implements(IDescribable)

    device_name = StringCol()
    description = UnicodeCol()
    station = ForeignKey('BranchStation')
    layout = ForeignKey('InvoiceLayout')

    def get_description(self):
        """
        Gets the description of the printer.
        @returns: description
        """
        return self.description

    @classmethod
    def get_by_station(cls, station, conn):
        """Gets the printer given a station.
        If there's no invoice printer configured for this station, return
        None.
        @param station: the station
        @param conn: database connection
        @returns: an InvoiceLayout or None
        """
        return InvoicePrinter.selectOneBy(station=station,
                                          connection=conn)


class InvoiceLayout(Domain):
    """A layout of an invoice.
    @param description: description of the layout, this is human friendly
      string which is displayed in interfaces.
    @param width: the width in units of the layout
    @param height: the height in units of the layout
    """
    implements(IDescribable)

    description = UnicodeCol()
    width = IntCol()
    height = IntCol()

    @property
    def size(self):
        return self.width, self.height

    @property
    def fields(self):
        """Fetches all the fields tied to this layout
        @returns: a sequence of InvoiceField
        """
        return InvoiceField.selectBy(
            connection=self.get_connection(),
            layout=self)

    def get_field_by_name(self, name):
        """Fetches an invoice field by using it's name
        @param name: name of the field
        """
        return InvoiceField.selectOneBy(
            connection=self.get_connection(),
            layout=self,
            field_name=name)

    def get_description(self):
        """
        Gets the description of the field
        @returns: description.
        """
        return self.description


class InvoiceField(Domain):
    """Represents a field in an InvoiceLayout.
    @ivar x: x position of the upper left corner of the field
    @ivar y: y position of the upper left corner of the field
    @ivar width: the width of the field, must be larger than 0
    @ivar height: the height of the field, must be larger than 0
    @ivar field_name: the name of the field, this is used to identify
      and fetch the data when printing the invoice
    @ivar layout: the layout this field belongs to
    """
    x = IntCol()
    y = IntCol()
    width = IntCol()
    height = IntCol()
    field_name = StringCol()
    layout = ForeignKey('InvoiceLayout')
