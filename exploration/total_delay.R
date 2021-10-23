#script 2, this performs many calculations and graphing of delay aggregtions
# Total Delay time by Carrier
airline_total_delay = flightsdf %>% group_by(AIRLINE.y) %>% 
  filter(total_delay > 0) %>% summarize(total_delay_time = sum(total_delay))

ggplot(airline_total_delay, aes(x = AIRLINE.y, y = total_delay_time)) + 
  geom_bar(stat="identity", aes(fill = AIRLINE.y)) +
  theme(axis.text.x = element_blank()) +
  ggtitle("Total Delay Minutes by Airline") + ylab("Delay Minutes") +
  xlab("Airline") 

#graphing total arrival delay minutes for top 10 airports
airport_arrival_delay = flightsdf %>% group_by(DESTINATION_AIRPORT) %>%
  summarize(total_arrival_delay_time = sum(ARRIVAL_DELAY))
top10_arr_delay_airports = slice_max(airport_arrival_delay,
                                     airport_arrival_delay$total_arrival_delay_time,n = 10)

#graphing on a bar plot
ggplot(top10_arr_delay_airports, aes(x = DESTINATION_AIRPORT,
                                     y = total_arrival_delay_time)) +
  geom_bar(stat = "identity", aes(fill = DESTINATION_AIRPORT))

#pie chart of delay reasons, will take the reasons and compare them against each other
pie_time = c(sum(flightsdf$AIR_SYSTEM_DELAY), sum(flightsdf$SECURITY_DELAY), 
             sum(flightsdf$AIRLINE_DELAY), sum(flightsdf$LATE_AIRCRAFT_DELAY), 
             sum(flightsdf$WEATHER_DELAY))
#this will compute the percentage of each
pie_percent = round(100 * pie_time / sum(pie_time), 1)
pie(pie_time, labels = pie_percent, main = "Delay Causes", col = rainbow(length(pie_time)))
legend("topright", c("Air Sys", "Security", "Airline","Late Aircraft", "Weather"), fill = rainbow(length(pie_time)))

#delay minutes by cause
names = c("Air Sys", "Security", "Airline","Late Aircraft", "Weather")
delay_min_causes = data.frame(names, pie_time)

ggplot(data = delay_min_causes, aes(x = names, y = pie_time)) + geom_bar(stat="identity", aes(fill = names))

#delay minutes by airline in a facet
ggplot(data = flightsdf, aes(x = ARRIVAL_DELAY)) + geom_histogram(aes(fill = AIRLINE)) + xlim(c(0,300)) + facet_wrap(~AIRLINE)