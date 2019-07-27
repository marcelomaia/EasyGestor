from stoqlib.domain.parameter import ParameterData


def apply_patch(trans):
    new_params = [
        {'field_name': 'EMPLOYERS_CAN_REMOVE_ITEMS', 'field_value': 'False', 'is_editable': True},
        {'field_name': 'TIME_TO_EMIT_Z', 'field_value': '00:00', 'is_editable': True},         # hora de emitir z
        {'field_name': 'CHOISE_BRANCH_NFE', 'field_value': 'True', 'is_editable': True},       # nfe
        {'field_name': 'PROMOTIONAL_MESSAGE', 'field_value': 'edite-me', 'is_editable': True}, # mensagem promocional
        {'field_name': 'ITEMS_TO_TAB', 'field_value': 'edite-me', 'is_editable': True},        # comanda
    ]

    for new_param in new_params:
        ParameterData(field_name=new_param['field_name'],
                      field_value=new_param['field_value'],
                      is_editable=new_param['is_editable'],
                      connection=trans)
    trans.commit()
