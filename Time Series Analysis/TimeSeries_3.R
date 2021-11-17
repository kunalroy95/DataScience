
library(ggplot2)
library(ggfortify)
library(forecast)
library(lmtest)
library(fUnitRoots)
library(tseries)
library(fpp2)

install.packages("TSA")

library(TSA)


### Q1:

df = read.table("GDP.txt", sep=";", header = T)

TS = ts(df, start = c(1960, 1), frequency = 1)
autoplot(TS)

#There is presence of non stationarity here as the variance looks un constant and the
#mean is un constant, my hypothesis is that this is not trend stationary
#there is not much seasonality present here

adfTest(TS)

adfTest(TS, type = "c")

#Cannot reject non stationarity here as the p value is larger than 0.01,
#therefore my hypthesis was correct that this is a non stationary series
#it is also likley not trend stationary which is whhat I hypothesized

kpss.test(TS)

#you can reject the null hypothesis for stationarity
#therefore the two tests agree, that this is a non stationary series


fit = lm(TS ~ time(TS))
summary(fit)

acf(fit$residuals)
pacf(fit$residuals)

#the acf has fairly quick decay to 0 and so the residuals show stationary behavior

adfTest(fit$residuals)
#you can reject non stationarity here and so the residuals are likely stationary

#the results here differ from the tests I ran on the series itself as here
#the residuals show stationary behavior as opposed to the non stationary series

source("eacf.R")

eacf(fit$residuals)

acf(TS)
pacf(TS)
eacf(TS)

#this is definitely an AR 1 model with some MA behavior according =
#to the eacf and so the model would (1,1,1) as differencing would
#be required since this is a non sationary series


#AR order of 2 since the PACF shows 2 significant spikes
#the EACF shows some MA behavuor as well so MA order of 1
#since the residuals are stationary, no differencing is required
#so the ARIMA model chosen is: (2,0,1)

fit_res = Arima(fit$residuals, order = c(2,0,1))
fit_res

fit1 = Arima(TS, order = c(1,1,1))
fit1

coeftest(fit1)

#lets remove the MA term as it is insignficant
fit2 = Arima(TS, order = c(1,1,0))
fit2

coeftest(fit2)

coeftest(fit_res)
#all the terms besides the ar1 term are insignificant

acf(fit_res$residuals)

#there is no significant autocorrelation presnet in the resiuals,
#this is likely a white noise series, therefore this model is a good fit

acf(fit2$residuals)

#there is no significant autocorrelation presnet in the resiuals,
#this is likely a white noise series, therefore this model is a good fit


fit_res_auto = auto.arima(fit$residuals)

#the autoarima does not agree as they wanyt to keep both the ar1 and ar2 term in,
#whereas the coeftest indicated that only the ar1 term should be kept

fit_auto = auto.arima(TS)
fit_auto

#auto arima does not agree with my model as it says there is
#no AR behavior, I think this is wrong because the ACF and PACF
#indicates strong AR 1 behavior


source("Backtest.R")

n_test = 0.80 * length(TS)

test1 = backtest(fit2, TS, orig = n_test, h=1)

test2 = backtest(fit_auto, TS, orig = n_test, h=1)

#the auto arima model is better when the backtest is run as all the error metrics =
#such as RMSE, MAPE are lower for the auto arima suggested model

plot(forecast::forecast(fit_auto, h = 10))

#The mean forecast curve is following the trend of the previous values
#and the standard errors increase as the forecast goes further out


### Q2:

df1 = read.csv("EnergyConsumption.csv")

energy_TS = ts(df1$Energy, start = c(1973, 1), frequency = 12 )
autoplot(energy_TS)

#this series is non stationary because it may have constant varaince,
#but the mean is un constant
#there is a gentle upward trend and then the trend starts to
#go down again
#there is strong seasonality present due to the constnat osicallation

acf(energy_TS, lag.max = 20)

#seasonality can be seen in the acf plot as well due to the additional peaks
#non stationarity can also be seen as there is slow decay,
#in fact the autocorrelation starts rising again in seasonal fashion
#also seaosnlaity is a type of non stationarity


acf(diff(energy_TS), lag.max = 20)

#even the differenced time series shows seasonality due 
#to recurrring spikes and non stationary behavior due to slow decay

kpss.test(energy_TS)

#you can reject the null hypothesis of stationarity, thereofore this
#series is non stationary as I first hypothesized


#the seasonal order is 12

pacf(energy_TS)
eacf(energy_TS)

#there is some AR and MA behavior in the non seasonal component
#with ARMA model (1,1,3)

acf(diff(diff(energy_TS), 12))
#there is definitley some AR and MA behavior in the seasonal compoenent
eacf(diff(diff(energy_TS), 12))

#I will go with the (1,1,3) model for the seasonal compoenet as well

seasonal_fit = Arima(energy_TS, order = c(1,1,3), seasonal = list(order = c(1,1,3), seasonal = 12))
seasonal_fit

seasonal_fit_auto = auto.arima(energy_TS)
seasonal_fit_auto

#my fit is better than the auto fit as lower AIC, BIC and sigma^2
#and tighter(to 0) ACF of residuals plot
acf(seasonal_fit$residuals)
acf(seasonal_fit_auto$residuals)


seasonal_fit1 = Arima(energy_TS, xreg = time(energy_TS), order = c(1,1,3), seasonal = list(order = c(1,1,3), seasonal = 12))
seasonal_fit1

#the auto arima results are better in this case due to lower AIC, BIC
#and sigma^2

n_test1 = 0.9 * length(energy_TS)

test3 = backtest(seasonal_fit, energy_TS, orig = n_test1, h=1)

test4 = backtest(seasonal_fit_auto, energy_TS, orig = n_test1, h=1)
#the backtesting is not producing any results for some reason
#lets choose my model as it was better than the auto arima model

plot(forecast(seasonal_fit, h=24))
#The forecast is capturing the seasonality well and it is 
#capturing the downward trend well, this looks like a good forecast



#------Q3:


df2 = read.table("steel2.txt", sep=";", header = T)

steel_TS = ts(df2)
autoplot(steel_TS)

#the varaince is un constant, so I would apply a log transform to it

steel_TS = log(steel_TS)
autoplot(steel_TS)

acf(steel_TS)
pacf(steel_TS)

#definitely a non stationary series due to slow decay of ACF
#strong AR behavior due to clear spikes in PACF, looks like order 2/3 AR model

eacf(steel_TS)

#due to clear triangle of zeros at (2,1), there is some MA behavior
#with degree one and AR behavior with degree 2
#lets try ARIMA model (2,1,1) 

fit_steel = Arima(steel_TS, order = c(2,1,1))
fit_steel

fit_steel1 = auto.arima(steel_TS)
fit_steel1

#Both models look very similar in terms of AIC, BIC and sigma^2

acf(fit_steel$residuals)
acf(fit_steel1$residuals)

#Both have very similar acf of residual plots, shows very little
#autocorrelations in the residuals, both could be good fit models for the data 
#need to do a final test with backtesting to compare


n_test2 = 0.8 * length(steel_TS)

test5 = backtest(fit_steel, steel_TS, orig = n_test2, h=1)

test6 = backtest(fit_steel1, steel_TS, orig = n_test2, h=1)

#The tests suggest my model was the better fit than the auto arima
#due to lower metrics like RMSE and MAPE

#lets check the normality of teh resiuals of my model
qqnorm(fit_steel$residuals)
qqline(fit_steel$residuals)
#looks pretty normal to me as it follows the diagonal decenly closely
#therefore we will use my model to make the forecasts

plot(forecast(fit_steel, h=10))



####  Q4:

df3 = read.csv("groceries.csv")

toothpaste_TS = ts(df3$ToothPaste)
pb_TS = ts(df3$PeanutButter)
bisc_TS = ts(df3$Biscuits)


autoplot(toothpaste_TS)
autoplot(pb_TS)
autoplot(bisc_TS)

#toothpaste does not seem to have much coreelation with PB and biscuits
#as toothpaste has upward and downard trends and the seasonlaity is different
#whereas the PB and biscuits have almost a horizontal line trend
#there seems to some relationship between peanut butter and biscuits though
#as they seem to have similar seasonality and a similar almost horiznal line trend

install.packages("astsa")
library(astsa)

lag2.plot(df3$ToothPaste, df3$PeanutButter, 8)

#lag 0 seems to be the strongest correlation

lag2.plot(df3$ToothPaste, df3$Biscuits, 8)
#lag -1 seems to be the strongest correlation


ccf(df3$ToothPaste, df3$PeanutButter)
#peak coorelation is at lag 0

ccf(df3$ToothPaste, df3$Biscuits)
#peak is at lag -1

#you need the right lag that will capture teh highest correlation
#so that the results of the regression results in a tighter fit

#Both of these varaibles can help in computing forecast for toothpaste sales
#as they both show some correlation at certain lags with toothpaste sales

install.packages("dynlm")
library(dynlm)

new_fit = dynlm(df3$ToothPaste ~ lag(df3$PeanutButter, 0) + lag(df3$Biscuits, -1))
summary(new_fit)

plot(new_fit)

#fairly good resiuals vs fitted plot, no shape to it, which is what we want

#pretty good adherence to normality

acf(new_fit$residuals)

#the residuals have no autocrrelation and so residuals
#are pretty much white noise series

#The model:
# y_t = 175.82 + 0.48*X_t - 0.46*X_t-1

#the lag 0 variable of penut butter sales is contributing positively
#to toothpaste sales and the lag -1 of biscuit sales is conytributing
#negativley to toothpaste sales
#if both the lagged penut butter sales and buscuit sales were 0,
#the toothpaste sales would be 175.82

auto.arima(df3$ToothPaste, xreg = cbind(df3$Biscuits[1:51], df3$PeanutButter))

#the results are very similar, the intercept is similar and the
#weights of the lagged biscuit variable and penut butter varaible
#are similar, they also have the same signs in the sense that biscuits is
#contributing neatively to toothpaste sales and peanut butter is
#contributing positively to toothpaste sales



### Q5:

library(lubridate)

df4 = read.csv("amzn.csv")

df4$Date = mdy(df4$Date)
class(df4$Date)
head(df4)

amznTS = ts(df4$Price, start = c(2005, 1), frequency = 365)

autoplot(amznTS)

log_returns = diff(log(df4$Price), lag=1)

plot(log_returns, type ='l')

acf(log_returns)

pacf(log_returns)

eacf(log_returns)

#possibly MA 1 or MA 2 model, no AR

#no eveidence of serial correlation in the log returns

Box.test(log_returns, type = "Ljung-Box")
#since p > 0.05, fail to reject the null so series is uncorrelated

install.packages('fDMA')
library(fDMA)
archtest(log_returns)

mod <- arima(log_returns,order = c(1,0,0))
arch.test(mod)

#p value is very small therefore you can reject the null 
#and therefore there is ARCH effects present
#therefore GARCH model can be applied

install.packages("fGarch")
library(fGarch)

gFit = garchFit( ~ arma(0, 1) + garch(1, 1), data=log_returns, trace=F)
gFit

res = ts(residuals(gFit, standardize = T))
autoplot(res)
acf(res)
acf(res^2)

#Garch(1,1) model:
# sigma_n = omega + alpha_1 * r_n-1 + beta_1 * sigma_n-1

#where alpha_1 is the weight for the previous periods return
#and beta_1 is the weight for the previous volatility estimate
#the output above gives the current volatility estimate

#predictions of 5 step ahead volatilities 
predict(gFit, n.ahead = 5)











