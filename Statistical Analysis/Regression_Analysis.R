########################## Problem 4

df <- read.delim("EX7_20.txt")
library(ggplot2)

#PLot the scatterplot of X and Y
ggplot(df, aes(X, Y)) +
  geom_point()
#The relationship between X and Y is strongly negative 

cor(df$X, df$Y)
#Correlation coefficient of -0.932 confirms the above statement

#calculate natural log of X and Y
df$log_X <- log(df$X)
df$log_Y <- log(df$Y)

#plot scatterplot of lnX and lnY
ggplot(df, aes(log_X, log_Y)) +
  geom_point() +
  xlab(label = "lnX")+
  ylab(label = "lnY")
#The relationship between lnX and lnY is still strongly negative

#fit the transformed model to data
transformedModel <- lm(log_Y ~ log_X , data=df)
summary(transformedModel)

#Yes, the model is adequate since p-value is 2.911e-07 and alpha is 0.05,
#alpha is greater than p-value, so one can reject the null hypothesis that the
#model coefficients  are 0. Hence there is a linear relationship between the X and Y. 

########################## Problem 6

df1 <- read.delim("BOILERS.txt")

#Create a linear model
model <- lm(Man.HRs ~ Capacity + Pressure + Boiler + Drum, data = df1)
summary(model)
resid(model) #List of residuals
plot(density(resid(model))) #A density plot of residuals

#histogram of residuals
ggplot(data = df1, aes(x = model$residuals)) +
  geom_histogram(fill = 'steelblue', color = 'black') +
  labs(title = 'Histogram of Residuals', x = 'Residuals', y = 'Frequency')

#from the histogram and density plot produced, it is pretty much bell-curved shaped
#and is reasonably symmetric, it does not look like the normality assumption is being violated.

############################# Problem 7

df2 <- read.delim("EX8_1.txt")

model1 <- lm(Y ~ X, data = df2)
summary(model1)

#plot residuals vs predicted values
a <- data.frame(df2$X)
colnames(a)[1] <- "X"
df2$y_hat <- predict(model1, newdata = a)
model1$residuals

ggplot(df2, aes(y_hat, model1$residuals)) +
  geom_point()

#this graph shows a trend of non-linearity
#hence a change to the model maybe needed by adding a quadratic term to it


df3 <- read.delim("EX8_2.txt")

model2 <- lm(Y ~ X, data = df3)
summary(model2)

#plot residuals vs predicted values
b <- data.frame(df3$X)
colnames(b)[1] <- "X"
df3$y_hat <- predict(model2, newdata = b)

ggplot(df3, aes(y_hat, model2$residuals)) +
  geom_point()
#there seems to be no correlation between residuals and predicted values
#this means no change to the current model is needed

#standardized residuals for both models above
rstandard(model1)

rstandard(model2)

################################## Problem 9
df4 <- read.delim("MISSWORK1.txt")

#fit the model to data
model3 <- lm(HOURS ~ WAGES, data = df4)
summary(model3)

#The fitted model is(least squares regression equation):
# y = 222.6 - 9.6x

#calculate predictions
c <- data.frame(df4$WAGES)

colnames(c)[1] <- "WAGES"

df4$y_hat <- predict(model3, newdata = c)

#plot residuals vs predicted values
ggplot(df4, aes(y_hat, model3$residuals)) +
  geom_point()

model3$residuals
#From the plot above, we can see there could be an outlier value with residual 436.5
#this corresponds to the 13th observation of HOURS

rstandard(model3)
#if we calculate standardized residuals, we can confirm that the 13th observatiom
#of HOURS is an outlier as the standardized residual value is above 3 at 3.45

#I would remove this outlier value because this employee has been fired and
#his higher than normal hours missed is contributing incorrectly to the model








