## 
# Plot 1

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Load packages
library("plyr")

# Load data
# This first line will likely take a few seconds.
# Assumes data files are in data directory of working directory
NEI <- readRDS("data//summarySCC_PM25.rds")
SCC <- readRDS("data//Source_Classification_Code.rds")

# Create summary table or total emissions per year
PMyear <- ddply(NEI, .(year), summarise, totalEmissions = sum(Emissions, na.rm = TRUE) / 1000000)

# Plot total per
plot(PMyear[["year"]], PMyear[["totalEmissions"]], type="l", xlab="Year", ylab="Emissions (million tons)",  xaxt="n", main = "Total PM2.5 emissions per year")
# Default axis is a little misleading so add custom axis intervals 
axis(side=1, at=PMyear[["year"]])

# Save plot as plot.png
dev.copy(png, file = "plot1.png", width = 800, height = 600);
dev.off();