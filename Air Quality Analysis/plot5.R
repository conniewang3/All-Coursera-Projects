# Load packages
library(ggplot2)
library(scales)

# Read in files
data <- readRDS("summarySCC_PM25.rds")
sources <- readRDS("Source_Classification_Code.rds")

# Answer the question: "How have emissions from motor vehicle sources changed 
# from 1999-2008 in Baltimore City?"

# Subset only data from motor vehicle sources
# I'm including in "motor vehicle sources": motorcycles, aircraft, 
# highway vehicles (including cars, trucks, buses)
SCC.motor <- as.character(sources[grep("Motor", sources$Short.Name), 'SCC'])
SCC.air <- as.character(sources[grep("Aircraft", sources$SCC.Level.Two), 'SCC'])
SCC.cars <- as.character(sources[grep("Highway", sources$SCC.Level.Two), 'SCC'])
SCC.veh <- c(SCC.motor, SCC.air, SCC.cars)
data.veh <- subset(data, SCC %in% SCC.veh)

# Using the ggplot2 plotting system, make a plot showing the emissions from
# motor vehicles in 1999-2008

# Open PNG graphics device
png(filename='plot5.png')

# Construct plot showing emissions from 1999-2008 from motor vehicles 
ggplot(data.veh, aes(x=year, y=Emissions)) + 
  stat_summary(fun.y=sum, geom = "line", linetype = 3, size=1) +
  stat_summary(fun.y=sum, geom = "point", size = 2) +
  ggtitle("PM2.5 Emissions from 1999-2008 from Motor Vehicles") + 
  xlab("Year") + ylab("Emissions")

# Close PNG graphics device
dev.off()