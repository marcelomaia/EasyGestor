import os

import gflags
import httplib2
from oauth2client.file import Storage
from oauth2client.client import OAuth2WebServerFlow
from oauth2client.tools import run

from apiclient.discovery import build
from stoqlib.lib.osutils import get_application_dir


FLAGS = gflags.FLAGS


def is_aware(value):
    """
    Determines if a given datetime.datetime is aware.

    The logic is described in Python's docs:
    http://docs.python.org/library/datetime.html#datetime.tzinfo
    """
    return value.tzinfo is not None and value.tzinfo.utcoffset(value) is not None


def rfc3339_date(date):
    # Support datetime objects older than 1900
    if is_aware(date):
        time_str = date.strftime('%Y-%m-%dT%H:%M:%S')
        offset = date.tzinfo.utcoffset(date)
        timezone = (offset.days * 24 * 60) + (offset.seconds // 60)
        hour, minute = divmod(timezone, 60)
        return time_str + "%+03d:%02d" % (hour, minute)
    else:
        return date.strftime('%Y-%m-%dT%H:%M:%SZ')


# Set up a Flow object to be used if we need to authenticate. This
# sample uses OAuth 2.0, and we set up the OAuth2WebServerFlow with
# the information it needs to authenticate. Note that it is called
# the Web Server Flow, but it can also handle the flow for native
# applications
# The client_id and client_secret can be found in Google Developers Console
FLOW = OAuth2WebServerFlow(
    client_id='1074741842321-e1l7u0rngcmb8ip0dcn7idfg3ik9uc4n.apps.googleusercontent.com',
    client_secret='GmsydPnPDP-lOaEXvOY9okyr',
    scope='https://www.googleapis.com/auth/calendar',
    user_agent='EasyGestor/1.0')


# To disable the local server feature, uncomment the following line:
# FLAGS.auth_local_webserver = False

# If the Credentials don't exist or are invalid, run through the native client
# flow. The Storage object will ensure that if successful the good
# Credentials will get written back to a file.
appdir = get_application_dir()
cacert = os.path.join(appdir, 'cacert.pem')
dat_file = os.path.join(appdir, 'calendar.dat')

http = httplib2.Http(timeout=3, ca_certs=cacert)

storage = Storage(dat_file)
credentials = storage.get()
if credentials is None or credentials.invalid is True:
    credentials = run(FLOW, storage, http=http)

# Create an httplib2.Http object to handle our HTTP requests and authorize it
# with our good Credentials.
http = credentials.authorize(http)

# Build a service object for interacting with the API. Visit
# the Google Developers Console
# to get a developerKey for your own application.
try:
    service = build(serviceName='calendar', version='v3', http=http,
                    developerKey='YOUR_DEVELOPER_KEY')
except Exception, e:
    print e

# email: ebi.automacao@gmail.com

# event = {
#   'summary': 'Appointment',
#   'location': 'Somewhere',
#   'start': {
#     'dateTime': '2011-06-03T10:00:00.000-07:00'
#   },
#   'end': {
#     'dateTime': '2011-06-03T10:25:00.000-07:00'
#   },
#   'attendees': [
#     {
#       'email': 'mmaia.cc@gmail.com',
#       # Other attendee's data...
#     },
#     # ...
#   ],
# }
#
# created_event = service.events().insert(calendarId='primary', body=event).execute()
#
# print created_event