# Define server logic to render output

shinyServer(function(input, output) {
    ## Total Crimes stats value box
    output$totalCrimes <- renderUI({
        valueBox(
            dim(montgomery_crime_data)[1], "Total Crimes", icon = icon("gavel", lib="font-awesome"),
            color = "green", width=NULL
        )
    })
    
    ## Vehicle Crimes stats value box
    output$vehicleCrimes <- renderUI({
        valueBox(
            dim(veh_crime_df)[1], "Vehicle Crimes", icon = icon("car-crash", lib="font-awesome"),
            color = "yellow", width=NULL
        )
    })
    
    ## render plot donutplot1
    output$donutplot1 <- renderPlotly({
            plot_ly(montgomery_donut,labels = ~Crime.Name3, values = ~Count) %>%
            add_pie(hole=0.7) %>%
            layout(title = "Vehicle Crime Type Analysis (Years 2016 - 2019)",  
                   showlegend=F, margin=list(t=50, b=120, l=75, r=75), height=500,
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })  
    
    ## render plot donutplot2
    output$donutplot2 <- renderPlotly({
        plot_ly(montgomery_donut2, labels = ~City, values = ~Count) %>%
            add_pie(hole=0.7) %>%
            layout(title = "Vehicle Crime City Analysis (Years 2016 - 2019)",  
                   showlegend=F, margin=list(t=50, b=240, l=75, r=75), height=500,
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })  
    
    ## render plot boxplot1
    output$boxplot1 <- renderPlotly({
        plot_ly(plotbox, x = ~Year, color = ~Police.District.Name, type = "box") %>%
            layout(title="Police District Crime Distribution (Years 2016 - 2019)",
                   margin=list(t=75, b=100, l=50, r=75), height=500, showlegend=FALSE)
    })  
    
    ## render map mapPlot
    output$mapPlot <- renderLeaflet({
        map_layers()
    })  
    
    ## render networkD3 Sankey diagram
    output$d3Plot <- renderSankeyNetwork({
        sankeyNetwork(Links = links, Nodes = nodes, 
                                 Source = 'source', 
                                 Target = 'target', 
                                 Value = 'value', 
                                 NodeID = 'name',
                                 units = 'words',
                                 fontSize=12,
                                 height="500px",
                                 width="100%"
        )
    })
    
## render word cloud for Twitter data
    output$wcPlot <- renderPlot({
        set.seed(1234)
        wordcloud(final_df3$target, final_df3$Count, max.words=40, colors=brewer.pal(1, "Dark2"))
    })
    
})
