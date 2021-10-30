#Fourth file
library(tidyverse)
library(sf)
library(tmap)
#graphing total arrival delays for top 10 airports
airport_arrival_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_arrival_delay_time = sum(ARRIVAL_DELAY))
top10_arr_delay_airports = slice_max(airport_arrival_delay,
                                     airport_arrival_delay$total_arrival_delay_time,n = 10)

ggplot(top10_arr_delay_airports, aes(x = DESTINATION_AIRPORT,
                                     y = total_arrival_delay_time)) +
  geom_bar(stat = "identity", aes(fill = DESTINATION_AIRPORT))

#this will map airports by delay amounts not minutes, using centroids
flightsdf_delays = filter(flightsdf, ARRIVAL_DELAY >= 15)
delay_collapsed = gather(flightsdf_delays, 'ARRIVAL_DELAY', 'AIR_SYSTEM_DELAY','SECURITY_DELAY','AIRLINE_DELAY','LATE_AIRCRAFT_DELAY', 'WEATHER_DELAY', key = delay_type, value = delay_time)

#using FAA def of delay
faa_delay = filter(delay_collapsed, delay_time >= 15)

airport_delays = faa_delay %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_delays = sum(delay_time >= 15))

airportsdf_sf <- left_join(airportsdf_sf, airport_delays, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airport_cent = st_centroid(airportsdf_sf)

tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_delays", 
             size = "total_delays", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#output some values that tell us mean and median of the airport delays
airport_arrival_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(arrival_delay_time_mean = mean(ARRIVAL_DELAY))

airport_arrival_delay_med = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(arrival_delay_time_med = median(ARRIVAL_DELAY))

#mapping just the busy airports with centroid amounts
delay_collapsed = gather(busy_airports, 'ARRIVAL_DELAY', 'AIR_SYSTEM_DELAY','SECURITY_DELAY','AIRLINE_DELAY','LATE_AIRCRAFT_DELAY', 'WEATHER_DELAY', key = delay_type, value = delay_time)

faa_delay = filter(delay_collapsed, delay_time >= 15)

airport_delays = faa_delay %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_delays = sum(delay_time >= 15))

airportsdf_sf <- left_join(airportsdf_sf, airport_delays, by = c("IATA_CODE" = "DESTINATION_AIRPORT"))
airport_cent = st_centroid(airportsdf_sf)

tm_shape(state_map) + tm_borders() + tm_shape(airport_cent) + 
  tm_symbols(col = "total_delays", 
             size = "total_delays", scale = 2,
             legend.size.show = F, alpha = 0.5, palette = heat.colors(5))

#just the top 10 busy airports delay distribution
busy_airports = flightsdf %>% group_by(DESTINATION_AIRPORT) %>% 
  filter(DESTINATION_AIRPORT == c('ORD','DFW', 'DEN','IAH','ATL','LAX','LAS','MSP','PHX','SFO'))

ggplot(data = busy_airports, aes(x = ARRIVAL_DELAY)) + geom_histogram(aes(fill = DESTINATION_AIRPORT), bins = 60) + xlim(c(0,300)) + facet_wrap(~DESTINATION_AIRPORT)