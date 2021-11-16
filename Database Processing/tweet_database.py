
import json
import sqlite3


conn = sqlite3.connect('tweetdata.db')

cur = conn.cursor()

cur.execute('''CREATE TABLE TWEET
(
    created_at DATETIME,
    id_str TEXT,
    text TEXT,
    source TEXT,
    in_reply_to_user_id INT,
    in_reply_to_screen_name TEXT,
    in_reply_to_status_id INT
)''')


f = open("Module5.txt", 'r', encoding='utf-8')

data = f.readline()  

tweet_data = data.split("EndOfTweet")


final_data = []

for i in tweet_data:
    
    json_object = json.loads(i, encoding='utf-8')
    
    final_data.append((json_object["created_at"], json_object["id_str"], json_object["text"],
                 json_object["source"], json_object["in_reply_to_user_id"],
                 json_object["in_reply_to_screen_name"], json_object["in_reply_to_status_id"]))


cur.executemany('INSERT INTO TWEET (created_at, id_str, text, source, in_reply_to_user_id, in_reply_to_screen_name, in_reply_to_status_id) VALUES (?,?,?,?,?,?,?)', final_data)

conn.commit()


cur.execute('SELECT * FROM TWEET LIMIT 10;')

for row in cur:
    print(row)
    


