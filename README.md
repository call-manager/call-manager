# Voilà Official Repository

Our app features instant video chatting translation with extra functionality of setting volume automatically based on user predefine scenarios by tracking locations, etc


## IDE And Third Party Library

We are going to use the following IDE and third party library to finish our app.

### IDE

[Xcode](https://developer.apple.com/xcode/) - Swift and IOS development

[PyCharm](https://www.jetbrains.com/pycharm/) - Python development

### Third Party Library

[Google Translation Client Library](https://cloud.google.com/translate/docs/reference/libraries/v3/overview-v3) - Alternative library for Google Translation

[Google Cloud Speech-to-Text Library](https://cloud.google.com/speech-to-text/docs/reference/libraries) - Client libraries for Google Cloud APIs

[Twilio](https://www.twilio.com/docs/libraries) - Video Call API

## Setup Installation 

Open terminal(For MAC), and do following command

#### Twilio

```
client:
cd call-manager/call-manager-ios
pod install
open AudioSinkExample.xcworkspace
In SocketIOManager.swift line18, change the url to your IP address(localhost) with port 3000, ex: http://10.XXX.XX.XXX:3000 (http://localhost:3000 doesnt work)

Server:
cd node_server
vim .env(add Twilio auth info)
npm install
npm start
go to localhost:3000, token exists in localhost:3000/token
```

#### Google Translation API

```
pip install google-cloud-translate==2.0.0
```


#### Google Speech-To-Text API

```
pip install --upgrade python-speech
```

#### Possible Library for Implementation

```
pip install numpy
```
#### Django Server Routes
http://167.172.255.230

/logon POST

json body {user: }
returns no call if no current calls
or calling if there are incoming calls

/call

json body {user: } POST
Changes status of the user in json body such that next logon
will return calling for that user
returns nothing

/getchatts GET

resets user status to no call

Server Setup

Add django-backend files to Digital Ocean django droplet
python manage.py runserver localhost:9000
service gunicorn restart
