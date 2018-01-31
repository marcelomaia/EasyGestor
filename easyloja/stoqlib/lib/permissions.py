from stoqlib.database.runtime import get_current_user, get_connection
from stoqlib.lib.message import warning


def permission_required(action):
    def wrapper(request_method):
        def check_pemission(*args, **kwargs):
            user = get_current_user(get_connection())
            profile = user.profile
            if not profile.check_action_permission(action):
                return warning(u"VOCE NAO E DEBOCHADO PARA %s" % action)
            return request_method(*args, **kwargs)
        return check_pemission
    return wrapper