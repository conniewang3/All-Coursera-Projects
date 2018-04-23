## Air Quality Assignment (Coursera)

#### Objective
The goal of this assignment was to create exploratory graphs that answer
questions about how fine particulate matter (PM2.5) emissions have changed
between 1999 and 2008

#### Data
Data was aquired from the Environmental Protection Agency (EPA) National 
Emissions Inventory website and encoded in two files which are included in
this repository. The first is summarySCC_PM25.rds, which contains a data frame
containing PM2.5 emissions data for 1999, 2002, 2005, and 2008. This file 
includes information about the source of emission (given as an source 
classification code, or SCC) and location by county (given as a 5-digit fips)
The second file, Source_Classification_Code.rds, contains a mapping from SCC to
actual name of the source, including "short name" and other categorizations.

#### Analysis
plot1.R . . . plot6.R contain code that generates plot1.png . . . plot6.png.
These plots answer the following questions:
> 1. Have total emissions from PM2.5 decreased in the United States from 1999 to
> 2008? 
> 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
> from 1999 to 2008?
> 3. Of the four types of sources indicated by the type (point, nonpoint, onroad> , nonroad) variable, which of these four sources have seen decreases in
> emissions from 1999-2008 for Baltimore City? Which have seen increases in
> emissions from 1999-2008? 
> 4. Across the United States, how have emissions from coal combustion-related
> sources changed from 1999-2008?
> 5. How have emissions from motor vehicle sources changed from 1999-2008 in 
> Baltimore City?
> 6. Compare emissions from motor vehicle sources in Baltimore City with
> emissions from motor vehicle sources in Los Angeles County, California. Which > city has seen greater changes over time in motor vehicle emissions?

Plot 1 shows that the total PM2.5 emissions have decreased in the United States 
overall from 1999 to 2008. 

Plot 2 shows that emissions in Baltimore City, Maryland have decreased overall
from 1999 to 2008, but spiked in 2005 to a level above 2002 emissions but still 
below 1999 levels.

Plot 3 shows that emissions from nonpoint, non-road, and on-road sources have 
all decreased overall from 1999 to 2008, but emissions from point sources have
actually gone up slightly, with an increasing trend from 1999 to 2005, but then
a sharp drop from 2005 to 2008, bringing 2008 levels to below 2002 levels, but 
above 1999 levels.

Plot 4 shows that emissions from coal combustion related sources across the
United States stayed relatively constant from 1999 to 2005, but decreased 
sharply from 2005 to 2008.

Plot 5 shows that emissions from motor vehicles have decreased steadily from 
1999 to 2008.

Plot 6 shows that emissions from motor vehicles has stayed relatively constant
in both Los Angeles County and Baltimore City. Los Angeles has seen more change
over time in absolute terms, but also has a much higher level of emissions
in general than Baltimore City (probably due to it being a more populated 
county). As a proportion of total emissions, Baltimore City has seen greater 
changes. 