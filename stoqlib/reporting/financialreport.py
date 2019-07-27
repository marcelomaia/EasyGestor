# coding=utf-8
from stoqlib.database.runtime import get_current_branch, get_connection
from stoqlib.domain.interfaces import ICompany
from stoqlib.domain.person import Liaison
from stoqlib.exceptions import DatabaseInconsistency
from stoqlib.lib.formatters import get_formatted_price, format_phone_number
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.reporting.base.flowables import CENTER
from stoqlib.reporting.base.printing import ReportTemplate

_ = stoqlib_gettext


class FinancialReport(ReportTemplate):
    """ Sample object table report. For complex data that is stored in a
    list of objects, an object table is recommended.
      """

    def __init__(self, filename, pagamentos_dic, start_date, end_date, **args):
        report_name = u'Relatório de faturamento de caixa'
        ReportTemplate.__init__(self, filename, report_name, do_header=0)
        self.start_date = start_date.strftime('%d/%m/%Y')
        self.end_date = end_date.strftime('%d/%m/%Y')
        self.add_report_title()
        self.add_entrada_total(d_normal=pagamentos_dic['entrada']['formas_pagamento'],
                               d_category=pagamentos_dic['entrada']['categoria'],
                               d_card=pagamentos_dic['entrada']['cartao'])
        self.add_saida_total(d_normal=pagamentos_dic['saida']['formas_pagamento'],
                             d_category=pagamentos_dic['saida']['categoria'])
        self.entrada_total = sum([p for p in pagamentos_dic['entrada']['formas_pagamento'].values() if p is not None])
        self.saida_total = sum([p for p in pagamentos_dic['saida']['formas_pagamento'].values() if p is not None])
        self.saldo_ontem = 0
        if pagamentos_dic.get('faturamento_ontem', None):
            self.saldo_ontem = pagamentos_dic.get('faturamento_ontem')
        self.faturamento = self.entrada_total + self.saldo_ontem - self.saida_total
        self.add_faturamento()
        self.build_signatures()

    def add_report_title(self):
        person = get_current_branch(get_connection()).person
        main_address = person.get_main_address()
        company = ICompany(person, None)

        if not person.name:
            raise DatabaseInconsistency("The person by ID %d should have a "
                                        "name at this point" % person.id)
        self.add_title(company.person.name)
        # Address lines
        address_string1 = ''

        address_parts = []
        if main_address:
            address_string1 = main_address.get_address_string()

            if main_address.postal_code:
                address_parts.append(main_address.postal_code)
            if main_address.get_city():
                address_parts.append(main_address.get_city())
            if main_address.get_state():
                address_parts.append(main_address.get_state())

        address_string2 = " - ".join(address_parts)

        # Contact line
        extra_phones = [l for l in Liaison.selectBy(person=person, connection=get_connection())]
        phone_str = ''
        if extra_phones:
            for extra_phone in extra_phones:
                phone_str += ', ' + format_phone_number(extra_phone.phone_number)
        contact_parts = []
        if person.phone_number:
            company_phone = format_phone_number(person.phone_number)
            if phone_str:
                company_phone += phone_str
            contact_parts.append(_("Phone: %s")
                                 % company_phone)
        if person.fax_number:
            contact_parts.append(_("Fax: %s")
                                 % format_phone_number(person.fax_number))

        contact_string = ' - '.join(contact_parts)

        # Company details line
        company_parts = []
        if company:
            if company.get_cnpj_number():
                company_parts.append(_("CNPJ: %s") % company.cnpj)
            if company.get_state_registry_number():
                company_parts.append(_("State Registry: %s")
                                     % company.state_registry)

        company_details_string = ' - '.join(company_parts)

        for text in (address_string1, address_string2, contact_string,
                     company_details_string):
            self.add_paragraph(text)
        self.add_paragraph('Faturamento de {} até {}'.format(self.start_date, self.end_date))

    def add_faturamento(self):
        self.add_title('Faturamento')
        if self.saldo_ontem:
            self.add_data_table([('Saldo anterior:', '{}'.format(get_formatted_price(self.saldo_ontem)))])

        self.add_data_table((('Entrada total:', '{}'.format(get_formatted_price(self.entrada_total))),
                             ('Saída total:', '{}'.format(get_formatted_price(self.saida_total))),
                             ('Saldo do dia {}:'.format(self.start_date),
                              '{}'.format(get_formatted_price(self.faturamento)))))

    def add_saida_total(self, d_normal, d_category):
        self.add_title("Saídas")
        pay_forms = [(k, get_formatted_price(v)) for k, v in d_normal.iteritems()]
        if len(pay_forms) >= 1:
            self.add_paragraph('Por formas de pagamento')
            self.add_data_table(pay_forms)
        cat_table = [(k, get_formatted_price(v)) for k, v in d_category.iteritems()]
        if len(cat_table) >= 1:
            self.add_paragraph('Por categoria')
            self.add_data_table([(k, get_formatted_price(v)) for k, v in d_category.iteritems()])

    def add_entrada_total(self, d_normal, d_card, d_category):
        self.add_title("Entradas")
        pay_methods_table = [(k, get_formatted_price(v)) for k, v in d_normal.iteritems()]
        if pay_methods_table:
            self.add_paragraph('Por forma de pagamento')
            self.add_data_table(pay_methods_table)
        cat_table = [(k, get_formatted_price(v)) for k, v in d_category.iteritems()]
        if len(cat_table) >= 1:
            self.add_paragraph('Por categoria')
            self.add_data_table(cat_table)
        card_table = [(k, get_formatted_price(v)) for k, v in d_card.iteritems()]
        if len(card_table) >= 1:
            self.add_paragraph('Cartões')
            self.add_data_table(card_table)

    def build_signatures(self):
        labels = ['Assinatura 1', 'Assinatura 2']
        self.add_signatures(labels, align=CENTER)
