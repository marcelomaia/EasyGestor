import csv

from kiwi.currency import currency
from kiwi.environ import environ

csv_file = environ.find_resource('csv', 'ibpt.csv')


def ncm_table():
    f = csv.reader(open(csv_file), delimiter=';')
    rows = [row for row in f]
    ncm = {}
    for row in rows:
        ncm[row[0]] = {'aliqNac': row[4], 'aliqImp': row[5]}
    return ncm


def tax_on_cupom(sale):
    ncm = ncm_table()
    impostos = currency('0.00')
    discount_value = sale.discount_value
    subtotal = sale.get_total_sale_amount()

    discount_percentage = float(discount_value) / float(subtotal)

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
                calc = currency(str(item.price)) * (currency(aliq['aliqNac'])) * item.quantity / 100
                calc = currency(calc) - currency(calc) * currency(discount_percentage)
                impostos += calc
                print item.price, aliq['aliqNac'], impostos, discount_percentage
            else:
                calc = currency(str(item.price)) * (currency(aliq['aliqImp'])) * item.quantity / 100
                calc = currency(calc) - currency(calc) * currency(discount_percentage)
                impostos += calc
                print item.price, aliq['aliqImp'], impostos, discount_percentage
        else:
            continue
    tax_cupom = "Val Aprox Tributos R$ {:.2f} ({:.2f} %) " \
                "Fonte: IBPT".format(impostos,
                                     (impostos / sale.get_total_sale_amount() * 100))
    return tax_cupom.replace('.', ',')


if __name__ == '__main__':
    table = ncm_table()
    ncm = raw_input("NCM: ")
    print(table[ncm])
