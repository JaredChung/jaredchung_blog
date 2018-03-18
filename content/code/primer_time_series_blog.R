


library(forecast)
library(ggplot2)
library(lubridate)
library(caret)

data <- read.csv("C:/Users/Jared Chung/Desktop/jaredchung_blog/content/data/beer_data_1992_2016.csv")

data$DATE <- dmy(data$DATE)

train <- data[data$DATE <= "2012-12-01",]
test <- data[data$DATE > "2012-12-01",]


head(data)


ggplot(data, aes(DATE,value)) + 
      geom_line() + 
      scale_x_date(date_breaks = "4 year") +
      labs(x="date", y = "sales", title = "US Beer Sales")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/postimg/testplot1.png",plot1
       ,height=7,width=7,dpi=300,scale = 1)

###########################################
# NAIVE
############################################


predict_naive <- data.frame(DATE = test$DATE, 
                            value = rep(train[nrow(train),]$value,nrow(test)))


ggplot(data=data, aes(DATE,value),colour = 'black') + 
  geom_line() + 
  geom_line(data=predict_naive,aes(DATE,value),colour = "red") +
  scale_x_date(date_breaks = "4 year") +
  labs(x="date", y = "sales", title = "US Beer Sales - Naive")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/post_img/time_series_blog_plot2.jpeg",plot2
       ,height=7,width=7,dpi=300)


###########################################
# Simple Average
############################################



sim_avg <- data.frame(DATE = test$DATE, 
                            value = rep(mean(test$value),nrow(test)))



ggplot(data, aes(DATE,value)) + 
  geom_line() + 
  scale_x_date(date_breaks = "4 year") +
  geom_line(data=sim_avg,aes(DATE,value),colour = "red") + 
  labs(x="date", y = "sales", title = "US Beer Sales - Simple Average")

ggsave("C:/Users/Jared Chung/Desktop/jaredchung_blog/static/img/post_img/time_series_blog/plot3.png",plot3
       ,height=7,width=7,dpi=300)

###################
# Time Series data
###################


ts_data <- ts(data$value,start = c(1992, 1), frequency = 12)

train_ts <- window(ts_data, start = c(1992,1), end = c(2012,12))

test_ts <- window(ts_data, start = c(2013,1))

###########################################
# Moving Average
############################################


mov_avg <- ma(ts_data, order = 12)

moving_average <- forecast(mov_avg, h = 36)

autoplot(moving_average) + labs(title = "US Beer Sales - Moving Average")

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











