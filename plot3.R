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

# cleaning up any NA values in the sub_metering vectors
cleansb1 <- complete.cases(as.numeric(subData$Sub_metering_1))
cleansb2 <- complete.cases(as.numeric(subData$Sub_metering_2))
cleansb3 <- complete.cases(as.numeric(subData$Sub_metering_3))
sm1_vector <- as.numeric(as.character(subData$Sub_metering_1[cleansb1]))
sm2_vector <- as.numeric(as.character(subData$Sub_metering_2[cleansb2]))
sm3_vector <- as.numeric(as.character(subData$Sub_metering_3[cleansb3]))

## opening new png graphics device
png(filename = "plot3.png", width = 480, height = 480, units = "px")

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
       lty = c(1,1,1),lwd = c(2.5,2.5), col=c("black", "red", "blue"))

## turning off the PNG graphics device
dev.off()