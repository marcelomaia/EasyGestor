from stoqlib.domain.parameter import ParameterData


def apply_patch(trans):
    new_param = dict(field_name="NFCE_PRINTER", field_value='1', is_editable=True)
    ParameterData(field_name=new_param['field_name'],
                  field_value=new_param['field_value'],
                  is_editable=new_param['is_editable'],
                  connection=trans)

    new_param = dict(field_name="NFCE_PORT", field_value='COM2', is_editable=True)
    ParameterData(field_name=new_param['field_name'],
                  field_value=new_param['field_value'],
                  is_editable=new_param['is_editable'],
                  connection=trans)

    new_param = dict(field_name="NFCE_SPEED", field_value='115200', is_editable=True)
    ParameterData(field_name=new_param['field_name'],
                  field_value=new_param['field_value'],
                  is_editable=new_param['is_editable'],
                  connection=trans)

    trans.commit()
