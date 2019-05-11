# Copy all necessary libraries
library("twitteR")
library("tidyr")
library("dplyr")
library("lubridate")
library("plotly")
library("shinyBS")
library("shinydashboard")
library("shinyjs")
library("stringr")
library("RColorBrewer")
library("leaflet")
library("V8")
library("markdown")
library("lazyeval")
library("tm")
library("networkD3")
library("wordcloud")


###  Read Montgomery county crime data 
### https://data.montgomerycountymd.gov/api/views/icn6-v9z3/rows.csv?accessType=DOWNLOAD
montgomery_crime_data <- read.csv("data/Crime.csv", stringsAsFactors=FALSE)

veh_crime_df <- montgomery_crime_data %>% filter(str_detect(Crime.Name3, "AUTO*|DRIV*|VEHI*")) 

### Create datasets for generating pie donut charts
montgomery_donut <- veh_crime_df %>% group_by(Crime.Name3) %>% summarize(Count=n()) %>% arrange(desc(Count))
montgomery_donut2 <- veh_crime_df %>% group_by(City) %>% summarize(Count=n()) %>% arrange(desc(Count)) %>% head(25)

### Create data for generating box plot
plotbox <- veh_crime_df %>% group_by(Year=year(mdy_hms(Start.Date.Time)), Police.District.Name) %>% 
  summarize(Count=n()) %>% arrange(desc(Count))

### Create data for generating map with layers
unique_crime_df <- veh_crime_df %>%  group_by(Crime.Name3) %>% summarize(Count=n()) %>% arrange(desc(Count))
markCol <- colorFactor(topo.colors(n_distinct(veh_crime_df$Crime.Name3)), domain=veh_crime_df$Crime.Name3)

map_layers <- function() {
  #base map 
  map <- leaflet() %>%
    addTiles(group ="OpenStreetMap")  %>%
    addProviderTiles("Stamen.TonerLite", group ="TonerLite") %>%
    addProviderTiles("CartoDB.Positron", group ="CartoDB") %>%
    addProviderTiles("CartoDB.DarkMatter", group ="CartoDBDark",
                     options=(providerTileOptions(opacity=1))) %>%
    addProviderTiles("Esri.WorldImagery") %>% addProviderTiles("Hydda.RoadsAndLabels",group="SatImagery") 
  
  #loop through all groups and add a layer one at a time
  for (i in unique_crime_df$Crime.Name3) {
    map_tempdata <- veh_crime_df %>% filter(Crime.Name3 == i)
    map <- map %>% 
      addCircleMarkers(
        group = i,
        data = map_tempdata, 
        lat= ~Latitude, lng= ~Longitude,
        popup = paste("CrimeDesc:",map_tempdata$Crime.Name3,"<br>",
                      "Location:",map_tempdata$Block_Address,map_tempdata$City,"<br>",
                      "Date of Crime:",map_tempdata$Start.Date.Time),
        color = markCol(i),
        fillOpacity = 0.9,stroke = FALSE,
        clusterOptions=markerClusterOptions()
      )
  }
  
  #create layer control
  map %>% 
    addLayersControl(
      baseGroups = c("OpenStreetMap","TonerLite","CartoDB","CartoDBDark","SatImagery"),
      overlayGroups = unique_crime_df$Crime.Name3,
      options = layersControlOptions(collapsed = TRUE)) %>% 
    hideGroup(unique_crime_df$Crime.Name3[2:n_distinct(unique_crime_df$Crime.Name3)]) #hide all groups except the 1st one
}

### Process Twitter data
tweets_df <- read.csv("data/tweets.csv", stringsAsFactors=FALSE)

# Do text mining on searched twitter data
final_df <- data.frame()
sname_df <- tweets_df %>% group_by(screenName) %>% summarise(Count=n()) %>% arrange(desc(Count)) %>% head(15)
for (sname in sname_df$screenName) {
  temp_df <- tweets_df %>% filter(screenName==sname)
  corpus <- VCorpus(VectorSource(temp_df$text))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeWords, c("the", "and", stopwords("english")))
  corpus <- tm_map(corpus, stripWhitespace)
  dtm <- DocumentTermMatrix(corpus)
  frequency = data.frame(sort(colSums(as.matrix(dtm)), decreasing=TRUE))
  frequency <- data.frame(rownames(frequency), frequency[,1])
  frequency['Source']=sname
  final_df <- rbind(final_df,frequency)
}

# Prepare text mined data for Sankey diagram
colnames(final_df) <- c('target','value','source')
final_df2 <- final_df %>% group_by(source) %>% top_n(3,value) %>% head(30)  

snames <- unique(as.character(final_df2$source))
twords <- unique(as.character(final_df2$target))
num_nodes <- length(snames)+length(twords)-1
nodes <- data.frame(node = c(0:num_nodes), name= c(snames, twords))

final_df2 <- merge(final_df2, nodes, by.x = "source", by.y = "name")
final_df2 <- merge(final_df2, nodes, by.x = "target", by.y = "name")

links <- final_df2[ , c("node.x", "node.y", "value")]
colnames(links) <- c("source", "target", "value")

### Process Twitter word count
final_df3 <- final_df %>% group_by(target) %>% summarise(Count=n()) %>% arrange(desc(Count)) 

