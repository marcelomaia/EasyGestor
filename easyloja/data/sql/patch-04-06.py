from stoqlib.domain.person import PersonAdaptToIndividual


def apply_patch(trans):
    for individual in PersonAdaptToIndividual.selectBy(connection=trans):
        if individual.birth_date:
            individual.birth_month = individual.birth_date.month
    trans.commit()
