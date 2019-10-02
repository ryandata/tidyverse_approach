Dataframe v. tibble v. datatable

# load data - gender_stats - see R_for_Data_Analysis.R for details
download.file("https://databank.worldbank.org/data/download/Gender_Stats_csv.zip", "gender.zip")
unzip("gender.zip")
gender_data <- read_csv("Gender_StatsData.csv")
gender_data <- gender_data[,c(-2,-4)]
gender_data2 <- pivot_longer(gender_data, 3:62, names_to = "Year", values_to = "Value")
gender_data2017 <-
  gender_data2 %>%
  filter(Year=="2017")
gender_data2017 <- gender_data2017[,-3]
gender_data2017wide <- 
  gender_data2017 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")