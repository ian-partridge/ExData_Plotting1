# open the data
library(data.table)
library(dplyr)
library(lubridate)

## 1 Load and sort measurements into data.table
# get column names in household_power_consumption.txt
cNames <- colnames(fread("household_power_consumption.txt", nrows = 1))
#read all feb 2007 data with column names defined
dtfeb <- fread("grep \\/2\\/2007 household_power_consumption.txt", col.names = cNames)
#combine date and time to make a datetime object as column called  dateTime
dtfeb$dateTime <- as.POSIXct(paste(dtfeb$Date, dtfeb$Time), format="%d/%m/%Y %H:%M:%S") 
#subset only the 1st and 2nd February and drop Date and Time columns
dt <- dtfeb[(Date == "1/2/2007")|(Date == "2/2/2007"), -c("Date","Time")]
# remove potential "?" rows
dt <- dt[(dt$Global_active_power != "?"| dt$Global_reactive_power != "?"| dt$Voltage != "?"| dt$Global_intensity!= "?"|dt$Sub_metering_1 != "?"| dt$Sub_metering_2 != "?"| dt$Sub_metering_3)]
dt$Global_active_power <- as.numeric(dt$Global_active_power)
rm(dtfeb)  # remove dtfeb from environment/memory

## 2 Create plot 4 as a png
png("plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2, 2))
#plot 1,1
plot(x= dt$dateTime,
     y = dt$Global_active_power,
     type="l",
     lwd = 1,
     col="black",
     xlab = "",
     ylab ="Global Active Power (kilowatts)")
# plot 1,2
plot(x= dt$dateTime,
     y = dt$Voltage,
     type="l",
     lwd = 1,
     col="black",
     xlab = "datetime",
     ylab ="Voltage")
# plot 2, 1
plot(x= dt$dateTime,
     y = dt$Sub_metering_1,
     type="l",
     lwd = 1,
     col="black",
     xlab = "",
     ylab ="Energy sub metering")
lines(x= dt$dateTime,y = dt$Sub_metering_2,col="red")
lines(x= dt$dateTime,y = dt$Sub_metering_3,col="blue")
legend("topright",
       c(3,1), 
       lwd =1,
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black", "red", "blue"))
# plot 2,2
plot(x= dt$dateTime,
     y = dt$Global_reactive_power,
     type="l",
     lwd = 1,
     col="black",
     xlab = "datetime",
     ylab ="Global_reactive_power")
dev.off()