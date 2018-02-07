from stoq.lib.actionslist import get_action_description
from stoqlib.database.runtime import get_current_user, get_connection
from stoqlib.gui.base.dialogs import run_dialog
from stoqlib.gui.dialogs.passworddialog import UserPassword
from stoqlib.lib.message import warning


def permission_required(action):
    def wrapper(request_method):
        def check_pemission(*args, **kwargs):
            conn = get_connection()
            user = get_current_user(conn)
            profile = user.profile
            action_description = get_action_description(action)
            print action_description
            if not profile.check_action_permission(action):
                admin_permission = run_dialog(UserPassword, None, conn, action=action,
                                              action_desc=action_description)
                if not admin_permission:
                    warning(u"Voce nao tem permissao para %s" % action_description)
                    return False
            return request_method(*args, **kwargs)
        return check_pemission
    return wrapper