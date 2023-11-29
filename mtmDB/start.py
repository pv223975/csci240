#!/usr/bin/python3

from flask import Flask, render_template, request, redirect, url_for
import mysql.connector, os, json

app = Flask(__name__)

#load credentials from secrets.json file (gitIgnored) for user wtest with only CRUD privileges in project DB
with open('secrets.json', 'r') as sf:
        creds = json.load(sf)['creds']
        
#start page - base html       
@app.route('/')
def base():
     return render_template('base.html')

#city page
@app.route('/city', methods=['get'])
def citypage():

     #create mysql connector
    connection = mysql.connector.connect(**creds)
    mc = connection.cursor()

    #insert varibles, PK is autoincrementing
    newC = request.args.get('city')
    newS = request.args.get('state')
    newCol = request.args.get('col')

     #if all attributes are filled, try insert/
     #else if delete is true try delete
    if newC is not None and newS is not None and newCol is not None:
         mc.execute("insert into city (cName, sName, costOfLiving) values (%s,%s,%s)", (newC, newS,newCol))
         connection.commit()
    elif request.args.get('delete') == 'true':
         delid = request.args.get('id')
         mc.execute("delete from city where cityID=%s", (delid,))
         connection.commit()

    #get city table from project DB
    mc.execute("Select * from city")
    cityinfo = mc.fetchall()
    mc.close()
    connection.close()

     #use cInfo in city.html which makes html table
    return render_template('city.html', cInfo=cityinfo)

#update city page
@app.route('/uCity')
def uCity():
     
    connection = mysql.connector.connect(**creds)

     #PK
    id = request.args.get('id')

     #update varibles
    newC = request.args.get('city')
    newS = request.args.get('state')
    newCol = request.args.get('col')

    if id is None:
         return "Unable to find ID"
    elif newC is not None and newS is not None and newCol is not None:
         mc = connection.cursor()
         mc.execute("UPDATE city set cName=%s, sName=%s, costOfLiving=%s where cityID=%s", (newC, newS, newCol, id))
         mc.close()
         connection.commit()
         connection.close()
         return redirect(url_for('citypage'))

    mc = connection.cursor()
    mc.execute("select * from city where cityID=%s;", (id,))
    #used for placeholder update fields
    _, oldC, oldS, oldCol = mc.fetchone()
    mc.close()
    connection.close()

    return render_template('uCity.html', id=id, oc=oldC, os=oldS, ocol=oldCol)
     
#Employer page
@app.route('/employer', methods=['get'])
def employerpage():

    connection = mysql.connector.connect(**creds)
    mc = connection.cursor()

    #PK
    nName = request.args.get('ename')

     #insert varibles
    nRate = request.args.get('erate')
    nSize = request.args.get('esize')

    if nName is not None and nRate is not None and nSize is not None:
         mc.execute("insert into employer (eName, eRating, eSize) values (%s,%s,%s)", (nName, nRate,nSize))
         connection.commit()
    elif request.args.get('delete') == 'true':
         delName = request.args.get('eName')
         mc.execute("delete from employer where eName=%s", (delName,))
         connection.commit()

    #show employer table from project DB in employer.html
    mc.execute("Select * from employer")
    employerinfo = mc.fetchall()
    mc.close()
    connection.close()

     #use eInfo for employer.html
    return render_template('employer.html', eInfo=employerinfo)

@app.route('/uEmp', methods=['get'])
def uEmp():
         
    connection = mysql.connector.connect(**creds)

     #index varible
    eName = request.args.get('eName')

     #new varibles
    nRate = request.args.get('rate')
    nSize = request.args.get('size')

    if eName is None:
         return ("Unable to find ID")
    elif nRate is not None and nSize is not None:
         mc = connection.cursor()
         mc.execute("UPDATE employer set eRating=%s, eSize=%s where eName=%s", (nRate, nSize, eName))
         mc.close()
         connection.commit()
         connection.close()
         return redirect(url_for('employerpage'))

    mc = connection.cursor()
    mc.execute("select * from employer where eName=%s;", (eName,))
    #placeholders to be used for update fields
    _, oRate, oSize = mc.fetchone()
    mc.close()
    connection.close()
    return render_template('uEmp.html', eName=eName, oR=oRate, oS=oSize)

#Bridge Page
@app.route('/empLoc', methods=['get'])
def empL():
    
    connection = mysql.connector.connect(**creds)
    mc = connection.cursor()

    #insert varibles
    eName = request.args.get('ename')
    cID = request.args.get('cID')
    #delete varible
    dcID = request.args.get('dcID')

    if eName is not None and cID is not None:
         mc.execute("insert into empLocation (eName, cityID) values (%s,%s)", (eName, cID,))
         connection.commit()
    elif request.args.get('delete') == 'true':
         mc.execute("delete from empLocation where eName = %s and cityID = %s", (eName, dcID,))
         connection.commit()

    #get empLocation(join)city table from project DB
    mc.execute("""select empLocation.eName, empLocation.cityID, city.cName, city.sName from empLocation 
               left join city on empLocation.cityID = city.cityID""")
    elInfo = mc.fetchall()

     #get eName in employer table from project DB
     #used for employer dropdown menu
    mc.execute("select eName from employer")
    eInfo = mc.fetchall()

     #get * in city table from project DB
     #used for city dropdown menu
    mc.execute("select * from city")
    lInfo = mc.fetchall()

    mc.close()
    connection.close()

    return render_template('empLoc.html', el=elInfo, ei=eInfo, li=lInfo)

#Many to Many City to Employer
#shows Employers in selected city's state
@app.route('/cityEmployer', methods=['get'])
def cityEmp():
     
     #create connector
    connection = mysql.connector.connect(**creds)
    mc = connection.cursor()

     #PK
    cid = request.args.get('id')
     #html name varibles
    sname = request.args.get('sname')

     #join city to empLoc(bridge) to employer tables
    if cid is not None:
         mc.execute("""select city.cName, city.sName, employer.eName, employer.eRating, employer.eSize from empLocation 
                    right join city on city.cityID = empLocation.cityID
                    right join employer on employer.eName = empLocation.eName
                    where city.sName = %s""", (sname,))
         mr = mc.fetchall()
    else:
         print('error')
         

    mc.close()
    connection.close()

    return render_template('cityEmployer.html', el=mr, id=cid, sname=sname)

#Many to Many Employer to City
#shows Cities that contain selected Employer
@app.route('/employerCity', methods=['get'])
def empCity():
     
     #create connection
    connection = mysql.connector.connect(**creds)
    mc = connection.cursor()

     #PK
    eName = request.args.get('eName')

     #join city to empLocation to employer table
    if eName is not None:
         mc.execute("""select employer.eName, city.cName, city.sName from empLocation 
                    right join city on city.cityID = empLocation.cityID
                    right join employer on employer.eName = empLocation.eName
                    where employer.eName = %s""", (eName,))
         mr = mc.fetchall()
    else:
         print('error')
         

    mc.close()
    connection.close()

    return render_template('employerCity.html', el=mr, eName=eName)


if __name__ == '__main__':
    app.run(port=8000, debug=True, host="0.0.0.0")

