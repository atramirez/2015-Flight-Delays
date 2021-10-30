#first file
library(tidyverse)

#load in csv files from the internet
flightsdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=flights.csv")
airportsdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=airports.csv")
airlinesdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=airlines.csv")

#summary of delays and delay causes
summary(flightsdf[,c("DEPARTURE_DELAY", "ARRIVAL_DELAY", "AIR_SYSTEM_DELAY",
                     "SECURITY_DELAY", "AIRLINE_DELAY", "LATE_AIRCRAFT_DELAY",
                     "WEATHER_DELAY")])

head(select(flightsdf, FLIGHT_NUMBER, AIR_SYSTEM_DELAY, SECURITY_DELAY,
               AIRLINE_DELAY, LATE_AIRCRAFT_DELAY, WEATHER_DELAY))

#this will fill all the delay causes NA values with zero
flightsdf <- flightsdf %>% filter(MONTH != 10) #we ignore October until issues #1 is fixed
flightsdf <- flightsdf %>% 
  mutate(AIR_SYSTEM_DELAY = replace(AIR_SYSTEM_DELAY, is.na(AIR_SYSTEM_DELAY), 0)) %>%
  mutate(SECURITY_DELAY = replace(SECURITY_DELAY, is.na(SECURITY_DELAY), 0)) %>%
  mutate(AIRLINE_DELAY = replace(AIRLINE_DELAY, is.na(AIRLINE_DELAY), 0)) %>%
  mutate(LATE_AIRCRAFT_DELAY = replace(LATE_AIRCRAFT_DELAY, is.na(LATE_AIRCRAFT_DELAY), 0)) %>%
  mutate(WEATHER_DELAY = replace(WEATHER_DELAY, is.na(WEATHER_DELAY), 0))
after = select(flightsdf, FLIGHT_NUMBER, AIR_SYSTEM_DELAY, SECURITY_DELAY,
               AIRLINE_DELAY, LATE_AIRCRAFT_DELAY, WEATHER_DELAY)
head(after) 

#join our three tables for use 
flightsdf <- flightsdf %>% left_join(airportsdf, by = c("ORIGIN_AIRPORT" = "IATA_CODE"))
flightsdf <- flightsdf %>% left_join(airportsdf, by = c("DESTINATION_AIRPORT" = "IATA_CODE"))
flightsdf <- flightsdf %>% left_join(airlinesdf, by = c("AIRLINE" = "IATA_CODE"))

