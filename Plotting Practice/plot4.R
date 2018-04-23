# Read in data, set headers
power <- read.table("household_power_consumption.txt", 
                    sep = ";", skip = 66637, nrows = 2880)
names(power) <- read.table("household_power_consumption.txt",
                           sep = ";", nrows = 1, stringsAsFactors = F)

# Combine date and time into a date-time column
power <- mutate(power, dateTime = paste(power$Date, power$Time, sep=", "))
# Create an array of POSIXlt dateTime values
dateTimes <- strptime(power$dateTime, format = "%d/%m/%Y, %H:%M:%S")

png(file="plot4.png",width=480,height=480)

# Set up grid
par(mfrow = c(2,2))

# Draw top left plot, which is just plot2
plot(dateTimes, power[,"Global_active_power"], type="l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")

# Draw top right plot
plot(dateTimes, power[,"Voltage"], type="l", 
     xlab = "datetime", ylab = "Voltage")

# Draw bottom left plot, which is just plot3
plot(dateTimes, power[,"Sub_metering_1"], type="l", 
     xlab = "", ylab = "Energy sub metering")
lines(dateTimes, power[,"Sub_metering_2"], type="l", 
      xlab = "", ylab = "Energy sub metering", col = "red")
lines(dateTimes, power[,"Sub_metering_3"], type="l", 
      xlab = "", ylab = "Energy sub metering", col = "blue")
# Add legend
legend('topright', names(power)[7:9], 
       lty = 1, bty = 'n',
       col = c('black', 'red', 'blue'))

# Draw bottom right plot
plot(dateTimes, power[,"Global_reactive_power"], type="l", 
     xlab = "datetime", ylab = "Global_reactive_power")

dev.off()