
library(glmnet)
library(corrplot)
library(MASS)

#################################################################
# Now, let's analyze this dataset with a more powerful tool
load("QuickStartExample.RData")

# This dataset has an x-variable set with twenty columns
# and a y-variable set with one column. 
#
# The datasets here need to be matrices
head(x)
head(y)

s = sample(1:100, 60)  
xTrain = x[s, ]
yTrain = y[s, ]
xTest = x[-s, ]
yTest = y[-s, ]

# Let's run a quick regression on this
ds = data.frame(yTrain, xTrain)
names(ds)[1] = "Y"
head(ds)
fitOLS = lm(Y ~ ., data=ds)
rmseTrain = sqrt(mean(fitOLS$residuals^2))
rmseTrain

summary(fitOLS)
yHat = predict(fitOLS, data.frame(xTest))   # Note that for OLS we have to convert 
c = fitOLS$coefficients                     # the dataset to a data.frame
rmsePredictOLS = sqrt(mean((yTest - yHat)^2))
rmsePredictOLS   

# Now let's run lasso using the glmnet function 
# Defaults to lasso, but can also do a version of ridge if you set alpha = 0
fit = glmnet(xTrain, yTrain)  # note there is no ~ here and y comes after the x's.
plot(fit, label=T)
print(fit)   # this gives us the table of R^2 = %dev vs lambda!

# Let's look at the coefficients for the model at a specific lambda
# We'll pick one somewhere in the middle with a nice value, .35, and only 
# 6 variables selected, but with still a .82 R^2
coef(fit, s=.35)    # Why s and not lambda ... sigh

yHat = predict(fit, xTrain, s=.35)
rmse = sqrt(mean((yTrain - yHat)^2))
rmse   # Pretty high, we may have gone too far :)

yPredict = predict(fit, xTest, s=.35)
rmsePredict = sqrt(mean((yTest - yPredict)^2))
rmsePredict   # High but not nearly as far from the training set ... more stable

#########################################################
# One of the nice things about this function is its 
# Ability to test with cross validation to choose the lamba

cvfit = cv.glmnet(xTrain, yTrain)
par(mar=c(3, 3, 3, 3))
plot(cvfit)

cvfit$lambda.min      # Note how much smaller this is than the one we chose
cvfit$lambda.1se      # Even this one is much smaller than the one we chose above

coef(cvfit, s="lambda.min")  # Note we are getting a lot more contributions here

yPredict = predict(cvfit, newx=xTest, s="lambda.min")
rmsePredict = sqrt(mean((yTest - yPredict)^2))
rmsePredict        # Quite a bit better than the OLS prediction!
rmsePredictOLS
