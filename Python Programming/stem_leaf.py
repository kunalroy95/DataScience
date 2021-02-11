"""
Created on January 17th, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/Qh9tq8qxkok

"""

import os.path
from os import path
import sys


def greetings():
    
    """prints a greeting message and how the program works"""
    
    print("Hello, welcome to the program!")
    print("This program takes in a data file of your choice and outputs its stem and leaf diagram")
    

def fileInput():
    
    """Asks the user for an inout number and returns that input number"""
    
    file_num = int(input("What file would you like to plot? (1,2 or 3) or enter 0 to exit: "))
    return file_num
    

def inputFile(file_num):
    
    """Takes in the file number entered by the user and returns a file name"""
    
    if file_num == 1:
        filename = "StemAndLeaf1.txt"
    elif file_num == 2:
        filename = "StemAndLeaf2.txt"
    elif file_num == 3:
        filename = "StemAndLeaf3.txt"
    elif file_num == 0:
        print("Exiting Program")
        sys.exit()
    return filename

D = {} #Dictionary data structure to hold the stem and leaves

def read_file(filename, D):
    
    """Takes in the file name and empty dictionary and populates the dictionary with the stems and leaves"""
    
    print("Reading file", filename)
    if not path.exists(filename):
        print("Error: file not found")
    f = open(filename, "r")
    text = f.read().split() 
    f.close()
    D.clear()
    for num in text:
        stem = int(num[:-1])
        leaf = int(num[-1])
        if stem in D:
             D[stem].append(leaf)
        else:
             D[stem] = [leaf]


def display_plot(D):
    
    """Takes in the populated dictionary, sorts the leaves and displays the plot with a pipe and spaces"""
    
    print("Stem and leaf plot\n")
    if len(D) == 0:
        print("nothing to dispay")
        return
    for a,b in D.items():
        leafs = "|"
        for x in sorted(b):
            leafs = leafs + " " + str(x)
        print(a, leafs)
    print()
    

def main():
    greetings() 
    while(True):
        file_num = fileInput()
        filename = inputFile(file_num)
        read_file(filename, D)
        i = input("Enter 1 for displaying a stem and leaf plot or 2 to exit: ")
        if i == "1":
            display_plot(D)
        else:
            print("Exiting")
            break
        
if __name__ == "__main__":
    main()
    
    
    
    
    
    
    
    
    
