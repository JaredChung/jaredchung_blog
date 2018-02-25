


library(forecast)
library(ggplot2)
library(lubridate)

data <- read.csv("C:/Users/Jared Chung/Desktop/jaredchung_blog/content/data/beer_data_1992_2016.csv")

data$DATE <- dmy(data$DATE)

head(data)


ggplot(data, aes(DATE,value)) + 
      geom_line() + 
      scale_x_date(date_breaks = "3 year") +
      labs(x="date", y = "sales", title = "US Beer Sales")

###########################################
# NAIVE
############################################

predict_naive <- data.frame(list(DATE=seq(data[nrow(data)-1,]$DATE+1,data[nrow(data)-1,]$DATE+(3*365),"month"),
                                value = rep(NA,36)))

predict_naive$value <- data[nrow(data)-1,]$value

naive <- rbind(data,predict_data)

ggplot(method_1, aes(DATE,value)) + 
  geom_line() + 
  scale_x_date(date_breaks = "3 year") +
  labs(x="date", y = "sales", title = "US Beer Sales")

###########################################
# Simple Average
############################################


sim_avg <- data.frame(list(DATE=seq(data[nrow(data)-1,]$DATE+1,data[nrow(data)-1,]$DATE+(3*365),"month"),
                                 value = rep(NA,36)))

sim_avg$value <- mean(data$value)

simple_average <- rbind(data,sim_avg)

ggplot(simple_average, aes(DATE,value)) + 
  geom_line() + 
  scale_x_date(date_breaks = "3 year") +
  labs(x="date", y = "sales", title = "US Beer Sales")



###########################################
# Moving Average
############################################



ts_data <- ts(data$value,start = c(1992, 1),frequency = 12)

mov_avg <- ma(ts_data, order = 12)

moving_average <- forecast(mov_avg, h = 36)

autoplot(moving_average) + labs(title = "US Beer Sales")

###########################################
# Exponential Smoothing
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











