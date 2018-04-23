# Load packages
library(ggplot2)
library(scales)

# Read in files
data <- readRDS("summarySCC_PM25.rds")
sources <- readRDS("Source_Classification_Code.rds")

# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037") 
# Which city has seen greater changes over time in motor vehicle emissions?

# Subset only data from motor vehicle sources
# I'm including in "motor vehicle sources": motorcycles, aircraft, 
# highway vehicles (including cars, trucks, buses)
SCC.motor <- as.character(sources[grep("Motor", sources$Short.Name), 'SCC'])
SCC.air <- as.character(sources[grep("Aircraft", sources$SCC.Level.Two), 'SCC'])
SCC.cars <- as.character(sources[grep("Highway", sources$SCC.Level.Two), 'SCC'])
SCC.veh <- c(SCC.motor, SCC.air, SCC.cars)
data.veh <- subset(data, SCC %in% SCC.veh)

# Subset from that data, data from LA and data from Baltimore
data.city <- subset(data.veh, fips %in% c("06037", "24510")) 

# Using the ggplot2 plotting system, make a plot showing the emissions from
# motor vehicles in 1999-2008 in Baltimore vs. LA

# Open PNG graphics device
png(filename='plot6.png')

# Construct plot with a line for each city over the years 1999-2008
ggplot(data.city, aes(x=year, y=Emissions, group=fips, colour=factor(fips))) + 
  stat_summary(fun.y=sum, geom = "line", linetype = 3, size=1) +
  stat_summary(fun.y=sum, geom = "point", size = 2) +
  scale_color_discrete(name = "City", labels = c("Los Angeles", "Baltimore")) +
  ggtitle("PM2.5 Emissions from 1999-2008 in LA vs. Baltimore") + 
  xlab("Year") + ylab("Emissions")

# Close PNG graphics device
dev.off()