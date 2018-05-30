# coding=utf-8

from iugu import MarketPlace as IuguMarketPlace


class MarketPlace():
    def __init__(self):
        self.mp = IuguMarketPlace()

    def create_subaccount(self, name, commission_percent):
        """Cria uma subconta, é super importante salvar esses dados no BD"""
        params = {'name': name,
                  'commission_percent': commission_percent}
        return self.mp.create(data=params)

    def get_subacount_data(self, account_id):
        return self.mp.sub_account(account_id)

    def verify_subaccount(self, account_id, data):
        """
        link: https://dev.iugu.com/reference#enviar-verificacao-de-conta
        Permite enviar documentos para verificação de subcontas. Todas as subcontas devem ter sua documentação
        verificada para emitir faturas no modo de produção.
        @:param account_id: id da subconta
        @:param data: dict com os parametros, sendo eles:
            data.price_range: Valor máximo da venda ('Até R$ 100,00', 'Entre R$ 100,00 e R$ 500,00',
                'Mais que R$ 500,00')
            data.physical_products: Vende produtos físicos?
            data.business_type: Descrição do negócio
            data.person_type: 'Pessoa Física' ou 'Pessoa Jurídica'
            data.automatic_transfer: Saque automático (Recomendamos que envie 'true')
            data.cnpj: CNPJ caso Pessoa Jurídica
            data.cpf: CPF caso Pessoa Física
            data.address: Endereço
            data.cep: CEP
            data.city: Cidade
            data.state: Estado
            data.telephone: Telefone
            data.resp_name: Nome do Responsável, caso Pessoa Jurídica
            data.resp_cpf: CPF do Responsável, caso Pessoa Jurídica
            data.bank: 'Itaú', 'Bradesco', 'Caixa Econômica', 'Banco do Brasil', 'Santander', 'Banrisul', 'Sicredi',
                'Sicoob'
            data.bank_ag: Agência da Conta
            data.account_type: 'Corrente', 'Poupança'
            data.bank_cc: Número da Conta
        """
        return self.mp.request_verification(account_id, data)

# token_acc_principal = '09fecfa8018ec877df2d7bc0326e9846'
# token_subconta = '110ef366314a888eaabab2eb8b10df9b'
#
# os.environ['IUGU_API_TOKEN'] = token_subconta
# marcelo_subaccount = '624229F5C249421EB6D11C183DF3D8A1'
# mp = MarketPlace()
# data = {'data':
#     {
#         'price_range': 'Mais que R$ 500,00',
#         'physical_products': False,
#         'business_type': 'TESTE ',
#         'person_type': 'Pessoa Física',
#         'automatic_transfer': True,
#         'cpf': '94882592215',
#         'city': 'BELEM',
#         'state': 'PA',
#         'telephone': '91991641767',
#         'bank': 'Banco do Brasil',
#         'bank_ag': '0765-x',
#         'account_type': 'Corrente',
#         'bank_cc': '00050726-1',
#         'name': 'Vitor Pinheiro Alves',
#         'address': 'Conj medice I, rua marapanim, 26',
#         'cep': '66620360',
#
#     }
# }
# print(mp.get_subacount_data(marcelo_subaccount))
