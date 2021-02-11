housing <- read.csv(file="housing.csv", head = TRUE, sep=",")
head(housing)
tail(housing)
summary(housing)
# 207 NAs found for total_bedrooms variable
dim(housing)          # 20640x10

## Check levels for factor variable ocean_proximity
levels(housing$ocean_proximity)
# [1] "<1H OCEAN"  "INLAND"     "ISLAND"     "NEAR BAY"   "NEAR OCEAN"

colnames(housing)    # Show variables list

#EXPLORATORY DATA ANALYSIS
# Plot distributions for each variable
ggplot(data = melt(housing), mapping = aes(x = value)) + 
  geom_histogram(bins = 30) + facet_wrap(~variable, scales = 'free_x')
#Total rooms mostly lies in between the range of 0 to 10,000 rooms
#The median age of housing mostly lies in between 15 to 40 years old

#DATA TRANSFORMATION

# Impute missing values for total_bedrooms variable with median
housing$total_bedrooms[is.na(housing$total_bedrooms)] = 
  median(housing$total_bedrooms , na.rm = TRUE)

# fix up total variables and make them means
housing$mean_bedrooms = housing$total_bedrooms/housing$households
housing$mean_rooms = housing$total_rooms/housing$households

# Remove total_bedrooms, and total_rooms
housing$total_bedrooms <- NULL
housing$total_rooms <- NULL

# Turn levels of ocean_proximity into binary category variables

# Set up matrix of zeroes
cat_housing <- data.frame(matrix(0, 
                                 nrow = nrow(housing), 
                                 ncol = length(unique(housing$ocean_proximity))))

# rename columns using factor levels in ocean_proximity
colnames(cat_housing) <- as.character(unique(housing$ocean_proximity))

# use sapply and ifelse to set value equal to one when the value in ocean_proximity is equal to the column name
cat_housing[] <- sapply(seq_along(cat_housing), 
                        function(x) ifelse(names(cat_housing[x]) == as.character(housing$ocean_proximity),1,0))

tail(cat_housing)
colnames(housing)

# Remove ocean_proximity
drops = c('ocean_proximity')
housing_num =  housing[ , !(names(housing) %in% drops)]

head(housing_num)
# Scale numerical variables
scaled_housing_num = scale(housing_num)

# newcol == median_house_value
newcol <- housing$median_house_value

# Create cleaned data frame
cleaned_housing = cbind(cat_housing, 
                        scaled_housing_num, newcol)

cleaned_housing$median_house_value <- NULL
                    
names(cleaned_housing)

# Create training and test sets
set.seed(314) # Set a random seed so that same sample can be reproduced in future runs

sample = sample.int(n = nrow(cleaned_housing), size = floor(.8*nrow(cleaned_housing)), replace = F)
train = cleaned_housing[sample, ] 
test  = cleaned_housing[-sample, ] 

head(train)

# Verify train and test sets size
nrow(train) + nrow(test) == nrow(cleaned_housing)

#MACHINE LEARNING

library('boot')

glm_house = glm(newcol~median_income+mean_rooms+population, 
                data=cleaned_housing)
k_fold_cv_error = cv.glm(cleaned_housing , glm_house, K=5)

k_fold_cv_error$delta

glm_cv_rmse = sqrt(k_fold_cv_error$delta)[1]
glm_cv_rmse
#83288.11

names(glm_house) 

glm_house$coefficients
#(Intercept) median_income    mean_rooms    population 
#206855.817     82608.959     -9755.442     -3948.293 

#randomForest classifier

install.packages("randomForest")
library(randomForest)

names(train)

set.seed(1738)

train_y = train[,'newcol']  
train_x = train[, names(train) !='newcol']

head(train_y)
head(train_x)

 rf = randomForest(x=train_x, y=train_y , 
                  ntree=500, importance=TRUE)


# Model object components
names(rf)
# [1] "call"            "type"            "predicted"       "mse"            
# [5] "rsq"             "oob.times"       "importance"      "importanceSD"   
# [9] "localImportance" "proximity"       "ntree"           "mtry"           
#[13] "forest"          "coefs"           "y"               "test"           
#[17] "inbag"        

# Higher number == more important predictor
rf$importance
#%IncMSE IncNodePurity
#NEAR BAY            427067774.3  1.209109e+12
#<1H OCEAN          1629776294.9  4.480189e+12
#INLAND             3950064248.7  3.060009e+13
#NEAR OCEAN          503192362.1  2.201326e+12
#ISLAND                 961562.1  6.395973e+10
#longitude          6762300662.2  2.524642e+13
#latitude           5369733628.7  2.249469e+13
#housing_median_age 1071563394.7  9.681345e+12
#population         1027786863.0  7.569844e+12
#households         1155616441.9  7.983246e+12
#median_income      8458186706.6  7.367125e+13
#mean_bedrooms       445475250.9  7.697656e+12
#mean_rooms         1892619813.6  2.105101e+13

# MODEL ACCURACY

# Calculate the out-of-bag (oob) error estimate. This is a
# way to determine accuracy of randomForest models.

oob_prediction = predict(rf) 

#So even using a random forest of 
# only 1000 decision trees I was able to predict the median price 
# of a house in a given district to within $49,000 of the actual 
# median house price.
train_mse = mean(as.numeric((oob_prediction - train_y)^2))
oob_rmse = sqrt(train_mse)
oob_rmse
#[1] 49207.7

#Now use the test set on the trained model.
test_y = test[,'newcol']
test_x = test[, names(test) !='newcol']

y_pred = predict(rf, test_x)
test_mse = mean(((y_pred - test_y)^2))
test_rmse = sqrt(test_mse)
test_rmse
#[1] 47491.05

# My model scored roughly the same on the training and testing data, 
#suggesting that it is not an overfit and that it makes good predictions.

#Predicted house prices on the new test data
y_pred
#1         4         8        11        13        24        27        28        33        57        58 
#420360.68 344451.67 243489.92 227295.72 224169.83 147606.78 135889.11 139529.58 124786.55 111069.77 131461.59 


