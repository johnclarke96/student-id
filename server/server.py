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
domain = '0.0.0.0:5000/' #Enter domain of site


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
    msg = 'Change Student ID app at:\n' + domain + '?secret_key=' + secret_key
    smtpserver.sendmail(gmail_user, to, msg)
    smtpserver.close()

@app.route('/login', methods=['POST'])
def login():
    for i in request.form:
        print i

    student_email = request.form['email']
    password = request.form['password']
    print student_email, password

    student = models.Student.query.filter_by(email=student_email).first()
    print student

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
        student = session1.query(models.Student).filter_by(email=email).one()
        student.secret_key = random_key

        session1.commit()

        newpass_url = domain + '?secret_key=' + random_key
        send_mail(email, newpass_url)
        print student.secret_key

        return json.dumps({'success': 1, 'message': 'Sent email to change pasword'})



@app.route('/password', methods=['GET', 'POST'])
def change_password():

    if request.method == 'GET':
        secret_key = request.args.get('secret_key')
        return render_template('html/changepass.html', secret_key=secret_key)

    if request.method == 'POST':
        newpass = request.form['newpass']
        print newpass
        secret_key = request.form['secret_key']
        print 'here'
        print secret_key

        session1 = db.create_session({})
        student = session1.query(models.Student).filter_by(secret_key=secret_key).one()
        print student

        if student is None:
            return render_template('html/error.html')

        student.password = newpass
        student.secret_key = None
        session1.commit()

        return render_template('html/success.html')



@app.route('/image', methods=['GET'])
def image():
    image_path = request.args.get('path', None)
    print image_path
    return send_file(image_path, mimetype='image/gif')



# CMS
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

        send_mail(email, secret_key)

        student_picture = request.files['file']
        filename = secure_filename(str(student_id) + '.jpg')
        student_picture.save(os.path.join('/srv/student_id/mit/',filename))


        return 'success'
@app.route('/student/delete', methods=['POST'])
def delete():
    primary_key = request.form['primary_key']
    user = models.Student.get(primary_key)
    db.session.delete(user)
    db.session.commit()
    return redirect(url_for('display_data'))


@app.route('/display_data', methods=['GET'])
def display_data():
   data =  models.Student.query.all()
   return render_template('html/displayTable.html', data=data)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
