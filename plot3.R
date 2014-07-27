## 
# Plot 3

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999–2008 for Baltimore City? 

# Which have seen increases in emissions from 1999–2008? 

# Use the ggplot2 plotting system to make a plot answer this question.

# Load packages
library("plyr")
library("ggplot2")

# Load data
# This first line will likely take a few seconds.
# Assumes data files are in data directory of working directory
NEI <- readRDS("data//summarySCC_PM25.rds")

# Subset data just for fips == 24510
NEI.bal <- subset(NEI,fips == 24510)

# Create summary table or total emissions per year
pYearType <- ddply(NEI.bal, .(year, type), summarise, totalEmissions = sum(Emissions, na.rm = TRUE))

# This data isn't continuous so convert to a factor for nicer charting
pYearType[["year"]] <- factor(pYearType[["year"]], levels = unique(pYearType[["year"]]) )

# Plot total per year per type
ggplot(data=pYearType, aes(x=year, y=totalEmissions, group=type, colour=type)) +
  geom_line() + 
  geom_point() + 
  xlab("Year") + 
  ylab("Emissions (tons)") + 
  ggtitle("Total PM2.5 emissions per year in Baltimore City, Maryland by type") + 
  scale_colour_hue(name="Emission type")

# Save plot as plot.png
dev.copy(png, file = "plot3.png", width = 800, height = 400);
dev.off();