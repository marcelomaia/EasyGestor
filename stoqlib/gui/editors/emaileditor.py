from stoqlib.domain.parameter import EmailConf
from stoqlib.gui.editors.baseeditor import BaseEditor


class EmailConfEditor(BaseEditor):
    gladefile = 'EmailConf'
    model_type = EmailConf
    proxy_widgets = ('smtp_server', 'port', 'email', 'password')
    title = u"Configuração de E-mail"

    def create_model(self, trans):
        results = EmailConf.select(connection=trans).limit(1)
        if results:
            return results[0]
        return EmailConf(smtp_server=u'dominio.smtp.com',
                         port=587,
                         email=u'seuemail@dominio.com',
                         password=u'sua senha',
                         connection=trans)

    def setup_proxies(self):
        self.add_proxy(self.model, EmailConfEditor.proxy_widgets)
