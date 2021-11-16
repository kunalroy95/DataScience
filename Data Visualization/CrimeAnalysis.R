arrests <- read.csv(file="arrests.csv", head = TRUE, sep=",")
head(arrests)
arrests$Report.ID <- NULL
arrests$Area.ID <- NULL
arrests$Reporting.District <- NULL
arrests$Descent.Code <- NULL

newdata <- arrests[1:1000,]
newdata1 <- arrests[1000:100000,]
newdata2 <- arrests[1000:30000,]

summary(arrests$Charge.Group.Description)
plot(newdata$Charge.Group.Description)
plot(newdata$Sex.Code)

mean(arrests$Age)
range(arrests$Age)
range(arrests$Age[arrests$Age > 10])

#criminal counts across location by gender and crime level
table1 <- table(arrests$Sex.Code, arrests$Arrest.Type.Code) 
ftable(table1)

#above table in percenatges
ftable(round(prop.table(table1), 2))

#percentages of gender
table2 <- table(arrests$Sex.Code)
prop.table(table2)

#Most common offences
head(sort(table(arrests$Charge.Group.Description), decreasing = TRUE))

#Top 5 Arrest locations
head(sort(table(arrests$Cross.Street), decreasing = TRUE))
#Need more patroling on certain streets and locations

#Mostly distributed between age of 20 and 30
hist(arrests$Age, nc = 100)

#Extract year from date by converting date into date class
newdata1$Arrest.Date  = as.Date(newdata1$Arrest.Date, "%m/%d/%Y")
newdata1$Arrest.Date = as.numeric(format(newdata1$Arrest.Date, "%Y"))

#Extraxt year from date
str_sub(arrests$Arrest.Date, 7, 10)
year <- str_sub(arrests$Arrest.Date, 7, 10)
arrests$year <- year

#Crimes over the years (has declines in the last few years)
ggplot(data = arrests) +
  stat_count(mapping = aes(x = year))


#Convert military time to regular time
newdata3 <- format(strptime(substr(as.POSIXct(sprintf("%04.0f", arrests$Time), 
                                  format="%H%M"), 12, 16), '%H:%M'), '%I:%M %p')
newdata4 <- cbind(arrests, newdata3)

dim(newdata4)
#change column name
colnames(newdata4)[18] <- "Standard_Time"

#Plot of crimes by time
ggplot(data = newdata4) +
  stat_count(mapping = aes(x = Standard_Time)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

#Top 5 times for crimes
head(sort(table(newdata4$Standard_Time), decreasing = TRUE))


ggplot(newdata1) + geom_bar(aes(x = Sex.Code))

#Split numerical ages into categories such as adults, teens etc.
for(i in 1 : nrow(newdata1))
  if (newdata1$Age[i] < 20){
    newdata1$Age[i] = 'Teenagers'
  } else if (newdata1$Age[i] < 35 & newdata1$Age[i] > 19){
    newdata1$Age[i] = 'Young Adults'
  } else if (newdata1$Age[i] < 60 & newdata1$Age[i] > 34){
    newdata1$Age[i] = 'Adults'
  } else if (newdata1$Age[i] > 59){
    newdata1$Age[i] = 'Senior Citizens'
  }

table(newdata1$Arrest.Date)

table(newdata1$Area.Name)

table(arrests$Area.Name)

table(arrests$Arrest.Type.Code)

line(newdata1$Arrest.Date)

#Can explore: Age of crime, sex of criminals, location of crimes, 
#popular crimes, popular crime by time of the day, 
#crime trend over the years/months/days, is it a felony/misdemeanor.infraction
# What is the most popular crime by area? What is the most popular crime by age group?

#Extract month from date
install.packages("stringr")
library(stringr)
str_sub(newdata1$Arrest.Date, 1, 2)
month<- str_sub(newdata1$Arrest.Date, 1, 2)
newdata1$month <- month

#Crime by location
ggplot(data = newdata1) +
  stat_count(mapping = aes(x = Area.Name)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(data = newdata1) +
  stat_count(mapping = aes(x = Sex.Code))

#numbers of arrests by month
ggplot(data = newdata1) +
  stat_count(mapping = aes(x = month))

#number of arrests by year
ggplot(data = newdata1) +
  stat_count(mapping = aes(x = Arrest.Date))

#multiple variables graph
ggplot(data = newdata1) +
  geom_bar(mapping = aes(x = Arrest.Type.Code, fill = Sex.Code )) 

#Crimes over the years split up into male/female(to give macro picture)
ggplot(data = arrests) +
  geom_bar(mapping = aes(x = year, fill = Sex.Code ))

#Crime over the years split up into felony/misdemeanor(to give macro picture)
ggplot(data = arrests) +
  geom_bar(mapping = aes(x = year, fill = Arrest.Type.Code ))

ggplot(data = newdata2) +
  geom_bar(mapping = aes(x = Charge.Group.Description, fill = Age )) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(data = newdata2) +
  geom_bar(mapping = aes(x = Cross.Street, fill = Age )) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggplot(data = newdata2) +
  geom_bar(
    mapping = aes(x = Area.Name, fill = Age),
    position = "dodge"
  )

#Time series graph
ggplot(data = newdata1, mapping = aes(x = month)) +
  geom_freqpoly(mapping = aes(color = Sex.Code), binwidth = 500)


#Pie Graph
pie <- ggplot(newdata2, aes(x = "", fill = factor(Age))) + 
  geom_bar(width = 1) +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="Age", 
       x=NULL, 
       y=NULL, 
       title="Pie Chart of Age", 
       caption="Source: mpg")
pie + coord_polar(theta = "y", start=0)
