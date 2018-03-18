


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



# Main Plotting Function
forecast_plot <- function(data, 
                          forecast_data,
                          name = "") {
    
    ggplot(data=data, aes(DATE,value),colour = 'black') +
    geom_line() + 
    geom_line(data=forecast_data,aes(DATE,value),colour = "blue", size = 1) +
    scale_x_date(date_breaks = "4 year") +
    labs(x="date", y = "sales", title = paste("US Beer Sales -", name, sep = ""))
  
}

result <- function(test_data,
                   predict_data) {
  
    mse <- mean((test_data$value - predict_data$value)^2)
    
    return(mse)
}


###########################################
# NAIVE
############################################


predict_naive <- data.frame(DATE = test$DATE, 
                            value = rep(train[nrow(train),]$value,nrow(test)))


forecast_plot(data=data,
              forecast_data = predict_naive,
              name = "Naive")

# 2598044
result(test,predict_naive)

###########################################
# Simple Average
############################################



sim_avg <- data.frame(DATE = test$DATE, 
                            value = rep(mean(test$value),nrow(test)))

forecast_plot(data=data,
              forecast_data = sim_avg,
              name = "Simple Average")


# 1840232
result(test,sim_avg)

######################################
# Time Series data
######################################


ts_data <- ts(data$value,start = c(1992, 1,1), frequency = 12)

train_ts <- window(ts_data, start = c(1992), end = c(2012,12))

test_ts <- window(ts_data, start = c(2013))

###########################################
# Moving Average
############################################


mov_avg <- ma(train_ts, order = 12)

moving_average <- forecast(mov_avg, h = length(test_ts))

ma_avg <- data.frame(DATE = test$DATE, 
                      value = as.vector(moving_average$mean))

forecast_plot(data=data,
              forecast_data = ma_avg,
              name = "Moving Average")

# 1645909
result(test,ma_avg)

###########################################
# Exponential Smoothing
############################################

ses_model <- ses(train_ts, h = length(test_ts))

ses_avg <- data.frame(DATE = test$DATE, 
                     value = as.vector(ses_model$mean))

forecast_plot(data=data,
              forecast_data = ses_avg,
              name = "Simple Exponential Smoothing")

# 2121549
result(test,ses_avg)

###########################################
# Holt winters
############################################


holt_winter <- hw(train_ts, h = length(test_ts))


hw_avg <- data.frame(DATE = test$DATE, 
                      value = as.vector(holt_winter$mean))

forecast_plot(data=data,
              forecast_data = hw_avg,
              name = "Holt Winters")

# 370809.9
result(test,hw_avg)

ets_model <- ets(train_ts)

ets_forecast <- forecast(ets_model, h = length(test_ts))

ets_avg <- data.frame(DATE = test$DATE, 
                      value = as.vector(ets_forecast$mean))

forecast_plot(data=data,
              forecast_data = ets_avg,
              name = "ets (automated)")
 
# 402562.1
result(test,ets_avg)

###########################################
# Arima
############################################


arima_model <- auto.arima(train_ts)

arima_forecast <- forecast(arima_model, h = length(test_ts))

arima_avg <- data.frame(DATE = test$DATE, 
                      value = as.vector(arima_forecast$mean))

forecast_plot(data=data,
              forecast_data = arima_avg,
              name = "Arima")

# 248802
result(test,arima_avg)







