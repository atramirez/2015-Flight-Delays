#second file
library(tidyverse)
library(sf)
library(tmap)

`%not_in%` <- purrr::negate(`%in%`)

#setup sf object
airportsdf_sf = st_as_sf(airportsdf, coords = c("LONGITUDE", "LATITUDE"), crs = 4269)

#loading in shape file 
state_map = st_read("cb_2018_us_state_500k.shp")

#just mainland U.S
state_map = filter(state_map, STATEFP %not_in% c('15','72','02','60','66','69','78'))

#all airports in U.S and territories
ggplot() + geom_sf(data=state_map) + 
  geom_sf(data=airportsdf_sf, size=0.5, col="red") + theme_minimal() + 
  coord_sf(xlim = airportsdf$LONGITUDE %>% range + c(-5, 5),
           ylim =  airportsdf$LATITUDE %>% range + c(-5, 5))

#focus on mainland U.S.
tm_shape(state_map) + tm_fill() + tm_borders() +
  tm_shape(airportsdf_sf) + tm_symbols(col = "red", scale=0.5)

#a look at the top 10 airports
busy_airports = flightsdf %>% group_by(DESTINATION_AIRPORT) %>% 
  filter(DESTINATION_AIRPORT == c('ORD','DFW', 'DEN','IAH','ATL','LAX','LAS','MSP','PHX','SFO'))


top10_airports <- flightsdf %>% group_by(ORIGIN_AIRPORT) %>% 
  summarise(airport_count = n())
top10_airports <- merge(x = airportsdf, y = top10_airports, by.x = 'IATA_CODE',
                        by.y = 'ORIGIN_AIRPORT') %>%
  arrange(desc(airport_count))
total = sum(top10_airports$airport_count)
top10_airports <- slice_max(top10_airports, top10_airports$airport_count, n=10)
ggplot(data = top10_airports, aes(x = AIRPORT, y = airport_count)) + 
  theme(axis.text.x = element_blank()) +
  geom_col(aes(fill = AIRPORT))

#pie chart of delay causes
pie_time = c(sum(flightsdf$AIR_SYSTEM_DELAY), sum(flightsdf$SECURITY_DELAY), 
             sum(flightsdf$AIRLINE_DELAY), sum(flightsdf$LATE_AIRCRAFT_DELAY), 
             sum(flightsdf$WEATHER_DELAY))
pie_percent = round(100 * pie_time / sum(pie_time), 1)
pie(pie_time, labels = pie_percent, main = "Delay Causes", col = rainbow(length(pie_time)))
legend("topright", c("Air Sys", "Security", "Airline","Late Aircraft", "Weather"), fill = rainbow(length(pie_time)))


#breaks down to have a row for type of delay, and the time in another
delay_collapsed = gather(busy_airports,'ARRIVAL_DELAY', 'AIR_SYSTEM_DELAY','SECURITY_DELAY','AIRLINE_DELAY','LATE_AIRCRAFT_DELAY', 'WEATHER_DELAY', key = delay_type, value = delay_time)

faa_delay = filter(delay_collapsed, delay_time > 15)

#delays by month by airport
ggplot(data = faa_delay, aes(x = MONTH, color = delay_type)) + geom_freqpoly(bins = 12) + facet_wrap(~DESTINATION_AIRPORT)

#flights by airline by month
ggplot(data = faa_delay, aes(x = MONTH, fill = AIRLINE)) + geom_bar(bins = 12) + facet_wrap(~DESTINATION_AIRPORT)