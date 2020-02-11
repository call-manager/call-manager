# Download the helper library from https://www.twilio.com/docs/python/install
from twilio.rest import Client
# from keys import ACCOUNT_ID, AUTH_TOKEN

# Your Account Sid and Auth Token from twilio.com/console
# DANGER! This is insecure. See http://twil.io/secure
account_sid = 'AC176361d9b7ded3a94d800693da7be3dd'
auth_token = '405b983056ab791d74f1b286d66eec2a'
client = Client(account_sid, auth_token)

calls = client.calls.list(limit=20, to='+19494840725')

for record in calls:
	print(record.sid)

# CAdcc94076c763e69766f4d5e4e62525f7
# CAec24db543a9fb325ae1b4d98bc784f7f
# CA8e9b6dce5d02c053fecdde50b525b54a
# CAaf2b7e4bd72f96423eb3705dbc7242ab
# CA147bf1f8c7afa035b1d0f6adcc0b5e86
# CAd7ed9740ad4776d2ace3c4cb09a78c2a
# CA76a62fe400bfdaafccd100ba651c31f6
# CA636759191c25b8114a687d222518606b

# call = client.calls('CAdcc94076c763e69766f4d5e4e62525f7').fetch()
# print(call)
# print(call.to)
