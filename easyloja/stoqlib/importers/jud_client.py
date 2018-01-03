__author__ = 'ebi'

from stoqlib.domain.address import Address, CityLocation
from stoqlib.domain.interfaces import ICompany, IClient
from stoqlib.domain.person import Person
from stoqlib.importers.csvimporter import CSVImporter


class JudClientImporter(CSVImporter):
    fields = ['name',
              'phone_number',
              'mobile_number',
              'email',
              'cnpj',
              'state_registry',
              'city',
              'country',
              'state',
              'street',
              'streetnumber',
              'district']

    def process_one(self, data, fields, trans):
        person = Person(
            connection=trans,
            name=data.name,
            phone_number=data.phone_number,
            mobile_number=data.mobile_number)

        person.addFacet(ICompany,
            connection=trans,
            cnpj=data.cnpj,
            fancy_name=data.name,
            state_registry=data.state_registry)

        ctloc = CityLocation.get_or_create(trans=trans,
            city=data.city,
            state=data.state,
            country=data.country)
        streetnumber = data.streetnumber and int(data.streetnumber) or None
        Address(
            is_main_address=True,
            person=person,
            city_location=ctloc,
            connection=trans,
            street=data.street,
            streetnumber=streetnumber,
            district=data.district
        )

        person.addFacet(IClient, connection=trans)
