import xlrd

from kiwi.environ import environ


def only_digits_cest(word, size):
    fixed_word = str(word)
    fixed_word = ''.join([p for p in fixed_word if p in '0123456789'])
    return fixed_word[:size]


def only_digits_ncm(word, size):
    fixed_word = str(word).replace('.0', '')
    fixed_word = ''.join([p for p in fixed_word if p in '0123456789'])
    return fixed_word[:size]


def find_cest(query_ncm):
    if len(query_ncm) != 8:
        return ''

    cest_xls = environ.find_resource('xls', 'CEST_NCM_TABELA.xls')

    xl_workbook = xlrd.open_workbook(cest_xls)
    xl_sheet = xl_workbook.sheet_by_name('CEST')
    total = 0
    COL_CEST = 0
    COL_NCM = 1
    ncm_sizes = [8, 7, 6, 5, 4, 2]
    cest = '2804400'  # default se nao achar nenhum
    total += 1
    skip_prod = False
    for row_idx in range(1, xl_sheet.nrows):  # Iterate through rows
        row_cest = ''
        for col_idx in [COL_CEST, COL_NCM]:  # Iterate through columns
            cell_obj = xl_sheet.cell(row_idx, col_idx)  # Get cell object by row, col
            if col_idx == COL_CEST:
                row_cest = only_digits_cest(cell_obj, 7)
            elif col_idx == COL_NCM and not skip_prod:
                for ncm in str(cell_obj).split(','):  # muitas vezes vem mais de um ncm separado por ,
                    ncm = only_digits_ncm(ncm, 8)
                    row_ncm = ncm
                    for size in ncm_sizes:  # tenta do tamanho 8 e vai tentando menores...
                        if query_ncm and not skip_prod:
                            ncm_piece = query_ncm[:size]
                            if row_ncm == ncm_piece:  # se o ncm bater, enao significa que pode pular o produto
                                skip_prod = True
                                cest = row_cest
    return cest
