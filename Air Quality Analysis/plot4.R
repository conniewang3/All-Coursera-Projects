# Load packages
library(ggplot2)
library(scales)

# Read in files
data <- readRDS("summarySCC_PM25.rds")
sources <- readRDS("Source_Classification_Code.rds")

# Answer the question: "Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999-2008?"

# Subset only data from coal combustion-related sources
SCC.coal <- as.character(sources[grep("Coal", sources$Short.Name), 'SCC'])
data.coal <- subset(data, SCC %in% SCC.coal)

# Using the ggplot2 plotting system, make a plot showing the emissions from
# coal in 1999-2008

# Open PNG graphics device
png(filename='plot4.png')

# Construct plot with a line for each type over the years 1999-2008
ggplot(data.coal, aes(x=year, y=Emissions)) + 
  stat_summary(fun.y=sum, geom = "line", linetype = 3, size=1) +
  stat_summary(fun.y=sum, geom = "point", size = 2) +
  ggtitle("PM2.5 Emissions from 1999-2008 from Coal") + 
  xlab("Year") + ylab("Emissions")

# Close PNG graphics device
dev.off()