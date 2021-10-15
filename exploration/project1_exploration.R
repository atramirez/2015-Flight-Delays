library(tidyverse)
library(sf)
library(usmap)

setwd('~/code/school/dat301/Project1/data')

#prelim questions
#where are all the airports in this set
#what carrier has the worst delays
#what airports have the worst delays, regions, why?
#what airport has the most flights, delay ratio?
#are longer routes worse for delays than short ones?
#What is the average overall delays and why?

flightsdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=flights.csv")
airportsdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=airports.csv")
airlinesdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=airlines.csv")

head(flightsdf)
head(airportsdf)
head(airlines)
