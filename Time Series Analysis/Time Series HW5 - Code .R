## HW5 -- Kunal Roy


### Q1:

df = read.csv("groceries.csv")

toothpaste_TS = ts(df$ToothPaste)
penut_TS = ts(df$PeanutButter)
bisc_TS = ts(df$Biscuits)

acf(toothpaste_TS)
acf(penut_TS)
acf(bisc_TS)

#all 3 of these series dont have much autocorrelation,
#all 3 have just one siggnificant lag of auto correlation and so have
#pretty similar amount of autocorrelation

ccf(df$ToothPaste, df$PeanutButter)
ccf(df$ToothPaste, df$Biscuits)
ccf(df$Biscuits, df$PeanutButter)

#biscuits and penut butter have the highest amount of cross correlation
#lets try a lag max = 4 for VAR model as there are not many significant lags

install.packages('vars')
library(vars)


s = VARselect(cbind(toothpaste_TS, penut_TS, bisc_TS), lag.max = 4, type = 'const')
s

#both AIC and BIC choose lag 3 model, there is no difference between the 
#various criteria, they all want lag 3 model
#therefore we will only try a fitted model with p = 3

fit = VAR(cbind(toothpaste_TS, penut_TS, bisc_TS),  p = 3, type = "const")
fit


serial.test(fit, lags.pt = 10, type = "PT.asymptotic")

#here we are failing to reject no auto correlation
#therefore it is highly likely there is no auto correlation,
#which is exactly what we want in our residuals and therefore this
#model does look like a good fit

autoplot(forecast(fit, h = 15))

#on all 3 varaibles the performance of the forecats look good
#as the swings are being captured well from the trainng data and
#you can clearly see what direction the swings go in for the next
#8 time steps from 53-60
#after the 60th time step, the forecasts start converging to mean of series
#also you can see biscuits and peanut butter sales have more representative
#swings of the training data as oppsed to tooth paste sales
#this is because there is more of a relationship between penut butter and biscuits



### Q2:


p = autoplot(gasoline)

#yes this series appears to have a non linear trend
#and yes this trend is in a trend-stationary sense as
#if you remove this non linear trend, this leaves a stationary series
#due to about constant variance in the series

# loess smoothing on top of series
p + geom_smooth(method = "loess")

#quadratic regression since the tend looks quadratic
t = time(gasoline)

loess_fit <- loess(gasoline ~ t)
summary(loess_fit)

res_TS = ts(loess_fit$residuals, start = 1991, frequency = 52)

autoplot(res_TS)

spectrum(res_TS, log="no", spans=c(2, 2), plot=T, xlab="Frequency (Cycles/Year)")

#frequency of 1 time per, 3 times per year have the highest spectral density
#spectrak density of frequency 1 is the highest at 0.13 and frequncy of 3
#has spectral density around 0.02
# a frequency of 1 year correpsonds to every year and frequency of 3
#corresponds to every 4 months of sesonality

spectrum(gasoline, log="no", spans=c(2, 2), plot=T, xlab="Frequency (Cycles/Year)")

#even the actual series has similar frequncies present, frequncies of
# 1 and 3 so lets include 3 harmonics in the model

fit1 = tslm(gasoline ~ trend + fourier(gasoline, K=3))
summary(fit1)

#forecasts for the next 2 years = 104 weeks
autoplot(forecast(fit1, data.frame(fourier(gasoline, K=3, h=104))))




