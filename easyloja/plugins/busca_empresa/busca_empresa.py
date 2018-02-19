import requests


def extract_digits(text):
    return ''.join([p for p in text if p in '0123456789'])


url = 'https://www.receitaws.com.br/v1/cnpj/{cnpj}'.format(cnpj=extract_digits('17.895.646/0001-87'))

r = requests.get(url, timeout=3)
data = r.json()

company_name = data.get('nome')
phone = data.get('telefone')
email = data.get('email')
uf = data.get('uf')
company_status = data.get('situacao')
status = data.get('status')
district = data.get('bairro')
street = data.get('logradouro')
number = data.get('numero')
postal_address = data.get('cep')
city = data.get('municipio')
legal_nature = data.get('natureza_juridica')
cnpj = data.get('cnpj')
fancy_name = data.get('fantasia')

main_activity_data = data.get('atividade_principal')
secondary_activity_data = data.get('atividades_secundarias')

if status == 'ERROR':
    print 'ERRO'

partners_data = data.get('qsa')
for partner in partners_data:
    partner_qual = partner.get('qual')
    partner_nome = partner.get('nome')
    print 'parceiro', partner_qual, partner_nome

for activity in main_activity_data:
    description = activity.get('text')
    code = activity.get('code')
    print 'main', description, extract_digits(code)

for activity in secondary_activity_data:
    description = activity.get('text')
    code = activity.get('code')
    print 'secondary', description, extract_digits(code)

print company_name, fancy_name
