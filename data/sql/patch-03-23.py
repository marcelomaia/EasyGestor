# -*- coding: utf-8 -*-
from stoqlib.domain.interfaces import IUser
from stoqlib.domain.person import Person


def apply_patch(trans):
    users = Person.iselectBy(IUser, trans)
    for user in users:
        if len(user.password) >= 64:
            continue
        user.crypt_passwd()
    trans.commit()