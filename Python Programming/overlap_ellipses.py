

import math
import random


class Point():
    
     "create a point on the plane"

     def __init__(self, x, y):
        
        "initialize x and y coordinates of point"
        
        self.X = x
        self.Y = y
        
    
     def distance(self, point2):
         
        "calculate distance between two points"
        
        x_difference = point2.X - self.X
        y_difference = point2.Y - self.Y
        return math.sqrt(x_difference**2 + y_difference**2)
    
     def get_x(self):
         
        "get x coordinate of point"
        
        return self.X

     def get_y(self):
        
        "get y coordinate of point"
         
        return self.Y
    
    
     def __str__(self):
         
        "print the point" 
        
        return "Point(%s,%s)"%(self.X, self.Y)
    
    
class Ellipse():
    
    "create an ellipse with 2 points and width"
    
    def __init__(self, x1, y1, x2, y2, width):
        
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.width = width
        self.p1 = Point(self.x1, self.y1)
        self.p2 = Point(self.x2, self.y2)
        
    def get_p1(self):
        
        "get the first point"
        
        return(self.x1, self.y1)
    
    def get_p2(self):
        
        "get the second point"
        
        return(self.x2, self.y2)
        
    def get_width(self):
        
        "get the width of ellipse"
        
        return self.width
    
    def is_inside(self, a):
        
        "determines whether point is within some area"
        
        if self.p1.distance(a) + self.p2.distance(a) < self.width:
            return True
    
    
    def __str__(self):
        
        "print the ellipse"
        
        return "Elipse(%s,%s,%s)"%(self.p1, self.p2, self.width)



def ellipse_1(point_x1, point_y1, point_x2, point_y2, width):
    
    "initialize the first ellipse"
    
    ellipse1 = Ellipse(point_x1, point_y1, point_x2, point_y2, width)
    
    return ellipse1


def ellipse_2(point_x1, point_y1, point_x2, point_y2, width):
    
    "initialize the second ellipse"
    
    ellipse2 = Ellipse(point_x1, point_y1, point_x2, point_y2, width)
    
    return ellipse2

def size(ellipse1, ellipse2):
    
    "calculate the size of the biggest ellipse"
    
    ellipse1_width = ellipse1.get_width()
    
    ellipse2_width = ellipse2.get_width()
    
    if ellipse1_width  > ellipse2_width:
        size = ellipse1_width
    else:
        size = ellipse2_width
        
    return size



def point_test(p, ellipse_1, ellipse_2):
    
    "check if the point is inside the intersection"
    
    if ellipse_1.is_inside(p) == True and ellipse_2.is_inside(p) == True:
        return True
        

def box(size, ellipse_1, ellipse_2):
    
    "create a box with 4 corners and return the co-ordinates of the corners"
    
    upper_left_x = min(ellipse_1.x1, ellipse_1.x2, ellipse_2.x1, ellipse_2.x2) + 0.2 * size
    upper_left_y = max(ellipse_1.y1, ellipse_1.y2, ellipse_2.y1, ellipse_2.y2) + 0.2 * size
    upper_right_x = max(ellipse_1.x1, ellipse_1.x2, ellipse_2.x1, ellipse_2.x2) + 0.2 * size
    upper_right_y = max(ellipse_1.y1, ellipse_1.y2, ellipse_2.y1, ellipse_2.y2) + 0.2 * size
    lower_left_x = min(ellipse_1.x1, ellipse_1.x2, ellipse_2.x1, ellipse_2.x2) + 0.2 * size
    lower_left_y = min(ellipse_1.y1, ellipse_1.y2, ellipse_2.y1, ellipse_2.y2) + 0.2 * size
    lower_right_x = max(ellipse_1.x1, ellipse_1.x2, ellipse_2.x1, ellipse_2.x2) + 0.2 * size
    lower_right_y = min(ellipse_1.y1, ellipse_1.y2, ellipse_2.y1, ellipse_2.y2) + 0.2 * size
    
    return upper_left_x, upper_left_y, upper_right_x, upper_right_y, lower_left_x, lower_left_y, lower_right_x, lower_right_y
       

def endpoints(upper_left_x, upper_left_y, upper_right_x, upper_right_y, lower_left_x, lower_left_y, lower_right_x, lower_right_y):
    
    "create the x axis and y axis of the box"
    
    x_axis = [upper_left_x, upper_right_x, lower_left_x, lower_right_x]
    
    y_axis = [upper_left_y, upper_right_y, lower_left_y, lower_right_y]
    
    start_x = int(min(x_axis))
    end_x = int(max(x_axis))
    start_y = int(min(y_axis))
    end_y = int(max(y_axis))

    
    return start_x, end_x, start_y, end_y

def ratio(start_x, end_x, start_y, end_y, ellipse_1, ellipse_2):
    
    "calculate the ratio of hits vs total points"
    
    count = 0
    
    num = 50000
    
    for i in range(num):
         
        a = random.randint(start_x, end_x)
        
        b = random.randint(start_y, end_y)
        
        point = Point(a,b)
        
        if point_test(point, ellipse_1, ellipse_2) == True:
            
            count = count + 1
            
        ratio = count/num
    
    return ratio


def computeOverlapOfEllipses(e1,e2):
    
    "calculate the overlap ratio"
    
    size1 = size(e1, e2)
    upper_left_x, upper_left_y, upper_right_x, upper_right_y, lower_left_x, lower_left_y, lower_right_x, lower_right_y = box(size1, e1, e2)
    start_x, end_x, start_y, end_y = endpoints(upper_left_x, upper_left_y, upper_right_x, upper_right_y, lower_left_x, lower_left_y, lower_right_x, lower_right_y)
    ratio1 = ratio(start_x, end_x, start_y, end_y, e1, e2)
    
    lower_right = Point(lower_right_x, lower_right_y)
    up_right = Point(upper_right_x, upper_right_y)
    lower_left = Point(lower_left_x, lower_left_y)

    length1 = lower_right.distance(up_right)
    length2 = lower_right.distance(lower_left)

   
    area = length1 * length2

    return ratio1 * area
    

#lets define the ellipses and compute area of the overlap
e1 = ellipse_1(2, 1, 4, -1, 5)
e2 = ellipse_2(2, 1, 4, 1, 8)

overlap = computeOverlapOfEllipses(e1,e2)

print("The area of the overlap between the 2 ellipses is:", overlap)
    


    
    
    
    

    
    

