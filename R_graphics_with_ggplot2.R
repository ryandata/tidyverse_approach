# R graphics with ggplot2
# 
# Ryan Womack, rwomack@rutgers.edu
# 2019-10-02 version

install.packages("tidyverse")

# actually today we will just focus on ggplot...
install.packages("ggplot2")

# for a couple of comparisons, we will use lattice
install.packages("lattice")

# load packages
library(lattice)
library(ggplot2)
library(tidyverse)

# load data - diamonds dataset
data(diamonds)
?diamonds
attach(diamonds)

# load data - gender_stats - see R_for_Data_Analysis.R for details
download.file("https://databank.worldbank.org/data/download/Gender_Stats_csv.zip", "gender.zip")
unzip("gender.zip")
gender_data <- read_csv("Gender_StatsData.csv")
gender_data[1,1]
gender_data[1:10,1:6]
gender_data[1:10,-1]
names(gender_data)
gender_data <- gender_data[,c(-2,-4)]
names(gender_data)
gender_data2 <- pivot_longer(gender_data, 3:62, names_to = "Year", values_to = "Value")
gender_data2017 <-
  gender_data2 %>%
  filter(Year=="2017")
gender_data2017 <- gender_data2017[,-3]
gender_data2017wide <- 
  gender_data2017 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")

# base R
plot(price~carat)

plot(price~carat)
abline(lm(price~carat), col="red")

plot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
     ylab="price of diamond in dollars", xlim=c(0,3))

# lattice
xyplot(price~carat)
xyplot(price~carat, groups=cut)
xyplot(price~carat | cut + clarity)
xyplot(price~carat | cut , groups=clarity, auto.key=list(space="right"))

xyplot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
       ylab="price of diamond in dollars", xlim=c(0,3), scales=list(tick.number=10))


# ggplot
ggplot(diamonds, aes(carat,price)) + geom_point()

ggplot(diamonds, aes(carat,price)) + facet_grid(.~clarity) + geom_point()

ggplot(diamonds, aes(carat,price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 

# barchart
ggplot(diamonds, aes(cut)) + geom_bar(position="stack") 
ggplot(diamonds, aes(clarity) )+ geom_bar(position="stack") 
ggplot(diamonds, aes(clarity)) + facet_grid(.~cut) + geom_bar(position="dodge")


# save graph as R object
mygraph <- ggplot(diamonds, aes(carat,price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
	labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 

# export to PDF (or JPEG, PNG)

pdf(file="output.pdf")
ggplot(diamonds, aes(clarity)) + facet_grid(.~cut) + geom_bar(position="dodge")
ggplot(diamonds, aes(carat,price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data")dev.off()


ggplot(diamonds, aes(carat, price)) + geom_point() + geom_smooth(method=lm)

# ggvis and other enhancements

# show more of the capabilities()
