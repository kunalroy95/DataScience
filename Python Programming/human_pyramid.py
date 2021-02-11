"""
January 30th, 2021

author: Kunal Roy

I have not given or received any
unauthorized assistance on this assignment

Youtube Video Link: https://youtu.be/IKFMZrudce0
    
"""

def humanPyramid(r,c):
    
    """Takes in row and column indicies of humans and returns the weight on the back of that human """ 
    
    #Base case: spits out the answer without having to do any work or make recursive calls
    if r == 0 and c == 0:
        return 0
    
    if c == 0:
        weight = (humanPyramid(r - 1, 0) + 128) / 2 #this covers the left side of the pyramid
    elif c == r:
        weight = (humanPyramid(r - 1, c - 1) + 128) / 2 #this covers the right side of the pyramid
    
    else:
        left_weight = (humanPyramid(r - 1, c - 1) + 128) / 2
        right_weight = (humanPyramid(r - 1, c) + 128) / 2
        weight = left_weight + right_weight
    return weight


#Driver code
humanPyramid(0,0)
# Weight = 0

humanPyramid(1,1)
# Weight = 64.0

humanPyramid(2,0)
# Weight = 96.0

humanPyramid(2,1)
# Weight = 192.0

#Everyone on the bottom row does not carry the same weight. The guys in the middle
#of the bottom row will cary more weight than the ones on the side. 


