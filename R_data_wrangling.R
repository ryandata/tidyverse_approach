# R data wrangling with dplyr, tidyr, readr, and more
#
# Ryan Womack, rwomack@rutgers.edu
# 2023-02-08 version

# install packages
install.packages("tidyverse")

# load packages
library(tidyverse)

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
mydata

# read_excel command also imports .xls files
# writexl package can export/save Excel files from R

# haven
# for SPSS, Stata, and SAS data.
# "foreign" is the traditional R package for these formats

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
# like RSQLite, RPostgres, or odbc. Learn more at https://solutions.posit.co/connections/db/.

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
getOption("timeout")
options(timeout=6000)
download.file("https://databank.worldbank.org/data/download/Gender_Stats_CSV.zip", "gender.zip")
unzip("gender.zip")

gender_data <- read_csv("Gender_StatsData.csv")
names(gender_data)
gender_data <- gender_data[,c(-2,-4)]
names(gender_data)
gender_data <- gender_data[,-66]
names(gender_data)

# if you need to reduce the size of the data (for example, for Posit Cloud)
# try this
# gender_data <- gender_data[1:10000,]

# pivot_longer
# to create long format data

gender_data2 <-
   gender_data %>%
   pivot_longer(3:65, names_to = "Year", values_to = "Value")
# the "pipe"
# magrittr provides the pipe, %>% used throughout the tidyverse

gender_data2021 <-
  gender_data2 %>%
  filter(Year=="2021")

gender_data2021 <- gender_data2021[,-3]

# pivot_wider
# to create wide format data
gender_data2021wide <-
  gender_data2021 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")

# drop_na()
gender_data_drop_na <-
    gender_data2021wide %>%
    drop_na()
# be careful - here that dropped ALL cases

# complete() - powerful, but be careful
gender_data_complete <-
  gender_data2021wide %>%
  complete(fill=list(`A woman can apply for a passport in the same way as a man (1=yes; 0=no)`=0))

# nested models
mtcars_nested <-
  mtcars %>%
  group_by(cyl) %>%
  nest()

mtcars_nested

# peek at column 2, row 1 in detail
mtcars_nested[[2]][[1]]

mtcars_nested <-
  mtcars_nested %>%
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

gender_data2021wide <-
  gender_data2021wide %>%
  mutate(gdp_ratio = (`GDP per capita (Current US$)`/10000)/`Fertility rate, total (births per woman)`)

#return of drop_na
gender_data2021wide <-
  drop_na(gender_data2021wide, gdp_ratio)

plot(gender_data2021wide$gdp_ratio)

gender_data2021wide <-
  gender_data2021wide %>%
  mutate(hi_ratio = gdp_ratio>0.78)

attach(gender_data2021wide)

# select() picks variables based on their names.

gender_gdp <-
  select(gender_data2021wide, c(`Country Name`,starts_with("GDP")))

gender_gdp
write_csv(gender_gdp, "gender_gdp.csv")

# filter() picks cases based on their values.

gender_data2021filtered <-
  gender_data2021wide %>%
  filter(gdp_ratio>2)

gender_data2021filtered
write_csv(gender_data2021filtered, "gender_filtered.csv")

# summarise() reduces multiple values down to a single summary.

gender_data2021wide %>%
  summarise(mean = mean(gdp_ratio), n = n(), median = sqrt(median(gdp_ratio)))

# Usually, you'll want to group first
gender_data2021wide %>%
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


# Program

# purrr
# purrr enhances R’s functional programming (FP) toolkit
# by providing a complete and consistent set of tools for working with functions and vectors. Once you master the basic concepts, purrr allows you to replace many for loops with code that is easier to write and more expressive. Learn more ...
# starting with "map" family of functions

mtcars %>%
  split(.$cyl) %>% # from base R
  map(~ lm(mpg ~ wt, data = .)) %>%
  map(summary) %>%
  map_dbl("r.squared")

# In addition to purrr, which provides very consistent and natural methods
# for iterating on R objects, there are two additional tidyverse packages
# that help with general programming challenges:

# glue
# glue provides an alternative to paste()
# that makes it easier to combine data and strings.

# broom
# You may also find broom to be useful:
# it turns models into tidy data which you can then
# wrangle and visualise using the tools you already know.
# tidy, glance, and augment
# are the key functions

library(broom)

regoutput<-lm(`GDP per capita (constant 2010 US$)`~`Fertility rate, total (births per woman)`, gender_data2021wide)

# base R regression summary
summary(regoutput)

# broom variants
tidy(regoutput)
glance(regoutput)
augment(regoutput)

# a grouped example

regressions <- gender_data2021wide %>%
  group_by(hi_ratio) %>%
  nest() %>%
  mutate(
    fit = map(data, ~ lm(`GDP per capita (constant 2010 US$)`~`Fertility rate, total (births per woman)`, data=.x,)),
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment)
  )

regressions %>%
  unnest(tidied)

regressions %>%
  unnest(glanced)

regressions %>%
  unnest(augmented)

# For a more complete introduction, consult
# R for Data Science
# https://r4ds.hadley.nz/
