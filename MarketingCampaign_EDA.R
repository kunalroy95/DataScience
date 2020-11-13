#This analysis is for the Marketing Campaign data set from Kaggle + linked with US census data

market <- read.csv(file="marketing_campaign.csv", head = TRUE, sep=";")
head(data)
summary(data)

#---Cleaning---

str(data)
summary(data$Education)

#replace 2n Cycle with School in Education column
data$Education[data$Education== "NA"] <- "School"

data$Education <- as.character(data$Education)

data[is.na(data)] = "School"

#Remove unecessary variables as the ID will not be used in our analysis
data$ID <- NULL

#Convert year brith column to an age column
data$age <- 2020 - data$Year_Birth
summary(data$age)
hist(data$age)

#Split numerical ages into categories such as adults, teens etc.
for(i in 1 : nrow(data))
  if (data$age[i] < 20){
    data$age[i] = 'Teenagers'
  } else if (data$age[i] < 35 & data$age[i] > 19){
    data$age[i] = 'Young Adults'
  } else if (data$age[i] < 60 & data$age[i] > 34){
    data$age[i] = 'Adults'
  } else if (data$age[i] > 59){
    data$age[i] = 'Senior Citizens'
  }

#The only variable that has missing values is the Income column

# Impute missing values for income variable with median
data$Income[is.na(data$Income)] = 
  median(data$Income , na.rm = TRUE)
summary(data$Income)

library(stringr)
#Extraxt year from date and append to dataframe
year <- str_sub(data$Dt_Customer, 1, 4)
data$year <- year
#could do the same for month too

#Rename recency variable for conveniance
colnames(data)[8] <- "DaysLastPurchase"
summary(data$Education)

#Subset the dataframe to extract only people hwo have PHD's
dataPHD <- subset(data, Education == "PhD")


#---EDA---

library(ggplot2)
#Lets get to know our customers
ggplot(data = data) +
  geom_bar(mapping = aes(x = Education, fill = age )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Education")

ggplot(data = data) +
  geom_bar(mapping = aes(x = Marital_Status, fill = Education )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Marital Status")

ggplot(data = data) +
  geom_bar(mapping = aes(x = Kidhome)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Kids Home")
#most of our customers have no kids at home

ggplot(data = data) +
  geom_bar(mapping = aes(x = year)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Year Joined")
#Most of our customers joined in 2013

ggplot(data = data) +
  geom_bar(mapping = aes(x = Response)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Overall Response to Campaign")
#most people did not accept the offer in the last campaign

ggplot(data = data) +
  geom_bar(mapping = aes(x = Complain)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Complaints?")
#Very few complaints which is a good thing

#lets see a heat map
heatmap <- ggplot(data = data, mapping = aes(x = Education,
                                             y = Marital_Status,
                                             fill = age)) +
  geom_tile() +
  xlab(label = "Education") +
  ylab(label = "Marital Status")
heatmap
#example insight: if you have done masters and you are divorced, then you are likley to be a senior citizen
#Can target specific customers with specific ads, if there is a specific ad more suited to masters holders
#and divorced people, then we should likley show it to senior citizens more


summary(data$age)
dataYoungAdults <- subset(data, age == "Young Adults")
dataAdults <- subset(data, age == "Adults")

#Lets look at just those who gave a response
dataResponses <- subset(data, Response == 1)

summary(dataResponses$Income)
summary(data$Income)
#The ones who gave responses, their average income is around 10,000 greater than the sample customers average income
#Need to get more customers with higher income
#Look at the census data and find areas where the average income is around 62,000
#Target all of those areas with these offers
#Can also think of oepening new stores in areas with higher income, more employment
#Then you can do same with age and other variables maybe

age <- table(dataYoungAdults$MntSweetProducts)
barplot(age, 
        xlab="Amount Spent on Sweet Products by Young Adults")

sum(dataYoungAdults$MntSweetProducts)
sum(dataAdults$MntSweetProducts)

#Box Plots(Summary Stats)

boxplot(data$DaysLastPurchase, ylab = "Days Since Last Purcahse", las =1)
#Median of around 50 days since last purchase, goal would be to reduce this median 

boxplot(data$MntSweetProducts, ylab = "Amount Spent on Sweet Products", las =1)
summary(data$MntSweetProducts)
#Median amount spent on sweet products are around 8, 3rd quartile is 33
#Dont want to be pricing your prducts any higher than the range of 8-33 unless they are of exceptional quality

#Correlations and Scatterplots

#Is there a correlation between the amount spent on foods vs amount spent on wines?
#If so can give wine offers to people who buy fruits to increase sales of wine
#Can do the same for other variables as well

ggplot(data, aes(MntFruits, MntWines)) +
  geom_point() +
  geom_smooth(method = "lm") +
  xlab(label = "Amount Spent on Fruits")+
  ylab(label = "Amount Spent on Wines")

cor(data$MntFruits, data$MntWines)
#low correlation = 0.39

cor(data$MntFishProducts, data$MntMeatProducts)
#higher correlation = 0.56
#So for people how buy fish products, they should also be reccomended meat products
#This will increase total sales as it is a functions of sub sales

#Lets do a regression model for the one with higher correlation

#Here is the scatter plot + Regression Line + confidence interval

ggplot(data, aes(MntFishProducts, MntMeatProducts)) +
  geom_point() +
  geom_smooth(method = "lm") +
  xlab(label = "Amount Spent on Fish Products")+
  ylab(label = "Amount Spent on Meat Products")
 
#This is the model:

model <- lm(MntFishProducts ~ MntMeatProducts, data = data)
model
summary(model)

# Linear Relationship(regression equation): MntMeatProducts = MntFishProducts*M + C
# M = 0.1376 and C = 14.5585
#Meaning= Direct Proportionality between the amount spent on fish products and amount spent on meat products
#Offers and deals need to be made in such a way that meat and fish products are together to increase company revenue


#There is some link between making store purcahses and then that increasing web purchases
ggplot(data, aes(NumStorePurchases, NumWebPurchases)) +
  geom_point() +
  geom_smooth(method = "lm") +
  xlab(label = "Number of Store Purchases")+
  ylab(label = "Number of Web Purchases")

cor(data$NumStorePurchases, data$NumWebPurchases)
#decent correlation of 0.5
#Increase marketing of your web presence at your stores to increase web purcahses
#This will increase overall sales

#Then can add all of these factors and see how it is related to the final response from customers
#Can see which factors dont contribute that much and which do
#according to that can put more emphasis on those factors that contribute to a final response
#more final responses to offers the better! = more sales

cor(data$NumStorePurchases + data$NumWebPurchases, data$Response)

cor(data$NumStorePurchases + data$NumWebPurchases + data$NumCatalogPurchases, data$Response)

cor(data$NumStorePurchases + data$NumWebPurchases + data$NumCatalogPurchases + data$MntMeatProducts, data$Response)
#There is not much correlation, more variables may be needed


model <- lm(Response ~ Recency + MntWines + MntFruits + MntMeatProducts + MntFishProducts + NumDealsPurchases + NumWebPurchases + NumStorePurchases, data = market)
model
summary(model)


model1 <- glm(Response ~ Recency + MntWines + MntFruits + MntMeatProducts + MntFishProducts + NumDealsPurchases + NumWebPurchases + NumStorePurchases, data = market, family = binomial(link="logit"))
summary(model1)

model2 <- lm(scale(NumStorePurchases) ~  scale(MntWines) + scale(MntFruits) + scale(MntMeatProducts) + scale(MntFishProducts), data = market)
model
summary(model2)



age <- c(26,26,29,29,40,45,50,55,60,55,45,60,55,61,62,63,75,66)

scale(age)





#Examine linking data set (US census data)

data1 <- read.csv(file="census.csv", head = TRUE, sep=",")

data1$CensusTract <- NULL

#Merge Data sets ------ What is the point of merging it?

new <- data1[1:2240,]
newdata <- cbind(data, new)
#Newdata is the merged data set with 66 variables

#Lets remove observations with missing values as we cannot will with median this time
data12 <- na.omit(data1) 
summary(data12$IncomePerCap)

#Lets get the break down of average incomes by state
tapply(data12$IncomePerCap, data12$State, mean)

#The highest income per capita is in District of Columbia, Connecticut, Virginia, New Hamphsire
#and Colorado. These are new areas which we can target and gain new customers. 

#Lets get the average unemployment breakdown by state
tapply(data12$Unemployment, data12$State, mean)

#States like Iowa, Vermont and Wyoming have the lwowest unemployment rates
#Can look to open new stores there as a lot fo people are employed + completely new area will increase reach of company

#We can be even more exact and do it by counties rather than states









