# -*- coding: utf-8 -*-
import json
import datetime
import random
import sys

from dateutils import timezone
from kiwi.argcheck import argcheck

from stoqlib.domain.interfaces import ICompany, IIndividual
from stoqlib.enums import NFeDanfeOrientation
from stoqlib.exceptions import ModelDataError
from stoqlib.lib.nfce.taxes import nfce_icms, nfce_ipi, nfce_pis, nfce_cofins
from stoqlib.lib.translation import stoqlib_gettext as _
from stoqlib.lib.nfce.nfceutils import get_state_code, get_city_code, strip_accents
from stoqlib.lib.parameters import sysparam
from stoqlib.lib.validators import validate_cnpj


class NFCeJsonGeneration(object):
    """
Here are the necessary data to create a json for NFC-e generation
tag meanings: https://www.fazenda.sp.gov.br/nfe/legislacao/manual_de_integracao_contribuinte_v202a.pdf
and -> http://www.nfe.fazenda.gov.br/portal/exibirArquivo.aspx?conteudo=th9CTZWwtBg=

there is only a portuguese manual

    ide -> dados de identificação
            CUF, NatOp, IndPag, Mod, Serie,
            NNF, DHEmi, DHSaiEnt, TpNF, idDest, CMunFG,
            TpImp, TpEmis, CDV, TpAmb, FinNFe, indFinal,
            indPres, ProcEmi, VerProc
    emit -> dados do emitente
            CNPJ, CPF, XNome, XFant, IE, CRT,
            enderEmitXLgr, enderEmitNro, enderEmitXCpl, enderEmitXBairro,
            enderEmitCMun, enderEmitXMun, enderEmitUF, enderEmitCEP,
            enderEmitCPais, enderEmitXPais, enderEmitFone
    avulsa -> dados avulsos
            CNPJ, DEmi, DPag, Fone, Matr, NDAR,
            RepEmi, UF, VDAR, XAgente, XOrgao
    dest -> dados do destinatário
            CNPJ, CPF, idEstrangeiro, XNome, IEDest, Email,
            enderDestXLgr, enderDestNro, enderDestXBairro,
            enderDestCMun, enderDestXMun, enderDestUF,
            enderDestCEP, enderDestCPais, enderDestXPais,
            enderDestFone
    autXML -> dados da autorização da XML
            CNPJ, CPF
    det ->  dados do produto
            NItem, InfAdProd, prodCProd, prodCEAN, prodXProd,
            prodNCM, prodCFOP, prodUCom, prodQCom, prodVUnCom,
            prodVProd, prodUTrib, prodQTrib, prodCEANTrib, prodVUnTrib,
            prodIndTot, Orig, CSOSN, VBCSTRet, VICMSSTRet, pisntCST, cofinsntCST
    total -> totais da NFE
            icmstotVBC, icmstotVICMS, icmstotvICMSDeson, icmstotVBCST,
            icmstotVST, icmstotVProd, icmstotVFrete, icmstotVSeg,
            icmstotVDesc, icmstotVII, icmstotVIPI, icmstotVPIS, icmstotVCOFINS,
            icmstotVOutro, icmstotVNF
    transp -> dados do transporte
            ModFrete, volQVol, volNVol, volPesoL, volPesoB
    pag ->  dados do pagamento
            tPag, vPag, cardCNPJ, cardcAut, cardBand
    infAdic -> informações adicionais
            InfCpl
    exporta -> dados de exportação
            UFSaidaPais, xLocDespacho, xLocExporta
    retirada -> dados entrega retirada
            cpf, cnpj, CMun, XLgr, Nro, UF, XBairro, XCpl, XMun

"""
    def __init__(self, sale, conn):
        self._sale = sale
        self.conn = conn
        self.json = ''
    #
    # main methods
    #

    def generate(self):
        """Generates the NF-e."""
        #/nfexmlgerar/{ide}/{emit}/{avulsa}/{dest}/{autXML}/{det}/{total}/{transp}/{pag}/{infAdic}/{exporta}/{retirada}/{autorizacao}/{nfeLote}
        branch = self._sale.branch
        ide = self._add_identification(branch)                  # ide
        emit = self._add_issuer(branch)                         # emit
        avulsa = self.avulsa(cnpj='14237745000183',
                             demi=datetime.datetime.today(),
                             dpag=datetime.datetime.today(),
                             fone='322251',
                             matr='321', ndar='3213',
                             repemi='312132',
                             uf='AM',
                             vdar='21221',
                             xagente='32123',
                             xorgao='10')
        dest = self._add_recipient(self._sale.client)           # dest
        aut = self.autxml('01347255222')
        det = self._add_sale_items(self._sale.get_items())      # det
        tot = self._add_totals()

        transp = self._add_transport_data(self._sale.transporter,
                                          self._sale.get_items())
        pag = self._add_billing_data()
        adt_inf = self._add_additional_information()
        export = self.exporta(ufsaidapais='PA', xlocdespacho='Belem', xlocexporta='Sp')         # export e retirada muito amarrado, resolver isso do lado do server
        retirada = self.retirada(cpf='01353538230', cnpj='', cmun='1304401', xlgr='asdasd', nro="213", uf="AM",
                                 xbairro="asda", xcpl="51321", xmun="Belem")
        self.json += ide + "/" + emit + "/" + avulsa + "/" + dest + "/" + aut + "/" + det + "/" + tot + "/" + transp + "/" + pag + "/" + adt_inf + "/" + export + "/" + retirada + "/1/1"

    def _add_additional_information(self):
        d = dict()
        import string
        fisco_info = sysparam(self.conn).NFE_FISCO_INFORMATION.strip(string.whitespace)
        d['infCpl'] = strip_accents("Fisco: %s\n" % fisco_info)
        return json.dumps(d)

    def _add_billing_data(self):
        """ Dados de Pagamento. Obrigatório apenas para (NFC-e) NT 2012/004

        @param tPag Forma de Pagamento: 01-Dinheiro; 02-Cheque; 03-Cartão de
        Crédito; 04-Cartão de Débito; 05-Crédito Loja; 10-Vale Alimentação;
        11-Vale Refeição; 12-Vale Presente; 13-Vale Combustível; 99 - Outros.

        @param vpag: Valor do Pagamento.

        Objeto (interno) Card: Grupo de Cartões
        @param cardcnpj: CNPJ da credenciadora de cartão de crédito/débito.
        @param cardcaut: Número de autorização da operação cartão de
        crédito/débito.
        @param cardband: Bandeira da operadora de cartão de crédito/débito:
        01–Visa; 02–Mastercard; 03–American Express; 04–Sorocred; 99–Outros.
        """
        # # Cartão
        # card = dict()
        # card['CNPJ'] = cardcnpj
        # card['tBand'] = cardband
        # card['cAut'] = cardcaut

        pag = dict()
        pag["tPag"] = '01'
        pag["vPag"] = str(self._sale.get_total_sale_amount())
        # pag["card"] = card
        return json.dumps(pag)

    def _add_transport_data(self, transporter, sale_items):
        transp = dict()
        volvet = []
        #{"modFrete":"9","vol":[{"qVol":"0","nVol":"0","pesoL":"0.000","pesoB":"0.000"}]}/
        if transporter:
            transporta = dict()
            person = transporter.person
            name = person.name
            individual = IIndividual(person, None)

            if individual is not None:
                cpf = ''.join([c for c in individual.cpf if c in '1234567890'])
                transporta["cpf"] = cpf
            else:
                company = ICompany(person)
                cnpj = ''.join([c for c in company.cnpj if c in '1234567890'])
                transporta["cnpj"] = cnpj
                transporta["cnpj"] = company.state_registry

            address = person.get_main_address()
            if address:
                transporta["xEnder"] = address.get_address_string()[:60]
                transporta['xMun'] = address.city_location.city[:60]
                transporta['UF'] = address.city_location.state
            transp['transporta'] = transporta                       # adiciona transportadora

        for item_number, sale_item in enumerate(sale_items):
            vol = dict()
            sellable = sale_item.sellable
            product = sellable.product
            if not product:
                continue

            unitary_weight = product.weight
            # if not unitary_weight:
            #     continue

            unit = sellable.unit and sellable.unit.get_description() or ''
            weight = sale_item.quantity * unitary_weight

            quantity = sale_item.quantity
            if quantity:
                import math
                vol["qVol"] = str(math.ceil(quantity))
            else:
                vol["qVol"] = '0'
            vol["nVol"] = ''
            vol["pesoL"] = "%.3f" % weight
            vol["pesoB"] = "%.3f" % weight
            volvet.append(vol)

        transp["modFrete"] = '1'
        transp["vol"] = volvet
        return json.dumps(transp)

    def _add_totals(self):
        d = dict()
        sale_total = self._sale.get_total_sale_amount()
        items_total = self._sale.get_sale_subtotal()
        discount = items_total - sale_total
        d['icmsTot'] = dict(vbc=self.format_value(sale_total),
                            vicms='0.00',
                            vICMSDeson='0',
                            vbcst='0',
                            vst='0',
                            vProd=self.format_value(items_total),
                            vFrete='0',
                            vSeg='0',
                            vDesc=self.format_value(discount),
                            vii='0',
                            vipi='0',
                            vpis='0',
                            vcofins='0',
                            vOutro='0',
                            vnf=self.format_value(sale_total))
        return json.dumps(d)

    def _add_identification(self, branch):
        danfe_orientation = {
            NFeDanfeOrientation.PORTRAIT: '1',
            NFeDanfeOrientation.LANDSCAPE: '2',
            }
        # Pg. 71
        branch_location = branch.person.get_main_address().city_location
        cuf = str(get_state_code(branch_location.state) or '')
        cnf = self._get_random_cnf()

        today = self._get_today_date()
        aamm = today.strftime('%y%m')

        nnf = self._sale.invoice_number
        assert nnf

        payments = self._sale.group.get_items()

        payment_type = 1
        installments = len(list(payments))
        if installments == 1:
            payment = payments[0]
            if (payment.paid_date and
                payment.paid_date.date() == datetime.date.today()):
                payment_type = 0
        mod = 65

        series = sysparam(self.conn).NFE_SERIAL_NUMBER
        dhemi = datetime.datetime.now()
        dhsaient = self._sale.close_date
        tpnf = '1'
        iddest = '1'
        cmunfg = get_city_code(branch_location.city, code=cuf) or ''
        orientation = sysparam(self.conn).NFE_DANFE_ORIENTATION
        nat_op = self._sale.operation_nature or ''
        tpimp = danfe_orientation[orientation]

        tpemis = '1'
        cnpj = self._get_cnpj(branch)
        mod = "%02d" % mod
        series = "%03d" % series
        nnf_str = '%09d' % nnf
        cnf = '%08d' % cnf
        cmunfg = str(cmunfg)
        key = cuf + aamm + cnpj + mod + series + nnf_str + tpemis + cnf
        cdv = self._calculate_verifier_digit(key)
        payment_type = str(payment_type)


        ide_str = self.ide(cuf=cuf,
                           cnf=cnf,
                           natop=nat_op,
                           indpag=payment_type,
                           mod=mod,
                           serie=series,
                           nnf=nnf_str,
                           dhemi=dhemi,
                           dhsaient=dhsaient,
                           tpnf=tpnf,
                           iddest=iddest,
                           cmunfg=cmunfg,
                           tpimp=tpimp,
                           tpemis=tpemis,
                           cdv=cdv,
                           tpamb='1',
                           finnfe='1',
                           indfinal='1',
                           indpres='1',
                           procemi='3',
                           verproc='3.0')

        return ide_str

    def _add_issuer(self, issuer):
        cnpj = self._get_cnpj(issuer)
        person = issuer.person
        name = person.name
        company = ICompany(issuer, None)
        fancy_name = company.fancy_name
        state_registry = company.state_registry
        street, \
        streetnumber, \
        complement, \
        district, \
        city, \
        state, \
        country, \
        postal_code,  \
        phone_number = self._get_address_data(person)

        crt = self._sale.branch.crt
        # should have a cnpj at this point
        emit_str = self.emit(cnpj=str(cnpj),    # cpf or cnpj, not both
                             cpf='',
                             xnome=str(name),
                             xfant=str(fancy_name),
                             ie=str(state_registry),
                             crt=str(crt),
                             enderemitxlgr=str(street),
                             enderemitnro=str(streetnumber) or "S/N",
                             enderemitxcpl=str(complement),
                             enderemitxbairro=str(district),
                             enderemitcmun=str(get_city_code(city)) or '',
                             enderemitxmun=str(city),
                             enderemituf=str(state),
                             enderemitcep=str(postal_code),
                             enderemitcpais='1058',
                             enderemitxpais='Brasil',
                             enderemitfone=str(phone_number))
        return emit_str

    def _add_recipient(self, client):
        person = client.person
        name = person.name
        email = person.email
        individual = IIndividual(person, None)
        cnpj = ''
        cpf = ''
        if individual is not None:
            cpf = ''.join([c for c in individual.cpf if c in '1234567890'])
        else:
            cnpj = self._get_cnpj(person)
            company = ICompany(person, None)
            state_registry = company.state_registry

        street, \
        streetnumber, \
        complement, \
        district, \
        city, \
        state, \
        country, \
        postal_code,  \
        phone_number = self._get_address_data(person)

        dest_str = self.dest(cnpj=str(cnpj),                     # cnpj or cpf, not both
                             cpf=str(cpf),
                             idestrangeiro='',
                             xnome=str(name),
                             iedest='1',
                             email=str(email),
                             enderdestxlgr=str(street),
                             enderdestnro=str(streetnumber) or "S/N",
                             # enderdestxcpl=str(complement),
                             enderdestxbairro=str(district),
                             enderdestcmun=str(get_city_code(city)) or '',
                             enderdestxmun=str(city),
                             enderdestuf=str(state),
                             enderdestcep=str(postal_code),
                             enderdestcpais='1058',
                             enderdestxpais='Brasil',
                             enderdestfone=str(phone_number))
        return dest_str

    def _add_sale_items(self, sale_items):
        det_list = []
        for item_number, sale_item in enumerate(sale_items):
            d = dict()
            # item_number should start from 1, not zero.
            item_number += 1

            sellable = sale_item.sellable
            product = sellable.product
            if product:
                ncm = product.ncm
                ex_tipi = product.ex_tipi
                genero = product.genero
            else:
                ncm = ''
                ex_tipi = ''
                genero = ''

            det_prod = self.det_prod(nitem=str(item_number),
                                     infadprod='',
                                     prodcprod=sellable.code,
                                     prodcean=sellable.barcode,
                                     prodxprod=sellable.get_description(),
                                     prodncm=ncm,
                                     prodcfop=sale_item.get_nfe_cfop_code(),
                                     producom=sellable.get_unit_description(),
                                     prodqcom=self.format_value(sale_item.quantity, precision=4),
                                     prodvuncom=self.format_value(sale_item.price, precision=4),
                                     prodvprod=self.format_value(sale_item.price * sale_item.quantity, precision=4),
                                     produtrib=sellable.get_unit_description(),
                                     prodqtrib=self.format_value(sale_item.quantity, precision=4),
                                     prodceantrib='',
                                     prodvuntrib=self.format_value(sale_item.price, precision=4),
                                     prodindtot='1',
                                     sale_item=sale_item,                   # taxes
                                     crt=self._sale.branch.crt)
            det_list.append(det_prod)
        return json.dumps(det_list)

    #
    # Private API
    #

    def _get_address_data(self, person):
        """Returns a tuple in the following format:
        (street, streetnumber, complement, district, city, state, country, postal_code,
         phone_number)
        """
        address = person.get_main_address()
        postal_code = ''.join([i for i in address.postal_code if i in '1234567890'])
        location = address.city_location
        return (address.street, address.streetnumber, address.complement,
                address.district, location.city, location.state, location.country,
                postal_code, person.get_phone_number_number())

    def format_value(self, value, precision=2):
        return '%.*f' % (precision, value)

    def _get_cnpj(self, person):
        company = ICompany(person, None)
        assert company is not None

        #FIXME: fix get_cnpj_number method (fails if start with zero).
        cnpj = ''.join([c for c in company.cnpj if c in '1234567890'])
        if not validate_cnpj(cnpj):
            raise ModelDataError(_("The CNPJ of %s is not valid.")
                                   % person.person.name)

        return cnpj

    def _calculate_verifier_digit(self, key):
        # Calculates the verifier digit. The verifier digit is used to
        # validate the NF-e key, details in page 72 of the manual.
        assert len(key) == 43

        weights = [2, 3, 4, 5, 6, 7, 8, 9]
        weights_size = len(weights)
        key_numbers = [int(k) for k in key]
        key_numbers.reverse()

        key_sum = 0
        for i, key_number in enumerate(key_numbers):
            # cycle though weights
            i = i % weights_size
            key_sum += key_number * weights[i]

        remainder = key_sum % 11
        if remainder == 0 or remainder == 1:
            return '0'
        return str(11 - remainder)

    def _get_today_date(self):
        return datetime.date.today()

    def _get_random_cnf(self):
        return random.randint(10000000, 99999999)

    #
    # Helper
    #

    def __adpt_time(self, time_datetime):
        """ To fit the time format
        (AAAA-MM-DDThh:mm:ssTZD) ex.: 2012-09-01T13:00:00-03:00.
        """
        # 2012-09-01T13:00:00-03:00
        tz = 'America/Belem'                                            # implementar para pegar o timezone da maquina
        nfe_time = timezone(dt=time_datetime, timezone=tz).strftime('%Y-%m-%dT%H:%m:%S%z')
        return nfe_time[:-2] + ":" + nfe_time[-2:]


    #
    # NFCe related
    #

    @argcheck(str, str, unicode, str, str, str, str, datetime.datetime, datetime.datetime, str,
              str, str, str, str, str, str, str, str, str, str, str)
    def ide(self, cuf, cnf, natop, indpag, mod, serie, nnf, dhemi, dhsaient,
            tpnf, iddest, cmunfg, tpimp, tpemis, cdv, tpamb, finnfe, indfinal,
            indpres, procemi, verproc):
        """     Identificação do emitente

        @param cuf: Código da UF que atendeu a solicitação
        @param cnf: Código numérico que compõe a Chave de Acesso. Número
                    aleatório gerado pelo emitente para cada NFC-e.
        @param natop: Natureza da operação de que decorrer a saída ou a entrada,
                    tais como: venda, compra, transferência, devolução, importação,
                    consignação, remessa (para fins de demonstração, de industrialização ou outra)
        @param indpag: Indicador da forma de pagamento
                    0 – pagamento à vista;
                    1 – pagamento à prazo;
                    2 - outros
        @param mod: Código do modelo do Documento Fiscal. 55 = NF-e; 65 = NFC-e
        @param serie: Série do Documento Fiscal: série normal 0-889; Avulsa Fisco
                      890-899; SCAN 900-999.
        @param nnf: Número do Documento Fiscal.
        @param dhemi: Data e Hora de emissão do Documento Fiscal, aceita objetos datetime()
                    o formato de saída é (AAAA-MM-DDThh:mm:ssTZD) ex.: 2012-09-01T13:00:00-03:00.
        @param dhsaient: Data e Hora da saída ou de entrada da mercadoria /
                    produto aceita objetos datetime() o formato de saída é (AAAA-MM-DDTHH:mm:ssTZD)
        @param tpnf: Tipo do Documento Fiscal 0 - entrada; 1 - saída.
        @param iddest: Identificador de Local de destino da operação 1-Interna;
                    2-Interestadual; 3-Exterior.
        @param cmunfg: Código do Município de Ocorrência do Fato Gerador
                    (utilizar a tabela do IBGE).
        @param tpimp: Formato de impressão do DANFE 0-sem DANFE; 1-DANFe Retrato;
                    2-DANFe Paisagem; 3-DANFe Simplificado; 4-DANFe NFC-e; 5-DANFe NFC-e em
                    mensagem eletrônica).
        @param tpemis: Forma de emissão da NF-e 1 - Normal; 2 - Contingência FS;
                    3 - Contingência SCAN; 4 - Contingência DPEC; 5 - Contingência FSDA; 6 -
                    Contingência SVC - AN; 7 - Contingência SVC - RS; 9 - Contingência
                off-line NFC-e;
        @param cdv: Digito Verificador da Chave de Acesso da NF-e.
        @param tpamb: Identificação do Ambiente: 1 - Produção; 2 - Homologação.
        @param finnfe: Finalidade da emissão da NF-e: 1 - NFe normal; 2 - NFe
                    complementar; 3 - NFe de ajuste; 4 - Devolução/Retorno.
        @param indfinal: Indica operação com consumidor final 0-Não; 1-Consumidor
                    Final.
        @param indpres: Indicador de presença do comprador no estabelecimento
                    comercial no momento da oepração 0-Não se aplica (ex.: Nota Fiscal
                    complementar ou de ajuste); 1-Operação presencial; 2-Não presencial,
                    internet; 3-Não presencial, teleatendimento; 4-NFC-e entrega em
                    domicílio; 9-Não presencial, outros.
        @param procemi: Processo de emissão utilizado com a seguinte codificação:
                    0 - emissão de NF-e com aplicativo do contribuinte; 1 - emissão de NF-e
                    avulsa pelo Fisco; 2 - emissão de NF-e avulsa, pelo contribuinte com seu
                    certificado digital, através do site do Fisco; 3 - emissão de NF-e pelo
                    contribuinte com aplicativo fornecido pelo Fisco.
        @param verproc: versão do aplicativo utilizado no processo de emissão
        @rtype: str
        """
        d = dict()

        d['cuf'] = cuf
        d['cnf'] = cnf
        d['natOp'] = natop
        d['indPag'] = indpag
        d['mod'] = mod
        d['serie'] = serie
        d['nnf'] = nnf
        d['dhEmi'] = self.__adpt_time(dhemi)
        d['dhSaiEnt'] = self.__adpt_time(dhsaient)
        d['tpNF'] = tpnf
        d['idDest'] = iddest
        d['cMunFG'] = cmunfg
        d['tpImp'] = tpimp
        d['tpEmis'] = tpemis
        d['cdv'] = cdv
        d['tpAmb'] = tpamb
        d['finNFe'] = finnfe
        d['indFinal'] = indfinal
        d['indPres'] = indpres
        d['procEmi'] = procemi
        d['verProc'] = verproc

        return json.dumps(d)


    @argcheck(str, str, str, str, str, str, str, str,
              str, str, str, str, str, str, str, str, str)
    def emit(self, cnpj, cpf, xnome, xfant, ie, crt, enderemitxlgr, enderemitnro,
             enderemitxcpl, enderemitxbairro,  enderemitcmun, enderemitxmun,
             enderemituf,  enderemitcep,  enderemitcpais, enderemitxpais,  enderemitfone):
        """    Identificação do Destinatário da Nota Fiscal eletrônica
        @param cnpj: Número do CNPJ do emitente
        @param cpf: Número do CPF do emitente
        @param xnome: Razão Social ou nome do destinatário
        @param xfant: Nome fantasia
        @param ie: Inscrição Estadual do Emitente
        @param crt: Código de Regime Tributário. Este campo será obrigatoriamente

        Objeto (interno) TEnderEmi: Tipo Dados do Endereço do Emitente //
        24/10/08 - desmembrado / tamanho mínimo versao: versão da NFC-e no caso
        3.1 IdLote: id lote NFC-e utilizado para a processos assincronos IndSinc:
        Indicador de processamento síncrono. 0=NÃO; 1=SIM=Síncrono

        @param enderemitxlgr: Logradouro
        @param enderemitnro: Número
        @param enderemitxcpl: Complemento
        @param enderemitxbairro: Bairro
        @param enderemitcmun: Código do município
        @param enderemitxmun: Nome do município
        @param enderemituf: Sigla da UF
        @param enderemitcep: CEP - NT 2011/004
        @param enderemitcpais: Código do país
        @param enderemitxpais: Nome do país
        @param enderemitfone: Preencher com Código DDD + número do telefone
        """
        ender = dict()
        ender['xLgr'] = strip_accents(enderemitxlgr)
        ender['nro'] = enderemitnro
        ender['xCpl'] = strip_accents(enderemitxcpl)
        ender['xBairro'] = strip_accents(enderemitxbairro)
        ender['cMun'] = enderemitcmun
        ender['xMun'] = strip_accents(enderemitxmun)
        ender['uf'] = enderemituf
        ender['cep'] = enderemitcep
        ender['cPais'] = enderemitcpais
        ender['xPais'] = strip_accents(enderemitxpais)
        ender['fone'] = enderemitfone

        d = dict()
        if cnpj != '':
            d['cnpj'] = cnpj
        else:
            d['cpf'] = cpf
        d['xNome'] = xnome
        # d['xFant'] = xfant
        d['ie'] = ie
        d['crt'] = crt
        d['enderEmit'] = ender

        return json.dumps(d)

    def autxml(self, cnpj='', cpf=''):
        """Pessoas autorizadas para o download do XML da NFC-e
        @param cnpj: CNPJ Autorizado
        @param cpf: CPF Autorizado
        """
        d = dict()
        if cnpj != '':
            d['cnpj'] = cnpj
        else:
            d['cpf'] = cpf
        return json.dumps(d)

    def avulsa(self, cnpj, demi, dpag,  fone,  matr, ndar,  repemi,  uf,  vdar,  xagente,  xorgao):
        """ Emissão de avulsa, informar os dados do Fisco emitente

        @param cnpj: CNPJ do Órgão emissor
        @param demi: Data de emissão do DAR, aceita datetime, formado-> (AAAA-MM-DD)
        @param dpag: Data de pagamento do DAR, aceita datetime, formado->  (AAAA-MM-DD)
        @param fone: Telefone
        @param matr: Matrícula do agente
        @param ndar: Número do Documento de Arrecadação de Receita
        @param repemi: Repartição Fiscal emitente
        @param uf: Sigla da Unidade da Federação
        @param vdar: Número do Documento de Arrecadação de Receita<
        @param xagente: Nome do agente
        @param xorgao: Órgão emitente
        """
        d = dict()
        d['cnpj'] = cnpj
        d['xOrgao'] = xorgao
        d["matr"] = matr
        d["xAgente"] = xagente
        d["fone"] = fone
        d["uf"] = uf
        d["ndar"] = ndar
        d["dEmi"] = demi.strftime('%Y-%m-%d')
        d["vdar"] = vdar
        d["repEmi"] = repemi
        d['dPag'] = dpag.strftime('%Y-%m-%d')

        return json.dumps(d)

    @argcheck(str, str, str,  str, str,
              str, str, str, str, str,
              str, str, str, str, str, str)
    def dest(self,  cnpj,  cpf,  idestrangeiro,  xnome,  iedest,  email,
             enderdestxlgr,  enderdestnro,  enderdestxbairro,
             enderdestcmun,  enderdestxmun,  enderdestuf,
             enderdestcep,  enderdestcpais,  enderdestxpais,
             enderdestfone):
        """Identificação do Destinatário da Nota Fiscal eletrônica

        @param cnpj: Número do CNPJ do emitente
        @param cpf: Número do CPF do emitente
        @param idestrangeiro: Identificador do destinatário, em caso de comprador
        estrangeiro
        @param xnome: Razão Social ou nome do destinatário
        @param iedest: Indicador da IE do destinatário: 1 – Contribuinte
        ICMSpagamento à vista; 2 – Contribuinte isento de inscrição; 9 – Não
        Contribuinte

        Objeto (interno) TEndereco: String Email: Informar o e-mail do
        destinatário. O campo pode ser utilizado para informar o e-mail de
        recepção da NF-e indicada pelo destinatário Tipo Dados do Endereço //
        24/10/08 - tamanho mínimo

        @param enderdestxlgr: Logradouro
        @param enderdestnro: Número
        @param enderdestxbairro: Bairro
        @param enderdestcmun: Código do município (utilizar a tabela do IBGE),
        informar 9999999 para operações com o exterior.
        @param enderdestxmun: Nome do município, informar EXTERIOR para operações
        com o exterior.
        @param enderdestuf: Sigla da UF, informar EX para operações com o
        exterior.
        @param enderdestcep: CEP
        @param enderdestcpais: Código do país
        @param enderdestxpais: Nome do país
        @param enderdestfone: Telefone, preencher com Código DDD + número do
        telefone , nas operações com exterior é permtido informar o código do
        país + código da localidade + número do telefone
        """
        ender = dict()
        ender["xLgr"] = strip_accents(enderdestxlgr)
        ender["nro"] = enderdestnro
        ender["xBairro"] = strip_accents(enderdestxbairro)
        ender["cMun"] = enderdestcmun
        ender["xMun"] = strip_accents(enderdestxmun)
        ender["uf"] = enderdestuf
        ender["cep"] = enderdestcep
        ender["cPais"] = enderdestcpais
        ender["xPais"] = strip_accents(enderdestxpais)
        ender["fone"] = enderdestfone

        d = dict()
        if cnpj != '':
            d["cnpj"] = cnpj
        elif cpf != '':
            d["cpf"] = cpf
        else:
            d["idEstrangeiro"] = idestrangeiro
        d["xNome"] = strip_accents(xnome)
        d['indIEDest'] = iedest
        d["email"] = email
        d["enderDest"] = ender

        return json.dumps(d)

    def array_of_det(self, args):
        d = dict()
        d = []
        for det in args:
            d.append(det)
        return json.dumps(d)

    def add_tax_details(self, sale_item, crt):
        nfe_tax = dict()
        # TODO: handle service tax (ISS) and ICMS.

        sale_icms = sale_item.get_nfe_icms_info()
        if sale_icms:
            nfe_icms = nfce_icms(sale_icms, crt)
            nfe_tax['icms'] = nfe_icms

        sale_ipi = sale_item.get_nfe_ipi_info()
        if sale_ipi:
             nfe_ipi = nfce_ipi(sale_ipi)
             nfe_tax['ipi'] = nfe_ipi

        if True: # if sale_item.pis_info
            nfe_pis = nfce_pis()
            nfe_tax['pis'] = nfe_pis

        if True: # if sale_item.cofins_info
            nfe_cofins = nfce_cofins()
            nfe_tax['cofins'] = nfe_cofins
        return nfe_tax

    def det_prod(self,  nitem,  infadprod,  prodcprod,
            prodcean,  prodxprod,  prodncm,
            prodcfop,  producom,  prodqcom,
            prodvuncom,  prodvprod,  produtrib,
            prodqtrib,  prodceantrib,  prodvuntrib,
            prodindtot, sale_item, crt):
        """ Dados dos detalhes da NFC-e

        @param nitem: Número do item do NF
        @param infadprod: Informações adicionais do produto (norma referenciada,
        informações complementares, etc) Objeto (interno) Prod: Dados dos
        produtos e serviços da NFC-e
        @param prodcprod: Código do produto ou serviço. Preencher com CFOP caso
        se trate de itens não relacionados com mercadorias/produto e que o
        contribuinte não possua codificação própria Formato ”CFOP9999”.

        @param prodcean: GTIN (Global Trade Item Number) do produto, antigo
        código EAN ou código de barras
        @param prodxprod: Descrição do produto ou serviço
        @param prodncm: Código NCM (8 posições), será permitida a informação do
        gênero (posição do capítulo do NCM) quando a operação não for de comércio
        exterior (importação/exportação) ou o produto não seja tributado pelo
        IPI. Em caso de item de serviço ou item que não tenham produto (Ex.
        transferência de crédito, crédito do ativo imobilizado, etc.), informar o
        código 00 (zeros)
        @param prodcfop: Código Fiscal de Operações e Prestações
        @param producom: Unidade Comercial
        @param prodqcom: Quantidade Comercial do produto, alterado para aceitar
        de 0 a 4 casas decimais e 11 inteiros.
        @param prodvuncom: Valor unitário de comercialização - alterado para
        aceitar 0 a 10 casas decimais e 11 inteiros
        @param prodvprod: Valor bruto do produto ou serviço.
        @param produtrib: Unidade Tributável
        @param prodqtrib: Quantidade Tributável - alterado para aceitar de 0 a 4
        casas decimais e 11 inteiros
        @param prodceantrib: GTIN (Global Trade Item Number) da unidade
        tributável, antigo código EAN ou código de barras
        @param prodvuntrib: Valor unitário de tributação - - alterado para
        aceitar 0 a 10 casas decimais e 11 inteiros
        @param prodindtot: Este campo deverá ser preenchido com: 0 – o valor do
        item (vProd) não compõe o valor total da NF-e (vProd) 1 – o valor do item
        (vProd) compõe o valor total da NF-e (vProd)

        Objeto (interno) Imposto: Dados dos produtos e serviços da NFC-e
        @param orig: origem da mercadoria: 0 - Nacional 1 - Estrangeira -
        Importação direta 2 - Estrangeira - Adquirida no mercado interno
        @param csosn: 500 – ICMS cobrado anterirmente por substituição tributária
        (substituído) ou por antecipação (v.2.0)
        @param vbcstret: Valor da BC do ICMS ST retido anteriormente (v2.0)
        @param vicmsstret: Valor do ICMS ST retido anteriormente (v2.0)

        Objeto (interno) PIS: Dados dos produtos e serviços da NFC-e
        @param pisntcst Código de Situação Tributária do PIS. 01 – Operação
        Tributável - Base de Cálculo = Valor da Operação Alíquota Normal
        (Cumulativo/Não Cumulativo); 02 - Operação Tributável - Base de Calculo =
        Valor da Operação (Alíquota Diferenciada)

        Objeto (interno) COFINS: Dados dos produtos e serviços da NFC-e
        @param cofinsntcst Código de Situação Tributária do COFINS. 01 – Operação
        Tributável - Base de Cálculo = Valor da Operação Alíquota Normal
        (Cumulativo/Não Cumulativo); 02 - Operação Tributável - Base de Calculo =
        Valor da Operação (Alíquota Diferenciada)
        """
        #
        # Dados do Produto
        #
        prod = dict()
        prod["cProd"] = prodcprod
        prod["cean"] = prodcean
        prod["xProd"] = strip_accents(prodxprod)
        prod["ncm"] = prodncm
        prod["cfop"] = prodcfop
        prod["uCom"] = producom
        prod["qCom"] = prodqcom
        prod["vUnCom"] = prodvuncom
        prod["vProd"] = prodvprod
        prod["ceanTrib"] = prodceantrib
        prod["uTrib"] = produtrib
        prod["qTrib"] = prodqtrib
        prod["vUnTrib"] = prodvuntrib
        prod["indTot"] = prodindtot

        #
        # Impostos
        #


        det_taxes = self.add_tax_details(sale_item, crt)

        d = dict()
        d["prod"] = prod                  # dados do produto
        d["imposto"] = det_taxes          # dados de imposto
        d["infAdProd"] = infadprod
        d["nItem"] = nitem
        return d

    def total(self,  icmstotvbc,  icmstotvicms,  icmstotvicmsdeson,  icmstotvbcst,
             icmstotvst,  icmstotvprod,  icmstotvfrete,
             icmstotvseg,  icmstotvdesc,  icmstotvii,
             icmstotvipi,  icmstotvpis,  icmstotvcofins,
             icmstotvoutro,  icmstotvnf):
        """ Dados dos totais da NFC-e

            Objeto (interno) ICMSTot: Totais referentes ao ICMS
            @param icmstotvbc: BC do ICMS
            @param icmstotvicms: Valor Total do ICMS
            @param icmstotvicmsdeson: Valor Total do ICMS desone
            @param icmstotvbcst: Valor Total do ICMS desonerado
            @param icmstotvst: Valor Total do ICMS ST
            @param icmstotvprod: Valor Total dos produtos e serviços
            @param icmstotvfrete: Valor Total do Frete
            @param icmstotvseg: Valor Total do Seguro
            @param icmstotVDesc: Valor Total do Desconto
            @param icmstotvii: Valor Total do II
            @param icmstotvipi: Valor Total do IPI
            @param icmstotvpis: Valor do PIS
            @param icmstotvcofins: Valor do COFINS
            @param icmstotvoutro: Outras Despesas acessórias
            @param icmstotvnf: Valor Total da NFC-e
        """
        icmstot = dict()
        icmstot["vbc"] = icmstotvbc
        icmstot["vicms"] = icmstotvicms
        icmstot["vICMSDeson"] = icmstotvicmsdeson
        icmstot["vbcst"] = icmstotvbcst
        icmstot["vst"] = icmstotvst
        icmstot["vProd"] = icmstotvprod
        icmstot["vFrete"] = icmstotvfrete
        icmstot["vSeg"] = icmstotvseg
        icmstot["vDesc"] = icmstotvdesc
        icmstot["vii"] = icmstotvii
        icmstot["vipi"] = icmstotvipi
        icmstot["vpis"] = icmstotvpis
        icmstot["vcofins"] = icmstotvcofins
        icmstot["vOutro"] = icmstotvoutro
        icmstot["vnf"] = icmstotvnf
        d = dict()
        d["icmsTot"] = icmstot
        # d["issqNtot"] = ''
        # d["retTrib"] = ''
        return json.dumps(d)

    def transp(self,  modfrete, volqvol,  volnvol,  volpesol,  volpesob):
        """ Dados dos transportes da NFC-e

        @param modfrete: Modalidade do frete 0- Por conta do emitente; 1- Por
        conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete
        (v2.0)

        Objeto (interno) Vol: Dados dos volumes

        @param volqvol: Quantidade de volumes transportados
        @param volnvol: Numeração dos volumes transportados
        @param volpesol: Peso líquido (em kg)
        @param volpesob: Peso bruto (em kg)
        """
        transp = dict()
        #{"modFrete":"9","vol":[{"qVol":"0","nVol":"0","pesoL":"0.000","pesoB":"0.000"}]}/
        vol = dict()
        vol['qVol'] = volqvol
        vol['nVol'] = volnvol
        vol['pesoL'] = volpesol
        vol['pesoB'] = volpesob

        transp["modFrete"] = modfrete
        transp["vol"] = [vol]
        return json.dumps(transp)

    def pag(self, tpag, vpag, cardcnpj, cardcaut, cardband):
        """ Dados de Pagamento. Obrigatório apenas para (NFC-e) NT 2012/004

        @param tPag Forma de Pagamento: 01-Dinheiro; 02-Cheque; 03-Cartão de
        Crédito; 04-Cartão de Débito; 05-Crédito Loja; 10-Vale Alimentação;
        11-Vale Refeição; 12-Vale Presente; 13-Vale Combustível; 99 - Outros.

        @param vpag: Valor do Pagamento.

        Objeto (interno) Card: Grupo de Cartões
        @param cardcnpj: CNPJ da credenciadora de cartão de crédito/débito.
        @param cardcaut: Número de autorização da operação cartão de
        crédito/débito.
        @param cardband: Bandeira da operadora de cartão de crédito/débito:
        01–Visa; 02–Mastercard; 03–American Express; 04–Sorocred; 99–Outros.
        """
        # Cartão
        card = dict()
        card['CNPJ'] = cardcnpj
        card['tBand'] = cardband
        card['cAut'] = cardcaut

        pag = dict()
        pag["tPag"] = tpag
        pag["vPag"] = vpag
        pag["card"] = card
        return json.dumps(pag)

    def infadic(self, infcpl):
        """ Informações adicionais da NFC-e
        @param infcpl: Informações complementares de interesse do Contribuinte
        """
        infadic = dict()
        infadic["infCpl"] = infcpl
        return json.dumps(infadic)

    def exporta(self, ufsaidapais, xlocdespacho, xlocexporta):
        """Informações de exportação
        @param ufsaidapais: Sigla da UF de Embarque ou de transposição de
        fronteira
        @param xlocdespacho: Local de Embarque ou de transposição de fronteira
        @param xlocexporta: Descrição do local de despacho
        """
        expr = dict()
        expr["UFSaidaPais"] = ufsaidapais
        expr["xLocExporta"] = xlocdespacho
        expr["xLocDespacho"] = xlocexporta
        return json.dumps(expr)

    def retirada(self, cpf, cnpj, cmun, xlgr, nro, uf, xbairro, xcpl, xmun):
        """Tipo Dados do Local de Retirada ou Entrega // 24/10/08 - tamanho mínimo // v2.0

        @param cpf: CPF (v2.0)
        @param cnpj: CNPJ
        @param cmun: Código do município (utilizar a tabela do IBGE)
        @param xlgr: Logradouro
        @param nro: Número
        @param uf: Sigla da UF
        @param xbairro: Bairro
        @param xcpl: Complemento
        @param xmun: Nome do município
        """
        tlocal = dict()
        if cnpj != '':
            tlocal["cnpj"] = cnpj
        else:
            tlocal["cpf"] = cpf
        tlocal["xLgr"] = strip_accents(xlgr)
        tlocal["nro"] = nro
        tlocal["xCpl"] = strip_accents(xcpl)
        tlocal["xBairro"] = strip_accents(xbairro)
        tlocal["cMun"] = cmun
        tlocal["xMun"] = strip_accents(xmun)
        tlocal["uf"] = uf
        return json.dumps(tlocal)

    def autorizacao(self):
        #TODO, implement a handshaking system here
        # right now 1 works
        return '1'

    def nfelote(self):
        #TODO, implement a lotting system
        # right now 1 works
        return '1'


def main(args):
    from stoqlib.domain.sale import Sale
    from kiwi.component import provide_utility
    from stoq.lib.options import get_option_parser
    from stoq.lib.startup import setup
    from stoqlib.database.admin import get_admin_user
    from stoqlib.database.interfaces import ICurrentUser
    from stoqlib.database.runtime import get_connection
    from stoqlib.lib.configparser import StoqConfig

    parser = get_option_parser()
    options, args = parser.parse_args(args)

    config = StoqConfig()
    config.load_default()
    setup(config, options, register_station=False, check_schema=False)
    conn = get_connection()
    provide_utility(ICurrentUser, get_admin_user(conn))


    sale = Sale.selectOneBy(id=17613, connection=conn)
    conn = get_connection()

    a = NFCeJsonGeneration(sale, conn)
    a.generate()
    print a.json.replace('\\', '')

if __name__ == '__main__':
    sys.exit(main(sys.argv))