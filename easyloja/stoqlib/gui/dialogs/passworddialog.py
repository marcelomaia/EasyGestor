from kiwi.log import Logger
from kiwi.python import Settable
from stoqlib.domain.person import PersonAdaptToUser
from stoqlib.gui.editors.baseeditor import BaseEditor

log = Logger("stoq-passworddialog")


# TODO: permissoes de usuario fazer um esquema de senha
class UserPassword(BaseEditor):
    gladefile = 'UserPassword'
    model_type = Settable
    proxy_widgets = ('user', 'password')
    ADM, GERENTE, VENDEDOR = (1, 2, 3)
    title_dict = {ADM: 'Senha administrador',
                  GERENTE: 'Senha gerente',
                  VENDEDOR: 'Senha vendedor'}

    def __init__(self, conn, profile=ADM, action=None, action_desc=None):
        self.profile = profile
        self.title = self.title_dict.get(self.profile)
        if action:
            self.title = '%s %s' % (self.title, action_desc)
        self.action = action
        BaseEditor.__init__(self, conn, model=None)

    def create_model(self, trans):
        return Settable(user=None, password=u'')

    def setup_proxies(self):
        self._setup_widgets()
        self.proxy = self.add_proxy(self.model,
                                    UserPassword.proxy_widgets)

    def _setup_widgets(self):
        adm_users = [(p.username, p) for p in PersonAdaptToUser.selectBy(profile=self.profile,
                                                                         connection=self.conn)]
        self.user.prefill(adm_users)

    def on_confirm(self):
        import hashlib
        h = hashlib.new('sha256')
        h.update(self.model.user.username)
        h.update(self.model.password)
        if h.hexdigest() == self.model.user.password:
            if self.action:
                return True if self.model.user.profile.check_action_permission(self.action) else False
            log.debug('Usuario {} digitou a senha com sucesso'.format(self.model.user.username))
            return True
        else:
            return False
