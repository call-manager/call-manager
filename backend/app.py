import base64
import json
import logging

from flask import Flask, request
from flask_sockets import Sockets
from twilio.rest import Client
from twilio.twiml.voice_response import VoiceResponse
from twilio.twiml.messaging_response import Message, MessagingResponse
# from SpeechClientBridge import SpeechClientBridge
# from google.cloud.speech import enums
# from google.cloud.speech import types



# TWILIO_ACCOUNT_SID = ''
# TWILIO_AUTH_TOKEN = ''

# client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

app = Flask(__name__)
sockets = Sockets(app)

HTTP_SERVER_PORT = 5000

# config = types.RecognitionConfig(
#     encoding=enums.RecognitionConfig.AudioEncoding.MULAW,
#     sample_rate_hertz=8000,
#     language_code='en-US')
# streaming_config = types.StreamingRecognitionConfig(
#     config=config,
#     interim_results=True)

def on_transcription_response(response):
    if not response.results:
        return
    result = response.results[0]
    if not result.alternatives:
        return
    transcription = result.alternatives[0].transcript
    print("Transcription: " + transcription)

@app.route('/')
def hello():
    return "Hello from Call Manager!"

# answer the http request from Twil, do business logic(translation), wrap up as TwilML send it back to Twilio
@app.route('/answer', methods=['GET', 'POST'])
def answer_call():
    """Respond to incoming phone calls with a breif message."""
    # Start our TwilML response
    ### GOOGLE API CALL comes here ###
    response = VoiceResponse()
    # 9494840725
    # Read a message aloud to the caller
    response.say("Hello Juncheng! Good evening!.", voice='alice')
    return str(response)

# record the call content, basic version
@app.route('/record', methods=['GET', 'POST'])
def record():
    """Returns TwiML which prompts the caller to record a message"""
    # Start our TwilML response
    response = VoiceResponse()
    # Use <Say> to give the caller some instructions
    response.say('Hello. Please leave a message')
    # Use <Record> to record the caller's message
    response.record()
    # ENd the call with <Hangup>
    response.hangup()
    return str(response)

# handle incoming phone calls
@app.route('/call', methods=['POST'])
def call():
    # Print the Call SID so that we can use it to update the call later.
    print(request.form['CallSid'])

    # Create a TwiML Voice Response object
    resp = VoiceResponse()
    resp.say('Please wait')
    # Do nothing until the call is asynchronously updated.
    resp.pause(length=100)
    return str(resp)

# 0.004 / min
# reference: https://www.twilio.com/docs/voice/tutorials/consume-real-time-media-stream-using-websockets-python-and-flask
@sockets.route('/media')
def echo(ws):
    app.logger.info("Connection accepted")
    # gogole translation bridge
    # bridge = SpeechClientBridge(
    #     streaming_config, 
    #     on_transcription_response
    # )
    # A lot of messages will be sent rapidly. We'll stop showing after the first one.
    has_seen_media = False
    message_count = 0
    while not ws.closed:
        message = ws.receive()
        if message is None:
            # to be fixed
            # bridge.terminate() 
            app.logger.info("No message received...")
            continue

        # Messages are a JSON encoded string
        data = json.loads(message)

        # Using the event type you can determine what type of message you are receiving
        if data['event'] == "connected":
            app.logger.info("Connected Message received: {}".format(message))
        if data['event'] == "start":
            app.logger.info("Start Message received: {}".format(message))
        if data['event'] == "media":
            # app.logger.info("Media message: {}".format(message))
            payload = data['media']['payload']
            # app.logger.info("Payload is: {}".format(payload))
            chunk = base64.b64decode(payload)
            # app.logger.info("That's {} bytes".format(len(chunk)))
            # app.logger.info("Additional media messages from WebSocket are being suppressed....")
            # bridge.add_request(chunk)
            print("bridge add request")
            # node js tutorial: https://www.twilio.com/blog/analyze-entities-in-real-time-calls-google-cloud-language
        if data['event'] == "closed":
            app.logger.info("Closed Message received: {}".format(message))
            break
        message_count += 1

    # bridge.terminate() 
    app.logger.info("Connection closed. Received a total of {} messages".format(message_count))


if __name__ == '__main__':
    app.logger.setLevel(logging.DEBUG)
    from gevent import pywsgi
    from geventwebsocket.handler import WebSocketHandler

    server = pywsgi.WSGIServer(('', HTTP_SERVER_PORT), app, handler_class=WebSocketHandler)
    print("Server listening on: http://localhost:" + str(HTTP_SERVER_PORT))
    server.serve_forever()

