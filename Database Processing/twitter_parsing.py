
import sqlite3, json
import urllib.request as urllib

conn = sqlite3.connect('HW7.db')
cur = conn.cursor()

cur.execute('''CREATE TABLE Tweet
(
created_at VARCHAR2(50),
id_str VARCHAR2(50),
text VARCHAR2(50),
source VARCHAR2(50),
in_reply_to_user_id NUMBER(20),
in_reply_to_screen_name VARCHAR2(30),
in_reply_to_status_id NUMBER(20),
user_id VARCHAR2(50),
CONSTRAINT Tweet_FK FOREIGN KEY(user_id)
REFERENCES User(id)
)''')

cur.execute( '''CREATE TABLE User
(
id VARCHAR2(50),
name VARCHAR2(50),
screen_name VARCHAR2(50),
description VARCHAR2(50),
friends_count NUMBER(50)
)''')



link = urllib.urlopen("https://dbgroup.cdm.depaul.edu/DSC450/Module7.txt")


tweets = link.readlines()

for i in tweets:


    try:
   
       tDict = json.loads(i.decode('utf8'))

    except ValueError:
    
        f = open("error.txt", "w")
        f.write(str(i))
    
  
cur.execute('''INSERT INTO Tweet VALUES(?, ?, ?, ?, ?, ?, ?, ?)''',
(tDict['created_at'], tDict['id_str'],
tDict['text'], tDict['source'],
tDict['in_reply_to_user_id'], tDict['in_reply_to_screen_name'],
tDict['in_reply_to_status_id'],  tDict['user']['id']))
    
    
cur.execute('''INSERT INTO User VALUES(?, ?, ?, ?, ?)''',
(tDict['user']['id'], tDict['user']['name'],
tDict['user']['screen_name'], tDict['user']['description'],
tDict['user']['friends_count']))   
    
conn.commit()


cur.execute('SELECT * FROM Tweet LIMIT 10;')

for row in cur:
    print(row)
    
    

cur.execute('SELECT * FROM User LIMIT 10;')

for row in cur:
    print(row)



cur.execute('SELECT * FROM Tweet LIMIT 40;')

for row in cur:
    print(row)
    