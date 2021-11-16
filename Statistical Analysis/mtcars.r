
# Consider the mtCars dataset, data on mpg based on other information about the cars
#   
#     Cyl = # of cylinders
#     disp = engine displacement in cc's
#     hp = horsepowere
#     etc.
head(mtcars)

ds = mtcars[, c(2:7, 10:11)]   # The metric variables in the data that are not mpg 
                               # and cut off the binary vairiables.  Note that 
                               # cylinder, gear and carb are all ordinal, so we 
                               # may have to deal with that later!

library(corrplot)
corrplot(cor(ds), order="AOE")

# Compute an initial analysis
p = prcomp(ds)
print(p)            # First component is mostly displacement and drat!
summary(p)          # How many components to get to 95%?
plot(p)             # scree plot.  How many components should we keep?

round(p$rotation, 2)   # What do you see here?
print(p)   # Component 1 is mostly displacement, but with a positive correlation with HP
           # Component 2 is mostly hp with a negative correlation with disp.  
           # Component 3 is mostly qsec

# One problem: The numbers in disp & hp vary in the hundreds
# while drat and wt are in the single digits (weight is in tonnes ... 
# what if it had been in lbs?)
#
# drat = rear axis ratio
# qsec = quarter mile time
summary(ds)

# So, let's scale
p2 = prcomp(ds, scale=T)
summary(p2)               
round(p2$rotation, 2)   # How about now?  Things are not as clear, more mixed

# Look at the scree plot
plot(p2)                # Notice the increased spread
abline(1, 0, col="red")

s = as.data.frame(p2$x)   # Pull them out so that we can analyze the scores
s[order(s$PC1), 1:2]    # Which cars score highly?  
s[order(s$PC2), 1:2]

# Let's see if we can sharpen up the interpretation
library(psych)
p3 = principal(ds, nf=2)
print(p3$loadings, cutoff=.4)  # Now, what do you see?


