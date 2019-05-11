dashboardPage(
    skin = "purple",
    
    dashboardHeader(
        title = "Montogomery County Vehicle Crime Analysis",
        titleWidth=425
    ),
    
    dashboardSidebar(
        useShinyjs(),
        sidebarMenu(id = "sidebar",
            menuItem("Dashboard", tabName = "dashboardView",
                     icon = icon("car", lib="font-awesome")
            ),
            menuItem("Map", tabName = "mapView",
                     icon = icon("globe-americas", lib="font-awesome")
            ),
            menuItem("Twitter", tabName = "networkView",
                     icon = icon("share-alt", lib="font-awesome")
            ),
            menuItem("About", tabName = "about",
                     icon = icon("info-circle", lib="font-awesome")
            )
        )
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = "dashboardView",
                    fluidRow(
                        column(width=6,
                               box(width = NULL, 
                                   title = "Pie Donuts", color = "aqua", 
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   plotlyOutput("donutplot1", width='auto',height='auto'),
                                   plotlyOutput("donutplot2", width='auto',height='auto')
                               )
                        ),
                        column(width=6,
                               uiOutput("totalCrimes", width='auto',height='auto'),
                               uiOutput("vehicleCrimes", width='auto',height='auto'),
                               box(width = NULL, 
                                   title = "Box Plot", color = "aqua", 
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   plotlyOutput("boxplot1", width='auto',height='auto')
                               )
                           )
                    )
            ),
            
            tabItem(tabName = "mapView",
                    fluidRow(
                        column(12,
                               leafletOutput('mapPlot', width = "100%", height = 700)
                        )
                    )
            ),
            
            tabItem(tabName = "networkView",
                    fluidRow(
                        column(12,
                               box(width = NULL, 
                                   title = "Twitter Sankey Diagram for keyword Geico", color = "aqua", 
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   sankeyNetworkOutput('d3Plot')),
                               box(width = NULL, 
                                   title = "Twitter Word Cloud for keyword Geico", color = "aqua", 
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   plotOutput('wcPlot'))
                        )
                    )
            ),
            
            tabItem(tabName = "about",
                    box(width = 12,
                        includeMarkdown("www/about.md")
                    )
            )
            
        ) 
    )  
) 
