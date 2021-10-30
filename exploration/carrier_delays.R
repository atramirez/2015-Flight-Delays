#third file
library(tidyverse)
library(sf)
library(tmap)

#total delay minutes by airline
airline_total_delay = flightsdf %>% group_by(AIRLINE.y) %>% 
  filter(ARRIVAL_DELAY >= 15) %>% summarize(total_delay_time = sum(ARRIVAL_DELAY))

ggplot(airline_total_delay, aes(x = AIRLINE.y, y = total_delay_time)) + 
  geom_bar(stat="identity", aes(fill = AIRLINE.y)) +
  theme(axis.text.x = element_blank()) +
  ggtitle("Total Delay Minutes by Airline") + ylab("Delay Minutes") +
  xlab("Airline") 

#delay minutes distibution by airline, does include <15 min "delays"
ggplot(data = flightsdf, aes(x = ARRIVAL_DELAY)) + geom_histogram(aes(fill = AIRLINE), bins=60) + xlim(c(0,300)) + facet_wrap(~AIRLINE.y)