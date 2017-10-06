filename <- "household_power_consumption.txt"
## reading in the file "household_power_consumption.txt"
importData <- read.csv(file = filename, header = TRUE, sep = ";")

## subsetting data for January 2, 2007 and February 2, 2007
subData <- importData[which(importData$Date == '1/2/2007' | 
                                importData$Date == '2/2/2007'),]

## reformatting Date column into Date class format "Year-Month-Day"
subData$Date <- as.Date(subData$Date, format = "%d/%m/%Y")

## uniting the Date column and Time column and formatting as POSIXlt class
newDateTime <- strftime(paste(subData$Date, subData$Time), 
                        format = "%Y-%m-%d %H:%M:%S", usetz = FALSE)

## reorganizing subData datafram to include united Data/Time column
subData <- data.frame(newDateTime, subData$Global_active_power, 
                      subData$Global_reactive_power, subData$Voltage, 
                      subData$Global_intensity, subData$Sub_metering_1, 
                      subData$Sub_metering_2, subData$Sub_metering_3)

## renaming the columns of SubData updated for united Data/Time
names(subData) <- c("DateTime", "Global_active_power", 
                    "Global_reactive_power", "Voltage", 
                    "Global_intensity", "Sub_metering_1", "Sub_metering_2", 
                    "Sub_metering_3")

## Graph 1 cleaning up
## cleaning the NA or (?) out of the vector of Global Actice Power data
clean <- complete.cases(as.numeric(subData$Global_active_power))

## assigning gap_vector name to the cleaned up Global Active Power Data
## ** NOTE: you must go from factor to character then to numeric!!! **
gap_vector <- as.numeric(as.character(subData$Global_active_power[clean]))

## Graph 2 cleaning up (Voltage)
cleanV <- complete.cases(as.numeric(subData$Voltage))
voltage_vector <- as.numeric(as.character(subData$Voltage[cleanV]))

## Graph 3 cleaning up (Sub metering 1,2,3)
# cleaning up any NA values in the sub_metering vectors
cleansb1 <- complete.cases(as.numeric(subData$Sub_metering_1))
cleansb2 <- complete.cases(as.numeric(subData$Sub_metering_2))
cleansb3 <- complete.cases(as.numeric(subData$Sub_metering_3))
sm1_vector <- as.numeric(as.character(subData$Sub_metering_1[cleansb1]))
sm2_vector <- as.numeric(as.character(subData$Sub_metering_2[cleansb2]))
sm3_vector <- as.numeric(as.character(subData$Sub_metering_3[cleansb3]))

## Graph 4 cleaning up (Global Reactive Power)
cleanGRP <- complete.cases(as.numeric(subData$Global_reactive_power))
grp_vector <- as.numeric(as.character(subData$Global_reactive_power[cleanGRP]))

## open a png graphics device to write the plot of Global Active Power
png(filename = "plot4.png", width = 480, height = 480, units = "px")

## setting the canvas parameters for 2x2 graphs on canvas
par(mfrow = c(2,2))

## ******* adding Graph 1 ******** ##
plot(as.POSIXct(as.character(subData$DateTime)), gap_vector, type = "l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")

## ******* adding Graph 2 ******** ##
plot(as.POSIXct(as.character(subData$DateTime)), voltage_vector, type = "l",
     ylab = "Voltage", xlab = "datetime")

## ******* adding Graph 3 ******** ##
## initializing the plot to be drawn in graphics device
plot(as.POSIXct(as.character(subData$DateTime)), sm1_vector, type = "n", 
     xlab = "", ylab = "Energy sub metering")
## adding a layer to the plot of sub_metering_1
points(as.POSIXct(as.character(subData$DateTime)), sm1_vector, type = "l")
## adding a layer to the plot of sub_metering_2
points(as.POSIXct(as.character(subData$DateTime)), sm2_vector, type = "l", 
       col = "red")
## adding a layer to the plot of sub_metering_3
points(as.POSIXct(as.character(subData$DateTime)), sm3_vector, type = "l", 
       col = "blue")
## adding a legend in the topright of the plot
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       lty = c(1,1,1),lwd = c(2.5,2.5), col=c("black", "red", "blue"), 
       bty = "n")

## ******* adding Graph 4 ******** ##
plot(as.POSIXct(as.character(subData$DateTime)), grp_vector, type = "l", 
     col = "black", ylab = "Global_reactive_power", xlab = "datetime")

## turn off the graphics device
dev.off()