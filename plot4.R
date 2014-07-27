## 
# Plot 4

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Load packages
library("plyr")
library("ggplot2")

# Load data
# This first line will likely take a few seconds.
# Assumes data files are in data directory of working directory
NEI <- readRDS("data//summarySCC_PM25.rds")
SCC <- readRDS("data//Source_Classification_Code.rds")

# Need to find which sources AKA SCC id's are coal combustion-related
# left join data together so we have all the information we need for each row
data <- join(NEI,SCC,by="SCC")

# EPA only collects data for USA so we don't need to worry about filtering by country
# Select only the rows that are related to coal combustion
# EI.Sector column contains this information within a string using the keywords "Comb" and "Coal" 
# Select rows where EI.Sector column contains "Comb" and "Coal"
data.coal <- subset( data, grepl('Coal.*Comb|Comb.*Coal',EI.Sector) )

# Create summary table of total emissions per year from coal combustion
summary.coal <- ddply(data.coal, .(year), summarise, totalEmissions = sum(Emissions, na.rm = TRUE))

# This data isn't continuous so convert to a factor for nicer charting
summary.coal[["year"]] <- factor( summary.coal[["year"]], levels = unique(summary.coal[["year"]]) )

# Plot total emissions from coal per year
ggplot(data=summary.coal, aes(x=year, y=totalEmissions, group = 1)) +
  geom_line() + 
  geom_point() + 
  xlab("Year") + 
  ylab("Emissions (tons)") + 
  ggtitle("Total PM2.5 emissions per year from coal combustion in USA") 

# Save plot as plot.png
dev.copy(png, file = "plot4.png", width = 800, height = 400);
dev.off();