## About this app
Montgomery County Vehicle Crime Data Analysis helps in understanding crime patterns related to vehicles in this county.
Data is pulled from <a href="https://data.montgomerycountymd.gov/Public-Safety/Crime/icn6-v9z3" target="_blank">Montgomery County Open Data Website</a>.

## Technology Used
This app is built using <a href="http://www.r-project.org/" target="_blank">R</a> and <a href="http://shiny.rstudio.com/" target="_blank">Shiny</a>. The <a href="https://github.com/krishnaitdbg/MontgomeryVehicleCrime" target="_blank">code</a> is available on github.

## Dashboard View
Dashboard view analyzes Montgomery County Vehicle Data dating from year 2016 to till date.
It also renders pie donut and box plots for better understanding of crime stats across the Montgomery county, MD.

## Map View
Map view analyzes Montgomery County Vehicle Data dating from year 2016 to till date.
And renders leaflet map with multiple layers of vehicle crime types and map backgrounds.
Try layers options to view vehicle crime data geographically.

## Twitter View (Sankey Diagram)
Twitter view is of Sankey diagram for analyzing user tweets which contain search keyword 'Geico'. 
This Sankey diagram analyzes twitter data (tweets done with in 50 miles radius of Montgomery County).
And it does word counts for each user and establish relationships between twitter users via commonly used words. 
Data is obtained using Twitter APIs from  <a href="https://developer.twitter.com/">Twitter Developers Website</a>.
Try hovering over the nodes and links between nodes to see pop up information about the word counts.

Please note that Sankey diagram is done only for top few twitter users with highest word usage of keyword 'Geico'.

And this view also shows word cloud for top ranking twitter words collected among all twitter users.

