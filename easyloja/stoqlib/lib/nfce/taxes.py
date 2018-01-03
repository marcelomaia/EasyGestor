# -*- coding: utf-8 -*-

#
# COFINS
#

available_cofins = ["cofinsAliq",
                    "cofinsQtde",
                    "cofinsnt",
                    "cofinsOutr"]


def cofinsaliq(cst, vbc, pcofins, vcofins):
    d = dict()
    d["cst"] = cst
    d["vbc"] = vbc
    d["pcofins"] = pcofins
    d["vcofins"] = vcofins
    return d


def cofinsqtde(cst, qbcprod, valiqprod, vcofins):
    d = dict()
    d["cst"] = cst
    d["qbcProd"] = qbcprod
    d["vAliqProd"] = valiqprod
    d["vcofins"] = vcofins
    return d


def cofinsnt(cst):
    d = dict()
    d["cst"] = cst
    return d


def cofinsoutr(cst, vbc, pcofins, qbcprod, valiqprod, vcofins):
    d = dict()
    d["cst"] = cst
    d["vbc"] = vbc
    d["pcofins"] = pcofins
    d["qbcProd"] = qbcprod
    d["vAliqProd"] = valiqprod
    d["vcofins"] = vcofins
    return d

#
# PIS
#

available_pis = ["pisaliq",
                 "pisqtde",
                 "pisnt",
                 "pisoutr"]


def pisaliq(cst, vbc, ppis, vpis):
    d = dict()
    d["cst"] = cst
    d["vbc"] = vbc
    d["ppis"] = ppis
    d["vpis"] = vpis
    return d


def pisqtde(cst, qbcprod, valiqprod, vpis):
    d = dict()
    d["cst"] = cst
    d["qbcProd"] = qbcprod
    d["vAliqProd"] = valiqprod
    d["vpis"] = vpis
    return d


def pisnt(cst):
    d = dict()
    d["cst"] = cst
    return d


def pisoutr(cst, vbc, ppis, qbcprod, valiqprod, vpis):
    d = dict()
    d["cst"] = cst
    d["vbc"] = vbc
    d["ppis"] = ppis
    d["qbcProd"] = qbcprod
    d["vAliqProd"] = valiqprod
    d["vpis"] = vpis
    return d

#
# ICMS
#

INFO_NAME_MAP = {
        'orig': 'orig',
        'cst': 'cst',
        'modBC': 'mod_bc',
        'modBCST': 'mod_bc_st',

        'vbc': 'v_bc',
        'vbcst': 'v_bc_st',
        'vicms': 'v_icms',
        'vicmsst': 'v_icms_st',

        'picms': 'p_icms',
        'pmvast': 'p_mva_st',
        'pRedBC': 'p_red_bc',
        'pRedBCST': 'p_red_bc_st',
        'picmsst': 'p_icms_st',

        # Simples Nacional
        'csosn': 'csosn',
        'pCredSN': 'p_cred_sn',
        'vCredICMSSN': 'v_cred_icms_sn',
        'vbcstRet': 'v_bc_st_ret',
        'vicmsstRet': 'v_icms_st_ret'}


available_icms = ["icms00",
                  "icms10",
                  "icms20",
                  "icms30",
                  "icms40",
                  "icms51",
                  "icms60",
                  "icms70",
                  "icms90",
                  "icmspart",
                  "icmsst",
                  "icmssn101",
                  "icmssn102",
                  "icmssn201",
                  "icmssn202",
                  "icmssn500",
                  "icmssn900"]


# Regime Normal
def icms00(sale_icms):
    d = dict()
    d['orig'] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d['cst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d['modBC'] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d['vbc'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d['picms'] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d['vicms'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    return d


def icms10(sale_icms):
    d = dict()
    d['orig'] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d['cst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d['modBC'] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d['vbc'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d['picms'] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d['vicms'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    d['modBCST'] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d['pmvast'] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d['pRedBCST'] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d['vbcst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d['picmsst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d['vicmsst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    return d


def icms20(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["modBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d["pRedBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBC'), ''))
    d["vbc"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d["picms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    return d


def icms30(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["modBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d["pmvast"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d["pRedBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d["vbcst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d["picmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d["vicmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    return d


def icms40(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    d["motDesICMS"] = str(getattr(sale_icms, INFO_NAME_MAP.get('motDesICMS'), ''))
    return d


def icms51(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["modBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d["pRedBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBC'), ''))
    d["vbc"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d["picms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    return d


def icms60(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["vbcstRet"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcstRet'), ''))
    d["vicmsstRet"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsstRet'), ''))
    return d


def icms70(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["modBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d["pRedBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBC'), ''))
    d["vbc"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d["picms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    d["modBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d["pmvast"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d["pRedBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d["vbcst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d["picmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d["vicmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    return d


def icmspart(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["modBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d["vbc"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d["pRedBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBC'), ''))
    d["picms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    d["modBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d["pmvast"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d["pRedBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d["vbcst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d["picmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d["vicmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    d["pbcOp"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pbcOp'), ''))
    d["ufst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('ufst'), ''))
    return d


def icms90(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["cst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('cst'), ''))
    d["modBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d["vbc"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d["pRedBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBC'), ''))
    d["picms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    d["modBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d["pmvast"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d["pRedBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d["vbcst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d["picmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d["vicmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    return d


# Simples nacional
def icmssn101(sale_icms):
    d = dict()
    d['orig'] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d['csosn'] = str(getattr(sale_icms, INFO_NAME_MAP.get('csosn'), ''))
    d['pCredSN'] = str(getattr(sale_icms, INFO_NAME_MAP.get('pCredSN'), ''))
    d['vCredICMSSN'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vCredICMSSN'), ''))
    return d


def icmssn102(sale_icms):
    d = dict()
    d['orig'] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d['csosn'] = str(getattr(sale_icms, INFO_NAME_MAP.get('csosn'), ''))
    return d


def icmssn201(sale_icms):
    d = dict()
    d['orig'] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d['csosn'] = str(getattr(sale_icms, INFO_NAME_MAP.get('csosn'), ''))
    d['modBCST'] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d['pmvast'] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d['pRedBCST'] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d['vbcst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d['picmsst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d['vicmsst'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    d['pCredSN'] = str(getattr(sale_icms, INFO_NAME_MAP.get('pCredSN'), ''))
    d['vCredICMSSN'] = str(getattr(sale_icms, INFO_NAME_MAP.get('vCredICMSSN'), ''))
    return d


def icmssn202(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["csosn"] = str(getattr(sale_icms, INFO_NAME_MAP.get('csosn'), ''))
    d["modBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d["pmvast"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d["pRedBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d["vbcst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d["picmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d["vicmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    return d


def icmsn500(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["csosn"] = str(getattr(sale_icms, INFO_NAME_MAP.get('csosn'), ''))
    d["vbcstRet"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcstRet'), ''))
    d["vicmsstRet"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsstRet'), ''))
    return d


def icmsn900(sale_icms):
    d = dict()
    d["orig"] = str(getattr(sale_icms, INFO_NAME_MAP.get('orig'), ''))
    d["csosn"] = str(getattr(sale_icms, INFO_NAME_MAP.get('csosn'), ''))
    d["modBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBC'), ''))
    d["vbc"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbc'), ''))
    d["pRedBC"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBC'), ''))
    d["picms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picms'), ''))
    d["vicms"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicms'), ''))
    d["modBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('modBCST'), ''))
    d["pmvast"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pmvast'), ''))
    d["pRedBCST"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pRedBCST'), ''))
    d["vbcst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vbcst'), ''))
    d["picmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('picmsst'), ''))
    d["vicmsst"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vicmsst'), ''))
    d["pCredSN"] = str(getattr(sale_icms, INFO_NAME_MAP.get('pCredSN'), ''))
    d["vCredICMSSN"] = str(getattr(sale_icms, INFO_NAME_MAP.get('vCredICMSSN'), ''))
    return d


def nfce_icms(sale_icms_info, crt):
    icms_dict = dict()
    if crt in ['1', '2']:                 # simples nacional
        csosn = str(sale_icms_info.csosn)
        if csosn in 'icmssn101':
            icms = icmssn101(sale_icms_info)
            icms_dict['icmssn101'] = icms

        elif csosn in 'icmssn102':
            icms = icmssn102(sale_icms_info)
            icms_dict['icmssn102'] = icms

        elif csosn in 'icmssn201':
            icms = icmssn201(sale_icms_info)
            icms_dict['icmssn201'] = icms

        elif csosn in 'icmssn202':
            icms = icmssn202(sale_icms_info)
            icms_dict['icmssn202'] = icms

        elif csosn in 'icmssn500':
            icms = icmsn500(sale_icms_info)
            icms_dict['icmssn500'] = icms

        elif csosn in 'icmssn900':
            icms = icmsn900(sale_icms_info)
            icms_dict['icmssn900'] = icms
    else:                                     # Normal
        cst = str(sale_icms_info.cst)
        if cst in 'icms00':
            icms = icms00(sale_icms_info)

            icms_dict['icms00'] = icms

        elif cst in "icms10":
            icms = icms10(sale_icms_info)
            icms_dict['icms10'] = icms

        elif cst in "icms20":
            icms = icms20(sale_icms_info)
            icms_dict['icms20'] = icms

        elif cst in "icms30":
            icms = icms30(sale_icms_info)
            icms_dict['icms30'] = icms

        elif cst in "icms40":
            icms = icms40(sale_icms_info)
            icms_dict['icms40'] = icms

        elif cst in "icms51":
            icms = icms51(sale_icms_info)
            icms_dict['icms51'] = icms

        elif cst in "icms60":
            icms = icms60(sale_icms_info)
            icms_dict['icms60'] = icms

        elif cst in "icms70":
            icms = icms70(sale_icms_info)
            icms_dict['icms70'] = icms

        elif cst in "icms90":
            icms = icms90(sale_icms_info)
            icms_dict['icms90'] = icms
    return icms_dict


def nfce_ipi(ipi_info):
    d = dict()
    d["clEnq"] = getattr(ipi_info, str(ipi_info.cl_enq), '')
    d["cnpjProd"] = getattr(ipi_info, str(ipi_info.cnpj_prod), '')
    d["cSelo"] = getattr(ipi_info, str(ipi_info.c_selo), '')
    d["qSelo"] = getattr(ipi_info, str(ipi_info.q_selo), '')
    d["cEnq"] = getattr(ipi_info, str(ipi_info.c_enq), '')
    if ipi_info.cst in (0, 49, 50, 99):
        ipi_trib = dict()
        ipi_trib["cst"] = getattr(ipi_info, str(ipi_info.cst), '')
        ipi_trib["vbc"] = getattr(ipi_info, str(ipi_info.v_bc), '')
        ipi_trib["pipi"] = getattr(ipi_info, str(ipi_info.p_ipi), '')
        ipi_trib["qUnid"] = getattr(ipi_info, str(ipi_info.q_unid), '')
        ipi_trib["vUnid"] = getattr(ipi_info, str(ipi_info.v_unid), '')
        ipi_trib["vipi"] = getattr(ipi_info, str(ipi_info.v_ipi), '')
        d["ipiTrib"] = ipi_trib        # composto
    else:
        ipi_nt = dict()
        ipi_nt['cst'] = getattr(ipi_info, str(ipi_info.cst), '')
        d["ipint"] = ipi_nt            # composto
    return d


def nfce_pis():
    d = dict()
    pis_aliq = dict()

    #TODO work in these bellow
    pis_qtde = dict()
    pis_nt = dict()
    pis_outr = dict()

    pis_aliq["cst"] = '99'      # got from nfeGenerator
    pis_aliq["vbc"] = '0'
    pis_aliq["ppis"] = '0'
    pis_aliq["vpis"] = '0'
    d["pisAliq"] = pis_aliq

    return d


def nfce_cofins():
    d = dict()
    cofins_aliq = dict()
    cofins_qtde = dict()
    cofinsnt = dict()
    cofins_outr = dict()

    cofins_aliq["cst"] = '99'       # got from nfeGenerator
    cofins_aliq["vbc"] = '0'
    cofins_aliq["pcofins"] = '0'
    cofins_aliq["vcofins"] = '0'

    d["cofinsAliq"] = cofins_aliq
    return d