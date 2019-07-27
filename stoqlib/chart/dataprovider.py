# -*- coding: utf-8 -*-

from decimal import Decimal


class AnnualSalesDataChart(object):
    initial_year = None
    final_year = None
    sql = '''
        select sum(total_amount) total_por_mes,
                date_part('year', confirm_date) ano,
                date_part('month', confirm_date) mes
        from sale
                where status in (1, 2)
                    and confirm_date::date between '01-01-%s' and '31-12-%s'
        group by ano, mes
        order by ano, mes
    '''

    def __str__(self):
        return 'Gerando Dados de %s a %s' % (self.initial_year, self.final_year)
    @property
    def legends(self):
        return range(self.initial_year, self.final_year+1)

    def year_interval_valid(self):
        if not self.initial_year or not self.final_year:
            return False
        return (self.final_year-self.initial_year) <= 4

    def mocks_end_list(self, year, first, last=12):
        return [(Decimal(0), year, i) for i in range(int(first), int(last)+1)]

    def final_greater_equal_initial(self):
        return self.final_year >= self.initial_year

    def complete_data(self, results):
        filled_results = []
        for c in range(self.initial_year, self.final_year+1):
            result_per_year = filter(lambda year_data: year_data[1] == c, results)
            if not result_per_year:
                filled_results += self.mocks_end_list(c, 1)
            else:
                filled_results += self.fill_holes_in_year(result_per_year)
        return filled_results

    def fill_holes_in_year(self, result_per_year):
        #A funçao somente recebe dados de um ano
        result_filled = []
        last_mounth = 1
        for result_month in result_per_year:
            if result_month[2] == last_mounth:
                last_mounth += 1
            else:
                #Faltaram Meses anteriores, se digamos que um ano começou
                # em Abril serao gerados mocks de Jan, Fev e Mar
                result_filled += [(Decimal(0), result_month[1], i)
                                  for i in range(int(last_mounth), int(result_month[2]))]
                last_mounth = result_month[2]+1
            result_filled.append(result_month)
        #Esse ultimo if serve para adicionar mocks ao final do array
        if len(result_filled) < 12:
            result_filled += self.mocks_end_list(result_per_year[0][1],
                                                 last_mounth)
        return result_filled

    #
    # DataChartInterface
    #

    def format_data(self, results):
        results = self.complete_data(results)
        retval = []
        tuples_series = [results[i:i+12] for i in range(0, len(results), 12)]
        for serie in tuples_series:
            retval.append([float(values[0]) for values in serie if values])
        return retval

    def query_for_results(self, conn):
        return conn.queryAll(self.sql % (self.initial_year, self.final_year))

    def validate_choice(self):
        return self.year_interval_valid() & self.final_greater_equal_initial()


class PaymentsDataChart(object):
    sql = '''
        select  mes, sum(valor_pago) total_mes, tipo
        from (
            select p.status, date_part('year', paid_date) ano, date_part('month', paid_date) mes,
            p.paid_value valor_pago, 'i' as tipo from payment p
            inner join payment_adapt_to_in_payment ip on p.id=ip.original_id
            union all
            select p.status, date_part('year', paid_date) ano, date_part('month', paid_date) mes,
            p.paid_value valor_pago, 'o' as tipo
            from payment p
            inner join payment_adapt_to_out_payment ip on p.id=ip.original_id) pagamentos
        where status=2 and ano=%s
        group by tipo, mes
        order by mes
    '''
    choiced_year = None
    tipos_pagamentos = ['i', 'o']

    @property
    def legends(self):
        return ['Recebimentos', 'Pagamentos']

    def mocks_end_list(self, tipo, first=0, last=12):
        return [(i, Decimal(0), tipo) for i in range(int(first), int(last)+1)]

    def fill_holes_in_year(self, result_per_year):
        result_filled = []
        last_mounth = 1
        for result_month in result_per_year:
            if result_month[0] == last_mounth:
                last_mounth += 1
            else:
                result_filled += [(i, Decimal(0), result_month[2])
                                  for i in range(int(last_mounth), int(result_month[0]))]
                last_mounth = result_month[0]+1
            result_filled.append(result_month)
        if len(result_filled) < 12:
            result_filled += self.mocks_end_list(result_per_year[-1][2], last_mounth)
        return result_filled

    def complete_data(self, results):
        filled_results = []
        for t in self.tipos_pagamentos:
            result_per_type = filter(lambda year_data: year_data[2] == t, results)
            if not result_per_type:
                filled_results += self.mocks_end_list(t, first=1)
            else:
                filled_results += self.fill_holes_in_year(result_per_type)
        return filled_results

    #
    # DataChartInterface
    #

    def validate_choice(self):
        return True

    def query_for_results(self, conn):
        return conn.queryAll(self.sql % self.choiced_year)

    def format_data(self, results):
        """
            this function split the results in series of n12 size to plotting the chart
        """
        results = self.complete_data(results)
        retval = []
        tuples_series = [results[i:i+12] for i in range(0, len(results), 12)]
        for serie in tuples_series:
            retval.append([float(values[1]) for values in serie if values])
        return retval