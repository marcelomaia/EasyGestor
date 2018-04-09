# coding=utf-8
import xlwt
import os
from stoqlib.database.orm import AND
from stoqlib.domain.purchase import (PurchaseOrder)
from stoqlib.domain.views import CreatedProductView
from stoqlib.domain.views import StockIncreaseView, StockDecreaseView, SaleCounterView, PurchasedItemAndStockView
from stoqlib.lib.nfce.nfceutils import remove_accentuation
from stoqlib.lib.osutils import get_desktop_path


def generate_csv(current_branch, past_date):
    # lista de produtos que foram criados até a determinada data
    products_before_2013 = CreatedProductView.select(AND(CreatedProductView.q.create_date <= past_date,
                                                         CreatedProductView.q.branch == current_branch))
    prod_list = [p for p in products_before_2013]
    csv = 'classificacao_fiscal|discriminacao|quantidade|unidade|unitario|parcial\n'
    for prod in prod_list:
        # quantidade inserida depois da determinada data (modificações após)
        total_increase = [p.quantity for p in
                          StockIncreaseView.select(AND
                                                   (StockIncreaseView.q.branch == current_branch,
                                                    StockIncreaseView.q.product_id == prod.product_id,
                                                    StockIncreaseView.q.confirm_date >= past_date))]
        # quantidade retirada depois da determinada data (modificações após)
        total_decrease = [p.quantity for p in
                          StockDecreaseView.select(AND
                                                   (StockDecreaseView.q.branch == current_branch,
                                                    StockDecreaseView.q.product_id == prod.product_id,
                                                    StockDecreaseView.q.confirm_date >= past_date))]
        # quantidade vendida depois da determinada data (modificações após)
        total_quantity_sold = [p.quantity for p in
                               SaleCounterView.select(AND
                                                      (SaleCounterView.q.product_id == prod.product_id,
                                                       SaleCounterView.q.branch == current_branch,
                                                       SaleCounterView.q.open_date >= past_date))]
        # lista de todas as vendas até a determinada data (modificações antes) p/ calcular o preço medio do produto
        total_sold = [p.total for p in
                      SaleCounterView.select(AND
                                             (SaleCounterView.q.product_id == prod.product_id,
                                              SaleCounterView.q.branch == current_branch,
                                              SaleCounterView.q.open_date <= past_date))]
        # compras depois da determinada data (modificações após)
        total_purchased = [p.received for p in
                           PurchasedItemAndStockView.select(
                               AND(PurchasedItemAndStockView.q.product_id == prod.product_id,
                                   PurchasedItemAndStockView.q.branch == current_branch,
                                   PurchasedItemAndStockView.q.purchased_date >= past_date,
                                   PurchasedItemAndStockView.q.status == PurchaseOrder.ORDER_CLOSED))]
        estoque_esperado = prod.current_quantity - sum(total_purchased) - sum(total_increase) + sum(
            total_quantity_sold) + sum(total_decrease)
        if total_sold:
            media_p_venda = float(sum(total_sold)) / float(len(total_sold))
        else:
            media_p_venda = prod.base_price
        if estoque_esperado == 0:
            continue

        line = "{ncm}|{description}|{esperado:.2f}|{un}|{avg_sale_price:.2f}|{total:.2f}\n".format(
            ncm=prod.ncm or 'Sem NCM',
            description=prod.description,
            un=prod.unit,
            avg_sale_price=media_p_venda,
            total=float(media_p_venda) * float(estoque_esperado),
            esperado=estoque_esperado)
        csv += line
    return csv


def export_livro_fiscal(current_branch, past_date):
    csv_txt = generate_csv(current_branch, past_date)
    csv_txt = remove_accentuation(csv_txt)
    title = "Livro Inventario do dia {}".format(past_date.strftime('%d_%m_%Y'))
    book = xlwt.Workbook()
    sheet1 = book.add_sheet('Livro Inventario')

    lines = csv_txt.split('\n')

    for num in range(len(lines)):
        row = sheet1.row(num)
        for index, col in enumerate(lines[num].split('|')):
            value = col
            row.write(index, value)
    path = os.path.join(get_desktop_path(), "{title}.xls".format(title=title))
    book.save(path)
    return path
