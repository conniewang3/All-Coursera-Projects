# Read in files
data <- readRDS("summarySCC_PM25.rds")
sources <- readRDS("Source_Classification_Code.rds")

# Answer the question: "Have total emissions from PM2.5 decreased in the 
# United States from 1999 to 2008?" 

# Using the base plotting system, make a plot showing the total PM2.5 emission
# from all sources for each of the years 1999, 2002, 2005, and 2008 

data.byyear <- split(data, data$year) # Split data by year

# Construct num vector with sums of all PM2.5 emissions from each year
sums <- c(sum(data.byyear[[1]]['Emissions']), sum(data.byyear[[2]]['Emissions']),
          sum(data.byyear[[3]]['Emissions']), sum(data.byyear[[4]]['Emissions']))

# Open PNG graphics device
png(filename='plot1.png')

# Construct line plot with sums
plot(c('1999', '2002', '2005', '2008'), sums, type = 'l', lty = 3, 
     xlab = 'Year', ylab = 'PM2.5 Emissions (tons)', 
     main = 'Total PM2.5 Emissions by Year')
points(c('1999', '2002', '2005', '2008'), sums, pch = 16)

# Close PNG graphics device
dev.off()