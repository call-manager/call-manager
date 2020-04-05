
sudo apt update
sudo apt install python3-venv
sudo apt install nginx
python3.6 -m venv env
source env/bin/activate
pip install wheel
pip install gunicorn flask

sudo ufw allow 5000

sudo apt install python-pip
pip install -r requirements.txt
pip install flask_socketio

http://142.93.241.20:5000

gunicorn --bind 0.0.0.0:5000 wsgi:app

sudo systemctl restart nginx
