# R graphics with ggplot2
# 
# Ryan Womack, rwomack@rutgers.edu
# 2019-10-02 version

# we will need the tidyverse again
install.packages("tidyverse")

# actually today we will just focus on ggplot and a few extensions
install.packages("ggplot2")
install.packages("ggridges")
install.packages("ggvis")
install.packages("ggthemes")
install.packages("gganimate")
install.packages("gapminder")
install.packages("cowplot")

# for a couple of comparisons, we will use lattice
install.packages("lattice")

# also for the Anscombe example
install.packages("grid")
install.packages("gridExtra")

# plus RColorBrewer, if not already installed
install.packages("RColorBrewer")

# load packages
library(lattice)
library(ggplot2)
library(ggridges)
library(ggvis)
library(ggthemes)
library(cowplot)
library(gapminder)
library(gganimate)
library(dplyr)
library(tidyverse)
library(grid)
library(gridExtra)
library(RColorBrewer)

# Anscombe's quartet can help us see why data visualization is important
# code from https://github.com/seandolinar/stats.seandolinar.com-Tutorials/blob/master/correlation-introduction.R

data(anscombe)

#correlation
cor1 <- format(cor(anscombe$x1, anscombe$y1), digits=4)
cor2 <- format(cor(anscombe$x2, anscombe$y2), digits=4)
cor3 <- format(cor(anscombe$x3, anscombe$y3), digits=4)
cor4 <- format(cor(anscombe$x4, anscombe$y4), digits=4)

#define the OLS regression
line1 <- lm(y1 ~ x1, data=anscombe)
line2 <- lm(y2 ~ x2, data=anscombe)
line3 <- lm(y3 ~ x3, data=anscombe)
line4 <- lm(y4 ~ x4, data=anscombe)

circle.size = 5
colors = list('red', '#0066CC', '#4BB14B', '#FCE638')

#plot1
plot1 <- ggplot(anscombe, aes(x=x1, y=y1)) + geom_point(size=circle.size, pch=21, fill=colors[[1]]) +
  geom_abline(intercept=line1$coefficients[1], slope=line1$coefficients[2]) +
  annotate("text", x = 12, y = 5, label = paste("correlation = ", cor1))

#plot2
plot2 <- ggplot(anscombe, aes(x=x2, y=y2)) + geom_point(size=circle.size, pch=21, fill=colors[[2]]) +
  geom_abline(intercept=line2$coefficients[1], slope=line2$coefficients[2]) +
  annotate("text", x = 12, y = 3, label = paste("correlation = ", cor2))

#plot3
plot3 <- ggplot(anscombe, aes(x=x3, y=y3)) + geom_point(size=circle.size, pch=21, fill=colors[[3]]) +
  geom_abline(intercept=line3$coefficients[1], slope=line3$coefficients[2]) +
  annotate("text", x = 12, y = 6, label = paste("correlation = ", cor3))

#plot4
plot4 <- ggplot(anscombe, aes(x=x4, y=y4)) + geom_point(size=circle.size, pch=21, fill=colors[[4]]) +
  geom_abline(intercept=line4$coefficients[1], slope=line4$coefficients[2]) +
  annotate("text", x = 15, y = 6, label = paste("correlation = ", cor4))

grid.arrange(plot1, plot2, plot3, plot4, top='Anscombe Quadrant -- Correlation Demostration')


# load data - diamonds dataset
data(diamonds)
?diamonds
attach(diamonds)

# base R
plot(price~carat)

plot(price~carat)
abline(lm(price~carat), col="red")

plot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
     ylab="price of diamond in dollars", xlim=c(0,3))

# lattice
xyplot(price~carat)
xyplot(price~carat | cut)
xyplot(price~carat, groups=cut)
xyplot(price~carat | cut + clarity)
xyplot(price~carat | cut , groups=clarity, auto.key=list(space="right"))

xyplot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
       ylab="price of diamond in dollars", xlim=c(0,3), scales=list(tick.number=10))


# ggplot
ggplot(diamonds, aes(x=carat,y=price)) + geom_point()

ggplot(diamonds, aes(x=carat,y=price)) + facet_wrap(clarity) + geom_point()

ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut))

ggplot(diamonds, aes(x=carat,y=price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 

# barchart
ggplot(diamonds, aes(cut)) + geom_bar(position="stack") 
ggplot(diamonds, aes(clarity) )+ geom_bar(position="stack") 
ggplot(diamonds, aes(clarity)) + facet_grid(.~cut) + geom_bar(position="dodge")


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
mydata+mytheme+mychart
dev.off()

# histogram
ggplot(diamonds, aes(depth))+geom_histogram()
ggplot(diamonds, aes(depth))+geom_histogram(aes(fill = ..count..))

# theme tweaks
ggplot(diamonds, aes(clarity)) +facet_grid(.~cut) + geom_bar(position="dodge", fill="purple")+theme(panel.background = element_rect(fill='pink', colour='green'))
ggplot(diamonds, aes(clarity)) +facet_grid(.~cut) + geom_bar(position="dodge")+theme(panel.background = element_rect(fill='white', colour='black'))
ggplot(diamonds, aes(x=clarity, fill=clarity)) +facet_grid(.~cut) + geom_bar(position="dodge")+ scale_fill_brewer(palette="Reds")

# this option can be used in some contexts
# scale_color_manual(values = c("yellow","orange","pink","red","purple"))

# using the power
mydata <- ggplot(diamonds, aes(clarity)) +facet_grid(.~cut) 
mytheme <- theme(panel.background = element_rect(fill='lightblue', colour='darkgrey'))
mychart <- geom_bar(position="dodge", fill="thistle", color="black")

mydata+mytheme+mychart

# regression
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth(method=lm)
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + stat_smooth()
ggplot(mtcars, aes(x=mpg, y=disp)) + geom_point() + stat_smooth()
# we can also plot customized confidence interval bands, but this requires computing them separately [see ggplot2 help]

# violin plot 
ggplot(diamonds, aes(x=cut, y=price)) + geom_violin()
ggplot(diamonds, aes(x=clarity, y=price)) + geom_violin()
ggplot(diamonds, aes(x=color, y=price)) + geom_violin()

# box plot
ggplot(diamonds, aes(x=color, y=price)) + geom_boxplot()
ggplot(diamonds, aes(x=color, y=price)) + geom_boxplot() + coord_flip()

# density plot and ggridges
ggplot(diamonds, aes(x=carat)) + geom_density() 
ggplot(diamonds, aes(x=carat, fill=clarity, color=clarity)) + geom_density() 
ggplot(diamonds, aes(x=carat, fill=clarity, color=clarity)) + geom_density(alpha=0.3, aes(y=..scaled..)) 

ggplot(diamonds, aes(x=carat, y=clarity)) + geom_density_ridges() 
ggplot(diamonds, aes(x=price)) + geom_density() 
ggplot(diamonds, aes(x=price, y=clarity)) + geom_density_ridges() 

# hexbin
ggplot(diamonds, aes(x=carat, y=price)) + geom_hex() 

# getting fancy
# first with scales
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth()
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

# then with color
ggplot(diamonds, aes(x=carat, y=price, color="purple")) + geom_point() + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(color="purple") + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth(color="purple") + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut)) + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point(color="purple") + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

# then with ggthemes (see also ggsci, ggthemr)
lastplot <- ggplot(diamonds, aes(x=carat,y=price)) + xlim(0,3) + geom_point(aes(color=cut)) + stat_smooth() + 
  labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 

lastplot + theme_bw()
lastplot + theme_cowplot()
lastplot + theme_dark()
lastplot + theme_economist()
lastplot + theme_fivethirtyeight()
lastplot + theme_tufte()
lastplot + theme_wsj()

# then with Rcolorbrewer
lastplot + theme_cowplot() + scale_color_brewer(palette = "Dark2")
lastplot + theme_tufte() + scale_color_brewer(palette = "Set3")
lastdensity <-ggplot(diamonds, aes(x=carat, fill=clarity, color=clarity)) + geom_density(alpha=0.3, aes(y=..scaled..)) 
lastdensity + theme_cowplot() + scale_fill_brewer(palette = "Dark2") + scale_color_brewer(palette = "Dark2")
lastdensity + theme_tufte() + scale_fill_brewer(palette = "Set3") + scale_color_brewer(palette = "Set3")


#ggvis
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_smooths(span = input_slider(0.5, 1, value = 1)) %>%
  layer_points(size := input_slider(100, 1000, value = 100))

mtcars %>% ggvis(x = ~wt) %>%
  layer_densities(
    adjust = input_slider(.1, 2, value = 1, step = .1, label = "Bandwidth adjustment"),
    kernel = input_select(
      c("Gaussian" = "gaussian",
        "Epanechnikov" = "epanechnikov",
        "Rectangular" = "rectangular",
        "Triangular" = "triangular",
        "Biweight" = "biweight",
        "Cosine" = "cosine",
        "Optcosine" = "optcosine"),
      label = "Kernel")
  )

# gganimate

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')


# for more information see
# ggplot docs at https://ggplot2.tidyverse.org/
# ggplot extensions at https://www.ggplot2-exts.org/
# ggplot2 book (via link.springer.com)