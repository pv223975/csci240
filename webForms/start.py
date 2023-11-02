#!/usr/bin/python3

from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('input.html')

@app.route('/table')
def page1():
    jt=request.args.get('jtitle')
    js=request.args.get('jsalary')
    jd=request.args.get('jdesc')
    return render_template('table.html', jt=jt, js=js, jd=jd)

if __name__ == '__main__':
    app.run(port=8000, debug=True, host="0.0.0.0")

