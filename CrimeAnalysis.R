#LA CRIME DATA ANALYSIS AND INSIGHTS- Over a million crime records from the past 10 years

arrests <- read.csv(file="arrests.csv", head = TRUE, sep=",")
head(arrests)
summary(arrests)

#DATA TRANSFORMATION

#Remove unecsseary variables
arrests$Report.ID <- NULL
arrests$Area.ID <- NULL
arrests$Reporting.District <- NULL
arrests$Charge.Group.Code <- NULL
arrests$Charge <- NULL

#Rename variables for conveniance
colnames(arrests)[1] <- "Date"
colnames(arrests)[3] <- "AreaName"
colnames(arrests)[5] <- "Sex"
colnames(arrests)[6] <- "Race"
colnames(arrests)[7] <- "Charge"
colnames(arrests)[8] <- "ArrestType"
colnames(arrests)[11] <- "CrossStreet"

#Extraxt year from date and append to dataframe
year <- str_sub(arrests$Date, 7, 10)
arrests$year <- year

#Extract month from date and append to dataframe
month <- str_sub(arrests$Date, 1, 2)
arrests$month <- month

#Convert numeric month to month name
month1 <- str_remove(month, "^0+")
arrests$month1 <- month1
y <- as.numeric(arrests$month1)
z <- month.abb[y]
arrests$z <- z
arrests$month1 <- NULL
arrests$month2 <- NULL
arrests$month <- NULL
colnames(arrests)[15] <- "Month"

#Extract day from date and append to dataframe
day <- str_sub(arrests$Date, 4, 5)
arrests$day <- day

#Convert military time to regular time
newdata1 <- format(strptime(substr(as.POSIXct(sprintf("%04.0f", arrests$Time), 
                                              format="%H%M"), 12, 16), '%H:%M'), '%I:%M %p')
arrests1 <- cbind(arrests, newdata1)
arrests1$Time <- NULL
colnames(arrests1)[15] <- "Time"

#Split numerical ages into categories such as adults, teens etc.
for(i in 1 : nrow(arrests1))
  if (arrests1$Age[i] < 20){
    arrests1$Age[i] = 'Teenagers'
  } else if (arrests1$Age[i] < 35 & arrests1$Age[i] > 19){
    arrests1$Age[i] = 'Young Adults'
  } else if (arrests1$Age[i] < 60 & arrests1$Age[i] > 34){
    arrests1$Age[i] = 'Adults'
  } else if (arrests1$Age[i] > 59){
    arrests1$Age[i] = 'Senior Citizens'
  }

#Subset the dataframe to extract only 2019, 2018 etc. observations
newdata2019 <- subset(arrests1, year == 2019)
newdata2018 <- subset(arrests1, year == 2018)
#Subset just the narcotics arrests
narcoticsdata <- subset(arrests1, Charge == 'Narcotic Drug Laws')
dui <- subset(arrests1, Charge == 'Driving Under Influence')

#Recode the variables into sometthing more readable
install.packages('tidyverse')
library(dplyr)
arrests1$Sex <- recode(arrests1$Sex, 'F' = 'Female', 'M' = 'Male')
arrests1$Race <- recode(arrests1$Race, "A" = "Other Asian", "B" = "Black", "C" = "Chinese", "D" = "Cambodian", "F" = "Filipino", "G" = "Guamanian", "H" = "Hispanci/Latin/Mexican", 'I' = "American Indian/Alaskan Native", "J" = "Japanese", "K" = "Korean", "L" = "Laotian", "O" = "Other", "P" = "Pacific Islander", "S" = "Somoan", "U" = "Hawaiian", "V" = "Vietnamese", "W" = "White", "X" = "Unknown", "Z" = "Asian Indian")
                
#DATA VISUALIZATION

#Top 5 Arrest streets
head(sort(table(arrests1$CrossStreet), decreasing = TRUE))
#Top 5 Arrest locations
head(sort(table(arrests1$AreaName), decreasing = TRUE))
#Top 5 Races
head(sort(table(arrests1$Race), decreasing = TRUE))
#Top 5 times for criminal activity
head(sort(table(arrests1$Time), decreasing = TRUE))
#Top 5 offences
head(sort(table(arrests1$Charge), decreasing = TRUE))

#criminal counts across gender and crime level
table1 <- table(arrests1$Sex, arrests1$ArrestType) 
ftable(table1)

#above table in percenatges
ftable(round(prop.table(table1), 2))

#percentages of gender
table2 <- table(arrests1$Sex)
prop.table(table2)

#criminal counts of race across crime level
table3 <- table(arrests1$Race, arrests1$ArrestType) 
ftable(table3)
ftable(round(prop.table(table3), 2))

#Crimes over the years
ggplot(data = arrests1) +
  stat_count(mapping = aes(x = year))

#Crimes over the months
ggplot(data = arrests1) +
  stat_count(mapping = aes(x = Month))

ggplot(data = arrests1) +
  stat_count(mapping = aes(x = Race)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Crime by location
ggplot(data = arrests1) +
  stat_count(mapping = aes(x = AreaName)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#location of just narcotics crimes
ggplot(data = narcoticsdata) +
  stat_count(mapping = aes(x = AreaName)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#Multiple variables graphs
#Location/Gender
ggplot(data = arrests1) +
  geom_bar(mapping = aes(x = AreaName, fill = Sex )) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) #vertical x axis labels

#Gender/Crime Types
ggplot(data = arrests1) +
  geom_bar(mapping = aes(x = Sex, fill = ArrestType )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) #vertical x axis labels

#Location/Race
ggplot(data = arrests1) +
  geom_bar(mapping = aes(x = AreaName, fill = Race )) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#DUI crimes by location/gender
ggplot(data = dui) +
  geom_bar(mapping = aes(x = AreaName, fill = Sex )) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#Top 5 times for DUI arrests
head(sort(table(dui$Time), decreasing = TRUE))
#Top 5 Streets for DUI's 
head(sort(table(dui$CrossStreet), decreasing = TRUE))


#Crimes in 2019 by gender break up
ggplot(data = newdata2019) +
  geom_bar(mapping = aes(x = Charge, fill = Sex )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#bar graph with counts on top of bars
ggplot(data=arrests1, aes(x=Race)) +
  geom_bar() +
  geom_text(stat='count', aes(label=..count..), vjust=-1)

#Location/Age groups
ggplot(data = newdata2019) +
  geom_bar(
    mapping = aes(x = AreaName, fill = Age),
    position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Pie Chart of Age
pie <- ggplot(arrests1, aes(x = "", fill = factor(Age))) + 
  geom_bar(width = 1) +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="Age", 
       x=NULL, 
       y=NULL, 
       title="Pie Chart of Age", 
       caption="Source: mpg")
pie + coord_polar(theta = "y", start=0)

#Crimes by age group in 2019
ggplot(data = newdata2019) +
  geom_bar(mapping = aes(x = Charge, fill = Age )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Crimes by race in 2019
ggplot(data = newdata2019) +
  geom_bar(mapping = aes(x = Charge, fill = Race )) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Time series graph
ggplot(data = newdata2019, mapping = aes(x = month)) +
  geom_freqpoly(mapping = aes(color = Sex), binwidth = 500)


