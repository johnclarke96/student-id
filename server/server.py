import json
import smtplib

from flask import Flask, send_file, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://hansonj:password@sql.mit.edu/hansonj+student_id'
db = SQLAlchemy(app)

import models

@app.route('/login', methods=['POST'])
def login():
    for i in request.form:
        print i

    student_email = request.form['email']
    password = request.form['password']
    print student_email, password

    student = models.Student.query.filter_by(email=student_email).first()
    print student
    print student.first_name

    if student is None:
        return {'error': 'invalid email'}

    if student.password != password:
        return {'error': 'invalid password'}

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


#@app.route('/password', methods=['GET', 'POST', 'PUT'])
#def change_password():

    if request.method == 'POST':

        email = request.form['email']
        student = models.Student.query.filter_by(email=email).first()

        if student is None:
            return {'success': 0, 'error': 'Email is not associated with an account'}

        random_key = al;ksjdf
        student.secret_key = random_key



#    if request.method == 'GET':
#        return render_template('/html/changepass.html')

    if request.method == 'PUT':
        newpass = request.form['newpass']
        secret_key = request.args.get('secret_key', None)

        student = models.Student.query.filter_by(secret_key=secret_key).first()

        if student is None:
            return render_template('html/error.html')

        student.change_password(newpass)
        return render_template('html/success.html')






@app.route('/image', methods=['GET'])
def image():
    image_path = request.args.get('path', None)
    print image_path
    return send_file(image_path, mimetype='image/gif')

if __name__ == "__main__":
    app.run(host='0.0.0.0')
