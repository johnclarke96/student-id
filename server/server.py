import json
import smtplib
import random
import os

from flask import Flask, send_file, request, render_template, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from werkzeug import secure_filename


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://hansonj:password@sql.mit.edu/hansonj+student_id'
db = SQLAlchemy(app)

import models

domain = '52.27.186.224/' #Enter domain of site



@app.route('/login', methods=['POST'])
def login():

    student_email = request.form['email']
    password = request.form['password']

    student = models.Student.query.filter_by(email=student_email).first()

    if student is None:
        return json.dumps({'success':0, 'data': {'error': 'invalid email'}})

    if student.password != password:
        return json.dumps({'success': 0, 'data': {'error': 'invalid password'}})

    first_name = student.first_name
    last_name = student.last_name
    student_id = student.student_id
    image_path = student.image_path
    school_name = student.school_name

    data = {
            'first_name': first_name,
            'last_name': last_name,
            'student_id': student_id,
            'image_path': image_path,
            'school_name': school_name
        }

    ret = {
            'success': 1,
            'data': data
        }

    return json.dumps(ret)

@app.route('/password_reset', methods=['POST'])
def password_reset():

        email = request.form['email']
        student = models.Student.query.filter_by(email=email).first()

        if student is None:
            return json.dumps({'success': 0, 'message': 'Email is not associated with an account'})

        random_key = get_secret_key()
        session1 = db.create_session({})
        student = session1.query(models.Student).filter_by(email=email).first()
        student.secret_key = random_key

        session1.commit()

        send_mail(email, random_key)

        return json.dumps({'success': 1, 'message': 'Sent email to change pasword'})

@app.route('/password', methods=['GET', 'POST'])
def change_password():

    if request.method == 'GET':
        secret_key = request.args.get('secret_key')
        return render_template('html/changepass.html', secret_key=secret_key)

    if request.method == 'POST':
        newpass = request.form['newpass']
        secret_key = request.form['secret_key']

        session1 = db.create_session({})
        student = session1.query(models.Student).filter_by(secret_key=secret_key).one()

        if student is None:
            return render_template('html/error.html')

        student.password = newpass
        student.secret_key = None
        session1.commit()

        return render_template('html/success.html')

@app.route('/image', methods=['GET'])
def image():
    image_path = request.args.get('path', None)
    return send_file(image_path, mimetype='image/gif')




# CMS
@app.route('/')
def go_home():
    return render_template('html/index.html')

@app.route('/admin', methods=['POST'])
def admin_login():
    if request.method == "POST":
        username = request.form['username']
        password = request.form['password']

        admin = models.Admin.query.filter_by(username=username).first()

        if admin is None:
            return "this admin username does not exist."

        if admin.password != password:
            return "the admin password is incorrect."

        return redirect(url_for('display_data'))

@app.route('/display_data', methods=['GET'])
def display_data():
    data =  models.Student.query.all()
    return render_template('html/displayTable.html', data=data)



#### CREATING AND DELETING WITH ADMIN PRIVLEDGES
@app.route('/student', methods=['POST', 'GET'])
def student():
    if request.method == 'GET':
        return render_template('html/inputStudent.html')

    if request.method == 'POST':
        first_name = request.form['firstname']
        last_name = request.form['lastname']
        email = request.form['email']
        student_id = request.form['studentid']
        school_name = request.form['schoolname']

        new_student = models.Student(first_name, last_name, student_id, email, school_name)

        secret_key = get_secret_key()
        new_student.secret_key = secret_key

        db.session.add(new_student)
        db.session.commit()
        db.session.close()

        send_mail(email, secret_key)

        # Uploading file
        student_picture = request.files['file']
        filename = secure_filename(str(student_id) + '.jpg')
        student_picture.save(os.path.join('/srv/student_id/' + school_name.lower() + '/',filename))

        return redirect(url_for('display_data'))

@app.route('/student/delete', methods=['POST'])
def delete():

    primary_key = request.form['primary_key']
    session1 = db.create_session({})
    user = session1.query(models.Student).filter_by(id=primary_key).first()
    session1.delete(user)
    session1.commit()
    return redirect(url_for('display_data'))


# Helper functions
def get_secret_key():
    return str(random.randint(0,10000000))

def send_mail(to, secret_key):
    gmail_user = 'thestudentidapp@gmail.com'
    gmail_pass = 'studentidpassword'
    smtpserver = smtplib.SMTP("smtp.gmail.com",587)
    smtpserver.ehlo()
    smtpserver.starttls()
    smtpserver.ehlo
    smtpserver.login(gmail_user, gmail_pass)
    msg = 'Change Student ID app at:\nhttp://' + domain + 'password?secret_key=' + secret_key
    smtpserver.sendmail(gmail_user, to, msg)
    smtpserver.close()



if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
