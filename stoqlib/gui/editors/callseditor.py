# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4

##
## Copyright (C) 2011 Async Open Source <http://www.async.com.br>
## All rights reserved
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., or visit: http://www.gnu.org/.
##
## Author(s): Stoq Team <stoq-devel@async.com.br>
##

import datetime
import webbrowser

from kiwi.datatypes import currency

from stoqlib.lib.message import warning
from stoqlib.api import api
from stoqlib.domain.interfaces import IUser, IClient
from stoqlib.domain.person import Calls, Person
from stoqlib.domain.service import Service
from stoqlib.gui.base.dialogs import run_dialog, get_current_toplevel
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.translation import stoqlib_gettext


_ = stoqlib_gettext


class CallsEditor(BaseEditor):
    model_type = Calls
    model_name = _("Calls")
    gladefile = 'CallsEditor'
    help_section = 'client-call'
    proxy_widgets = ('date',
                     'person_combo',
                     'description',
                     'message',
                     'attendant',
                     'price',
                     'service',
                     'status',)
    size = (500, 400)

    def __init__(self, conn, model, person, person_iface):
        self.person = person
        self.person_iface = person_iface
        BaseEditor.__init__(self, conn, model)
        # If person is not None, this means we already are in this person
        # details dialog. No need for this option
        if person:
            self.details_button.set_sensitive(False)

        if self.model.person:
            self.set_description(_('Call to %s') % self.model.person.name)
        else:
            self.set_description(_('call'))
        self.link_lbl.hide()
        self.link_button.hide()

    def create_model(self, conn):
        return Calls(date=datetime.date.today(),
                     description='',
                     message='',
                     person=self.person,
                     attendant=api.get_current_user(self.conn),
                     price=currency('0'),
                     service=None,
                     connection=conn)

    def setup_proxies(self):
        self._fill_attendant_combo()
        self._fill_person_combo()
        self._fill_service_combo()
        self._fill_status_combo()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    def _fill_status_combo(self):
        statuses = Calls.statuses
        self.status.prefill([(statuses[s], s) for s in statuses])

    def _fill_person_combo(self):
        if self.model.person:
            self.person_combo.prefill([(self.model.person.name,
                                        self.model.person)])
            self.person_combo.set_sensitive(False)
        else:
            persons = [(p.person.name, p.person)
                         for p in Person.iselect(self.person_iface,
                                                 connection=self.conn)]
            self.person_combo.prefill(sorted(persons))

    def _fill_attendant_combo(self):
        attendants = [(a.person.name, a)
                     for a in Person.iselect(IUser,
                                             connection=self.conn)]
        self.attendant.prefill(sorted(attendants))

    def _fill_service_combo(self):
        services = [(s.sellable.description, s)
                    for s in Service.select(connection=self.conn)]
        self.service.prefill(sorted(services))

    def on_details_button__clicked(self, button):
        from stoqlib.gui.dialogs.clientdetails import ClientDetailsDialog
        client = IClient(self.model.person, None)
        if client:
            run_dialog(ClientDetailsDialog, get_current_toplevel(), self.conn, client)

    def on_service__validate(self, arg1, service):
        sellable = service.sellable
        self.model.price = sellable.base_price
        self.price.update(self.model.price)

    def on_link_button__clicked(self, bt):
        try:
            from stoqlib.lib.google_agenda import rfc3339_date, service
        except Exception, e:
            warning('Não foi possível conectar com os serviços do google!', 'Tente novamente mais tarde')
            print e, 'erro no callseditor.py'
            return
        event = {
            'summary': self.model.description,
            'description': self.model.description + " -> " +
                           self.model.service.sellable.description + ": " +
                           Calls.get_status_name(self.model.status) + " Preço: R$ %s " % self.model.price,
            'location': self.model.person.get_main_address().get_address_string(),
            'start': {
                'dateTime': rfc3339_date(self.model.date)
            },
            'end': {
                'dateTime': rfc3339_date(self.model.date)
            },
            'created': {
                'dateTime': rfc3339_date(datetime.datetime.today())
            },
            'attendees': [
                {
                    'email': self.model.person.email or "ebi@ebi.com.br",
                    'displayName': self.model.person.name,
                    'comment': self.model.person.get_formatted_phone_number()},
                {
                    'email': self.model.attendant.person.email or "ebi@ebi.com.br",
                    'displayName': self.model.attendant.person.name}]}

        # we assume that we have an event id from google calendar
        if self.model.link:
            try:
                updated_event = service.events().update(calendarId='primary', eventId=self.model.event, body=event).execute()
                print "Event updated: %s" % updated_event
                webbrowser.open(self.model.link)
            except Exception, e:
                warning('Não foi possível abrir o link',
                        'Tente novamente mais tarde')
                return

        else:
            try:
                created_event = service.events().insert(calendarId='primary', body=event, sendNotifications=True).execute()
                print "Created event %s" % created_event
                self.model.link = created_event['htmlLink']
                self.model.event = created_event['id']
                webbrowser.open(self.model.link)
            except Exception, e:
                warning('Não foi possível abrir o link',
                        'Tente novamente mais tarde')
                return
        warning('Um link para o google agenda será aberto no se navegador')
