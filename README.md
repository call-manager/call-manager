# Voilà Official Repository

Our app features instant video chatting translation with extra functionality of setting volume automatically based on user predefine scenarios by tracking locations, etc


## File Structure

```
FrontEnd
  --call-manager-ios
    --AudioSinkExample (*.swift)

Backend:
  --backend 
  --django-backend 

```

### Build & Run

```
Client:
cd call-manager/call-manager-ios
pod install
open AudioSinkExample.xcworkspace


Server:
ssh root@161.35.106.220
cd flask_server
source env/bin/activate
python3 app.py
```

### File structure of MVP code 
```
Location Based Ringtone Control: ./call-manager-ios/AudioSinkExample)
```
[locationManager(), AddLoc()](https://github.com/call-manager/call-manager/commit/8426abf34a365e7fbad9d82e55e84b66b03efcfd)
```
Display caller information(username): ./call-manager-ios/AudioSinkExample/ContactListVC.swift
```
[showCallNoti()](https://github.com/call-manager/call-manager/blob/master/call-manager-ios/AudioSinkExample/ContactListVC.swift)
```
Display the caption box in target language, turn on/off by user
Detect sentence ending: ./backend/app.py
```
[restore_sentence()](https://github.com/call-manager/call-manager/blob/master/backend/app.py)


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
twilio, re, flask, googletrans, flask_socketio, flask
```

#### Flask Server Routes
http://161.35.106.220:5000/

```
/token/<identity>
twilio token for join the same chat room

/split/<identity>
detect sentence ending

```

#### Django Server Routes
http://167.172.255.230

```
/getloc POST

json body {user: }
gets muted location coordinates, if none, returns 0 0.


/addloc

json body {user: latitude: longitude} POST
adds latitude longitude to location for given user.

Server Setup

Add django-backend files to Digital Ocean django droplet

python manage.py runserver localhost:9000

service gunicorn restart
```

## Skeletal Product
```
Make/Receive Calls
Notification of calls
Accept/Decline Calls
```
[files related to above features](https://github.com/call-manager/call-manager/blob/master/call-manager-ios/AudioSinkExample/ContactProfileViewController.swift), [showCallNoti()](https://github.com/call-manager/call-manager/blob/master/call-manager-ios/AudioSinkExample/ContactListVC.swift)
```
Mute button
```
[ClicktoMuteUnmute()](https://github.com/call-manager/call-manager/blob/master/call-manager-ios/AudioSinkExample/ChatRoomVC.swift)
```
Voice to text
Text translation
```
[recognizeAudio()](https://github.com/call-manager/call-manager/blob/master/call-manager-ios/AudioSinkExample/ChatRoomVC.swift)
```
Record transcript in original and target languages
```
[AfterCallTranscriptVC.swift](https://github.com/call-manager/call-manager/blob/master/call-manager-ios/AudioSinkExample/AfterCallTranscriptVC.swift)

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

