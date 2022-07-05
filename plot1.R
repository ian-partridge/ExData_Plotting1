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

## 2 Create plot 1 as a png
png("plot1.png", width = 480, height = 480, units = "px")
hist(dt$Global_active_power, 
     col="red",
     main="Global Active Power",
     xlab ="Global Active Power (kilowatts)")
dev.off()