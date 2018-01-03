# coding=utf-8
import datetime
import hashlib
from decimal import Decimal

from kiwi.datatypes import ValidationError
from kiwi.enums import ListType
from kiwi.ui.objectlist import Column

from stoqlib.domain.interfaces import IBranch
from stoqlib.domain.nfe import NFeContract
from stoqlib.domain.nfe import NFeVolume
from stoqlib.domain.person import PersonAdaptToBranch, PersonAdaptToCompany, Person
from stoqlib.domain.sale import Sale
from stoqlib.gui.base.lists import ModelListDialog
from stoqlib.gui.editors.baseeditor import BaseEditor
from stoqlib.lib.message import warning


class NFeVolumeEditor(BaseEditor):
    gladefile = 'NFeVol'
    model_type = NFeVolume
    proxy_widgets = ('quantity',
                     'unit',
                     'brand',
                     'number',
                     'net_weight',
                     'gross_weight')

    def __init__(self, conn, model=None, sale=None):
        self.sale = sale
        super(NFeVolumeEditor, self).__init__(conn, model)

    def create_model(self, trans):
        return NFeVolume(quantity=1,
                         unit='caixa',
                         brand='sem marca',
                         number='sem numero',
                         net_weight=0.0,
                         gross_weight=0.0,
                         sale=self.sale,
                         connection=trans)

    def setup_proxies(self):
        self.add_proxy(self.model, NFeVolumeEditor.proxy_widgets)


class NFeVolumeListEditor(ModelListDialog):
    # ModelListDialog
    model_type = NFeVolume
    editor_class = NFeVolumeEditor
    size = (600, 300)
    title = "NFeVolume"

    def __init__(self, conn, sale):
        self.sale = sale
        super(NFeVolumeListEditor, self).__init__(conn)

    # ListDialog
    columns = [
        Column('quantity', 'Quantidade', data_type=float),
        Column('unit', u'Espécie', data_type=str),
        Column('brand', 'Marca', data_type=str),
        Column('number', u'Numeração', data_type=str),
        Column('net_weight', 'Peso liquido', data_type=Decimal),
        Column('gross_weight', 'Peso bruto', data_type=Decimal), ]

    def populate(self):
        if self._reuse_transaction:
            conn = self._reuse_transaction
        else:
            conn = self.conn
        return NFeVolume.selectBy(sale=self.sale, connection=conn)

    def run_editor(self, trans, model):
        """This can be override by a subclass who wants to send in
        custom arguments to the editor.
        """
        if self._editor_class is None:
            raise ValueError("editor_class cannot be None in %s" % (
                type(self).__name__))

        return self.run_dialog(
            self._editor_class,
            conn=trans, model=model, sale=self.sale)


class ContractEditor(BaseEditor):
    gladefile = 'NFeContract'
    model_type = NFeContract
    title = 'Contrato'

    proxy_widgets = ['key', 'contract', 'company', 'start_date', 'end_date']

    (HALFYEAR,
     ONEYEAR,
     TWOYEARS) = (182, 365, 730)

    time_options = [
        ('', None),
        ('6 meses', HALFYEAR),
        ('1 ano', ONEYEAR),
        # ('2 anos', TWOYEARS),
    ]

    def __init__(self, conn, model):
        super(ContractEditor, self).__init__(conn, model)

    def setup_cbs(self):
        branch_values = [(b.fancy_name, b) for b in
                         PersonAdaptToCompany.select(PersonAdaptToCompany.q.original ==
                                                     PersonAdaptToBranch.q.original, connection=self.conn)]
        contract_types = NFeContract.contract_types
        contract_values = [(contract_types[p], p) for p in contract_types]
        branch_values.insert(0, ('', None))
        self.company.prefill(branch_values)
        self.period.prefill(self.time_options)
        self.contract.prefill(contract_values)

    def setup_proxies(self):
        self.setup_cbs()
        self.proxy = self.add_proxy(self.model,
                                    ContractEditor.proxy_widgets)

    def create_model(self, trans):
        return NFeContract(key=u'',
                           contract=NFeContract.NFCE300,
                           company=None,
                           start_date=datetime.datetime.today(),
                           end_date=datetime.datetime.today() + datetime.timedelta(days=182),
                           connection=trans)

    def _change_dates(self, period):
        start = datetime.datetime.today()
        end = start + datetime.timedelta(days=period)
        self.start_date.update(start)
        self.end_date.update(end)

    def _get_cnpj(self):
        return ''.join([d for d in self.model.company.cnpj if d in '0123456789'])

    def _validate_key(self, key):
        h = hashlib.md5()
        cnpj = self._get_cnpj()
        start_date = self.model.start_date.strftime('%d/%m/%Y')
        end_date = self.model.end_date.strftime('%d/%m/%Y')
        contract = self.model.contract
        h.update(cnpj)
        h.update(start_date)
        h.update(end_date)
        h.update(str(contract))
        return key == h.hexdigest()

    def on_confirm(self):
        key = self.key.read()
        if not self._validate_key(key):
            warning(u'Chave inválida!')
            return
        return self.model

    #
    # Callbacks
    #

    def on_period__content_changed(self, widget):
        period = widget.read()
        if period:
            self._change_dates(period)

    def on_key__validate(self, widget, value):
        if len(value) != 32:
            return ValidationError('Chave inválida')
        if not self._validate_key(value):
            return ValidationError('Chave inválida')


class NFeContractListEditor(ModelListDialog):
    title = 'Contratos'
    size = (900, 350)
    editor_class = ContractEditor
    model_type = NFeContract

    def __init__(self, conn):
        ModelListDialog.__init__(self, conn)
        self.listcontainer.set_list_type(ListType.UNREMOVABLE)

    def _get_contract_name(self, value):
        return NFeContract.get_contract_name(value)

    def get_columns(self):
        columns = [
            Column('contract', title='Contrato', format_func=self._get_contract_name,
                   sorted=True, data_type=unicode),
            Column('company.fancy_name', title='Filial', data_type=unicode),
            Column('key', title='Chave', data_type=unicode),
            Column('start_date', title='Data início', data_type=datetime.datetime),
            Column('end_date', title='Data fim', data_type=datetime.datetime)]
        return columns

    # ModelListDialog

    def populate(self):
        return NFeContract.select(
            connection=self.conn)

    def edit_item(self, item):
        return ModelListDialog.edit_item(self, item)


#TODO move it to dialogs
class NfeBranchDialog(BaseEditor):
    gladefile = "NfeBranchDialog"
    title = "Detalhes da Nfe"
    model_type = Sale
    proxy_widgets = ("branch_cb",)
    size = (250, 150)

    def __init__(self, conn, model, visual_mode=False):
        self.model = model
        self.conn = conn
        BaseEditor.__init__(self, conn, model)
        self._setup_widgets()
        self.setup_proxies()

    def _setup_widgets(self):
        statuses = []
        for branch in Person.iselect(IBranch, connection=self.conn):
            statuses.append((branch.person.name, branch))
        self.branch_cb.prefill(sorted(statuses))
        self.branch_cb.grab_focus()

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(model=self.model, widgets=self.proxy_widgets)

    def on_confirm(self):
        self.model.branch = self.branch_cb.get_selected()
        return self.model
