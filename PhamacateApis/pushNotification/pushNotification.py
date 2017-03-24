# -*- coding: utf-8 -*-
"""
Created on Thu Aug  4 00:12:37 2016

@author: Dip
"""

import time
from apns import APNs, Frame, Payload

apns = APNs(use_sandbox=True, cert_file='key.pem', key_file='cert.pem', enhanced=True)

# Send a notification
token_hex = 'da6c62c81aadc61615c60ec3aa04ce6b444fc24ec957213f35ca481065ceda15'
#token_hex = 'ffa91142 640ab67d 9df795d5 3c71d5c2 92f21af9 6063edb3 537d47fb a9be7c1c'
payload = Payload(alert="Welcome to Pharmacate", sound = "default", badge=1)
apns.gateway_server.send_notification(token_hex, payload)