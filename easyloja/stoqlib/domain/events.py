# -*- Mode: Python; coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2007 Async Open Source <http://www.async.com.br>
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
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##

"""
Events used in the domain code
"""

from stoqlib.enums import CreatePaymentStatus
from stoqlib.lib.event import Event


#
# Product events
#


class ProductCreateEvent(Event):
    """
    This event is emitted when a product is created.

    @param product: the created product
    """


class ProductEditEvent(Event):
    """
    This event is emitted when a product is edited.

    @param product: the edited product
    """


class ProductRemoveEvent(Event):
    """
    This event is emitted when a product is about to be removed.

    @param product: the removed product
    """


class ProductStockUpdateEvent(Event):
    """
    This event is emitted when a product stock is in/decreased.

    @param product: the product that had it's stock modified
    @param branch: the branch on which the stock was modified
    @param old_quantity: the old product stock quantity
    @param new_quantity: the new product stock quantity
    """


#
# Category events
#

class CategoryCreateEvent(Event):
    """
    This event is emitted when a category is created.

    @param product: the created category
    """


class CategoryEditEvent(Event):
    """
    This event is emitted when a category is edited.

    @param product: the edited category
    """


#
# Sale events
#

class SaleDeliveryEvent(Event):
    """
    This event is emitted when a sale is confirmed

    @param sale: the sale which had it's status changed
    @param old_status: the old sale status
    """


class HasNFeHistoryEvent(Event):
    """
    This event is emitted when saledetailsdialog is opened:
    @param sale: a Sale
    """


class SaleSEmitEvent(Event):
    """
    This event is emitted when a sale is confirmed

    @param sale: the sale which had it's status changed
    @param old_status: the old sale status
    """


class SaleSLastEmitEvent(Event):
    """
    This event is emitted when a sale is confirmed

    @param sale: the sale which had it's status changed
    """


class SaleStatusChangedEvent(Event):
    """
    This event is emitted when a sale is confirmed

    @param sale: the sale which had it's status changed
    @param old_status: the old sale status
    """


class ECFIsLastSaleEvent(Event):
    """
    This event is emitted to compare the last sale with the last document
    in ECF.

    @param sale: sale that will be compared.
    """


# EBI 18/09/2013
class SalesReportPrint(Event):
    """
    Used to print a report from sale

    @param sale: sale that will be compared.
    """


# EBI 19/09/2013
class SalesCompareEvent(Event):
    """
    Used to print different items of 2 sales. See impressora_remota plugin

    @param sale: sale  before edit that will be compared.
    @param sale: sale after edit that will be compared.
    """


# EBI 14/11/2014
class SalesNFCEEvent(Event):
    """
    Used to send a sale to NFCE plugin

    @param sale: sale  before edit that will be compared.
    """


class ValidateItemNFCEEvent(Event):
    """
    Used to send a sale to NFCE plugin

    @param sellable: sellable to be validated
    """


class SalesNFCEReprintEvent(Event):
    """
    Used to reprint a sale to NFCE plugin
    """


class SalesCouponCancel(Event):
    """
    Used to cancel a coupon
    """


#
# NF-e Events
#


class SalesNFePreview(Event):
    """
    Used to create a nfe a coupon
    @param sale
    """


class SalesNFeCreate(Event):
    """
    Used to create a nfe a coupon
    @param sale
    """


class SalesNFeCancel(Event):
    """
    Used to create a nfe a coupon
    @param sale
    """


class SalesNFeCartaCorrecao(Event):
    """
    Used to create a nfe a coupon
    @param sale
    """


class SalesXMLNFeCreate(Event):
    """
    Used to send a nfe xml
    """


class SalesNfeDetails(Event):
    """
     Used to obtain info about current sale nf-e
     @param sale
    """


class PurchaseNfeDownload(Event):
    """
        Used when the user wanna get the nf-e xml
        to complete a purcahse process
    """


#
# Payment related events
#
class CreatedInPaymentEvent(Event):
    """
    This event is emmited when a payment is confirmed
    @param in_payment: The selected payment method.
    """


class CreatedOutPaymentEvent(Event):
    """
    This event is emmited when a payment is confirmed
    @param out_payment: The selected payment method."""


class CreatePaymentEvent(Event):
    """
    This event is emmited when a payment is about to be created and
    should be used to 'intercept' that payment creation.

    return value should be one of L{enum.CreatePaymentStatus}

    @param payment_method: The selected payment method.
    @param sale: The sale the payment should belong to
    """

    returnclass = CreatePaymentStatus


class CardPaymentReceiptPrepareEvent(Event):
    """
    This will be emmited when a card payment receipt should be printed.

    Expected return value is a string to be printed

    @param payment: the receipt of this payment
    @param supports_duplicate: if the printer being used supports duplicate
                               receipts
    """


class CardPaymentReceiptPrintedEvent(Event):
    """
    This gets emmited after a card payment receipt is successfully printed.

    @param payment: the receipt of this payment
    """


class CancelPendingPaymentsEvent(Event):
    """
    This gets emmited if a card payment receipt fails to be printed, meaning
    that all payments should be cancelled
    """


class GerencialReportPrintEvent(Event):
    """
    """


class ECFReportPrintEvent(Event):
    """
    """


class NFCEReportPrintEvent(Event):
    """
    """


class GerencialReportCancelEvent(Event):
    """
    """


class CheckECFStateEvent(Event):
    """After the TEF has initialized, we must check if the printer is
    responding. TEF plugin will emit this event for the ECF plugin
    """


#
# Till events
#

class TillOpenDrawer(Event):
    """
    This event is emitted when to open a drawer
    """


class TillOpenEvent(Event):
    """
    This event is emitted when a till is opened
    @param till: the opened till
    """


class TillCloseEvent(Event):
    """
    This event is emitted when a till is closed
    @param till: the closed till
    @param previous_day: if the till wasn't closed previously
    """


class HasPendingReduceZ(Event):
    """
    This event is emitted when a has pending 'reduce z' in ecf.
    """
    pass


class TillAddCashEvent(Event):
    """
    This event is emitted when cash is added to a till
    @param till: the closed till
    @param value: amount added to the till
    """


class TillRemoveCashEvent(Event):
    """
    This event is emitted when cash is removed from a till
    @param till: the closed till
    @param value: amount remove from the till
    """


class TillAddTillEntryEvent(Event):
    """
    This event is emitted when:

    cash is added to a till;
    cash is removed from a till;
    @param till_entry: TillEntry object
    @param conn: database connection
    """


class BuscaProdutoEvent(Event):
    """
    Esse evento é emitido para bucar informações de um barcode:

    @param barcode: a barcode string
    """


class PrintBillEvent(Event):
    """
    This event is emitted to print a bill.

    @param payment: payment itself
    """


class GenerateBillEvent(Event):
    """
    This event is emitted to generate a bill.

    @param payment: payment itself
    """


class CancelBillEvent(Event):
    """
    This event is emitted to cancel a bill.

    @param payment: payment itself
    """


class GenerateDuplicateEvent(Event):
    """
    This event is emitted to generate a duplicate.

    @param payment: payment itself
    """


class CheckBillStatusEvent(Event):
    """
    This event is emitted to check bill status.

    @param payment: payment itself
    """


class GenerateBatchBillEvent(Event):
    """
    This event is emitted to generate a lot of bills.

    @param sale: sale with payments
    """


class CheckPendingBillEvent(Event):
    """
    This event is emitted to generate a lot of bills.

    @param payments: a list of payment object
    """


class CheckCreatedBillEvent(Event):
    """
    This event is emitted to generate a lot of bills.

    @param payments: a list of payment object
    """


class CheckPaidBillEvent(Event):
    """
    This event is emitted to search paid bills

    @param start_date: start date
    @param end_date: end date
    """


class ResultListEvent(Event):
    """
    This event is emitted to provide a resultlist
    """


class CreateAffiliateEvent(Event):
    """
        This event is emitted to create a affiliate
    """
