# -*- coding: utf-8 -*-
import smtplib
from email.encoders import encode_base64
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from smtplib import SMTPException
from time import strftime, gmtime

from stoqlib.database.runtime import get_connection
from stoqlib.domain.parameter import EmailConf
from stoqlib.lib.message import error


def email_deliver(TO, body, subject, **attachs):
    conn = get_connection()
    results = EmailConf.select(connection=conn).limit(1)
    conn.close()
    if not results:
        return False
    else:
        SMTP_SERVER = results[0].smtp_server
        PORT = results[0].port
        FROM = results[0].email
        PASSW = results[0].password
    try:
        smtpObj = smtplib.SMTP(SMTP_SERVER, PORT)
        smtpObj.ehlo()
        smtpObj.starttls()
        smtpObj.login(FROM, PASSW)
    except SMTPException, e:
        error('Erro Servidor SMTP', str(e))
        return False
    msg = MIMEMultipart()
    msg['From'] = FROM
    msg['To'] = TO
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    for key in attachs.keys():
        _main_type = key.split('_')[0]
        _sub_type = key.split('_')[1]
        attachment = MIMEBase(_main_type, _sub_type)
        attachment.set_payload(attachs[key])
        encode_base64(attachment)
        file_name = "%s.%s" % (strftime("%Y%m%d", gmtime()), _sub_type)
        attachment.add_header('Content-Disposition', 'attachment', filename=file_name)
        msg.attach(attachment)
    try:
        if not TO:
            return False
        smtpObj.sendmail(FROM, TO, msg.as_string())
    except SMTPException, e:
        error('Erro ao enviar email', str(e))
        return False
    return True


if __name__ == "__main__":
    subject = 'Email Teste'
    receiver = 'mmaia.cc@gmail.com'
    body = 'Estou mandando este email para mandar voce tomar no copo.'
    if email_deliver(receiver, body, subject):
        print "Email enviado a %s" % receiver
