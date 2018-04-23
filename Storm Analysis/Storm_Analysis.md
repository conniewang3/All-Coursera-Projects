---
title: "Health and Economic Consequences of Severe Weather Events, by Type and State"
author: "Connie Wang"
date: "January 9, 2018"
output: 
  html_document: 
    keep_md: yes
---



## Synopsis

This article contains an analysis of severe weather data from the US National Oceanic and Atmospheric Administration (NOAA). The data tracks characteristics of major storms and weather events in the US between 1950 and 2011, including when and where they occur and estimates of fatalities, injuries, and property damage. The **objective** of this analysis is to identify which  types of events have the greatest impact on human health and the economy. The **results** indicate that flooding and hurricanes have the greatest economic impact, and tornadoes are of the most concern to human health. These findings vary somewhat among states, but tornadoes appear to be the most dangerous event across all of the US. 

## Data Processing

The data was downloaded on October 26, 2017 as a csv.bz2 file (a comma-separated-value file compressed via the bzip2 algorithm) from the Course Project 2 page of the Reproducible Research Coursera Course (Week 4): https://www.coursera.org/learn/reproducible-research/peer/OMZ37/course-project-2

Data was imported into R using read.csv directly on the .csv.bz2 file. I selected out only the columns of interest. These are STATE, EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, and CROPDMGEXP.

In order to find more meaningful patterns, I combined some similar event type categories into the following categories. Keywords were generated manually by reading through levels(stormData$EVTYPE). Any events that fell under multiple keywords (for example, "drought/excessive heat") were counted under both.

* Cold
    + cold
    + cool
    + freeze
    + freezing
    + frost
    + hypothermia
    + low temperature
    + chill
    + record low
  
* Drought
    + driest
    + dry
    + low rainfall
  
* Fire
    + fire
  
* Flood: contains any of these keywords:
    + flood
    + fld
    + urban
    + stream (urban and stream are used to refer to urban/small stream flooding, which is occasionally labeled as urban and small or urban/small in the EVTYPE variable)
    + erosion (beach erosion, a type of flooding)
    + erosin (a misspelling of erosion)
    + dam (for dam breaks and failures)

* Fog
    + fog
    + vog

* Hail
    + hail

* Heat 
    + heat (note: drought/excessive heat and heat drought were categorized under drought)
    + hot
    + hyperthermia
    + high temperature
    + warm

* Hurricane
    + hurricane
    + floyd
    + tropical (for tropical storms and tropical depressions)
    + typhoon

* Landslide
    + slide
    + landslump

* Marine
    + seas
    + surf
    + swells
    + tide
    + waves
    + marine
    + current
    + seiche
    + tsunami

* Rain
    + rain
    + precipitation
    + precipatation (a misspelling of precipitation)
    + wet
    + mix
    + shower

* Snow and ice
    + snow
    + blizzard
    + ice
    + glaze
    + mix
    + sleet
    + winter

* Thunderstorm
    + lightning
    + thunder
    + thundeer, thundere, thuder, thunde, thuner (misspellings)
    + tstm

* Tornado
    + tornado
    + torndao (misspelling)
    + dust
    + spout (landspouts and waterspouts) 
    + funnel
    + gustnado

* Other Wind
    + wind
    + downburst
    + microburst
    + wnd

* Volcano
    + volcanic

* Other
    + included miscellaneous events and any event type where I couldn't actually figure out what type of event it was: wall clouds, "summary [date]", just "excessive", "mild pattern", "no severe weather", "none", "other", "northern lights", "record temperatures", "red flag criteria".
  
I also parsed the columns for property damage and crop damage cost into a single numeric column containing total cost. In the data, they are set as two columns each -- "PROPDMG", which contains a number, and "PROPDMGEXP" which contains the exponent of that number. I used levels() to see all the possible values of PROPDMGEXP and CROPDMGEXP and parsed them as follows:

* "", "-", "?", "+", "0": Multiply by 1
* n = "1" through "8": Multiply by 10^n
* "B": Multiply by 10^9
* "h" or "H": Multiply by 100
* "k" or "K": Multiply by 1000
* "m" or "M": Multiply by 10^6

The state column had several abbreviations that I did not recognize and assume are types (like "AM" or "LM", and I tossed those entries out).
 

```r
storm_data <- read.csv("StormData.csv.bz2")
```


```r
process_data <- storm_data %>%
  mutate(Cold = grepl("cold|cool|freeze|freezing|frost|hypothermia|low temperature|chill|record low", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Drought = grepl("driest|dry|low rainfall", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Fire = grepl("fire", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Flood = grepl("flood|fld|urban|stream|erosion|erosin|dam", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Fog = grepl("fog|vog", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Hail = grepl("hail", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Heat = grepl("heat|hot|hyperthermia|high temperature|warm", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Hurricane = grepl("hurricane|floyd|tropical|typhoon", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Landslide = grepl("slide|landslump", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Marine = grepl("seas|surf|swells|tide|waves|marine|current|seiche|tsunami", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Rain = grepl("rain|precipitation|precipatation|wet|mix|shower", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Snow = grepl("snow|blizzard|ice|glaze|mix|sleet|winter", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Thunderstorm = grepl("lightning|thunder|thundeer|thundere|thuder|thunde|thuner|tstm", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Tornado = grepl("tornado|torndao|dust|spout|funnel|gustnado", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Wind = grepl("wind|downburst|microburst|wnd", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Volcano = grepl("volcanic", EVTYPE, ignore.case = TRUE)) %>%
  mutate(Other = grepl("wall clouds|summary|excessive$|mild pattern|no severe weather|none|other|northern lights|record temperatures|red flag criteria", EVTYPE, ignore.case = TRUE)) %>%
  mutate(PROPDMGEXP = as.character(PROPDMGEXP)) %>%
  mutate(CROPDMGEXP = as.character(CROPDMGEXP)) %>%
  mutate(PROPDMGEXP = ifelse(as.integer(PROPDMGEXP) %in% seq(8), 10^as.integer(PROPDMGEXP),
                    ifelse(PROPDMGEXP == "B", 10^9, 
                    ifelse(PROPDMGEXP %in% c("h", "H"), 100,
                    ifelse(PROPDMGEXP %in% c("k", "K"), 1000, 
                    ifelse(PROPDMGEXP %in% c("m", "M"), 10^6, 1)))))) %>%
    mutate(CROPDMGEXP = ifelse(as.integer(CROPDMGEXP) %in% seq(8), 10^as.integer(CROPDMGEXP),
                    ifelse(CROPDMGEXP == "B", 10^9, 
                    ifelse(CROPDMGEXP %in% c("h", "H"), 100,
                    ifelse(CROPDMGEXP %in% c("k", "K"), 1000, 
                    ifelse(CROPDMGEXP %in% c("m", "M"), 10^6, 1)))))) %>%
  mutate(cost = PROPDMG * PROPDMGEXP + CROPDMG * CROPDMGEXP) %>%
  select(state=STATE, fatalities=FATALITIES, injuries=INJURIES, Cold:cost) %>%
  filter(state %in% c("AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MH", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"))
```

## Results

First, we identified which types of events are most harmful with respect to **population health**. In order to answer this question, we looked at the columns for fatalities, injuries, and event type (FATALITIES, INJURIES, and all event type indicator columns). 


```r
# Which types of events result in the most fatalities/injuries?
health <- process_data %>%
  select (-cost, -state) %>%
# Multiply indicator for each event by number of fatalities or injuries and store in new event_f or event_i variables
  mutate_at(.vars = vars(Cold:Other),
            .funs = funs(f = . * fatalities, i = . * injuries)) %>%
  select(Cold_f:Other_i) %>%
# Get sum of each event type column to find total number of fatalities or injuries for that event
  summarize_each(funs(sum)) %>%
# Reshape into two columns for numbers of fatalities and injuries, with event type as the rows
  gather() %>%
  separate(key, c('event', 'id'), sep="_") %>%
  spread(id, value) %>%
# get only the events with the top 5 number of injuries to plot
  arrange(desc(i)) %>%
  slice(1:5)

# Count number of events of each type
count <- process_data %>%
  mutate_at(.vars = vars(Cold:Other),
            .funs = as.integer) %>%
  summarize_at(.vars = vars(Cold:Other),
               .funs = funs(sum)) %>%
  gather(event, count)

# Bind count to fatalities/injuries data
health <- left_join(health, count, by="event")
  
# Plot as scatter, use count as font size
ggplot(health, aes(x=f, y=i)) +
  geom_text(aes(label=event, size=count), hjust="inward") +
  scale_size(range=c(4,7)) +
  labs(title = "Top 5 Most Injurious Weather Event Types Between 1950 and 2011",
       x = "Fatalities", y = "Injuries", size = "Occurence Count")
```

![](Storm_Analysis_files/figure-html/health-1.png)<!-- -->

This plot shows the number of fatalities and injuries caused by the top 5 most injurious types of weather events. The font size of each label shows how many times that event occured between 1950 and 2011. We can see here that tornadoes caused the most injuries and fatalities by far. Thunderstorms, wind, and floods also caused very many injuries and fatalities, but far fewer than tornadoes, and largely because they happen so frequently. Heat-related events have disproportionately many fatalities (relative to how many injuries they cause). The number of heat-related fatalities is particularly noteworthy because they are caused by a relatively smaller number of occurences (although duration of each heat-related event is not taken into account).

Then, we looked at which types of events are most harmful with respect to **economic impact**. In order to answer this question, we looked at the columns for total cost and event type (cost and all event type indicator columns). 

```r
# Which types of events result in the highest economic impact?
econ <- process_data %>%
  select (-fatalities, -injuries, -state) %>%
# Multiply indicator for each event by total cost
  mutate_at(.vars = vars(Cold:Other),
            .funs = funs(. * cost)) %>%
  select(Cold:Other) %>%
# Get sum of each event type column to find total number of fatalities or injuries for that event
  summarize_each(funs(sum)) %>%
  gather(event, cost) %>%
  # get only the events with the top 5 number of injuries to plot
  arrange(desc(cost)) %>%
  slice(1:5)

# Bind count to fatalities/injuries data
econ <- left_join(econ, count, by="event")
  
# Plot as bar plot, use count as widths of bars
ggplot(econ, aes(x=event, y=cost)) +
  geom_bar(aes(label=event, fill=count), stat="identity") +
  # scale_size(range=c(4,8)) +
  labs(title = "Top 5 Most Costly Weather Events Between 1950 and 2011",
       x = "Event Type", y = "Cost (Property and Crop Damage) in USD", fill = "Occurence Count")
```

![](Storm_Analysis_files/figure-html/econ-1.png)<!-- -->

Floods are by far the most costly event, at about double the cost of the next-highest (hurricanes), and costing upwards of $150 billion in property and crop damage between 1950 and 2011. The color here shows the number of recorded occurences between 1950 and 2011 -- from this information, we can see that hurricanes are the costliest per event.

Lastly, I wanted to output the type of event that is most devastating **in each state**, since different states are likely to experience different disasters. I made maps by total health impact (sum of fatalities and injuries) and economic impact (total property and crop damage cost).


```r
# What is the most dangerous event type in each state?
health_bystate <- process_data %>%
  select (-cost) %>%
  # Multiply indicator for each event by number of fatalities and injuries and sum for total health impact
  mutate_at(.vars = vars(Cold:Other),
            .funs = funs(. * (fatalities + injuries))) %>%
  select(state, Cold:Other) %>%
  group_by(state) %>%
  # Get sum of each event type column to find total number of fatalities or injuries for that event in each state
  summarize_each(funs(sum)) %>% 
  gather(event, value, -state) %>%
  spread(state, value) %>%
  # Find the event with the top impact to plot
  summarize_at(.vars = vars(AK:WY),
               .funs = funs(event[which.max(.)])) %>%
  gather(state, event) %>%
  mutate(state = stateFromLower(state))
  
# Plot as map
states_map <- tbl_df(map_data("state"))
health_map <- ggplot(health_bystate, aes(map_id = state)) +
  geom_map(aes(fill = event), map = states_map, color = "#ffffff") +
  expand_limits(x = states_map$long, y = states_map$lat) +
  theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank()) +
  labs(fill = "Event Type", title = "Most Dangerous Weather Event by State")
  
# What is the most dangerous event type in each state?
cost_bystate <- process_data %>%
  select (-fatalities, -injuries) %>%
  # Multiply indicator for each event by cost for cost per event
  mutate_at(.vars = vars(Cold:Other),
            .funs = funs(. * cost)) %>%
  select(state, Cold:Other) %>%
  group_by(state) %>%
  # Get sum of each event type column to find total number of fatalities or injuries for that event in each state
  summarize_each(funs(sum)) %>% 
  gather(event, value, -state) %>%
  spread(state, value) %>%
  # Find the event with the top impact to plot
  summarize_at(.vars = vars(AK:WY),
               .funs = funs(event[which.max(.)])) %>%
  gather(state, event) %>%
  mutate(state = stateFromLower(state))
  
# Plot as map
states_map <- tbl_df(map_data("state"))
cost_map <- ggplot(cost_bystate, aes(map_id = state)) +
  geom_map(aes(fill = event), map = states_map, color = "#ffffff") +
  expand_limits(x = states_map$long, y = states_map$lat) +
  theme(axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank()) +
  labs(fill = "Event Type", title = "Most Costly Weather Event by State")

# Make side by side plot
plot_grid(health_map, cost_map, ncol=1)
```

![](Storm_Analysis_files/figure-html/by_state-1.png)<!-- -->

Across most of the US, tornadoes cause the most combined injuries and fatalities, but there are exceptions mostly in the Northeast (where thunderstorms seem to be a larger concern), and the West Coast. In my home state of California, the most dangerous event type is Fire -- as we've been plagued by even more wildfires than usual this year, this result is particularly believable.

In terms of cost of property and crop damage, the results are much more varied across states. Flooding is the most costly event on much of the West Coast and Northeast, while tornadoes affect the Midwest more, and Hurricanes are the most costly in the Southeast.
