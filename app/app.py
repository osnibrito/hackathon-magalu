from flask import Flask, session

app = Flask(__name__)
app.config['SECRET_KEY'] = 'any secret string'
@app.route("/")
def index():
    return render_template("index.html")
from routes import *