
##########################################################
# Analyze the swiss Fertility dataset
##########################################################

head(swiss)

# Set a random number seed so we always get the same result
set.seed(489)

# Grab test and training sets
n = nrow(swiss)
s = sample(n, n/2)
swissTrain = swiss[s, ]
swissTest = swiss[-s, ]

# Compute least-squares fit
olsFit = lm(Fertility ~ ., data=swissTrain)
summary(olsFit)  # R^2 is not innordinately high!

# Find the rmse
rmseOlsTrain = sqrt(mean(olsFit$residuals^2))
rmseOlsTrain

# Predict on the test set and compute error
olsPred = predict(olsFit, swissTest)
rmseOlsTest = sqrt(mean((olsPred - swissTest$Fertility)^2))
rmseOlsTest  # A lot higher, almost double

#######################################################################
# In glmnet, ElasticNet is obtained by setting alpha between 0 and 1
#######################################################################

install.packages("glmnet")
library(glmnet)

# Separate the X's and Y's as matrices
xTrain = as.matrix(swissTrain[, -1])   # Take out "Fertility", column 1
yTrain = as.matrix(swissTrain[, 1])    # Take only "Fertility", column 1

xTest = as.matrix(swissTest[, -1])   # Take out "Fertility", column 1
yTest = as.matrix(swissTest[, 1])    # Take only "Fertility", column 1

# Fit a ridge with glmnet ... doesn't give us much but does tell us how R^2 
# depends on lambda.  We need to give it
#
#   alpha = 0 --> selects ridge
#   lambda = <a single value or a sequence of lambdas to test>
lRange = seq(0, 5, .1)
fitElastic = glmnet(xTrain, yTrain, alpha=.5, lambda=lRange)

# Get a plot of th variable sizes based on lambda.  
plot(fitElastic, xvar="lambda")

fitElastic          # Lists the lambdas along with the R^2, (%Dev)
                    # Also shows how many VARIABLES are chosen at each 
                    # value of lambda!  Notice that like lasso, we still 
                    # get some variable selection, but it takes larger
                    # lambdas to do so since we are mixing in ridge!

# The cross-validated version helps us with lambda selection!
fitElastic = cv.glmnet(xTrain, yTrain, alpha=.5, nfolds=7)
fitElastic$lambda.min   # lambda = .2, very small labmda!

plot(fitElastic)

# To predict with this model, we need to tell it the lambda.
# we do so with the "s" parameter ... go figure :)
elasticPred = predict(fitElastic, xTest, s="lambda.min")
rmseElastic = sqrt(mean((elasticPred - yTest)^2))
rmseElastic  # Ridge did a bit better on this set
rmseOlsTest

#################################################################################
# ADVANED:  Can we find the best alpha overall.  We try this by trying different
# values of alpha for 100 training and test sets, and then averaging the test
# error
#################################################################################

set.seed(3402)

alphaBest = 0
bestError = 9999999    # Start out with a huge error
for (alpha in seq(0, 1, .1))
{
  meanError = 0
  for (i in 1:100)
  {
    # Grab test and training sets
    n = nrow(swiss)
    s = sample(n, n/2)
    swissTrain = swiss[s, ]
    swissTest = swiss[-s, ]
    
    xTrain = as.matrix(swissTrain[, -1])   # Take out "Fertility", column 1
    yTrain = as.matrix(swissTrain[, 1])    # Take only "Fertility", column 1
    xTest = as.matrix(swissTest[, -1])   # Take out "Fertility", column 1
    yTest = as.matrix(swissTest[, 1])    # Take only "Fertility", column 1
    
    fitElastic = cv.glmnet(xTrain, yTrain, alpha=alpha, nfolds=7)
    elasticPred = predict(fitElastic, xTest, s="lambda.min")
    meanError = meanError + sqrt(mean((lassoPred - yTest)^2))
  }
  meanError = meanError / 100
  
  if (meanError < bestError)
  {
    alphaBest = alpha
    bestError = meanError
  }
}
print("Best alpha is: ")
print(alphaBest)
print("Gives mean test error: ")
print(bestError)
