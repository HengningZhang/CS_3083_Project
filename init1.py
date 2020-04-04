#Import Flask Library
from flask import Flask, render_template, request, session, url_for, redirect
import pymysql.cursors
import datetime

#Initialize the app from Flask
app = Flask(__name__)

#Configure MySQL
conn = pymysql.connect(host='localhost',
                       port = 8889,
                       user='root',
                       password='root',
                       db='finstagram1',
                       charset='utf8mb4',
                       cursorclass=pymysql.cursors.DictCursor)

#Define a route to hello function
@app.route('/')
def hello():
    return render_template('index.html')

#Define route for login
@app.route('/login')
def login():
    return render_template('login.html')

#Define route for register
@app.route('/register')
def register():
    return render_template('register.html')

#Authenticates the login
@app.route('/loginAuth', methods=['GET', 'POST'])
def loginAuth():
    #grabs information from the forms
    username = request.form['username']
    password = request.form['password']

    #cursor used to send queries
    cursor = conn.cursor()
    #executes query
    query = 'SELECT * FROM person WHERE username = %s and password = %s'
    cursor.execute(query, (username, password))
    #stores the results in a variable
    data = cursor.fetchone()
    #use fetchall() if you are expecting more than 1 data row
    cursor.close()
    error = None
    if(data):
        #creates a session for the the user
        #session is a built in
        session['username'] = username
        return redirect(url_for('home'))
    else:
        #returns an error message to the html page
        error = 'Invalid login or username'
        return render_template('login.html', error=error)

#Authenticates the register
@app.route('/registerAuth', methods=['GET', 'POST'])
def registerAuth():
    #grabs information from the forms
    username = request.form['username']
    password = request.form['password']
    fname= request.form['firstName']
    lname= request.form['lastName']
    email= request.form['email']
    #cursor used to send queries
    cursor = conn.cursor()
    #executes query
    query = 'SELECT * FROM person WHERE username = %s'
    cursor.execute(query, (username))
    #stores the results in a variable
    data = cursor.fetchone()
    #use fetchall() if you are expecting more than 1 data row
    error = None
    if(data):
        #If the previous query returns data, then user exists
        error = "This user already exists"
        return render_template('register.html', error = error)
    else:
        ins = 'INSERT INTO person(username,password,firstName,lastName,email) VALUES(%s,%s,%s,%s,%s)'
        cursor.execute(ins, (username, password,fname,lname,email))
        conn.commit()
        cursor.close()
        return render_template('index.html')


@app.route('/home')
def home():
    username = session['username']
    cursor = conn.cursor()
    query = 'SELECT postingDate,pID,caption FROM photo WHERE poster = %s ORDER BY postingDate DESC'
    cursor.execute(query, (username))
    data = cursor.fetchall()
    cursor.close()
    return render_template('home.html', username=username ,posts=data)

        
@app.route('/post', methods=['GET', 'POST'])
def post():
    username = session['username']
    cursor = conn.cursor()
    path = request.form['path']
    caption= request.form['caption']
    allfollowers=request.form['privacy']
    query="SELECT MAX(pID) FROM PHOTO"
    cursor.execute(query)
    pid=int(cursor.fetchone()['MAX(pID)'])+1
    query = 'INSERT INTO photo (pId, postingDate, filePath, allFollowers, caption, poster) VALUES(%s, %s, %s, %s, %s, %s)'
    now=datetime.datetime.now()
    now.strftime("%D,%H:%M:%S")
    cursor.execute(query, (pid, now, path, allfollowers, caption, username))
    conn.commit()
    cursor.close()
    return redirect(url_for('home'))

@app.route('/discover')
def discover():
    #check that user is logged in
    try:
        username = session['username']
    except:
        return render_template('index.html')
    #should throw exception if username not found
    

    cursor = conn.cursor()
    query="DROP VIEW IF EXISTS relation"
    cursor.execute(query)
    query="Create View Relation AS(Select followee as username From Person Natural JOIN Follow where username=%s and follower=%s)"
    cursor.execute(query,(username,username))

    query = 'SELECT DISTINCT person.username FROM person LEFT JOIN relation ON (person.username=relation.username) WHERE relation.username is NULL AND person.username<>%s'
    cursor.execute(query,(username))
    data = cursor.fetchall()
    cursor.close()
    return render_template('discover.html', user_list=data)


@app.route('/follow')
def follow():
    try:
        username = session['username']
    except:
        return render_template('index.html')
    toFollow = request.args['toFollow']
    cursor = conn.cursor()
    query = 'INSERT INTO FOLLOW(follower,followee,followStatus) VALUES(%s,%s,0)'
    cursor.execute(query, (username,toFollow))
    cursor.close()
    return redirect(url_for('discover'))
@app.route("/viewable_photos",methods=["GET"])
def viewable_photos():
    try:
        username = session['username']
    except:
        return render_template('index.html')
    cursor=conn.cursor()
    query="DROP VIEW IF EXISTS following"
    cursor.execute(query)
    query="Create View following AS(Select followee as username From Person Natural JOIN Follow where username=%s and follower=%s and followStatus=1)"
    cursor.execute(query,(username,username))
    query="DROP VIEW IF EXISTS myGroup"
    cursor.execute(query)
    query="Create ViEW myGroup AS(select groupName,groupCreator FROM person NATURAL JOIN belongTo where username=%s)"
    cursor.execute(query,(username))
    query="SELECT pID,postingDate,filePath,caption,poster FROM following JOIN photo ON following.username=photo.poster UNION SELECT pID,postingDate,filePath,caption,poster FROM myGroup NATURAL JOIN sharedWith NATURAL JOIN photo"
    cursor.execute(query)
    data = cursor.fetchall()
    cursor.close()
    return render_template("browse.html",photo_list=data)
@app.route("/manageFollow",methods=["GET","POST"])
def manageFollow():
    try:
        username = session['username']
    except:
        return render_template('index.html')
    cursor=conn.cursor()
    query="SELECT follower from follow where followee=%s and followStatus=0"
    cursor.execute(query,(username))
    data=cursor.fetchall()
    cursor.close()
    return render_template("manageFollower.html",requests=data)

@app.route("/acceptFollow")
def acceptFollow():
    try:
        username = session['username']
    except:
        return render_template('index.html')
    toAccept = request.args['requests']
    cursor=conn.cursor()
    query="UPDATE FOLLOW SET followStatus=1 where followee=%s and follower=%s"
    cursor.execute(query,(username,toAccept))
    cursor.close()
    return redirect(url_for('manageFollow'))

@app.route("/rejectFollow")
def rejectFollow():
    try:
        username = session['username']
    except:
        return render_template('index.html')
    toAccept = request.args['requests']
    cursor=conn.cursor()
    query="DELETE FROM FOLLOW where followee=%s and follower=%s"
    cursor.execute(query,(username,toAccept))
    cursor.close()
    return redirect(url_for('manageFollow'))
    
@app.route('/logout')
def logout():
    session.pop('username')
    return redirect('/')
        
app.secret_key = 'some key that you will never guess'
#Run the app on localhost port 5000
#debug = True -> you don't have to restart flask
#for changes to go through, TURN OFF FOR PRODUCTION
if __name__ == "__main__":
    app.run('127.0.0.1', 5000, debug = True)
