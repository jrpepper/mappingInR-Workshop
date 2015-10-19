fluidPage(
  navbarPage("Berkeley Crime Map", id="nav",
             tabPanel("Map", icon = icon("map-marker"),
                      div(class="outer",
                          tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                          leafletOutput("map", width="100%", height="100%"),
                          
                          absolutePanel(top = 30, right = 30,
                                        wellPanel(style = "background-color: #ffffff; width: 350px",
                                                  selectizeInput('offenseFilter', 'Filter by type(s) of offenses:', choices = c(offenseList), multiple=TRUE)
                                        )
                          )
                      )
             ),
             tabPanel("About",
                      icon = icon("question"),
                      
                      #content on left hand side of the page
                             h1("About"),
                             br(),
                             p("Default is to display data from the past year. To change data range, click on the advanced options tab.")
                      )
  )
)