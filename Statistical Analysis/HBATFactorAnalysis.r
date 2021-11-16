
library(foreign)  # Allows us to read spss files!
library(corrplot)
library(car)
library(QuantPsyc)
library(leaps)

####################################################################
# Start here if you want to see how to read in an 
# SPSS file with errors and correct them
####################################################################

# Read in the hbat spss "hbat" dataset from the book by Hair, et. al.
hbat = read.spss("HBAT.sav", to.data.frame=T)

# Note that we have a set of numeric parameters from X6 to X22
head(hbat)

# But we have a problem ... These aren't numeric for R, they're ALL factors!
sapply(hbat, class)

# Unfortunately, the numeric columns get read in with some labels for the
# ends of the scale and R interprets them as factors.  Worse, we cannot
# just use "as.numeric" on the subset of columns, it gives an error, so the
# only way to do it is to go through the columns one-by-one. 
# 
# Note that there are two values in hbat[, 7] that are marked as "Excellent"
# Since that field ranges from 5 to 9.9, with Excellent above, we will take
# Excellent to be 10.0.  These convert to NA in the following numerical
# conversion, so we replace them afterwards
hbat[hbat[, 7] == "Excellent", 7:20]   # Note the first column value

# Now, to convert, we have to first convert the factor to a string and then
# to numeric
for(i in 7:20)
{
  hbat[ , i] = as.numeric(as.character(hbat[ , i]))
}

# The samples in question are #'s 47 and 59
head(hbat[, 7:20])
# So clean them up
hbat[47, 7] = 10.0
hbat[59, 7] = 10.0

write.csv(hbat, "hbat.csv", row.names=F)

#######################################################################
# Start here for the main analysis
#######################################################################

# Now, we can just read the correct data with 
hbat = read.csv("hbat.csv")
head(hbat)

# Pull out just the numeric fields and place customer satisfaction 
# at the front because it will be our "Y".  It makes it easier to 
# interpret correlation matrices!
hbatNumeric = hbat[, c(20, 7:19)]

# Rename the columns so that we can read them :)
names(hbatNumeric) = c("Satis", "PQual", "EComm", "Tech", "CRes", "Advert", "PLine", "SImage", "Price", "Warrant", "NewProd", "Order", "PFlex", "Deliv")
head(hbatNumeric)

# Compute the correlation matrix and visualize it
cor.hbat = cor(hbatNumeric[, -1])
corrplot(cor.hbat, method="ellipse", order="AOE")   # 3 Main groupings with 
                                                    # a lone variable = NewProd
# Look at the size of the numeric data
dim(hbatNumeric)

###################################################################################
# Now, let's apply principal factor analysis
###################################################################################

library(psych)

# Sphericity and Sample Adequacy
hbatReduced = hbatNumeric[, -c(1, 11, 13)]
bartlett.test(hbatReduced)     # Yes, significant correlation
KMO(hbatReduced)

hbatReduced = hbatNumeric[, -c(1, 11, 13)]
p3 = principal(hbatReduced, rotate="varimax", nfactors=4)
print(p3$loadings, cutoff=.4, sort=T)
p3$loadings
p3$values            # The variances for each component
p3$communality       # Communalities tell % of variance captured for each variable
p3$rot.mat           # These are the eigenvectors
head(p3$scores)      # Here are the scores

##################################################################################
# And finally, common factor analysis and compare the two
##################################################################################

fit = factanal(hbatReduced, 4, scores="regression")
print(fit$loadings, cutoff=.4, sort=T)
print(fit)            # Chi-square of .113 so we fail to reject that it faithfully 
fit$correlation       # reproduces the correlation ... note ... not proof!

fit$s

fit = factanal(hbatReduced, 3)
print(fit$loadings, cutoff=.4, sort=T)
print(fit)            # Chi-square of ~0 so we reject the null hypothesis and the
fit$correlation       # model is inadequate.

# What happens if we go to 5?
fit = factanal(hbatReduced, 5)
print(fit$loadings, cutoff=.4, sort=T)
print(fit)            # Chi-square of .531 fail to reject with higher p-value
fit$correlation       # But it pulls off a single variable as a component

##################################################################################
# Now, let's test the fit using confirmatory factor analysis
##################################################################################

install.packages("lavaan")

library(lavaan)

names(hbatNumeric) = c("Satis", "PQual", "EComm", "Tech", "CRes", "Advert", "PLine", "SImage", "Price", "Warrant", "NewProd", "Order", "PFlex", "Deliv")

# specify the model ... notice we are using summated scales here!
hbat.model = ' order    =~ CRes + Order + Deliv + PLine      
               image    =~ EComm + Advert + SImage
               support  =~ Tech + Warrant
               product  =~ PQual + PLine + Price'

# fit the model
head(hbatReduced)
fit = cfa(hbat.model, data=hbatReduced)   # Note that we get a warning about negative variance
                                          # This can be an indication that N is too small
# display summary output
summary(fit, fit.measures=TRUE)

install.packages("semPlot")
library(semPlot)
semPaths(fit, style="lisrel")

# Look in particular at the Chi-Square, the RMSEA
# and the covariances (to see relationships among the
# factors)
