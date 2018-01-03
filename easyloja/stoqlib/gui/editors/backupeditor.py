# -*- coding: utf-8 -*-
# vi:si:et:sw=4:sts=4:ts=4
from subprocess import Popen
from stoqlib.api import api
from stoqlib.lib.message import info
from kiwi.log import Logger
from stoqlib.gui.editors.baseeditor import BaseEditor

log = Logger(__name__)

_app_settings = api.user_settings

class BackupSchedule(object):
    schedule = 'weekly'
    options = {'daily': "schtasks /Create /TN \"Easyloja Backup\" /SC DAILY /ST 09:00 /F /TR \"dump.bat\"",
               'weekly': "schtasks /Create /TN \"Easyloja Backup\" /SC WEEKLY /ST 09:00 /D MON /F /TR \"dump.bat\"",
               'monthly': "schtasks /Create /TN \"Easyloja Backup\" /SC MONTHLY /ST 09:00 /D 1 /F /TR \"dump.bat\""}

    def create_task(self):
        cmd = self.options[self.schedule]
        log.debug('executing %s' % cmd)
        proc = Popen(cmd, shell=False)
        if proc.wait() == 0:
            _app_settings.set('backup-mode', self.schedule)
            info("Uma rotina de backup foi agendada, por favor verifique no sistema as tarefas agendadas.")


class BackupEditor(BaseEditor):
    model_name = 'Configuraçao de Backup'
    model_type = BackupSchedule
    gladefile = 'BackupEditor'
    proxy_widgets = ('daily_rb', 'weekly_rb', 'monthly_rb', )

    def __init__(self, conn):
        BaseEditor.__init__(self, conn)
        self.setup_widgets()

    #
    # BaseEditor Hooks
    #

    def setup_proxies(self):
        self.proxy = self.add_proxy(model=self.model, widgets=self.proxy_widgets)

    def setup_widgets(self):
        backup_setting = _app_settings.get('backup-mode', default=self.model.schedule)
        widget = getattr(self, '%s_rb' % backup_setting, None)
		widget.set_active(True)
		
    def create_model(self, conn):
        return BackupSchedule()

    def on_confirm(self):
        self.model.create_task()