# Download the helper library from https://www.twilio.com/docs/python/install
from twilio.rest import Client


# Your Account Sid and Auth Token from twilio.com/console
# DANGER! This is insecure. See http://twil.io/secure
account_sid = 'AC176361d9b7ded3a94d800693da7be3dd'
auth_token = '405b983056ab791d74f1b286d66eec2a'
client = Client(account_sid, auth_token)

call = client.calls.create(
                        url='http://demo.twilio.com/docs/voice.xml',
                        to='+19494840725',
                        from_='+17348829877'
                    )

print(call.sid)
