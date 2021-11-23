

#Q1 a)

from urllib.request import urlopen

data = urlopen("http://dbgroup.cdm.depaul.edu/DSC450/OneDayOfTweets.txt")


import time

start1 = time.time()


for i in range(6000):
     
    str_response = data.readline().decode("utf8")   
    
       
    with open("final_data1.txt", "a", encoding="utf-8") as out_txt_file:
        out_txt_file.write(str_response)
    
    
end1 = time.time()

print ("Time it took is ", round((end1 - start1), 2), 'seconds')


## c)

import sqlite3
import json


tweet_table = ''' CREATE TABLE Tweet
(
    user_id NUMBER ,   
    created_at VARCHAR(40),
    id_str VARCHAR(40) PRIMARY KEY UNIQUE,
    text VARCHAR(150),
    source VARCHAR(70),
    in_reply_to_user_id VARCHAR(26),
    in_reply_to_screen_name VARCHAR(26),
    in_reply_to_status_id VARCHAR(26),
    retweet_count VARCHAR(26),
    contributors VARCHAR(45)
)
'''

conn = sqlite3.connect("final.db")

cur = conn.cursor()


cur.execute("DROP TABLE IF EXISTS Tweet")

cur.execute(tweet_table)


tweet_user = ''' CREATE TABLE TweetUser
(
    id VARCHAR(45) PRIMARY KEY UNIQUE, 
    name VARCHAR(45), 
    screen_name VARCHAR(45), 
    description VARCHAR(210), 
    friends_count NUMBER, 
    
    CONSTRAINT tweet_user_fk
    FOREIGN KEY (id)
      REFERENCES tweet(id_str)
)
'''


cur.execute("DROP TABLE IF EXISTS TweetUser")

cur.execute(tweet_user)


geo_table = ''' CREATE TABLE Geo
(
    gID VARCHAR(45) PRIMARY KEY UNIQUE, 
    type VARCHAR(50), 
    latitude VARCHAR(50),    
    longitude VARCHAR(50),  
    
    CONSTRAINT geo_fk
    FOREIGN KEY (gID)
      REFERENCES tweet(id_str)
)
'''

cur.execute("DROP TABLE IF EXISTS Geo")

cur.execute(geo_table)



import time

start2 = time.time()



for i in range(6000):  
    
    response = data.readline().decode()

     
    try:
        tDict = json.loads(response)
        
        cur.execute("INSERT OR IGNORE INTO Tweet VALUES (?,?,?,?,?,?,?,?,?,?);", 
                       (tDict['user']['id_str'],
                        tDict['user']['created_at'],                        
                        tDict['id_str'], 
                        tDict['text'], 
                        tDict['source'],
                        tDict['in_reply_to_user_id'], 
                        tDict['in_reply_to_screen_name'], 
                        tDict['in_reply_to_status_id'], 
                        tDict['retweeted_status']['retweet_count'], 
                        tDict['contributors']))               
        
        cur.execute("INSERT OR IGNORE INTO TweetUser VALUES (?,?,?,?,?);", 
                       (tDict['id_str'],   
                        tDict['user']['name'], 
                        tDict['user']['screen_name'], 
                        tDict['user']['description'], 
                        tDict['user']['friends_count']))
        
        cur.execute("INSERT OR IGNORE INTO Geo VALUES (?,?,?,?);", 
                        (tDict['id_str'], 
                        tDict['geo']['type'], 
                        tDict['geo']['coordinates'][0], 
                        tDict['geo']['coordinates'][1])) 



    except(ValueError, KeyError, UnicodeEncodeError, TypeError): 
        cur.execute("INSERT OR IGNORE INTO Tweet VALUES (?,?,?,?,?,?,?,?,?,?);", 
                       (tDict['user']['id_str'],
                        tDict['user']['created_at'],                        
                        tDict['id_str'], 
                        tDict['text'], 
                        tDict['source'],
                        tDict['in_reply_to_user_id'], 
                        tDict['in_reply_to_screen_name'], 
                        tDict['in_reply_to_status_id'], 
                        tDict['retweet_count'], 
                        tDict['contributors']))  




conn.commit()

end2 = time.time()
print ("Time it took is ", round((end2-start2), 2), 'seconds')




cur.execute('SELECT COUNT(*) FROM Tweet;')

for row in cur:
    print(row)

cur.execute('SELECT COUNT(*) FROM TweetUser;')

for row in cur:
    print(row)
    

cur.execute('SELECT COUNT(*) FROM Geo;')

for row in cur:
    print(row)



### b)

cur.execute('SELECT MAX(LENGTH(text)) FROM tweet;')

for row in cur:
    print(row)


cur.execute('SELECT MAX(LENGTH(in_reply_to_user_id)) FROM tweet;')

for row in cur:
    print(row)

cur.execute('SELECT MAX(LENGTH(in_reply_to_screen_name)) FROM tweet;')

for row in cur:
    print(row)


cur.execute('SELECT MAX(LENGTH(screen_name)) FROM tweetuser;')

for row in cur:
    print(row)


### d)
    
    
file = open('final_data1.txt', 'r', encoding='utf8')

lines = file.readlines()


start3 = time.time() 

for line in lines:
    
    obj = json.loads(line)
    
    if 'retweeted_status' in obj.keys():
        retweet_count = obj['retweeted_status']['retweet_count']
    else:
        retweet_count = obj['retweet_count']
    
    tweet_values = (obj['user']['id_str'], obj['created_at'], obj['id_str'], obj['text'], obj['source'],obj['in_reply_to_user_id'], obj['in_reply_to_screen_name'], obj['in_reply_to_status_id'], retweet_count, obj['contributors']) 
    
    
    cur.execute("INSERT OR REPLACE INTO Tweet VALUES(?,?,?,?,?,?,?,?,?,?);",tweet_values)
    
    tweet_user_inserts = (obj['id_str'],obj['user']['name'], obj['user']['screen_name'], obj['user']['description'], obj['user']['friends_count'])
    
    
    cur.execute("INSERT OR IGNORE INTO TweetUser VALUES (?,?,?,?,?);", tweet_user_inserts)
    

    if obj['geo'] != None:
        
        geo_type = obj['geo']['type']
        lat = obj['geo']['coordinates'][0]
        long = obj['geo']['coordinates'][1]
        
        geo_inserts = (obj['id_str'], geo_type, lat, long)
        
        cur.execute("INSERT OR IGNORE INTO Geo VALUES (?,?,?,?);", geo_inserts)
 

end3 = time.time() 

print ("Time it took is ", round((end3-start3), 2), 'seconds')


## f)

from matplotlib import pyplot as plt

x = [1000, 1000, 1000, 6000, 6000, 6000]
y = [1.46, 6.99, 0.23, 27.75, 32.33,1.16 ]

plt.scatter(x, y)
plt.xlabel('Number of Tweets')
plt.ylabel('Run Time')
plt.show()


#Q2 a)


cur.execute('SELECT user_id, MIN(longitude), MIN(latitude) FROM tweet, tweetgeo WHERE tweet.user_id = tweetgeo.gID;')

for row in cur:
    print(row)




#--- b)

start4 = time.time() 

for i in range(10):

    cur.execute('SELECT user_id, MIN(longitude), MIN(latitude) FROM Tweet, Geo WHERE Tweet.user_id = Geo.gID;').fetchall()

end4 = time.time() 

print ("Time it took is ", round((end4-start4), 2), 'seconds')




start5 = time.time() 

for i in range(100):

    cur.execute('SELECT user_id, MIN(longitude), MIN(latitude) FROM Tweet, Geo WHERE Tweet.user_id = Geo.gID;').fetchall()

end5 = time.time() 

print ("Time it took is ", round((end5-start5), 2), 'seconds')


## c)


file = open("final_data1.txt", 'r', encoding='utf8')

start6 = time.time()

lat_list = []

lon_list = []

user_list = []



for i in range(10):



    for line in file:
    
        new_line = json.loads(line)
    
    
        user_list.append(new_line.get('id'))
        
    
        lat_list.append(new_line.get('coordinates'))
        
    
        lon_list.append(new_line.get('coordinates'))


end6 = time.time()
print ("Time it took is ", round((end6 - start6), 2), 'seconds')


#print out data frame of result to view

lat_list = lat_list[0:10]
lon_list = lon_list[0:10]
user_list = user_list[0:10]


import pandas as pd

results_df = pd.DataFrame(
    {'user_id': user_list,
     'latitude': lat_list,
     'longitude': lon_list
    })

results_df


file = open("final_data1.txt", 'r', encoding='utf8')

start7 = time.time()


lat_list = []

lon_list = []

user_list = []


for i in range(100):



    for line in file:
    
        new_line = json.loads(line)
    
    
        user_list.append(new_line.get('id'))
        
    
        lat_list.append(new_line.get('coordinates'))
        
    
        lon_list.append(new_line.get('coordinates'))



end7 = time.time()
print ("Time it took is ", round((end7 - start7), 2), 'seconds')


### e) f)


import re

start8 = time.time()


for i in range(10):

    with open('final_data1.txt', 'r') as myfile:
    
         data = myfile.read()


    regex1 = re.compile('id_str":"([^"]*)"')

    user_id = regex1.findall(data)

    regex2 = re.compile('coordinates":"([^"]*)"')

    lat1 = regex2.findall(data)

    regex3 = re.compile('coordinates":"([^"]*)"')

    long1 = regex3.findall(data)


end8 = time.time()
print ("Time it took is ", round((end8 - start8), 2), 'seconds')

#to display resultant df

user_id = user_id[0:10]
lat1 = lat1[0:10]
long1 = long1[0:10]


import pandas as pd

results_df1 = pd.DataFrame(
    {'user_id': user_id,
     'latitude': lat1,
     'longitude': long1
    })

results_df1



start9 = time.time()


for i in range(100):

    with open('final_data1.txt', 'r') as myfile:
    
         data = myfile.read()


    regex1 = re.compile('id_str":"([^"]*)"')

    user_id = regex1.findall(data)

    regex2 = re.compile('coordinates":"([^"]*)"')

    lat1 = regex2.findall(data)

    regex3 = re.compile('coordinates":"([^"]*)"')

    long1 = regex3.findall(data)


end9 = time.time()
print ("Time it took is ", round((end9 - start9), 2), 'seconds')



#3 a)


cur.execute('''
               
               CREATE TABLE joined_table AS
               SELECT * 
               FROM Tweet 
               JOIN TweetUser ON Tweet.id_str = TweetUser.id
               Join GEO ON TweetUser.id = Geo.gID;
               
               
               ''')


cur.execute('SELECT * FROM joined_table LIMIT 5;')

for row in cur:
    print(row)




# b)

f = open('joined_tables3.json', 'w')

rows = cur.execute('SELECT * FROM joined_table;').fetchall()

for i in rows:

    obj = json.dumps(i)

    f.write(obj)
    
    f.write('\n')
    


# c)

import pandas as pd

df = pd.read_sql('SELECT * FROM joined_table;', conn)
df.to_csv('joined_tables.csv')







