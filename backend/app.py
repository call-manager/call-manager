# app.py
from flask import Flask         
from flask_socketio import SocketIO

app = Flask(__name__)
# app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

@socketio.on('call')
def receive_call(info):
    print('caller: {}, callee: {}'.format(info["caller"], info["callee"]))
    socketio.emit('receive', {"caller":info["caller"], "callee":info["callee"]})

@app.route('/call')
def call(request):
    if request.method != 'POST':
        abort(404)
    json_data = json.loads(request.body)
    print("requesT:", request)
    print("json_data:", json_data)
    return {}

@app.route('/')                   
def hello():                     
    return "Hello World!"         
if __name__ == "__main__":        
    # app.run()                    
    socketio.run(app)
# 67.207.90.211:5000
# http://67.207.90.211:5000/

/usr/bin/gunicorn

# mkdir flaskapp
# (sudo) apt-get install python3-venv
# python3 -m venv env
# source env/bin/activate
# pip3 install -r requirements.txt
# sudo ufw allow 5000
# http://67.207.90.211:5000/

pip install gunicorn flask
gunicorn --bind 0.0.0.0:5000 wsgi:app
