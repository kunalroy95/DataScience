
## 1) e)
a = rnorm(1000, 0, .1)
plot(a, pch=16, cex=.2)


p = rep(0, 1000)
p[1] = 0
p[2] = 0
theta_1 = 0 
theta_2 = 0.4 


for (i in 3:1000) 
{
  p[i] = theta_1 * p[i-1] + theta_2 * p[i-2] + a[i]
}
p = ts(p)


mean(p)
autoplot(p)
lag.plot(p)
acf(p, lag.max = 5)

##mean = 0.06 which is close to the theoretical mean of 0.17

## The lag 1 autocrrelation is around -0.05 which is close to the theretical lag 1 autoccrelation of 0

## The lag 2 correlation is around 0.4 which is also close to the theoretical lag 2 ac of exactly 0.4


# 2) e)

a = rnorm(1000, 0, .1)

#MA(2) Process:
p = 5 + -0.5 * a[1:999] + .25 * a[2:1000]
plot(p, type="l")
acf(p)
mean(p)

#the mean of 4.999 is very close to the theoretical calculation of 5

#The lag 1 autocorrelation of -0.4 and lag 2 autocorrelation of close to 0 is close to the theoretical calculations


# 4)

df = read.csv("NAPM.csv")

TS = ts(df$index)

autoplot(TS)

fit1 = auto.arima(TS, seasonal = F)
fit1

coeftest(fit1)

fit2 = auto.arima(TS, seasonal = F, ic = 'bic')
fit2

#Yes the fitted model does change, the degree of AR changes from 3 to 1

#The model that was fitted in homework 2 was of order (2,0,0) and had sigma squared of 4.439,
#In this model the degrees have changed sigma squared has decreased to 4.284

#AIC and BIC is lower (1,0,2) model hence we will go with this model.

forecast(fit)

plot(forecast(fit))

#Yes the trend is consistent with the behavior shown, since there is a cyclical pattern, the trend is on the way up after
#being on a down trend

#The 10th step forecast is above 50, therefore the manufacturing economy is expanding

#The model forecast converges to the overall mean of series of 51.4 as seen from output


# 5)-------------------------------



df1 = read.csv("indpro.csv")

head(df1)

df1$date = mdy(df1$date)
class(df1$date)
head(df1)

rateTS = ts(df1$rate, start=c(1990, 2), frequency=12)

autoplot(rateTS)

#This is a stationary series. 
#There is no clear trend as such, the series oscillated around 0
#There is a strong seasonality present due to continuous upward and downward oscilation aorund rate 0

hist(rateTS)

#Yes, the time series is pretty much normally distributed due to the bell shaped curve
#there is a slight skew though, but overall it looks pretty normal


adf.test(rateTS)            
#with 0.01 p value 
#we can reject the null hypothesis(non stationarity), and therefore this series is stationary 


kpss.test(rateTS, null="Level")
#you cannot reject the null hypothesis of stationarity and so it is stationary
#so can use the original series


acf(rateTS)
pacf(rateTS)
eacf(rateTS)

#this is a stationary series as the ACF drops to near 0 decently quickly

#the PACF cuts off immediately after lag 4, this indicates a AR(4) series 


model = Arima(rateTS, order = c(4,0,0))
model

Box.test(resid(model),type="Ljung")

#by the ljung box test, there is no serial correlation present amongst the residuals
#therefore this is a white noise series

acf(resid(model))

#plotting the ACF of the residuals, there is no autocorrelation in this residuals series,
#therefore it is white noise, therefore this model is a good fit

coeftest(model)

#the coefficients ar2, 3 and 4 are significant, ar1 is not sigficant

#the model expression is:
# v_t = 0.0018 + 0.07*v_t-1 + 0.17*v_t-2 + 0.24*v_t-3 + 0.16*v_t-4
#this is a good model as the residuals are white noise and that is what we want

model2 = auto.arima(rateTS, ic = "bic")
model2

acf(resid(model2))
#The acf shows no autocrrelation of residuals, therefore residuals are white noise
#and so this is a good fit for the model

coeftest(model2)
#all coeffecients are significant in this model

#model expression:
# v_t = 0.88*v_t-1 + a_t - 0.83*a_t-1 + 0.22*a_t-2
#this is a good model for data as the residuals are white noise

library(forecast)


plot(forecast(model))
plot(forecast(model2))

#The forecasts are similar in behavior as they are straight lines reverting to the mean of 0
#the major difference is that the model I selected shows some sign of catching the seasoanlity at the
#begining of the forecast but then flattens out into a straight line

#I would use neither in decision making going forward as they are both pretty much just giving
# a straight line forecast when there is so much fluctuation in the actual values
# a straight line forecast would not be useful in practice


# 6)----------------------------------------

df2 = read.csv("consump.csv")

df2$consump <- NULL
df2$sent <- NULL
df2$unemp <- NULL

df2$date = mdy(df2$date)
class(df2$date)
head(df2)

incomeTS = ts(df2$pers_inc, start=c(2000, 1), frequency=12)

autoplot(incomeTS)

#This series is non stationary, it has an upward trend throughout
#it does not have a strong seasonality

#It is a multiplicative series and needs to be log transformed

log_ts = log(incomeTS)

acf(log_ts, lag.max = 20)
pacf(log_ts, lag.max = 20)

#the ACF shows  a very slow decay to 0 therefore this is a non stationary series



acf(diff(log_ts), lag.max = 20)
pacf(diff(log_ts), lag.max = 20)

#the differenced series now shows stationary behavior as there is a quick fall off
#in the acf to near 0


install.packages("fUnitRoots")
library(fUnitRoots)
adfTest(log_ts,lags=5,type="ct")

#the hypothesis of unit root non stationarity cannot be rejected. 
#Test results suggest that first difference of time series is stationary

# the version is  "ct" for a regression with an intercept
# constant and a time trend according to observations in a)


#the ACF cuts after lag 1 and the PACF shows a slow decay,
#therefore a MA(1) model is appropriate here with differencing order 1
#therefore the ARIMA model needed is (0,1,1)
#drift is included in Arima model when d = 1

model3 = Arima(incomeTS, order = c(0,1,1))
model3

coeftest(model3)

checkresiduals(model3)



#high p value means no serial correlation therefore the residuals are white noise
#bell curved normal distribution also shows white noise residulas so this model fits well

plot(forecast(model3))
         
#Not a very good forecast as it is a straight line, gives the same foreacst value for every step

model4 = auto.arima(incomeTS)
model4

#yes the selected model incrudes drift with order (2,1,2)
#comparing with my model, there is an AR term in the suggested one
# and the degree of MA is 2 and not 1

checkresiduals(model4)

#there is a strongr case for the suggested model to have white noise residuals
#as the p value is larger for ljung box test
#the suggested model would be the one to use as it is showing stronger case for white nouse residulas
#from the histogram plot and ACF

plot(forecast(model4))

#the forecast for the suggested model is much better as it follows the trend of the actual values         
