from flask import Flask, jsonify
from flask_socketio import SocketIO
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import VideoGrant


account_sid = ""
api_key = ""
api_secret = ""

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


@socketio.on('call')
def receive_call(info):
    print('CALLER: {}, CALLEE: {}'.format(info["caller"], info["callee"]))
    socketio.emit('receive', {"caller":info["caller"], "callee":info["callee"]})


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
