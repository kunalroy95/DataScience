#### HW2 Code: -----------------------------------------------------------------


#### Q1:
df = read.csv("groceries.csv")

df$Date = mdy(df$Date)
class(df$Date)
head(df)

dfTS = ts(df$ToothPaste, start = 2008, frequency = 52)
autoplot(dfTS, xlab="Date", ylab="Sales")

lag.plot(df$ToothPaste)
#The lag plot exhibits some linear pattern, it shows that the data is
#not strongly random and shows there is some serial correlation present
#and some positive autocorrelation is present, it is not very strong but some decent amount is present
#an autoregressive model maybe appropriate in this case

acf(df$ToothPaste)

#The ACF plot backs up my previous point that there is some serial correlation present as
#the lag 1 autocorrelation at 1 starts off at 0.5 and wsince it is above the dashed line
#there is evedience of autocrrelation present, however at later lags, the spikes are within the
#dashed line which shows evidence against autocorrelation

Box.test(df$ToothPaste, type = "Ljung-Box")
#null hypothesis: No serial correlation up tp 10 lags
#p-value is less than 0.05, therefore we can reject the null hypothesis
#therefore there is some serial correlation present up to 10 lags

#weak stationarity means the mean and varaince are finite and time invariant,
# so the mean and variance of future returns are the same of the past data and this implies that
# we can use past data to learn about the future

#a method to analyze stationarity is that the trend line of a time series is flat and not growing,
#the mean and varaince of a time series are time invariant and the ACF has a quick decay to 0

#### Q2:


intel = read.csv("Intel.csv")

log_prices = log(intel$Price)

lag.plot(log_prices)

#The lag plot shows a perfectly strong linear pattern, this means there
#is a very high serial correlation and a very high positive autocorrelation present

acf(log_prices)

#There is evidence of very high serial correlation for all lags present in the graph,
#It is very close to a autocrrelation of 1 for lag1 and then it slowly dips for higher lags
#but still remains very high - this is typical of stock price data that have data similar to random walk characteristics

#The autocorrelation is very close to 1 for lag1 and then it bvery slowly dips going towards lag10,
#Because of the slow deacy in the ACF, this is definitely a non-stationary series. 
#Also stock price data is similar to random walk data, a random walk series has time variant mean and variance,
#hence the non-staionarity of the series

log_returns = diff(log(intel$Price), lag=1)
plot(log_returns, type = 'l')

acf(log_returns, lag.max = 15)
#The serial correlation for the returns of the intel stock is lower than the
#serial correlation for the prices as it satrts off with autocorrelation of near 0.6 for lag1
#then it decreases and increases again in a seasonal manner. Therefore the returns dont have as much
#as autocorrelation as the prices do, but for some lags they do like lag5, lag10 and lag15

Box.test(log_returns, type = "Ljung-Box")

#p-value is much less than 0.05, therefore we can reject the null hypothesis
#therefore there is significant serial correlation present
  
#### Q5:

data = read.csv("NAPM.csv")

data$date = mdy(data$date)
class(data$date)
head(data)

TS = ts(data$index, start = 1980, frequency = 12)
autoplot(TS, xlab="Date", ylab="Index")

#This sereies is additive as the swings do not get bigger or smaller as time goes on,
#in fact, the swings start big, get smaller and then get bigger again

decomp <- decompose(TS)
plot(decomp)

#There is no clear upward or donward trend, the trend is follwoing the observed time series quite closely

#There is seasonality present, there seems to be an upward spike followed by a downward spike on a yearly basis

acf(data$index)

Box.test(data$index, type = "Ljung-Box")

#From the ACF, this time series does have serial correlation as the autocorrelation at lag 1
#starts close to 1.0 and then reduces, but up till lag 10, there is startically significant autocorrelation,
#which indicates serial correlation is present

#The Ljung box test also backs this up as thep value is much less than 0.05 and therefor the null can
#be rejected and therefore there is serial correlation present


model = Arima(data$index, order = c(2,0,0))
model



library(lmtest)
coeftest(model)

# The estimated AR(2) model is:
# v_t = 51.3+ 1.09*v_t-1 - 0.17*v_t-2 + a_t

#the first lag is highly positively correlated with the v_t output, 
#the second lag has a low negative correlation with the v_t output
# if the second lag and the first lag are 0, the v_t ouput is 51.3

## All the model coefficents are highly significant and therefore all must be kept in the model
#  no coefficient is highly significant from 0 and therefore none should be thrown away
# All coeffecinets have 3 stars and thereofre their p value is highly significant, which means
# they all have a relationship with the output



#### Q6:

#From the ACF plot, only the lag 1 autocorrelation is significant, all higher lags are non significant
#hence this suggests a  MA(1) model

model2 = Arima(df$ToothPaste, order=c(0, 0, 1))
model2
coeftest(model2)

#The estimated MA(1) model is:
# v_t = 219.4 + a_t + 0.6 * a_t-1

#this means the past white noise error has a small positive relation to the output of this model, v_t
# if the current and past white noise error is 0, the model output is 219.4

#All the coeffecinets of the model are highly significant with low p values as they have 3 stars next to them,
#this indicates that all of the coefficients along with their varaibles in the model are related to 
#the output of the model











