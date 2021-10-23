#script 3, this will contain calculation and graphs for mapping related subjects
library(tidyverse)
library(sf)
library(tmap)

airportsdf = read_csv("https://www.kaggle.com/usdot/flight-delays?select=airports.csv")
airportsdf <- airportsdf %>% drop_na(LATITUDE, LONGITUDE)

airportsdf_sf = st_as_sf(airportsdf, coords = c("LONGITUDE", "LATITUDE"), crs = 4269)

#this has yet to be uploaded it will temprarily set the directory to fetch shape files for maps
setwd("~/code/2015-flight-days/data")
state_map = st_read("cb_2018_us_state_500k.shp")

`%not_in%` <- purrr::negate(`%in%`)
state_map = filter(state_map, STATEFP %not_in% c('60','66','69','78'))

#entire U.S plot of airports with ggplot for practice
ggplot() + geom_sf(data=state_map) + 
  geom_sf(data=airportsdf_sf, size=0.5, col="red") + theme_minimal() + 
  coord_sf(xlim = airportsdf$LONGITUDE %>% range + c(-5, 5),
           ylim =  airportsdf$LATITUDE %>% range + c(-5, 5))

#just mainland U.S using tmap, what will mainly be used from here on out
#this exclused all territories HI and AK
state_map = filter(state_map, STATEFP %not_in% c('15','72','02','60','66','69','78'))

#plot all airports from the dataset
tm_shape(state_map) + tm_fill() + tm_borders() +
  tm_shape(airportsdf_sf) + tm_symbols(col = "red", scale=0.5)

#this next part is a WIP a bit dirty
#it groups each by airports and sums the respective delay reason, this allows to be joined to a mapping table
airport_arrival_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_arrival_delay_time = sum(ARRIVAL_DELAY))

air_sys_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_air_sys_delay = sum(AIR_SYSTEM_DELAY))

security_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_security_delay = sum(SECURITY_DELAY))

airline_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_airline_delay = sum(AIRLINE_DELAY))

late_aircraft_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_late_aircraft_delay = sum(LATE_AIRCRAFT_DELAY))

weather_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_weather_delay = sum(WEATHER_DELAY))

#we join them all one by one by the airport codes which will match and do this automatically
airportsdf_sf <- left_join(airportsdf_sf, airport_arrival_delay, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airportsdf_sf <- left_join(airportsdf_sf, air_sys_delay, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airportsdf_sf <- left_join(airportsdf_sf, security_delay, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airportsdf_sf <- left_join(airportsdf_sf, airline_delay, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airportsdf_sf <- left_join(airportsdf_sf, late_aircraft_delay, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airportsdf_sf <- left_join(airportsdf_sf, weather_delay, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))

#check the columns for proper joins
head(airportsdf_sf)

#set airport centroid
airport_cent = st_centroid(airportsdf_sf)

#this portion is a bit repetitive, but layouts out some graphs to play around with, and ideas for dashboard pages

#this graphs a U.S map of the mainland with each airport being a centroid for arrival delay minutes
tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_arrival_delay_time", 
             size = "total_arrival_delay_time", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#each airport being a centroid for air system minutes
tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_air_sys_delay", 
             size = "total_air_sys_delay", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#each airport being a centroid for security delay minutes
tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_security_delay", 
             size = "total_security_delay", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#each airport being a centroid for airline delay minutes
tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_airline_delay", 
             size = "total_airline_delay", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#each airport being a centroid for late aircraft delay minutes
tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_late_aircraft_delay", 
             size = "total_late_aircraft_delay", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#each airport being a centroid for weather delay minutes
tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_weather_delay", 
             size = "total_weather_delay", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))
