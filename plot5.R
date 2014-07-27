## 
# Plot 5

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Load packages
library("plyr")
library("ggplot2")

# Load data
# This first line will likely take a few seconds.
# Assumes data files are in data directory of working directory
NEI <- readRDS("data//summarySCC_PM25.rds")
SCC <- readRDS("data//Source_Classification_Code.rds")

# Left join data together so we have all the information we need for each row
data <- join(NEI,SCC,by="SCC")

# Save a little memory
rm(NEI)
rm(SCC)

# Select only data from Baltimore fips == 24510
data.bal <- subset(data,fips == 24510)

# Select only the rows that are related to motor vehicle sources
# Considered using subset(SCC,grepl('Veh',Short.Name) which includes off-road motor vehicle sources
# but I stuck with filtering on "Onroad" because when you ask most people to to
# think about motor vechile emissions they're thinking about cars and traffic
# jams not tractors in fields
data.bal.onroad <- subset(data.bal,Data.Category == "Onroad" )

# Create summary table of total emissions per year from onroad  Vehicles in Baltimore
summary.bal.onroad <- ddply(data.bal.onroad, .(year), summarise, totalEmissions = sum(Emissions, na.rm = TRUE))

# This data isn't continuous so convert to a factor for nicer charting
summary.bal.onroad[["year"]] <- factor( summary.bal.onroad[["year"]], levels = unique(summary.bal.onroad[["year"]]) )

# Plot total emissions from onroad per year
ggplot(data=summary.bal.onroad, aes(x=year, y=totalEmissions, group = 1)) +
  geom_line() + 
  geom_point() + 
  xlab("Year") + 
  ylab("Emissions (tons)") + 
  ggtitle("Total PM2.5 emissions per year from Motor Vehicles in Baltimore, Maryland") 

# Save plot as plot.png
dev.copy(png, file = "plot5.png", width = 800, height = 400);
dev.off();