# coding=utf-8
import smtplib
from smtplib import SMTPException
from kiwi.ui.delegates import Delegate
from kiwi.ui.dialogs import warning, error
from kiwi.ui.gadgets import quit_if_last
from stoqlib.gui.base.dialogs import get_current_toplevel


sender = 'feedback@easyloja.com'
passw = 'cx8Q4fSRMx1J'
receivers = ['feedback@easyloja.com, vitor@ebi.com.br, thiagovulcao@ebi.com.br']

try:
   smtpObj = smtplib.SMTP('smtp.easyloja.com', 587)
   smtpObj.login(sender, passw)
except SMTPException, e:
    print "Error: unable to login", e


class FeedbackDialog(Delegate):
    gladefile = 'FeedbackDialog'
    size = (400, 300)

    def __init__(self, appname,  toplevel=get_current_toplevel(), widgets=(), gladefile=None, toplevel_name=None, delete_handler=quit_if_last,
                 keyactions=None):
        self.appname_desc = appname
        super(FeedbackDialog, self).__init__(toplevel, widgets, gladefile, toplevel_name, delete_handler, keyactions)
        self.setup_widgets()
        self.get_toplevel().set_size_request(*self.size)

    def setup_widgets(self):
        self.appname.update(self.appname_desc)
        self.appname.set_bold(True)

    def run(self):
        self.show_and_loop()

    #
    # Callbacks
    #

    def on_cancel_bt__clicked(self, arg):
        self.hide_and_quit()

    def on_send_bt__clicked(self, arg):

        try:
            smtpObj = smtplib.SMTP('smtp.easyloja.com', 587)
            smtpObj.login(sender, passw)
        except SMTPException, e:
            error('Erro ao enviar mensagem', str(e))
            return

        message = """From: %s\nSubject: Feedback para o Easyloja\n\nFeedback relativo ao aplicativo %s:\n%s
        """ % (self.email.get_text(), self.appname_desc, self.feedback.read())

        try:
            smtpObj.sendmail(sender, receivers, message)
            warning('Mensagem enviada', 'Mensagem enviada com sucesso! '
                                        'Retornaremos assim que possível')
            self.hide_and_quit()
        except SMTPException, e:
            error('Erro ao enviar mensagem', str(e))
