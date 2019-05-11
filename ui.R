dashboardPage(
    skin = "purple",
    
    dashboardHeader(
        title = "Montogomery County Vehicle Crime Data Dashboard",
        titleWidth=1500
    ),
    
    dashboardSidebar(
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
                               box(width=NULL,
                                   title = "Pie Donut", 
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   plotlyOutput("donutplot1", height=NULL)
                               ),
                               box(width=NULL, 
                                   title = "Pie Donut",  
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   plotlyOutput("donutplot2", height=NULL)
                               )
                        ),
                        column(width=6,
                               uiOutput("totalCrimes", width = NULL),
                               uiOutput("vehicleCrimes", width = NULL),
                               box(width = NULL, 
                                   title = "Box Plot", 
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   plotlyOutput("boxplot1", height=NULL)
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
