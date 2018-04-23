# Read in data, set headers
power <- read.table("household_power_consumption.txt", 
                    sep = ";", skip = 66637, nrows = 2880)
names(power) <- read.table("household_power_consumption.txt",
                           sep = ";", nrows = 1, stringsAsFactors = F)

# Combine date and time into a date-time column
power <- mutate(power, dateTime = paste(power$Date, power$Time, sep=", "))
# Create an array of POSIXlt dateTime values
dateTimes <- strptime(power$dateTime, format = "%d/%m/%Y, %H:%M:%S")

# Draw line graph, using xlab and ylab to label the axes
plot(dateTimes, power[,"Global_active_power"], type="l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")

# Copy to PNG
dev.copy(png, "plot2.png", width = 480, height = 480)
dev.off()