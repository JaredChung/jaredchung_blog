layout: post
title:  "A Primer on Time Series using R and Python"
date:  2016-07-17
categories: R, Python

Time Series is an area of data science which is often overlooked. The majority of books and tutorials mainly focus on traditional <b> Classification </b> and <b> Regression </b> based problems. 

In this blog we will look at variety of forecasting time series techniques while utilizing the programming languages R and Python.

The topics to be covered include:

* Naive method
* Simple Average
* Moving Average
* Exponential Smoothing
* Holt's Winter method
* ARIMA

I'll be using the daily US Beer Sales dataset to test out the forecasting techniques. The data is comprised of sales between 1992 to 2016 as shown in the table below. The main packages that will be used is the <i>forecast</i> package for R and the <i>statsmodels</i> package for Python.

![]({{ url_for('static', filename = 'img/postimg/timeseries_table.png') }})

![]({{ url_for('static', filename = 'img/postimg/testplot1.png') }})


## Naive Method

The <b>Naive</b> approach is by far the most simplest forecasting technique. It is calculated by taking the last data point available and forecasting all future values based on this value. The below code represents how simplicity of the implementation. This method is most effective if the time series is quite stable overtime.


    #R
    data[nrow(data)-1,] #Extract the last value
    
    #Python
    data[len(data)-1] #Extract the last value

![]({{ url_for('static', filename = 'img/postimg/time_series_blog_plot2.jpeg') }})


## Simple Average

You can see how the Naive method might create some issues, if the last value is unusually high or low, this will then be used to forecast future values. Another way to tackle this problem is to take a <b>Simple Average </b>, which is calculated by taking an average of all previous values. This technique can smooth out volatility in the data.

    #R
    mean(data$value)
    
    #Python
    data.value.mean()

![your-alt-text]({{ url_for('static', filename = 'img/postimg/timeseries_simple_average.jpeg') }})


## Moving Average

A variation to Simple Average is the <b>Moving Average</b>. Using a specified window (e.g 12), take the average of the data points after this shift one point and repeat. This is sometimes called a "sliding window". The benefit of using a moving average is that it is able to adapt to changes over time and as such can capture the "Trend" of the data.

    #R
    library(forecast)
    ma(train$count, order = 12)
    
    #Python
    train['Count'].rolling(12).mean()

![your-alt-text]({{ url_for('static', filename = 'img/postimg/timeseries_moving_average.jpeg') }})

## Exponential Smoothing

We have looked at a few examples involving taking averages of past points, in many cases, only the most recent information is needed to influence our future forecast. <b>Exponential Smoothing</b> applies a weighting to past values with larger weights assigned to more recent observations. The weights decrease exponentially the further into the past.  

    #R
    library(forecast)
    ses(data, alpha = 0.2, initital = "simple", h = 36)
    #Python
    
    from statsmodels.tsa.api import SimpleExpSmoothing
    fit = SimpleExpSmoothing(np.asarray(train['Count'])).fit(smoothing_level = 0.2, optimzed = False)
    fit.forecast(len(test))


![your-alt-text]({{ url_for('static', filename = 'img/postimg/timeseries_exponential_smoothing.jpeg') }})


## Holt Winters

The <b>Holt Winters</b> technique extends the simple exponential smoothing. The techniques encompasses three smoothing equations, the first part is the level (essentially exponential smoothing), the second part is the trend and the last part is the seasonality. This can be broken into two variations. One variation is the "additive" method, which is suitable for constant seasonality. The second variation is the "multiplicative" method which allows seasonality to change over time.

    #R
    library(forecast)
    fit <- hw(data, seasonal = "additive")
    
    # "ets" function is an automated version
    ets_model <- ets(ts_data)
    ets_forecast <- forecast(ets_model, h = 36)
    
    #Python
    from statsmodel.tsa.api import ExponentialSmoothing
    fit = ExponentialSmoothing(np.asarray(train['Count]), seasonal_period = 7, trend = 'add', seasonal = 'add')


![your-alt-text]({{ url_for('static', filename = 'img/postimg/timeseries_holt_winters.jpeg') }})


## Arima

Another popular method is <b>Arima</b> which is made up of three parts, autoregressive, integrated and moving average . One of the main differences compared to the previous methods is that it is based on autocorrelations. The first part of states the # of linear combinations of past values. The second part denotes how many times the time series has been "differenced" (transformed) so it is stationary (time series which doesn't depend on time). The third and final part is the moving average which is similar to the first part except that it is a linear combination of the error terms.

    #R
    library(forecast)
    fit <- auto.arima(data)
    
    #Python
    from statsmodels.tsa.statespace import SARIMAX
    
    fit = SARIMAX(train['count'], order = (2,1,4), seasonal_order = (0,1,1,7)).fit()


![your-alt-text]({{ url_for('static', filename = 'img/postimg/timeseries_arima.jpeg') }})

## Conclusion

In this blog we have explored a variety of different forecasting techniques which can be easily applied. The choose of technique depends significantly on the data, for example, determining whether there is a particular trend or seasonality. 

One of the main take always, is that there is not a single technique which is supreme but it depends on the particular dataset. Benchmarking each method such as determining which has the lowest <b>RMSE</b> is a strategy to determine which model to use.  







