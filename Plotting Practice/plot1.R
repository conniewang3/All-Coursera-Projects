# Read in data, set headers
powerm <- read.table("household_power_consumption.txt", 
                   sep = ";", skip = 66637, nrows = 2880)
names(power) <- read.table("household_power_consumption.txt",
                           sep = ";", nrows = 1, stringsAsFactors = F)
# Draw histogram, using the col parameter to specify color, 
# main, xlab, and ylab to label the title and axes
hist(power[,"Global_active_power"], col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency")

# Copy to PNG
dev.copy(png, "plot1.png", width = 480, height = 480)
dev.off()