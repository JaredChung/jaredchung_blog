layout: post
title:  "ATP Men’s Tennis Analysis using the R package GGPlot2"
date:  2016-06-01
categories: R

I’m a huge tennis fan, so I decided, why not write a blog post on one of my favorite sports. In this blog, I will be using the programming software R to explore historical data on tennis competitions and generate interesting insights about the tennis players and the game itself.

## Data

The data set used in this analysis was acquired from http://www.tennis-data.co.uk/alldata.php which contains ATP matches from 2000-2016. Just as a general background, the ATP (Association of Tennis Professionals) is an association which organizes worldwide tennis tour for men and women.

The main package we’ll be using for this analysis is **tidyverse** by Hadley Wickham which contains powerful packages like **GGPlot2** for data visualisations and **Dplyr **for data manipulation.

The data set contains 46652 matches and 54 columns which is a decent amount of information to work with. Although there is quite a lot of features in the data set, I won’t be using all of them. The table below gives a small peak at what the data looks like. It has some useful information like the Winner, Loser, Tournament and even what Surface they played on.

<img alt="" src="/static/img/postimg/tennisblog/tennis_Table1-1.png" style="width: 100%;">

There are some missing values so it’s a good idea to check which columns have missing values and how many are there. There are missing values in the columns W1 – L5 which is understandable as not every match ends up in 5 sets. The remaining columns are related to betting odds and so not every match contained.

<img alt="" src="/static/img/postimg/tennisblog/tennis_Table_missing_values.png" style="width: 100%;">

The first analysis I want to do is look at the top 20 players and compare their win rate of the years. This can be achieved by aggregating each player by year and surface and then counting how many wins and losses they had in each season.

The first data visualization I want to create in GGPlot is a heat map which shows the win percentage for the top 20 players based on the surface.

<img alt="" src="/static/img/postimg/tennisblog/tennis_Table_missing_values.png" style="width: 100%;">

The heat map shows the each players win percentage which is indicated by the intensity of the color. You can see that Nadal has an exceptional win rate on Clay which is no surprise considering he is called the “King of Clay”.

Although having an overall high win rate is considered impressive, the main focus of players is to win at the major tournaments.

<img alt="" src="/static/img/postimg/tennisblog/tennis_graph3_heatmap_surface.png" style="width: 100%;">

You can clearly see that Andre Agassi performed the best at the Australian Open. Pete Sampras had completely opposite results when competing in the French Open versus the US Open.

The next visualization is focused on looking at the win rate trend of the top 10 players over the years.

<img alt="" src="/static/img/postimg/tennisblog/tennis_graph1.png" style="width: 100%;">

In the end we produce a plot which shows each player and how they compare over time. Some interesting trends include Novak Djokovic has shown consistent improved both in Clay and Hard court. Rafael Nadal has had the highest win rate for a season on Clay and Roger Federer is the same for Hard Courts. The most volatile when it comes to performance is Kei Nishikori, which shows that he has large troughs and peaks.

## Summary

In summary, I used the R package ggplot to produce some visualizations which highlighted some interesting insights about tennis players. I have only scratched the surface with some simple graphical analysis. I think there is a lot of space for modeling as well, that is, creating a model that can predict the winning records of a player.



