from flask import Flask
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def default():
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")

    return "request received = " + current_time