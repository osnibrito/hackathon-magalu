
from wtforms import RadioField, SelectField, StringField, SubmitField
from flask import render_template, request, session
from wtforms.validators import DataRequired
from flask_wtf import FlaskForm
from app import app
from generate import generate

OPTIONS_MAHCINE = [
    "BV1-1-10",
    "BV2-2-40",
    "BV1-2-20",
    "BV2-4-40",
    "BV4-8-100",
    "BV8-16-100",
    "BV1-4-20",
    "BV2-8-40",
    "BV4-16-100",
    "BV8-32-100"
]

OPTIONS_SERVER_PROVIDERS = [
    'nordeste',
    'sudeste'
]

API_KEY = None
KEY_ID = None
KEY_SECRET = None

class MachineForm(FlaskForm):
    machine = SelectField("Maquina (CPU- RAM- DISCO)", choices=OPTIONS_MAHCINE)
    name = StringField("Nome")
    provider = SelectField("Local do Servidor", choices=OPTIONS_SERVER_PROVIDERS)
    ssh_key_name = StringField("Nome da chave SSH")
    submit = SubmitField("Enviar")

class CloudForm(FlaskForm):
    api_key = StringField("Api Key")
    key_id = StringField("Key ID")
    key_secret = StringField("Key Secret")
    submit = SubmitField("Enviar")

@app.route('/config_vm', methods=['GET', 'POST'])
def config_vm():
    form = MachineForm(request.form)

    
    if request.method == 'POST':
        print('APIKEY: ', session['API_KEY'])
        print(form.data)
        terraform_content = generate(
            api_key= session['API_KEY'],
            key_id= session['KEY_ID'],
            key_secret= session['KEY_SECRET'],
            machine= form.data['machine'],
            name= form.data['name'],
            provider= form.data['provider'],
            ssh_key_name= form.data['ssh_key_name'],
        )
        arquivo = open("main.tf", "w")
        arquivo.write(terraform_content)
        arquivo.close()
        return render_template("index.html", form = form)
    return render_template("config_vm.html", form=form)

@app.route('/config_magalu', methods=['GET', 'POST'])
def config_magalu():
    form = CloudForm(request.form)
    
    if request.method == 'POST':
        session['API_KEY'] = form.data['api_key']
        session['KEY_ID'] = form.data['key_id']
        session['KEY_SECRET'] = form.data['key_secret']
        return render_template("index.html", form = form)
    
    return render_template("config_magalu.html", form=form)