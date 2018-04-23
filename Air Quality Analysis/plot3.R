# Load packages
library(ggplot2)
library(scales)

# Read in files
data <- readRDS("summarySCC_PM25.rds")
sources <- readRDS("Source_Classification_Code.rds")

# Answer the question: "Of the four types of sources indicated by the type --
# point, nonpoint, onroad, nonroad, which of these four sources have seen 
# decreases in emissions from 1999-2008 for Baltimore City? Which have seen 
# increases in emissions from 1999-2008?"

# Using the ggplot2 plotting system, make a plot showing the emissions from
# 1999-2008 in Baltimore City, broken down by type

data.baltimore <- subset(data, fips == "24510") # Subset data from Baltimore

# Open PNG graphics device
png(filename='plot3.png')

# Construct plot with a line for each type over the years 1999-2008
ggplot(data.baltimore, aes(x=year, y=Emissions, group=type, colour=factor(type))) + 
  stat_summary(fun.y=sum, geom = "line", linetype = 3, size=1) +
  stat_summary(fun.y=sum, geom = "point", size = 2) +
  scale_color_discrete(name = "Type") +
  ggtitle("PM2.5 Emissions from 1999-2008 by Type") + 
  xlab("Year") + ylab("Emissions")

# Close PNG graphics device
dev.off()