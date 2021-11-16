#KUNAL ROY'S FINAL PROJECT

#Access the data set
housing <- read.csv(file="housing.csv", head = TRUE, sep=",")
getwd()
head(housing)
tail(housing)
summary(housing)
#longitude         latitude     housing_median_age  total_rooms    total_bedrooms  
#Min.   :-124.3   Min.   :32.54   Min.   : 1.00      Min.   :    2   Min.   :   1.0  
#1st Qu.:-121.8   1st Qu.:33.93   1st Qu.:18.00      1st Qu.: 1448   1st Qu.: 296.0  
#Median :-118.5   Median :34.26   Median :29.00      Median : 2127   Median : 435.0  
#Mean   :-119.6   Mean   :35.63   Mean   :28.64      Mean   : 2636   Mean   : 537.9  
#3rd Qu.:-118.0   3rd Qu.:37.71   3rd Qu.:37.00      3rd Qu.: 3148   3rd Qu.: 647.0  
#Max.   :-114.3   Max.   :41.95   Max.   :52.00      Max.   :39320   Max.   :6445.0  
#                                                                    NA's   :207 


#Data Visualization
Total_Rooms <- housing$total_rooms
hist(Total_Rooms)
#Total rooms mostly lies in between the range of 0 to 10,000 rooms
Housing_Median_Age <- housing$housing_median_age
hist(Housing_Median_Age)
#The median age of houisng mostly lies in between 15 to 40 years old
hist(housing$total_bedrooms)
hist(housing$population)
hist(housing$longitude)
hist(housing$latitude)

#Data Transformation

#Filling missing values using imputation
install.packages("e1071")
library(e1071)
total_bedrooms_imputed <- impute(housing[5:5], what = 'median')
summary(total_bedrooms_imputed)
housing$total_bedrooms_imputed <- housing_imputed
dim(housing$total_bedrooms_imputed)
install.packages("dplyr")
library(dplyr)

#Create new variables
housing_new <- mutate(housing, mean_number_rooms = total_rooms/20640)
housing_new1 <- mutate(housing_new, mean_number_bedrooms = total_bedrooms_imputed/20640)


housing_new1$total_bedrooms <- NULL
housing_new1$total_rooms <- NULL

#ATTEMPT to split ocean_proximity variable into a number of binary categorical variable 
levels(housing_new1$ocean_proximity)

INLAND <- matrix(0, ncol = 1, nrow = 20640)
ISLAND <- matrix(0, ncol = 1, nrow = 2)
NEAR_BAY <- matrix(0, ncol = 1, nrow = 2)
NEAR_OCEAN <- matrix(0, ncol = 1, nrow = 2)
H_OCEAN <- matrix(0, ncol = 1, nrow = 2)
df <- data.frame(INLAND, ISLAND, NEAR_BAY, NEAR_OCEAN, H_OCEAN)
df
#Fill in the empty data frame using a for loop
for (i in 1:nrow(df))
    if(housing$ocean_proximity[i] == "INLAND")
      print("1")
else
  print("0")
dim(housing)
df    
    
    
housing_new1[c(1,2,3,4,5,6,8,9,10,11)] <- lapply(housing_new1[c(1,2,3,4,5,6,8,9,10,11), function(x) c(scale(x))

#Feature scaling                                                        
scalehousing <- scale(housing_new1[1:6])
scalehousing1 <- scale(housing_new1[ 11: 12])
new <- cbind(scalehousing, scalehousing1, x)
#new is the data frame that is now ready for ML algorithm

library(dplyr)

x <- select(housing_new1, "median_house_value")

#Create Training and test set
n <- nrow(new) 
ntrain <- round(n*0.8)
set.seed(314)   
tindex <- sample(n, ntrain)   

train <- new[tindex,]   
test <- new[-tindex,]   

#Split into train_x and train_y
train_x <- data.frame(train)
train_x$median_house_value <- NULL


train_y1 <- data.frame(train)
train_y <- select(train, "median_house_value")
as.factor(train_y)

class(train_x)
class(train_y)
length(train_x)
length(train_y)

#ML Algorithm
install.packages("randomForest")
library(randomForest)

summary(train)
rf = randomForest(median_house_value~., data=train,
                  ntree=500,mtry=2, importance=TRUE)
#Getting an error somehow
names(rf)
rf$importance

#Model Evaluation(could not get errors because algorithm not running)
oob_prediction = predict(rf)

train_mse = mean(as.numeric((oob_prediction - train_y)^2))
oob_rmse = sqrt(train_mse)
oob_rmse

y_pred = predict(rf , test_x)

test_mse = mean(((y_pred - test_y)^2))
test_rmse = sqrt(test_mse)
test_rmse


