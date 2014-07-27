## 
# Plot 2

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == 24510) from 1999 to 2008?

# Load packages
library("plyr")

# Load data
# This first line will likely take a few seconds.
# Assumes data files are in data directory of working directory
NEI <- readRDS("data//summarySCC_PM25.rds")


# Subset data just for fips == 24510
NEI.bal <- subset(NEI,fips == 24510)

# Create summary table or total emissions per year
PMyear <- ddply(NEI.bal, .(year), summarise, totalEmissions = sum(Emissions, na.rm = TRUE))

# Plot total per
plot(PMyear[["year"]], PMyear[["totalEmissions"]], type="l", xlab="Year", ylab="Emissions (tons)",  xaxt="n", main = "Total PM2.5 emissions per year in Baltimore City, Maryland")
# Default axis is a little misleading so add custom axis intervals 
axis(side=1, at=PMyear[["year"]])

# Save plot as plot.png
dev.copy(png, file = "plot2.png", width = 800, height = 600);
dev.off();