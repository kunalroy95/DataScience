
import sqlite3, json
import urllib.request as urllib

conn = sqlite3.connect('HW9.db')
cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS Tweet")

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

cur.execute("DROP TABLE IF EXISTS User")

cur.execute( '''CREATE TABLE User
(
id VARCHAR2(50),
name VARCHAR2(50),
screen_name VARCHAR2(50),
description VARCHAR2(50),
friends_count NUMBER(50)
)''')


cur.execute("DROP TABLE IF EXISTS Geo")


cur.execute( ''' CREATE TABLE Geo
(
    G_ID VARCHAR(30) PRIMARY KEY UNIQUE, 
    type VARCHAR(50), 
    latitude VARCHAR(50),    
    longitude VARCHAR(50)  
    
)
''')



link = urllib.urlopen("https://dbgroup.cdm.depaul.edu/DSC450/Module7.txt")


tweets = link.readlines()

for i in tweets:


    try:
   
       tDict = json.loads(i.decode('utf8'))
       
       cur.execute("INSERT OR IGNORE INTO Tweet VALUES (?,?,?,?,?,?,?,?);", 
                       (tDict['user']['created_at'],
                        tDict['user']['id_str'],
                        tDict['text'], 
                        tDict['source'],
                        tDict['in_reply_to_user_id'], 
                        tDict['in_reply_to_screen_name'], 
                        tDict['in_reply_to_status_id'],
                        tDict['id_str']))               
       
       cur.execute("INSERT OR IGNORE INTO User VALUES (?,?,?,?,?);", 
                       (tDict['id_str'],
                        tDict['user']['name'], 
                        tDict['user']['screen_name'], 
                        tDict['user']['description'], 
                        tDict['user']['friends_count']))
                       
                      
       
      

    except ValueError:
    
        f = open("error.txt", "w")
        f.write(str(i))
    
  

    
conn.commit()



cur.execute('SELECT * FROM Tweet LIMIT 10;')

for row in cur:
    print(row)
    
cur.execute('SELECT * FROM User LIMIT 5;')

for row in cur:
    print(row)
    

import time
   
start1 = time.time()

cur.execute("SELECT * FROM Tweet WHERE id_str LIKE '%44%' OR id_str LIKE '%777%';").fetchall()

end1 = time.time()

print ("Time it Took:", round((end1-start1), 2), 'seconds')



start2 = time.time()

cur.execute("SELECT COUNT(DISTINCT in_reply_to_user_id) FROM Tweet;").fetchall()

end2 = time.time()

print ("Time it took is ", round((end2-start2), 2), 'seconds')



x = []

cur.execute("SELECT LENGTH(text) FROM Tweet LIMIT 40;")
for row in cur:
    x.append(row)


y = []

cur.execute("SELECT LENGTH(name) FROM User LIMIT 40;")
for row in cur:
    y.append(row)



from matplotlib import pyplot as plt

plt.scatter(x, y)
plt.xlabel('Length of Tweets')
plt.ylabel('Length of UserName')
plt.show()




start3 = time.time()

file = open("twitter_data.txt", 'r', encoding='utf8')

data = file.read()

id_list = []


for line in data:
    
    new_line = json.loads(line)
    
    if 'id_str' in new_line:
        
        id_list.append(new_line.get('id_str'))


for value in id_list:

    if "44" in value or "777" in value:
        print(value)
    
end3 = time.time()
print ("Time it took is ", round((end3 - start3), 2), 'seconds')





start4 = time.time()

file = open("twitter_data.txt", 'r', encoding='utf8')

data = file.read()

id_list = []

for line in data:
    
    new_line = json.loads(line)
    
    if 'in_reply_to_user_id' in new_line:
        
        id_list.append(new_line.get('in_reply_to_user_id'))

#prints number of unique id's
print(len(set(id_list)))
    
end4 = time.time()
print ("Time it took is ", round((end4 - start4), 2), 'seconds')






