# -*- coding: utf-8 -*-
from stoqlib.domain.person import PersonCategoryPaymentInfo
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.translation import stoqlib_gettext
from stoqlib.lib.message import warning
from kiwi.datatypes import ValidationError

_ = stoqlib_gettext

class PersonPaymentEditor(BaseEditor):
    model_name = _('Person Category Payment Info')
    model_type = PersonCategoryPaymentInfo
    gladefile = 'PersonPaymentInfoEditor'

    proxy_widgets = ("person", "payment_category", "is_default", )

    def _setup_widgets(self):
        self.person.prefill([(self.model.person.name, self.model.person), ])
        self.payment_category.prefill([(self.model.payment_category.name, self.model.payment_category), ])
        self.person.set_sensitive(False)
        self.payment_category.set_sensitive(False)

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model, self.proxy_widgets)

    # def on_is_default__toggled(self, *args, **kwargs):
    #     default_category = self.model.person.get_default_category()
    #     print default_category
    #     if default_category:
    #         warning(_(u'This person already has a default payment category'))
    #         self.is_default.set_active(False)
