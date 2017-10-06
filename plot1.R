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
## cleaning the NA or (?) out of the vector of Global Actice Power data
clean <- complete.cases(as.numeric(subData$Global_active_power))

## assigning gap_vector name to the cleaned up Global Active Power Data
## ** NOTE: you must go from factor to character then to numeric!!! **
gap_vector <- as.numeric(as.character(subData$Global_active_power[clean]))

## open a png graphics device to write the histogram of Global Active Power
png(filename = "plot1.png", width = 480, height = 480, units = "px")

## make and write the histogram to the PNG graphics device
hist(gap_vector, breaks = 15, col = "red", ylim = c(0,1200), 
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

dev.off()

