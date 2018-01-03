# -*- coding: utf-8 -*-
from stoqlib.domain.product import ProductStockItem, ProductAdaptToStorable, Product
from stoqlib.domain.sale import SaleItem, Sale
from stoqlib.database.orm import AND
from stoqlib.domain.sellable import Sellable


def apply_patch(trans):
    """ This patch updates the table ProductStockItem and sets the quantity of product on quote
    """
    
    sale_items = SaleItem.select(AND(SaleItem.q.saleID == Sale.q.id,
                                     Sale.q.status == Sale.STATUS_QUOTE,
                                     SaleItem.q.sellableID == Sellable.q.id,
                                     ), connection=trans)
    dict = {}

    for saleitem in sale_items:
        try:
            if saleitem.sellable.id not in dict:
                dict[saleitem.sellable.id] = saleitem.quantity
            else:
                dict[saleitem.sellable.id] += saleitem.quantity
        except (AttributeError, TypeError):
            pass

    for sellable_id in dict.keys():
        product_stock_items = ProductStockItem.select(AND(ProductStockItem.q.storableID == ProductAdaptToStorable.q.id,
                                                          ProductAdaptToStorable.q.originalID == Product.q.id,
                                                          Product.q.sellableID == sellable_id),
                                                      connection=trans)

        # sets the quantity on quote by each sellable, who persists this info is ProductStockItem
        if product_stock_items.count() > 0:
            for stock_item in product_stock_items:
                stock_item.quote_quantity = dict[sellable_id]       # sets quantity on ProductStockItem

    trans.commit()