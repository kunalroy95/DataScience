import sqlite3

 
con = sqlite3.connect("weather.db")

 
cursor = con.cursor()

 
student_table = ('''CREATE TABLE Student(
   StudentID INT PRIMARY KEY NOT NULL,
   Name VARCHAR(30),
   Address VARCHAR(50),
   GradYear INT
)''')

 
student_inserts = ["INSERT INTO Student VALUES ( 1, 'Joe', 'Address 1', '2018' );", "INSERT INTO Student VALUES ( 2, 'Kunal', 'Address 2', '2019' );", "INSERT INTO Student VALUES ( 3, 'Bob', 'Address 3', '2019' );", "INSERT INTO Student VALUES ( 4, 'Gabe', 'Address 4', '2020' );"]
           
cursor.execute(student_table)   
for ins in student_inserts:
    cursor.execute(ins)
    
    
grade_table = ('''
CREATE TABLE Grade(
    CName VARCHAR(50),
    StudentID INT,
    CGrade VARCHAR(5),
    PRIMARY KEY(CName, StudentID)
)''')


grade_inserts = ["INSERT INTO Grade VALUES ('Geo 1', 1 , 'A' );", "INSERT INTO Grade VALUES ('Hist 1', 2 , 'B' );", "INSERT INTO Grade VALUES ('Math 1', 3 , 'C' );", "INSERT INTO Grade VALUES ('CS 1', 4 , 'A' );"]


cursor.execute(grade_table)   
for ins in grade_inserts:
    cursor.execute(ins)



course_table = ('''
CREATE TABLE Course(
   CName VARCHAR(40) PRIMARY KEY NOT NULL,
   Department VARCHAR(40),
   Credits INT
)''')


course_inserts =["INSERT INTO Course VALUES ('Geo 1', 'Geography', 4);", "INSERT INTO Course VALUES ('Hist 1', 'History', 4);", "INSERT INTO Course VALUES ('Math 1', 'Mathematics', 4);", "INSERT INTO Course VALUES ('CS 1', 'Computer Science', 4);"]   
        

cursor.execute(course_table)   
for ins in course_inserts:
    cursor.execute(ins)



con.commit()


cursor.execute('SELECT * FROM Student LIMIT 5;')

for row in cursor:
    print(row)


cursor.execute('SELECT * FROM Grade LIMIT 5;')
 
for row in cursor:
    print(row)
    

cursor.execute('SELECT * FROM Course LIMIT 5;')

for row in cursor:
    print(row)


cursor.execute('''

               CREATE VIEW all_view AS 
SELECT Student.*, Course.*, Grade.*
FROM Student 
JOIN Grade ON Student.StudentID = Grade.StudentID
JOIN Course ON Course.CName = Grade.CName
;''')

con.commit()

 
cursor.execute('SELECT * FROM all_view;')

for row in cursor:
    print(row)      
        
  
data = cursor.execute('SELECT * FROM all_view;')

f = open("midterm_data.txt", "w")

for row in data:
    
    f.write('%d, %s, %s, %d, %s, %s, %d, %s, %d, %s\n' % (row[0], row[1], row[2], row[3], row[4], 
                                                          row[5], row[6], row[7], row[8], row[9]))

con.commit()




f = open("midterm_data.txt", "r")

data = f.readlines()


term1 = "Geo 1"
term2 = "4"
term3 = "Hist 1"
term4 = "4"
term5 = "Math 1"
term6 = "4"
term7 = "CS 1"
term8 = "4"

for row in data:
    
    r = row.strip()
    
    r1 = r.split(',')[4]
    r2 = r.split(',')[6]
    
    
    if term1 in r1 and term2 in r2:
        
        print("functional dependacy does not exist")
        
    elif term3 in r1 and term4 in r2:
        
        print("functional dependacy does not exist")
            
    elif term5 in r1 and term6 in r2:
        
        print("functional dependacy does not exist")
                
    elif term7 in r1 and term8 in r2:
    
        print("functional dependacy does not exist")
    
    else:
        
        print("functional dependacy does exist")
    



 
cursor.execute('SELECT Department, AVG(GradYear) FROM all_view GROUP BY Department;')

for row in cursor:
    print(row)      
        


from statistics import mean

f = open("midterm_data.txt", "r")

data = f.readlines()


term1 = "Geography"
term2 = "History"
term3 = "Mathematics"
term4 = "Computer Science"

grad_year_geo = []
grad_year_hist = []
grad_year_math = []
grad_year_cs = []

for row in data:
    
    r = row.strip()
    
    r1 = r.split(',')[3] #grad year
    r2 = r.split(',')[5] #dept   
    
    
    if term1 in r2:
        grad_year_geo.append(r1)
    
    elif term2 in r2:
        grad_year_hist.append(r1)
        
    elif term3 in r2:
        grad_year_math.append(r1)
    
    elif term4 in r2:
        grad_year_cs.append(r1)
 

grad_year_geo = [int(i) for i in grad_year_geo]
grad_year_hist = [int(i) for i in grad_year_hist]
grad_year_math = [int(i) for i in grad_year_math]
grad_year_cs = [int(i) for i in grad_year_cs]


print("Avg Graduation Year by Dept:")
print()
print("Geography:", mean(grad_year_geo))
print("History:", mean(grad_year_hist))
print("Mathematics:", mean(grad_year_math))
print("Computer Science:", mean(grad_year_cs))
    