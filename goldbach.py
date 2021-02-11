"""
Created on January 22nd, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/SbZYJ0dVsS8
    
"""

import math

def is_prime(x):
    
    """Takes in a number and returns whether the number is a prime or not """
    
    sq_x = int(math.sqrt(x))
    for i in range(2, sq_x + 1):
        if x%i == 0:
            return False
    return True
    

def prime_pair(prime_list, even_num):
    
    """Takes in a number and a list of primes to return 2 numbers that sum to that input parameter number """
    
    for i in range(0, len(prime_list)):
        for j in range(i, len(prime_list)):
            if prime_list[i] + prime_list[j] == even_num:
                return (prime_list[i], prime_list[j])
    return 0,0



def goldbach():
    
    """This function creates the list of primes and then prints even numbers and the 2 numbers that sum to that even number """
   
    prime_list = [2]
    for j in range(3,100):
         if(is_prime(j)):
             prime_list.append(j)
    
    for i in range(4,100,2):
            
        terms = prime_pair(prime_list, i)
        print(i, "=", terms[0], "+", terms[1])

goldbach()


