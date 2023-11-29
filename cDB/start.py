#!/usr/bin/python3

from flask import Flask, render_template, request, redirect, url_for
import mysql.connector, os, json

app = Flask(__name__)

#load credentials from secrets.json file
with open('secrets.json', 'r') as sf:
        creds = json.load(sf)['creds']


@app.route('/', methods=['get'])
def front():

    connection = mysql.connector.connect(**creds)
    mc = connection.cursor()

    #insert
    newC = request.args.get('city')
    newS = request.args.get('state')
    newCol = request.args.get('col')
    if newC is not None and newS is not None and newCol is not None:
         mc.execute("insert into city (cName, sName, costOfLiving) values (%s,%s,%s)", (newC, newS,newCol))
         connection.commit()
    elif request.args.get('delete') == 'true':
         delid = request.args.get('id')
         mc.execute("delete from city where cityID=%s", (delid,))
         connection.commit()

    #show city table from project DB

    mc.execute("Select * from city")
    cityinfo = mc.fetchall()
    mc.close()
    connection.close()

    return render_template('city.html', cInfo=cityinfo)

@app.route("/updateCity")
def updateCity():
     
    connection = mysql.connector.connect(**creds)

    id = request.args.get('id')
    newC = request.args.get('city')
    newS = request.args.get('state')
    newCol = request.args.get('col')

    if id is None:
         return "Error, id not specified"
    elif newC is not None and newS is not None and newCol is not None:
         mc = connection.cursor()
         mc.execute("UPDATE city set cName=%s, sName=%s, costOfLiving=%s where cityID=%s", (newC, newS, newCol, id))
         mc.close()
         connection.commit()
         connection.close()
         return redirect(url_for('front'))

    mc = connection.cursor()
    mc.execute("select * from city where cityID=%s;", (id,))
    _, oldC, oldS, oldCol = mc.fetchone()
    mc.close()
    connection.close()
    return render_template('updateCity.html', id=id, oldC=oldC, oldS=oldS, oldCol=oldCol)
     

if __name__ == '__main__':
    app.run(port=8000, debug=True, host="0.0.0.0")

