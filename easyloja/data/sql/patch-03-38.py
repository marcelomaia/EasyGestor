from stoqlib.domain.parameter import ParameterData


def apply_patch(trans):
    new_param = dict(field_name="CUSTOM_LOGO_FOR_NFCE", field_value='', is_editable=True)
    parameter = ParameterData(field_name=new_param['field_name'],
                              field_value=new_param['field_value'],
                              is_editable=new_param['is_editable'],
                              connection=trans)
    trans.commit()