# -*- Mode: Python; coding: iso-8859-1 -*-
# vi:si:et:sw=4:sts=4:ts=4
import logging
import os
import csv
from datetime import datetime
from kiwi.environ import environ
from stoqlib.domain.person import PersonAdaptToIndividual, PersonAdaptToClient, Person
from stoqlib.database.runtime import get_connection
from stoqlib.lib.osutils import get_application_dir
from stoqlib.database.orm import AND
from stoqlib.lib.parameters import sysparam

log = logging.getLogger(__name__)

query_file = environ.find_resource('csv', 'analisys.csv')
messages = os.path.join(get_application_dir('stoq'), 'propaganda.txt')


def get_query_analisys():
    conn = get_connection()
    message = open(messages, 'a')
    with open(query_file) as csv_file:
        f = csv.reader(csv_file, delimiter=';')
        rows = [row for row in f]
        for row in rows:
            output = conn.queryOne(row[1])
            if output is not None:
                message.write(row[0] % (output[0], output[1])+'\n')
    message.close()


def get_advertisement():
    """ Fetches an url from ebi,
    try to get advertisements if fails, it will return a default link and message
    """
    from suds.client import Client

    TOKEN = "><"
    APPDIR = get_application_dir('stoq')
    data = [u"Para mais novidades visite o site da EBI!<>http://ebi.com.br"]
    try:
        if sysparam(get_connection()).ONLINE_SERVICES:
            client = Client("http://ebi.com.br/service/webservice/server.php?wsdl")
            data = client.service.get_propaganda('').split(TOKEN)
    except Exception, e:
        data = [u"Para mais novidades visite o site da EBI!<>http://ebi.com.br"]
        log.error(str(e))

    person_inds = PersonAdaptToIndividual.select(AND
                                                 (Person.q.id == PersonAdaptToClient.q.originalID,
                                                  Person.q.id == PersonAdaptToIndividual.q.originalID,
                                                  PersonAdaptToIndividual.q.birth_date != None),
                                                 connection=get_connection())
    if person_inds:
        today = datetime.today()
        for person in person_inds:
            birth_date = person.birth_date
            if birth_date.month == today.month and birth_date.day == today.day:
                person_name = person.person.name
                phone_number = person.person.phone_number
                data.append("Aniversariante de Hoje: %s - Tel: %s <>http://ebi.com.br" % (str(person_name),
                                                                                          str(phone_number)))

    with open(messages, 'a') as f:
        for i in data:
            if i != '':
                f.write(i + '\n')
        f.close()
