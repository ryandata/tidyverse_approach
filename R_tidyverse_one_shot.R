# R, a tidyverse approach
# 90 minute "one shot" version
# selected highlights
# Ryan Womack, rwomack@rutgers.edu
# 2020-10-09 version

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
ls()

# install packages
install.packages("tidyverse", dependencies = TRUE)

# update packages
update.packages()

# load packages
library(tidyverse)

# check help again
?tidyverse
library(help=tidyverse)
??tidy
# also see https://tidyverse.org for complete documentation

# get data
data(diamonds)
?diamonds
attach(diamonds)

# matrix notation [row,column]
diamonds[1,1]
diamonds[1:10,1:6]
diamonds[1:10,-1]

# variable/column names
names(diamonds)

# get information about data with summary
ls()
summary(diamonds)

# summarise is the tidyverse way, from dplyr
diamonds %>%
  summarise_if(is.numeric, mean, na.rm=TRUE)

# ls lists items in the workspace, while rm removes them
# do not execute the command below unless you are sure! removes all files!
# rm(list = ls())

# computing a new variable 
diamonds$price_per_carat <- price/carat
attach(diamonds)
summary(price_per_carat)
plot(price_per_carat)
plot(price_per_carat ~ x)

# R has a range of quick functions for descriptive statistics
sd(price_per_carat)  
sd(price_per_carat, na.rm=TRUE)
var(price_per_carat, na.rm=TRUE)
median(price_per_carat, na.rm=TRUE)
quantile(price_per_carat, na.rm=TRUE)

# even a histogram
hist(price_per_carat)

# creating a quick table to count observations
table(cut)
table(cut,clarity)

# statistical tests in R are easy if you locate the correct command (in the help)
# t-test usage illustrated below
t.test(price_per_carat)
t.test(price_per_carat, mu=4000)
t.test(price_per_carat, mu=3900, conf.level=.99)
?t.test

# other tests like chisq.test are easily available
# consult the help

# linear regression
lm(price_per_carat~x)
# with no intercept, add -1
lm(price_per_carat~x-1)

# to get full regression output, use summary
summary(lm(price_per_carat~x))

# multiple explanatory variables? just use +
summary(lm(price_per_carat~x+y))

# we can store (and use) a regression output as an R object
regoutput<-lm(price_per_carat~x)
names(regoutput)
regoutput$residuals

# numerous quick functions are available to build off of the regression results

# predicted values
predict(regoutput)

# analysis of variance (anova)
anova(regoutput)

# we can also easily pull up regression diagnostic plots
plot(regoutput, pch=3)

# R graphics with ggplot2

# one extra package for this section
install.packages("RColorBrewer")
library(RColorBrewer)

# base R
plot(price~carat)
abline(lm(price~carat), col="red")

plot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
     ylab="price of diamond in dollars", xlim=c(0,3))

# ggplot
ggplot(diamonds, aes(x=carat,y=price)) + geom_point()

ggplot(diamonds, aes(x=carat,y=price)) + facet_wrap(clarity) + geom_point()

ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut))

ggplot(diamonds, aes(x=carat,y=price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 


# save graph as R object
mygraph <- ggplot(diamonds, aes(x=carat,y=price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 

# export to PDF (or JPEG, PNG)
pdf(file="output.pdf")
ggplot(diamonds, aes(clarity)) + facet_grid(.~cut) + geom_bar(position="dodge")
ggplot(diamonds, aes(x=carat,y=price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data")
dev.off()

jpeg(file="output.jpg", width = 800, height = 600, quality=100)
ggplot(diamonds, aes(depth))+geom_histogram(aes(fill = ..count..))
dev.off()

# histogram
ggplot(diamonds, aes(depth))+geom_histogram()
ggplot(diamonds, aes(depth))+geom_histogram(aes(fill = ..count..))

# using the power
mydata <- ggplot(diamonds, aes(clarity)) +facet_grid(.~cut) 
mytheme <- theme(panel.background = element_rect(fill='lightblue', colour='darkgrey'))
mychart <- geom_bar(position="dodge", fill="thistle", color="black")

mydata+mytheme+mychart

# regression
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth(method=lm)
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + stat_smooth()
ggplot(mtcars, aes(x=mpg, y=disp)) + geom_point() + stat_smooth()

# for more information see
# ggplot docs at https://ggplot2.tidyverse.org/
# ggplot extensions at https://exts.ggplot2.tidyverse.org/
# ggplot2 book (via link.springer.com)

# R data wrangling with dplyr, tidyr, readr, and more

# "base" tidyverse includes
# ggplot2, which we've already seen 
# readr, purrr, forcats, stringr, dplyr, tibble, tidyr
# which focus on data manipulation

# Importing data

# readr
# importing data with readr
# start with a tab-separated file
download.file("https://ryanwomack.com/data/myfile.txt", "myfile.txt")
mydata <- read_tsv("myfile.txt")
mydata

# later we will see read_csv

# see readr.tidyverse.org for complete details

# As well as readr, for reading flat files, the tidyverse includes:

# readxl for .xls and .xlsx sheets.

# install.packages("readxl")
library(readxl)

download.file("https://ryanwomack.com/data/mydata.xlsx", "mydata.xlsx")
mydata<-read_excel("mydata.xlsx", 1)
# read_excel command also imports .xls files
# writexl package can export/save Excel files from R

# haven 
# for SPSS, Stata, and SAS data.

# googledrive 
# allows you to interact with files on Google Drive from R.

# the following are not in the tidyverse, but are useful

# jsonlite
# for JSON.

# xml2 
# for XML.

# httr 
# for web APIs.

# rvest 
# for web scraping.

# DBI 
# for relational databases. 
# To connect to a specific database, 
# you’ll need to pair DBI with a specific backend 
# like RSQLite, RPostgres, or odbc. Learn more at https://db.rstudio.com.

# rclone
# for working with cloud sites like AWS

# tibble
# https://tibble.tidyverse.org/
# the tibble is a "better-behaved" data.frame, at least in some ways
# data.frame is the traditional R data structure
# many packages still expect it

library(tibble)

# "as" functions in R convert back and forth between formats
# "." notation in base R, "_" notation in tidyverse
as.data.frame(mydata)
as_tibble(iris)

# data.table
# not a part of tidyverse

# https://github.com/Rdatatable/data.table

# high performance version of data.frame suitable for big data applications
# fread to import data

# tidyr
# https://tidyr.tidyverse.org

# The goal of tidyr is to help you create tidy data. Tidy data is data where:

# Every column is a variable.
# Every row is an observation.
# Every cell is a single value.

# load data - gender_stats - see R_for_Data_Analysis.R for details
download.file("https://databank.worldbank.org/data/download/Gender_Stats_csv.zip", "gender.zip")
unzip("gender.zip")
gender_data <- read_csv("Gender_StatsData.csv")
gender_data <- gender_data[,c(-2,-4)]
gender_data <- gender_data[,1:63]

# if you need to reduce the size of the data (for example, for RStudio Cloud)
# try this
# gender_data <- gender_data[1:10000,]

# pivot_longer 
# to create long format data
gender_data2 <- pivot_longer(gender_data, 3:63, names_to = "Year", values_to = "Value")

# the "pipe"
# magrittr provides the pipe, %>% used throughout the tidyverse

gender_data2017 <-
  gender_data2 %>%
  filter(Year=="2017")

gender_data2017 <- gender_data2017[,-3]

# pivot_wider 
# to create wide format data
gender_data2017wide <- 
  gender_data2017 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")


# nested models
mtcars_nested <- mtcars %>% 
  group_by(cyl) %>% 
  nest()

mtcars_nested

# peek at column 2, row 1 in detail
mtcars_nested[[2]][[1]]

mtcars_nested <- mtcars_nested %>% 
  mutate(model = map(data, function(df) lm(mpg ~ wt, data = df)))
mtcars_nested
mtcars_nested$model

mtcars_nested <- mtcars_nested %>% 
  mutate(model = map(model, predict))
mtcars_nested$model


# dplyr
# https://dplyr.tidyverse.org


# dplyr is a grammar of data manipulation, 
# providing a consistent set of verbs 
# that help you solve the most common data manipulation challenges:

# mutate() adds new variables that are functions of existing variables

gender_data2017wide <- gender_data2017wide %>%
  mutate(gdp_ratio = (`GDP per capita (Current US$)`/10000)/`Fertility rate, total (births per woman)`)

#drop_na
gender_data2017wide <- drop_na(gender_data2017wide, gdp_ratio)

plot(gender_data2017wide$gdp_ratio)

gender_data2017wide <- gender_data2017wide %>%
  mutate(hi_ratio = gdp_ratio>0.78)

attach(gender_data2017wide)

# select() picks variables based on their names.

gender_gdp <-
  select(gender_data2017wide, c(`Country Name`,starts_with("GDP")))

gender_gdp
write_csv(gender_gdp, "gender_gdp.csv")

# filter() picks cases based on their values.

gender_data2017filtered <-
  gender_data2017wide %>%
  filter(gdp_ratio>2)

gender_data2017filtered
write_csv(gender_data2017filtered, "gender_filtered.csv")

# summarise() reduces multiple values down to a single summary.

gender_data2017wide %>%
  summarise(mean = mean(gdp_ratio), n = n())

# Usually, you'll want to group first
gender_data2017wide %>%
  group_by(hi_ratio) %>%
  summarise(mean = mean(gdp_ratio, na.rm=TRUE), n = n())

# see http://www.milanor.net/blog/aggregation-dplyr-summarise-summarise_each/
# for some more options


# arrange() changes the ordering of the rows.

gender_gdp <-
  gender_gdp %>% 
  arrange(desc(gdp_ratio))

gender_gdp$gdp_ratio
write_csv(gender_gdp, "gender_gdp.csv")

# These all combine naturally with group_by() 
# which allows you to perform any operation “by group”. 
# You can learn more about them in vignette("dplyr"). 
# As well as these single-table verbs, 
# dplyr also provides a variety of two-table verbs, 
# which you can learn about in vignette("two-table").

# Wrangle
# In addition to tidyr, and dplyr, 
# there are five packages which are designed 
# to work with specific types of data:

# lubridate 
# for dates and date-times.

# hms 
# for time-of-day values.

# blob 
# for storing blob (binary) data.

# stringr
# stringr provides a cohesive set of functions 
# designed to make working with strings as easy as possible. 

# forcats
# forcats provides a suite of useful tools 
# that solve common problems with factors. 
# R uses factors to handle categorical variables, 

# For a more complete introduction, consult
# R for Data Science
# https://r4ds.had.co.nz/