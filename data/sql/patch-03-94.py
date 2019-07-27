from stoqlib.domain.parameter import ParameterData


def apply_patch(trans):
    new_param = dict(field_name="COMPLETE_REGISTER_INDIVIDUAL", field_value='0', is_editable=True)
    ParameterData(field_name=new_param['field_name'],
                  field_value=new_param['field_value'],
                  is_editable=new_param['is_editable'],
                  connection=trans)

    new_param = dict(field_name="COMPLETE_REGISTER_COMPANY", field_value='0', is_editable=True)
    ParameterData(field_name=new_param['field_name'],
                  field_value=new_param['field_value'],
                  is_editable=new_param['is_editable'],
                  connection=trans)

    trans.commit()
