from server import db

class Student(db.Model):


    id = db.Column(db.Integer, primary_key=True)

    # Student info
    first_name = db.Column(db.String(120))
    last_name = db.Column(db.String(120))
    student_id = db.Column(db.Integer, unique=True)
    school_name = db.Column(db.String(100))

    email = db.Column(db.String(120), unique=True)
    password = db.Column(db.String(40))
    secret_key = db.Column(db.String(120), unique=True)

    image_path = db.Column(db.String(200), unique=True)

    def __init__(self, first_name, last_name, student_id, email, school_name):
        self.first_name = first_name
        self.last_name = last_name
        self.student_id = student_id
        self.school_name = school_name

        self.email = email

        self.image_path = '/srv/student_id/' + school_name.lower() + '/' + student_id + '.jpg'

    def __repr__(self):
        return '<User %r>' % self.email


#class Admin(db.Model):

    #id = db.Column(db.Integer, primary_key=True)

    #email = db.Column(db.String(120), unique=True)
    #password = db.Column(db.String(40))


