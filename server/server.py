from flask import Flask, send_file
from flask_sqlalchemy import SQLAlchemy

import models

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://hansonj:password@sql.mit.edu/hansonj+student_id'
db = SQLAlchemy(app)

app.route('/login/', methods=['POST'])
def login():

    request_parser = reqparse.RequestParser()
    request_parser.add_argument('email', type=str, location='json')
    request_parser.add_argument('password', type=str, location='json')
    request_args = request_parser.parse_args()
    student_email = request_args['email']
    password = request_args['password']

    student = Student.query.filter_by(email=student_email).all()

    if student is None:
        return {'error': 'invalid email'}

    if student.password != password:
        return {'error': 'invalid password'}

    student_name = student.student_name
    student_id = student.student_id
    image_path = student.path_to_image

    data = {
            'first_name': first_name,
            'last_name': last_name,
            'student_id': student_id,
            'image_path': image_path
        }

    ret = {
            'success': 1,
            'data': data
        }

    return ret


app.route('/image/', methods=['GET'])
def image():
    request_parser = reqparse.RequestParser()
    request_parser.add_argument('path', type=str)
    request_args = request_parser.parse_args()
    image_path = request_args['path']

    return send_file(image_path, mimetype='image/gif')

app.run(host='0.0.0.', port=8000)
