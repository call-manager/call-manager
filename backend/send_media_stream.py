from twilio.twiml.voice_response import VoiceResponse, Start, Stream

URL = 'http://6424d691.ngrok.io/' 

response = VoiceResponse()
start = Start()
start.stream(
    name='Example Audio Stream', url=URL
)

response.append(start)

print(response)



