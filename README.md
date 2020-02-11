# Call Manager wiz Ringtone Control

Our app features instant video chatting translation with extra functionality of setting volume automatically based on user predefine scenarios by tracking locations, etc


## IDE And Third Party Library

We are going to use the following IDE and third party library to finish our app.

### IDE

[Xcode](https://developer.apple.com/xcode/) - Swift and IOS development

[PyCharm](https://www.jetbrains.com/pycharm/) - Python development

### Third Party Library

[Google Translation Client Library](https://cloud.google.com/translate/docs/reference/libraries/v3/overview-v3) - Alternative library for Google Translation

[Google Cloud Speech-to-Text Library](https://cloud.google.com/speech-to-text/docs/reference/libraries) - Client libraries for Google Cloud APIs

### Setup server
# open a new terminal, in the backend directory
# server script: app.py
# google_creds.json: api key for GCP API
# small scripts for testing: list_calls.py, make_call.py
python3 -m venv venv
source ./venv/bin/activate
pip install flask flask-sockets

pip install Flask twilio
pip freeze > requirements.txt
pip install -r requirements.txt

python app.py 
# go to localhost:5000, you should see a greeting message

# reference:
# WebSocket Twilio
# https://www.twilio.com/docs/voice/tutorials/consume-real-time-media-stream-using-websockets-python-and-flask?code-sample=code-create-a-socket-decorator-5&code-language=Python&code-sdk-version=default

# Flask Twilio python SDK
# https://www.twilio.com/docs/usage/tutorials/how-to-set-up-your-python-and-flask-development-environment

# Install ngrok
# https://ngrok.com/download
# (Move ngrox file to the root directory)







