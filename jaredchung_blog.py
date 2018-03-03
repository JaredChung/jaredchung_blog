import os
from flask import Flask, render_template, request, flash, render_template_string, Markup
from flask_flatpages import FlatPages, pygmented_markdown
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, TextAreaField, validators
from flask_mail import Message, Mail

# Blog post variables
DEBUG = True
FLATPAGES_AUTO_RELOAD = DEBUG
FLATPAGES_EXTENSION = '.md'
FLATPAGES_ROOT = 'content'
POST_DIR = 'posts'

app = Flask(__name__)
flatpages = FlatPages(app)

def prerender_jinja(text):
    prerendered_body = render_template_string(Markup(text))
    return pygmented_markdown(prerendered_body)

app.config['FLATPAGES_HTML_RENDERER'] = prerender_jinja

app.config.from_object(__name__)
app.secret_key = 'personal key'

# Mail variables

app.config["MAIL_SERVER"] = 'smtp.live.com'
app.config["MAIL_PORT"] = 587
app.config["MAIL_USE_TLS"] = True
app.config["MAIL_USE_SSL"] = False
app.config["MAIL_DEBUG"] = True
app.config["MAIL_USERNAME"] = str(os.environ.get('MAIL_USERNAME'))
app.config["MAIL_PASSWORD"] = str(os.environ.get('MAIL_PASSWORD'))
app.config['SECURITY_EMAIL_SENDER'] = 'jared_chung@hotmail.com'

mail = Mail(app)

#mail.init_app(app)

class ContactForm(FlaskForm):
    name = StringField("Name", [validators.DataRequired("Please enter your name.")])
    email = StringField("Email", [validators.DataRequired("Please enter your email."), validators.Email()])
    subject = StringField("Subject", [validators.DataRequired("Please enter a subject.")])
    message = TextAreaField("Message", [validators.DataRequired("Please enter a message.")])
    submit = SubmitField("Send")

@app.route('/contact', methods = ['GET','POST'])
def contact():
    form = ContactForm()
    if request.method == 'POST':
        if form.validate_on_submit() == False:
            flash('All fields are required')
            return render_template('contact.html', form=form)
        else:
            msg = Message(form.subject.data, sender='jared_chung@hotmail.com', recipients=['jared_chung@hotmail.com'])
            msg.body = """
            From: %s <%s>
            %s
            """ % (form.name.data, form.email.data, form.message.data)
            mail.send(msg)
            return render_template('contact.html', success=True)
    elif request.method == 'GET':
        return render_template('contact.html', form=form)

@app.route('/about')
def about():
    return render_template('about.html')

@app.route("/posts")
def posts():
    posts = [p for p in flatpages if p.path.startswith(POST_DIR)]
    posts.sort(key = lambda item:item['date'], reverse=True)
    return render_template('posts.html', posts = posts)

@app.route('/posts/<name>/')
def post(name):
    path = '{}/{}'.format(POST_DIR, name)
    post = flatpages.get_or_404(path)
    return render_template('post.html', post=post)

@app.errorhandler(404)
def error():
    return render_template('404.html')

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == "__main__":
    app.run(debug=False)
