


library(forecast)
library(ggplot2)
library(lubridate)

data <- read.csv("C:/Users/Jared Chung/Desktop/jaredchung_blog/content/data/beer_data_1992_2016.csv")

data$DATE <- dmy(data$DATE)

head(data)


ggplot(data, aes(DATE,value)) + 
      geom_line() + 
      scale_x_date(date_breaks = "3 year") +
      labs(x="date", y = "sales", title = "US Beer Sales 1992-2016")



