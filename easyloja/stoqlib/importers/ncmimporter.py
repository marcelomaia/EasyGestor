from kiwi.currency import currency
from kiwi.environ import environ
import csv

csv_file = environ.find_resource('csv', 'ibpt.csv')


def ncm_table():
    f = csv.reader(open(csv_file), delimiter=';')
    rows = [row for row in f]
    ncm = {}
    for row in rows:
        ncm[row[0]] = {'aliqNac': row[4], 'aliqImp':row[5]}
    return ncm


def tax_on_cupom(sale):
        ncm = ncm_table()
        impostos = currency('0.00')
        for item in sale.get_items():
            sellable = item._get_sellable()
            product = sellable._get_product()
            if not product:
                continue

            ncm_product = product.ncm
            aliq = ncm.get(ncm_product)
            if aliq is None:
                continue

            if product.icms_template:
                orig = getattr(product.icms_template, 'orig', 0)
                if orig in (0, 3, 4, 5):
                    impostos += currency(str(item.price)) * (currency(aliq['aliqNac'])) * item.quantity / 100
                    print item.price, aliq['aliqNac'], impostos
                else:
                    impostos += currency(str(item.price)) * (currency(aliq['aliqImp'])) * item.quantity / 100
                    print item.price, aliq['aliqImp'], impostos
            else:
                continue
            if sale.discount_value > 0:
                # diminui a qtde de impostos de acordo com o desconto da venda
                impostos -= impostos * sale.discount_value / sale.get_sale_subtotal()
        tax_cupom = "Val Aprox Tributos R$ {:.2f} ({:.2f} %) Fonte- IBPT".format(impostos,
                                                                                 (impostos*100)/sale.get_sale_subtotal()-sale.discount_value)
        return tax_cupom.replace('.', ',')


if __name__=='__main__':
    table = ncm_table()
    ncm = raw_input("NCM: ")
    print(table[ncm])