"""
Created on February 4th, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link:
    
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
 

def game():
    
    "this function simulates the game"
    
    print("Hi, welcome to my casino game!")
    x = input("Please enter your name:")
    balance = 100
    print(x,"welcome to the game, your balance is 100")
    y = input("Would you like to play a game?(y/n):")
    
    while y == "y":
        goal = random.randint(1, 100)
        print("Your goal is", goal)
        z = float(input("How much would you like to bet?:"))
        while z <= 0:
            print("You must bet a positive value")
            z = float(input("How much would you like to bet?:"))
        
        #subtract the bet from balance and update balance variable
        balance -= z
        six_sided = int(input("How many six sided die would you like to roll?:"))
        ten_sided = int(input("How many ten sided die would you like to roll?:"))
        twenty_sided = int(input("How many twenty sided die would you like to roll?:"))
        cup = Cup(six_sided, ten_sided, twenty_sided)
        cup.roll()
        roll = cup.getSum()
        print("Roll:", roll, "Goal:", goal)
        
        #if cup roll is equal to the goal, accumulate 10 times the bet to the balance
        if(cup.roll == goal):
            balance += z*10
            print("You won $", z*10)
        elif((roll < goal) and (goal - roll) <= 3):
            balance += z*5
            print("You won $", z*5)
        elif((roll < goal) and (goal - roll) <= 10):
            balance += z*2
            print("You won $", z*2)
        else:
            print("You lost $", z)
        print(x, "your updated balance is $", balance)
        y = input("Would you like to play the game again?(y/n):")
    print("Thanks for playing, we hope to see you again!")

game()

            
        
            
        
        
        
    
    

