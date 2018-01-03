from stoqlib.domain.person import PersonAdaptToBranch


def apply_patch(trans):
    branches = PersonAdaptToBranch.selectBy(connection=trans)
    for branch in branches:
        person = branch.original
        branch.name = person.name
    trans.commit()


