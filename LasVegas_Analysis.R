
##This is a trip advisor data set, where tripadvisor users have gone to vegas hotels and have rated
#experinece and have helped log information about the hotel and details about it
#This kind of data set could be very useful in marketing to specific users
#I got this data set from the UCI Machine learning repository 

vegas <- read.csv(file="vegas.csv", head = TRUE, sep=";")
head(vegas)
summary(vegas)

#Cleaning Data: The data set was already very clean and needed to only do minor cleaning:
# I removed few uncessary variables that would not be of much help in analyis
# and I renamed a few variables so it is easy to call them later
#I also converted a factor variable to a numeric variable so I could see a statistical summary of it

#Remove unecessary variables
vegas$Nr..hotel.reviews <- NULL
vegas$Nr..reviews <- NULL
vegas$Helpful.votes <- NULL
vegas$Review.month <- NULL
vegas$Review.weekday <- NULL

#Change variable names for convenience of use later
colnames(vegas)[13] <- "Rooms"
colnames(vegas)[3] <- "PeriodStay"

#Convert Hotel.stars variable from factor to numeric
vegas$Hotel.stars <- as.numeric(vegas$Hotel.stars)
str(vegas$Hotel.stars)

#encode categorical binary variable into numeric variable so that it can be used in ML algorithms
vegas$Spa <- ifelse(vegas$Spa=="YES", 1, 2)
str(vegas$Spa)

#Subset data to extract only people going to Paris LV and USA traffic 
parisLV <- subset(vegas, Hotel.name == "Paris Las Vegas")
summary(vegas$Hotel.name)
summary(vegas$User.country)
USAtraffic <- subset(vegas, User.country == "USA")



#(Summary statitics)
tapply(vegas$Rooms, vegas$Traveler.type, summary)

tapply(vegas$Hotel.stars, vegas$Traveler.type, summary)

tapply(vegas$Score, vegas$Traveler.type, summary)

#Boxplots
boxplot(vegas$Rooms ~ vegas$Traveler.type, ylab = "Rooms", main = "Rooms vs Traveler Type", las =1)
#Couples are usually staying at hotels where the median number rooms is higher and business travelers are staying at hotels where the median number of rooms are lower

boxplot(vegas$Hotel.stars ~ vegas$Traveler.type, ylab = "Hotel Stars", main = "Hotel Stars vs Traveler Type", las =1)
#Median number of stars is similar for all traveler types at 3 star hotels

#Boxplot with new variables
boxplot(vegas$Score ~ vegas$User.continent, ylab = "Score", xlab = "User Continent", main = "Score vs User Continent", las =1)

#Histogarm with new variable 
set.seed(1234); 
vegas$Score <-rnorm(200)
hist(vegas$Score, col="lightblue", xlab = "Score", main = "Histogram of Scores")
abline(v = mean(vegas$Score), col="red", lwd=3, lty=2)
#The Average score from a customer is somehwere between 4 and 5 as indicated bby the red dashed line
#This means customers are mostly satisfied with most hotels in vegas

#Barplot with new variable
period <- table(vegas$PeriodStay)
barplot(period, 
        xlab="Period of Stay")

period <- table(vegas$Score)
barplot(period, 
        xlab="Score", ylab="Count")

library(ggplot2)

# scatterplot + regression line
ggplot(body, aes(Nr..reviews, Nr..hotel.reviews, color = Traveler.type)) +
geom_point() +
geom_smooth(method = "lm") +
  xlab(label = "Number of Reviews")+
  ylab(label = "Number of Hotel Reviews")

ggplot(body, aes(Nr..reviews, Nr..hotel.reviews)) +
  geom_point() +
  geom_smooth(method = "lm")+
  xlab(label = "Number of Reviews")+
  ylab(label = "Number of Hotel Reviews")

model <- lm(Nr..reviews ~ Nr..hotel.reviews, data = body)
model

# Linear Relationship(regression equation): NrReviws = Nr Hotel Reviews*M + C
# M = 2.051 and C = 15.272
#Meaning= Direct Proportionality between the Nr of hotel reviews with Nr of reviews

#Summary statitics with boxplot of each numerical varibale

boxplot(body$Nr..reviews)
boxplot(body$Nr..hotel.reviews)
boxplot(body$Helpful.votes)
boxplot(body$Score)

boxplot(score,
        data=body,
        main="Boxplot of Scores Variable",
        ylab="Scores",
        col="steelblue",
        border="black"
)
boxplot(vegas$Rooms,
        data=vegas,
        main="Boxplot of Rooms Variable",
        ylab="Rooms",
        col="steelblue",
        border="black"
)

#Insights
ggplot(data = body) +
  geom_bar(mapping = aes(x = Traveler.type, fill = Pool )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  xlab(label = "Traveler Type")

ggplot(data = vegas) +
  geom_bar(mapping = aes(x = PeriodStay, fill = Traveler.type )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab(label = "Period of Stay")

ggplot(data = body) +
  geom_bar(mapping = aes(x = Traveler.type, fill = Gym )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab(label = "Traveler Type")

ggplot(data = body) +
  geom_bar(mapping = aes(x = Traveler.type, fill = User.continent)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
xlab(label = "Traveler Type")

ggplot(data = body) +
  geom_bar(
    mapping = aes(x = User.continent, fill = Hotel.stars),
    position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab(label = "User Continent")

ggplot(data = body) +
  geom_bar(
    mapping = aes(x = Traveler.type, fill = Hotel.stars),
    position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
xlab(label = "Traveler Type")


heatmap <- ggplot(data = body, mapping = aes(x = User.continent,
                                                       y = Hotel.stars,
                                                       fill = Traveler.type)) +
  geom_tile() +
  xlab(label = "User Continent") +
  ylab(label = "Hotel Stars")
heatmap

heatmap1 <- ggplot(data = vegas, mapping = aes(x = score,
                                             y = PeriodStay,
                                             fill = User.continent)) +
  geom_tile() +
  xlab(label = "Score") +
  ylab(label = "Period of Stay")
heatmap1
summary(vegas$PeriodStay)

#Just USA traffic
ggplot(data = USAtraffic) +
  geom_bar(
    mapping = aes(x = Traveler.type, fill = PeriodStay),
    position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Just using Paris Las Vegas Guests
ggplot(data = parisLV) +
  geom_bar(
    mapping = aes(x = User.continent, fill = PeriodStay),
    position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#But since only 24 observations here, insight may not be very accurate


#histograms + density plots
library(ggplot2)
ggplot(vegas, aes(Rooms, fill = Traveler.type)) + 
  
  geom_histogram(alpha = 0.5, position = 'identity') + 
  
  geom_histogram(binwidth=1)

ggplot(vegas, aes(Rooms, fill = Traveler.type)) + geom_density(alpha = 0.2)

ggplot(vegas, aes(Hotel.stars, fill = Traveler.type)) + geom_density(alpha = 0.2)

#High probability of couples staying in 5 star hotels, business travelers have a high probability of
#staying in 3 star hotels and family and friends have a high probability of staying in 1-2 star hotels

ggplot(vegas, aes(Score, fill = Traveler.type)) + geom_density(alpha = 0.2)



counts <- table(vegas$Traveler.type)
barplot(counts, 
        xlab="Types of Travelers")

#Couples are the highest types of travelers to vegas for this period anbd solo travelers are the least


av <- tapply(vegas$Hotel.stars, vegas$Pool, mean)
barplot(av)
#Hotels where they have pools, the average hotel stars is 3, and where they dont have pools the average hotel stars is 1


pie <- ggplot(vegas, aes(x = "", fill = factor(Spa))) + 
  geom_bar(width = 1) +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="Spa?", 
       x=NULL, 
       y=NULL, 
       title="Pie Chart of Spas", 
       caption="Source: mpg")
pie + coord_polar(theta = "y", start=0)

#Most hotels in vegas have spas, around 75% do

write.csv(vegas, "vegas1.csv")

str (body)

str(vegas$Hotel.name)





