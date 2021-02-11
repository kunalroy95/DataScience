"""
Created on January 22nd, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/5rK-ObdlX-g
    
"""

def is_happy(x):

    """Takes in a number and returns the sum of the square of the digits once the loop ends """    
    
    digit = sum = 0    
    while(x > 0):    
        digit = x % 10 
        sum = sum + (digit * digit)    
        x = x // 10   
    return sum


def is_prime(n):
    
    """Takes in a number and returns whether that number is a prime or not"""
    
    if n == 2:
        return True
    if n % 2 == 0 or n <= 1:
        return False
    else:
        return True

#This while loop endlessly loops accepting an int from the user and prints
#whether the given number is a happy prime, sad prime, happy non-prime or sad non-prime
while(True):
    num = int(input("Enter any positive interger:"))
    result = num
    while(result != 1 and result != 4):    
        result = is_happy(result)  
    
    if (result == 1 and is_prime(num) == True):
        print(num, "is a happy prime")
    elif (result == 1 and is_prime(num) == False):
        print(num, "is a happy non-prime")
    elif (result == 4 and is_prime(num) == True):
        print(num, "is a sad prime")
    elif (result == 4 and is_prime(num) == False):
        print(num, "is a sad non-prime")
        
