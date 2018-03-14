


library(forecast)
library(ggplot2)
library(lubridate)

data <- read.csv("C:/Users/Jared Chung/Desktop/jaredchung_blog/content/data/beer_data_1992_2016.csv")

data$DATE <- dmy(data$DATE)

head(data)


plot1 <- ggplot(data, aes(DATE,value)) + 
      geom_line() + 
      scale_x_date(date_breaks = "4 year") +
      labs(x="date", y = "sales", title = "US Beer Sales")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/postimg/testplot1.png",plot1
       ,height=7,width=7,dpi=300)

###########################################
# NAIVE
############################################

predict_naive <- data.frame(list(DATE=seq(data[nrow(data)-1,]$DATE+1,data[nrow(data)-1,]$DATE+(3*365),"month"),
                                value = rep(NA,36)))

predict_naive$value <- data[nrow(data)-1,]$value

naive <- rbind(data,predict_naive)

plot2 <- ggplot(naive, aes(DATE,value)) + 
  geom_line() + 
  scale_x_date(date_breaks = "4 year") +
  labs(x="date", y = "sales", title = "US Beer Sales")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/post_img/time_series_blog_plot2.jpeg",plot2
       ,height=7,width=7,dpi=300)


###########################################
# Simple Average
############################################


sim_avg <- data.frame(list(DATE=seq(data[nrow(data)-1,]$DATE+1,data[nrow(data)-1,]$DATE+(3*365),"month"),
                                 value = rep(NA,36)))

sim_avg$value <- mean(data$value)

simple_average <- rbind(data,sim_avg)

plot3 <- ggplot(simple_average, aes(DATE,value)) + 
  geom_line() + 
  scale_x_date(date_breaks = "4 year") +
  labs(x="date", y = "sales", title = "US Beer Sales")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/post_img/time_series_blog/plot3.png",plot3
       ,height=7,width=7,dpi=300)

###################
# Time Series data
###################


ts_data <- ts(data$value,start = c(1992, 1),frequency = 12)


###########################################
# Moving Average
############################################


mov_avg <- ma(ts_data, order = 12)

moving_average <- forecast(mov_avg, h = 36)

plot4<- autoplot(moving_average) + labs(title = "US Beer Sales")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/post_img/time_series_blog_plot4.jpeg",plot4
       ,height=7,width=7,dpi=300)

###########################################
# Exponential Smoothing
############################################

ses_model <- ses(ts_data, h = 36)

autoplot(ses_model) + labs(title = "US Beer Sales")

###########################################
# Holt winters
############################################


holt_winter <- hw(ts_data, h = 36)

autoplot(holt_winter) + labs(title = "US Beer Sales")

ets_model <- ets(ts_data)

ets_forecast <- forecast(ets_model, h = 36)

autoplot(ets_forecast) + labs(title = "US Beer Sales")

###########################################
# Arima
############################################


arima_model <- auto.arima(ts_data)

arima_forecast <- forecast(arima_model, h = 36)

autoplot(arima_forecast) + labs(title = "US Beer Sales")











