library(lubridate)
library(ggplot2)
library(ggfortify)
library(forecast)
library(lmtest)
library(fUnitRoots)
library(tseries)
library(fpp2)


df = read.csv("Temp_Change.csv")

df$Date = mdy(df$Date)
class(df$Date)
head(df)

TS = ts(df$Temp_Change_.c., start=c(1961, 1), frequency=12)

autoplot(TS, ylab = "Surface Temprature Change")

#this is an additive series, no log transform needed

#this is not a stationary series because although varaince is constant, mean is not constant

# a differencing will be requred to make it sttaionary

decomp <- decompose(TS)
plot(decomp)

#general trend is upward
#strong seasonality is present
#random component is completely random

acf(TS)

#acf plot confirms this is a non staionary series due to slow decay

#acf plot also indicates seasinality, a SARIMA model may be needed

acf(diff(TS))

#acf of the first differincing makes it stationary, theredore d = 1 in ARIMA model
#also acf of first differencing usually shows seasonality clearly,
#however none is present here as there is no repeating larger spike
#so we will not go with that approach.

pacf(TS)

#The ACF shows slow decay and the PACF cuts off after lag 4
#so maybe a AR(4) model is needed

#ARIMA model of (4,1,0) can be tried with one order of differencing as first differencing makes it a stationary series

source("eacf.R")
eacf(TS)

#according to EACF and the traingle of zeros an ARMA of (1,2) is needed
#hence a (1,1,2) model should be tried

model1 = Arima(TS, order = c(1,1,2))
model1

#lets compare to auto arima results
model2 = auto.arima(TS)
model2

coeftest(model1)

coeftest(model2)

#both models have significant params

acf(model1$residuals)
acf(model2$residuals)

#the acf plot of residuals looks better for the auto arima model
#as less serial correlation
#we want resiuduals to be white noise and have no serial correlation

#lets check the normality of the residuals
qqnorm(model1$residuals)
qqline(model1$residuals)

qqnorm(model2$residuals)
qqline(model2$residuals)
#Both have fat tails so this is inconclusive

#lets do a backtest to pick one

source("Backtest.R")

n_test = 0.8 * length(TS)

test1 = backtest(model1, TS, orig = n_test, h=1)

test2 = backtest(model2, TS, orig = n_test, h=1)

#the auto arima model is better on metrics like RMSE, MAPE etc.

#lets forecast both models
plot(forecast(model1, h =10))

plot(forecast(model2, h =10))
#the auto arima forecast definitely looks better as it is actually
#capturing the swings much better, the down swing in the forecasts are visible

#lets check the point forecasts of  next 10 months of the 
#best model: auto arima model
#this gives the temprature change values predicted for the next 10 months
#this can be very useful in climate research
forecast(model2, h =10)
