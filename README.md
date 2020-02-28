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

#### IOS 
```
sudo gem install cocoapods
pod install (Install TwilioVideo, SwiftIO Modules, and it will create .xcworkspace file in your directory)
open the .xcworkspace
```

#### Server
```
All files locate in node_server folder
go to ./node_server
npm install (install packages, create node_modules file)
npm start
go to localhost:3000 (private)
cd ..
./ngrok http 3000 (generate a public url, copy paste the https url)
```

#### Add Credentials (Twilio, GCP)

### Update:
several endpoints ./node_server/server/index.js provides (to be added)
/: client browser (fake user)
/token: token
/test: testing socket message

ios client is listenting for the event called 'test', the real-time message

When phone and browser are connected
make a phone call to 19494840725(Twilio phone number)
translated text from your phone will be rendered on the ios client side



