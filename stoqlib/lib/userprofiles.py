from stoqlib.database.runtime import get_connection
from stoqlib.domain.person import PersonAdaptToUser


def is_admin_user(user):
    adm_users = [p.id for p in PersonAdaptToUser.selectBy(profile=1,
                                                          connection=get_connection())]
    if user.id in adm_users:
        return True
    return False
