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

#this will set all the na values in each delay reason column to 0 for future addition and math to be done with these
flightsdf <- flightsdf %>% 
  mutate(AIR_SYSTEM_DELAY = replace(AIR_SYSTEM_DELAY, is.na(AIR_SYSTEM_DELAY), 0)) %>%
  mutate(SECURITY_DELAY = replace(SECURITY_DELAY, is.na(SECURITY_DELAY), 0)) %>%
  mutate(AIRLINE_DELAY = replace(AIRLINE_DELAY, is.na(AIRLINE_DELAY), 0)) %>%
  mutate(LATE_AIRCRAFT_DELAY = replace(LATE_AIRCRAFT_DELAY, is.na(LATE_AIRCRAFT_DELAY), 0)) %>%
  mutate(WEATHER_DELAY = replace(WEATHER_DELAY, is.na(WEATHER_DELAY), 0))

head(flightsdf)
head(airportsdf)
head(airlines)
