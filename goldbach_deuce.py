"""
January 30th, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/QqJPr_2SZMM
    
"""

import numpy

length = int(input("Enter the length of list:"))

num = int(input("Enter the number you would like the two numbers to sum to:"))

ran_list = numpy.random.randint(0, 100, length)

#Convert numpy array to list
list1 = ran_list.tolist()

list1.sort()

#Time complexity of binary search function below is O(logn)
def sum_pair(list1,length,num):
    
    """Takes in a sorted list, length of list, number and returns 2 numbers that sum to that number """ 
    
    l = 0
    h = length-1
    while l < h:
        mid = max(int((h - l)/2), 1)
        if (list1[l] + list1[h] == num):
            return True, (list1[l], list1[h])
        elif (list1[l] + list1[h] < num): 
            l += mid
        else: 
            h -= mid
    return False

sum_pair(list1,length,num)

#Time Complexity of entire program is O(logn) excluding the sorting






