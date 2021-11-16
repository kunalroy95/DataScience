# Real Estate Data Analysis

# Load the dataset.  Note that read.csv automatically assumes that
# there will be a header in the file with column names
sales = read.csv("RealEstate.csv")
head(sales)
str(sales)     # This lists the "structure" of the dataset
# including variable names and types

# Let's get a scatterplot matrix to determine linearity
plot(sales, pch=16)  # PlotCharacter (pch) number 16 is a filled dot

# The psych library has a much more useful scatterplot matrix plotter
#It gives correlations, distributions and more
library(psych)
pairs.panels(sales)

# Create an initial fit with the most significant correlation
fit1 = lm(Sold ~ Size, data=sales)
summary(fit1)
plot(fit1)

# Add the other variable and compare
fit = lm(Sold ~ Size + Assessed, data=sales)
summary(fit)

library(car)
vif(fit)

# Predict with new data
head(sales)
newdata = data.frame(Size=c(17), Assessed=c(70))
predict(fit1, newdata, interval="confidence", level=.99)

predict(fit1, newdata, interval="predict", level=.99)

predict(fit, newdata, interval="predict", level=.99)

# Run these commands if you are missing a package
install.packages("corrplot")
install.packages("QuantPsyc")
install.packages("car")
install.packages("leaps")
install.packages("lm.beta")

library(psych)     # Has a much better scatterplot matrix function
library(corrplot)  # A nice correlation matrix visualization
library(car)       # Misc statistical methods
library(QuantPsyc) # Misc statistical methods
library(leaps)     # Gives forward, backward and stepwise
library(lm.beta)   # Gives us standardized coefficients

# Read in the hbat spss "hbat" dataset from the book by Hair, et. al.
hbat = read.csv("hbatSatisfaction.csv")
head(hbat)        # Shows the first 6 rows
str(hbat)         # Gives the structure of the data including data-types
summary(hbat)     # Provides summary statistics for each column

# Show a scatterplot matrix, but even with this better version, there is not
# much here. We can see a few linear relationships that are weak, but it is 
# difficult to even read the titles.
pairs.panels(hbat)

# Compute the correlation matrix and visualize it
#
# Notice that new NewProd, PFlex and Tech are the least correlated with 
# Satisfaction so we will take them out right from the beginning
# 
# Also notice that there are some significant correlations here, so we should
# expect some multicolinearity
cor.hbat = cor(hbat)
corrplot(cor.hbat)

#############################################################################
# Manual Model Building
#############################################################################

fullFit = lm(Satis ~ . - NewProd - PrceFlex - Tech, data=hbat)
summary(fullFit)

fit1 = lm(Satis ~ CRes, data=hbat)
summary(fit1)
plot(fit1)    # Note that this will cause a message to appear in the 
# "Console" panel below asking you to hit <Return> for each
# of the four plots

# If you want to plot all four at the same time, this will do it
par(mfrow=c(2, 2))    # This will set up a 2x2 grid of plots
plot(fit1)            # Plot all four
par(mfrow=c(1, 1))    # Return the plot window to one plot

# Check the correlations of the residuals with the other variables
# Notice that we are removing here "Satis = 1" and "CRes = 5" because
# the first is the parameter of interest and the second was included
# in the first model
cor(fit1$residuals, hbat[, -c(1, 5)])

# PQual is the highest in absolute value, so include it in the next step
fit2 = lm(Satis ~ CRes + PQual, data = hbat)
summary(fit2)
vif(fit2)

###################################################################
# Automated fitting
###################################################################

# The leaps package function "step" can perform stepwise regression, 
# but to get going, we need to feed it the two "bounding" models so 
# that it knows what to work with
null = lm(Satis ~ 1, data=hbat)
null
full = lm(Satis ~ ., data=hbat)
summary(full)

# First we do a forward search
hbatForward = step(null, scope = list(lower=null, upper=full), 
                   direction="forward", trace=F)
summary(hbatForward)

# The lm.beta gives "standardized betas" which better tell how large 
# an effect a variable has on the parameter of interest than the raw 
# beta does.
lm.beta(hbatForward)  # Sales force image has the biggest impact

# Look at the standardized coefficients to see which influence the 
# parameter of interest to a greater degree. 
stdCoef = coef(lm.beta(hbatForward))    # Grab the standardized coefficients
barplot(sort(stdCoef))
barplot(rev(sort(stdCoef)))             # Graph the coefficients in order of importance
stdCoef

# Next do a backward search.  No need for a scope since the lower
# limit is "no variables"
hbatBackward = step(full, scope=list(lower=null, upper=full), direction="backward", trace=F)
hbatBackward = step(full, direction="backward", trace=F)
summary(hbatBackward)

stdCoef = coef(lm.beta(hbatBackward))    # Grab the standardized coefficients
barplot(rev(sort(stdCoef)))             # Graph the coefficients in order of importance
stdCoef    

# Note that Delivery Speed and Complaint Resolution have been replaced
# by Product Line and Price Flexibility!

# Finally we do a "stepwise" search combining the two
hbatStep = step(null, scope=list(lower=null, upper=full), direction="both", trace=F)

summary(hbatStep)
summary(hbatForward)
summary(hbatBackward)

anova(hbatStep, hbatForward)    # Is there any difference in predictive power?
anova(hbatStep, hbatBackward)   # Is there any difference in predictive power?

# Backward elimination produced a SLIGHTLY better result with a different
# set of variables.  The difference is not statistically significant.
# Is there one that makes more sense practically?

#############################################################################################
# All subsets regression
#
# The leaps package has a beautiful subset search routine that also provides a viaualization
# of its results.  
#############################################################################################

hbatSubsets = regsubsets(Satis ~ ., data=hbat, nbest=5)

plot(hbatSubsets, scale="adjr2")
bestR2Fit = lm(Satis ~ PQual + EComm + CRes + PLine + SImage + Price + Order + PrceFlex, data=hbat)
summary(bestR2Fit)

lm.beta(hbatStep)     # SImage and PQual are most influential predictors
lm.beta(hbatForward)  # Again, SImage ad PQual
lm.beta(hbatBackward) # Again
lm.beta(bestR2Fit)    # Once more

# Things are really nice if they all agree ... unfortunately they don't!
# but they do agree on the most important predictors
# 
# Also notice that our greatest correlation CRes is insignificant in all of these
# So its contribution must be getting explained by others, or there must be some
# multicolinearity.  Unfortunately, it doesn't show up in the VIF!

sort(lm.beta(hbatForward))
sort(lm.beta(hbatBackward))
sort(lm.beta(hbatStep))
sort(lm.beta(bestR2Fit))

# There is some agreement on these, but let's see how they do on cross-validation
# The LeaveOutOne.R script contains the definition of a function that
# performs LeaveOutONe cross-validation
source("LeaveOutOne.R")

LeaveOutOne(hbatForward)
LeaveOutOne(hbatBackward)
LeaveOutOne(hbatStep)
LeaveOutOne(bestR2Fit)

# Notice that hbatBackward seems to do slightly better.
# And certainly does better than our second manual step
LeaveOutOne(fit2)
