# R for Data Analysis
# A tidyverse approach
# Ryan Womack, rwomack@rutgers.edu
# 2019-09-25 version

# install packages
install.packages("tidyverse")

# update packages
update.packages()

# load packages
library(tidyverse)

# grab data
# the is the World Bank Gender Statstics database
download.file("https://databank.worldbank.org/data/download/Gender_Stats_csv.zip", "gender.zip")
unzip("gender.zip")

# this is the base R read command
# gender_data<-read.csv("Gender_StatsData.csv")
# from tidyverse, read_csv is a simpler alternative
gender_data <- read_csv("Gender_StatsData.csv")

# matrix notation [row,column]
gender_data[1,1]
gender_data[1:10,1:6]
gender_data[1:10,-1]

# drop columns
names(gender_data)
gender_data <- gender_data[,c(-2,-4)]
names(gender_data)

# from tidyr
# gather and spread used to be the commands to generate long or wide data
# these are no longer being developed
# pivot_longer and pivot_wider are the future

# create data in long form
gender_data2 <- pivot_longer(gender_data, 3:62, names_to = "Year", values_to = "Value")

# alternative with pipes is below

# gender_data3 <- 
#   gender_data %>%
#   pivot_longer(3:62, names_to = "Year", values_to = "Value")

#filter
gender_data2017 <-
  gender_data2 %>%
  filter(Year=="2017")

gender_data2017 <- gender_data2017[,-3]

gender_data2017wide <- 
  gender_data2017 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")

# if we wanted to write output, we use a write function like write.csv
# write.csv(gender_data2017wide,"genderout.csv")


# now that we have created the dataset
# let's look at a few preliminaries before analyzing the data

# R is case sensitive
Getwd()
getwd()
getwd

# the console as calculator
2+2


# creating your own functions is easy
funkyadd<-function(x,y)
{
  x+y+1
}
funkyadd(2,2)


# R has a full range of statistical methods such as sampling and probability distributions
sample(1:100,10)
rnorm(10)
rnorm(10, mean=100, sd=20)

# the R help system is easy to access
?sample
?rnorm
?tidyverse
library(help=tidyverse)
??tidy

# get information about data with summary
ls()
summary(gender_data)
summary(gender_data2017)
summary(gender_data2017wide)

# summarise is the tidyverse way, from dplyr
gender_data2017wide %>%
  summarise_if(is.numeric, mean, na.rm=TRUE)

# ls lists items in the workspace, while rm removes them
# do not execute the command below unless you are sure! removes all files!
# rm(list = ls())


# studying the life expectancy variable
mean(gender_data2017wide$`Life expectancy at birth, female (years)`, na.rm=TRUE)
summary(gender_data2017wide$`Life expectancy at birth, female (years)`, na.rm=TRUE)

# attaching data
attach(gender_data2017wide)
mean(`Life expectancy at birth, female (years)`, na.rm=TRUE)
mean(`Life expectancy at birth, male (years)`, na.rm=TRUE)
summary(`Life expectancy at birth, female (years)`, na.rm=TRUE)
summary(`Life expectancy at birth, male (years)`, na.rm=TRUE)

# visualizing the data (very briefly)
plot(`Life expectancy at birth, female (years)`~`Life expectancy at birth, male (years)`)
abline(0,1)

# computing a new variable 
lifespread <- `Life expectancy at birth, female (years)` - `Life expectancy at birth, male (years)`
mean(lifespread, na.rm=TRUE)
summary(lifespread, na.rm=TRUE)
plot(lifespread)
plot(lifespread~`GDP per capita (constant 2010 US$)`)

# R has a range of quick functions for descriptive statistics
sd(lifespread)  # generates error
sd(lifespread, na.rm=TRUE)
var(lifespread, na.rm=TRUE)
median(lifespread, na.rm=TRUE)
quantile(lifespread, na.rm=TRUE)
summary(lifespread, na.rm=TRUE)

# even a histogram
hist(lifespread)


# creating a quick table to count observations
table(`Country Name`)

# we can create categorical variables
gender_data2017wide$hi_spread <- lifespread>5
gender_data2017wide$hi_age <- `Life expectancy at birth, female (years)`>78

# reattaching the data to make the freshly computed variables available 
attach(gender_data2017wide)

# table and cross-tab on the categorical data
table(hi_spread)
table(hi_age)
table(hi_spread,hi_age)

# statistical tests in R are easy if you locate the correct command (in the help)
# t-test usage illustrated below
t.test(lifespread)
t.test(lifespread, mu=5)
t.test(lifespread, mu=4, conf.level=.99)
?t.test

# a two-sample t-test
t.test(lifespread~hi_age)

# we can also test
t.test(`Life expectancy at birth, female (years)`,`Life expectancy at birth, male (years)`)

# other tests like chisq.test are easily available
# consult the help

# linear regression
lm(lifespread~`GDP per capita (constant 2010 US$)`)
# with no intercept, add -1
lm(lifespread~`GDP per capita (constant 2010 US$)`-1)

# checking additional relationships
lm(lifespread~`Fertility rate, total (births per woman)`)
lm(`Fertility rate, total (births per woman)`~`GDP per capita (constant 2010 US$)`)


# to get full regression output, use summary
summary(lm(lifespread~`GDP per capita (constant 2010 US$)`))
summary(lm(lifespread~`Fertility rate, total (births per woman)`))
summary(lm(`Fertility rate, total (births per woman)`~`GDP per capita (constant 2010 US$)`))

# multiple explanatory variables? just use +
summary(lm(`Fertility rate, total (births per woman)`~`GDP per capita (constant 2010 US$)`+lifespread))

# we can store (and use) a regression output as an R object
regoutput<-lm(`Fertility rate, total (births per woman)`~`GDP per capita (constant 2010 US$)`+lifespread)
names(regoutput)
regoutput$residuals

# numerous quick functions are available to build off of the regression results

# predicted values
predict(regoutput)

# analysis of variance (anova)
anova(regoutput)

# correlation
cor(lifespread,`Fertility rate, total (births per woman)`)
cor(lifespread,`Fertility rate, total (births per woman)`, na.rm=TRUE)
# why won't those first two work? 
# defaults and options of R commands are not very standardized
cor(lifespread,`Fertility rate, total (births per woman)`, use="complete.obs")
cor.test(lifespread,`Fertility rate, total (births per woman)`)

# we can also easily pull up regression diagnostic plots
plot(regoutput, pch=3)
