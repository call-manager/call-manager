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

### Installation 

Twilio

Open terminal(For MAC), and do following command
```
cd backend
python3 -m venv venv
source ./venv/bin/activate
pip install flask flask-sockets

pip install Flask twilio
pip freeze > requirements.txt
pip install -r requirements.txt

```
Then go to localhost:5000, there should exist a greeting message.


Google Translation API

```
pip install google-cloud-translate==2.0.0
```


Google Speech-To-Text API

```
pip install --upgrade python-speech
```

