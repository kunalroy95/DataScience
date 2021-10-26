"""
Created on February 12th, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/kqTgtUvHvew
    
"""

def is_palindrome(date):
    
    "Takes in a date and returns whether it is palindrome or not"
    
    #if backwards date = normal date
    return date[::-1] == date
      
#list of days in each month of the year
months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

#create file to be written to
file = open('written_file4.txt', 'w')

#for every year in the 21st century
for year in range(2000,2100):
    #for all 12 months
    for month in range(1,13):
        #for all days in every month
        for day in range(1, months[month - 1] + 1):
            
            #genereate date
            date = f'{day:02}{month:02}{year}'
            
            if is_palindrome(date) == True:
                file.write(f'{day:02}/{month:02}/{year}\n')

file.close()



