"""
Created on February 4th, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/twI3nkOgoB4
    
"""

import random

class SixSidedDie():
    
    "a class for a six sided die"
    
    def __init__(self):
        "initializes the number of faces of the dice and the value of the face"
        self.faces = 6
        self.value = 0
    
    def roll(self):
        "rolls the dice by creating a random int from 1 to the number of faces"
        self.value = random.randint(1, self.faces)
        
    def getFaceValue(self):
        "returns the face value that the roll lands on"
        return self.value
    
    def __repr__(self):
        "returns a string with the face value inside"
        return f"SixSidedDie({self.value})"
    
class TenSidedDie(SixSidedDie):
    
    "a class for a ten sided die"
    
    def __init__(self):
        "initializes the number of faces of the dice and the value of the face"
        self.faces = 10
        self.value = 0
     
    def __repr__(self):
        "returns a string with the face value inside"
        return f"TenSidedDie({self.value})"

class TwentySidedDie(SixSidedDie):
    
    "a class for a twenty sided die"
    
    def __init__(self):
        "initializes the number of faces of the dice and the value of the face"
        self.faces = 20
        self.value = 0
    
    def __repr__(self):
        "returns a string with the face value inside"
        return f"TwentySidedDie({self.value})"

class Cup():
    
    "a class Cup that holds 3 different types of die"
    
    def __init__(self, a, b, c):
        "creating lists of die of each type"
        self.num_six = [SixSidedDie() for i in range(0,a)]
        self.num_ten = [TenSidedDie() for i in range(0,b)]
        self.num_twenty = [TwentySidedDie() for i in range(0,c)]
    
    def roll(self):
        "roll each die and append the face value to a list "
        #create an empty list to store face numbers of the dice
        self.faces = []
        #for every dice in the cup, roll it and append the face value to the empty list
        for i in self.num_six:
            i.roll()
            self.faces.append(i.getFaceValue())
        
        for i in self.num_ten:
            i.roll()
            self.faces.append(i.getFaceValue())
        
        for i in self.num_twenty:
            i.roll()
            self.faces.append(i.getFaceValue())
            
    def getSum(self):
        "gets the sum of all the face values of each rolled die in the cup"
        return sum(self.faces)
    
    def __repr__(self):
        "returns multiple strings with all the dice in the cup and their face values"
        die = ""
        for i in self.num_six:
            die += f"{i}, "
        for i in self.num_ten:
            die += f"{i}, "
        for i in self.num_twenty:
            die += f"{i}, "
        die = die[0:-2]
        return f"Cup({die})" 
 

#Testing code       
d = SixSidedDie()
d.roll()
d.getFaceValue()
d

cup = Cup(1,2,1)
cup.roll()
cup.getSum()
cup
     
               
        
    