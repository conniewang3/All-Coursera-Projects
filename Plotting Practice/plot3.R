# Read in data, set headers
power <- read.table("household_power_consumption.txt", 
                    sep = ";", skip = 66637, nrows = 2880)
names(power) <- read.table("household_power_consumption.txt",
                           sep = ";", nrows = 1, stringsAsFactors = F)

# Combine date and time into a date-time column
power <- mutate(power, dateTime = paste(power$Date, power$Time, sep=", "))
# Create an array of POSIXlt dateTime values
dateTimes <- strptime(power$dateTime, format = "%d/%m/%Y, %H:%M:%S")

# Create PNG file
png(file="plot3.png",width=480,height=480)

# Draw line graphs, using col for color,
# xlab and ylab to label the axes
plot(dateTimes, power[,"Sub_metering_1"], type="l", 
     xlab = "", ylab = "Energy sub metering")
lines(dateTimes, power[,"Sub_metering_2"], type="l", 
     xlab = "", ylab = "Energy sub metering", col = "red")
lines(dateTimes, power[,"Sub_metering_3"], type="l", 
      xlab = "", ylab = "Energy sub metering", col = "blue")

# Add legend
legend('topright', names(power)[7:9], 
       lty = 1,
       col = c('black', 'red', 'blue'))

dev.off()