import re
import requests
from flask import Flask, jsonify, request
from flask_socketio import SocketIO
from googletrans import Translator
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import VideoGrant


account_sid = "AC6f12b34f892d3f4aedecfd57476ade5d"
api_key = "SK45447f679a086f275e8179aa3a57b3f6"
api_secret = "l3pKhBuIFvLfeHKm7acqQN080psJFfDl"

def create_token(identity):
    token = AccessToken(account_sid, api_key, api_secret)
    token.identity = identity
    # Create a Video grant and add to token
    video_grant = VideoGrant(room='441')
    token.add_grant(video_grant)
    # Return token info as JSON
    # return {"identity":identity, "token":token.to_jwt()}
    return token.to_jwt()

app = Flask(__name__)
# app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, async_mode='gevent')


@app.route('/split/<identity>', methods=['POST', 'GET'])
def restore_sentence(identity):
    url = 'http://bark.phon.ioc.ee/punctuator'
    # get raw text
    raw_text = request.form['text']
    print("Receiving raw text: \n{}".format(raw_text))
    data = {
        'text':raw_text
    }
    response = requests.post(url, data=data)
    print('Seperated text: \n{}'.format(response.text))
    pattern = r'[.,?!:]'
    sentences = re.split(pattern, response.text)
    translator = Translator()
    translates = []
    for s in sentences:
        res = translator.translate(s,src='en',dest='es')
        translates.append(res.text)
    print("sentences: \n{}\n{}".format(sentences, translates))
    # print("json:", jsonify(sentence=sentences, translates=translates))
    return jsonify(sentence=sentences, translates=translates)

@socketio.on('call')
def receive_call(info):
    print('CALLER: {}, CALLEE: {}'.format(info["caller"], info["callee"]))
    socketio.emit('receive', {"caller":info["caller"], "callee":info["callee"]})


@socketio.on('call_accept')
def accept_reject_call(info):
    print('ANSWER: {}'.format(info["state"]))    
    socketio.emit('call_accept_res', {"state": info["state"]}) 

@app.route("/")                   
def hello():                     
    return "Hello World!"         


@app.route("/token/<identity>")
def get_token(identity):
   token = create_token(identity)
   return token

if __name__ == "__main__":        
    # app.run(host="0.0.0.0")                    
    socketio.run(app, host="0.0.0.0")
