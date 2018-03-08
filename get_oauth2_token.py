'''
    SCRIPT TAKEN FROM: https://gist.github.com/burnash/6771295

    This script will attempt to open your webbrowser,
    perform OAuth 2 authentication and print your access token.
    It depends on two libraries: oauth2client and gflags.
    To install dependencies from PyPI:
    $ pip install python-gflags oauth2client
    Then run this script:
    $ python get_oauth2_token.py
    
    This is a combination of snippets from:
    https://developers.google.com/api-client-library/python/guide/aaa_oauth
'''

from oauth2client.client import OAuth2WebServerFlow
from oauth2client.tools import run_flow
from oauth2client.file import Storage
import os

CLIENT_ID = os.environ.get('PHDORG_CLIENTID')
CLIENT_SECRET = os.environ.get('PHDORG_CLIENTSECRET')


flow = OAuth2WebServerFlow(client_id=CLIENT_ID,
                           client_secret=CLIENT_SECRET,
                           scope='https://www.googleapis.com/auth/calendar.readonly',
                           redirect_uri='http://example.com/auth_return')

storage = Storage('creds.data')

credentials = run_flow(flow, storage)

print "access_token: %s" % credentials.access_token
