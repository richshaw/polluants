## 
# Plot 6

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?

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

# Select only data from Baltimore fips == 24510 or LA fips = "06037"
# Note LA fips is not an integer
data.balLa <- subset(data,fips == "24510" | fips == "06037")

# Select only the rows that are related to motor vehicle sources
# Considered using subset(SCC,grepl('Veh',Short.Name) which includes off-road motor vehicle sources
# but I stuck with filtering on "Onroad" because when you ask most people to to
# think about motor vechile emissions they're thinking about cars and traffic
# jams not tractors in fields
data.balLa.onroad <- subset(data.balLa,Data.Category == "Onroad" )

# Create summary table of total emissions per year from onroad  Vehicles in Baltimore and LA
summary.balLa.onroad <- ddply(data.balLa.onroad, .(fips, year), 
                              summarise, totalEmissions = sum(Emissions, na.rm = TRUE))


# This data isn't continuous so convert to a factor for nicer charting
summary.balLa.onroad[["year"]] <- factor( summary.balLa.onroad[["year"]],levels = unique(summary.balLa.onroad[["year"]]) )

# fips isn't very descriptive so rename
names(summary.balLa.onroad)[names(summary.balLa.onroad) == 'fips'] <- 'location'

# fips id's are confusing so convert to factor to make it easier to understand
summary.balLa.onroad[["location"]] <- factor( summary.balLa.onroad[["location"]],
                                              levels = unique(summary.balLa.onroad[["location"]]), 
                                              labels = c("LA county","Baltimore City") )

# Plot total emissions from onroad per year
# ggplot(data=summary.balLa.onroad, aes(x=year, y=totalEmissions, group=location, colour=location)) +
# geom_line() +
# geom_point() +
# xlab("Year") +
# ylab("Emissions (tons)") +
# ggtitle("Total PM2.5 emissions per year from Motor Vehicles in Baltimore City & LA county)") +
# scale_colour_discrete(name  = "Location")

# This plot  shows changes overtime but does it show *Which city has seen greater changes over time*?
# Solution: Calculate % change YoY and plot that
summary.balLa.yoy <- ddply(summary.balLa.onroad, .(location), transform, yoy = ((100 / totalEmissions[1]) * totalEmissions) - 100)

# Plot YOY percentage change
ggplot(data=summary.balLa.yoy, aes(x=year, y=yoy, group=location, colour=location)) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Emissions (% change year on year)") +
  ggtitle("% change in PM2.5 emissions year on year from Motor Vehicles in Baltimore City & LA county)") +
  scale_colour_discrete(name  = "Location")

# Save plot as plot.png
dev.copy(png, file = "plot6.png", width = 800, height = 400);
dev.off();