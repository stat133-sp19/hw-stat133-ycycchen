library(shiny)
library(ggplot2)
library(reshape2)

# Define UI for application that outputs a plot and a data table
ui <- fluidPage(
  
  # Application title
  titlePanel("Annual Balances of Different Saving Modalities"),
  
  # inputs
  fluidRow(
    column(4,
           sliderInput("initial",
                       "Initial Amount",
                       min = 0,
                       max = 100000,
                       value = 1000,
                       step = 500,
                       pre = "$")
    ),
    column(4,
           sliderInput("rate",
                       "Return Rate (in %)",
                       min = 0,
                       max = 20,
                       step = 0.1,
                       value = 5)
    ),
    column(4,
           sliderInput("years",
                       "Years",
                       min = 0,
                       max = 50,
                       step = 1,
                       value = 20)
    )
  ),
  fluidRow(
    column(4,
           sliderInput("contrib",
                       "Annual Contribution",
                       min = 0,
                       max = 50000,
                       value = 2000,
                       step = 500,
                       pre = "$")
    ),
    column(4,
           sliderInput("growth",
                       "Growth Rate (in %)",
                       min = 0,
                       max = 20,
                       value = 2,
                       step = 0.1)
    ),
    column(4,
           selectInput("facet",
                       "Facet?",
                       c("No", "Yes"),
                       "No")
    )
  ),
  
  hr(),
  
  # outputs
  h4("Timelines"),
  fluidRow(
    column(12,
           plotOutput("timelines")
    )
  ),
  
  h4("Balances"),
  fluidRow(
    column(12,
           verbatimTextOutput("balances")
    )
  )
)


# Define server logic
server <- function(input, output) {
  
  #' @title future_value
  #' @description compute the future value of an investment
  #' @param amount initial invested amount
  #' @param rate annual rate of return
  #' @param years number of years
  #' @return the future value of an investment
  
  future_value <- function(initial, rate, years){
    FV <- initial*(1+rate)^years
    return(FV)
  }
  
  #' @title annuity
  #' @description compute the future value of annuity
  #' @param contrib contributed amount
  #' @param rate annual rate of return
  #' @param years number of years
  #' @return the future value of annuity
  
  annuity <- function(contrib, rate, years){
    FVA <- contrib*(((1 + rate) ^ years - 1) / rate)
    return(FVA)
  }
  
  #' @title growing_annuity
  #' @description compute the future value of growing annuity
  #' @param contrib contributed amount
  #' @param growth annual growth rate
  #' @param rate annual rate of return
  #' @param years number of years
  #' @return the future value of growing annuity
  
  growing_annuity <- function(contrib, growth, rate, years){
    FVGA <- contrib*(((1 + rate) ^ years - (1 + growth) ^ years) / (rate - growth))
    return(FVGA)
  }
  
  modalities <- reactive({
    
    year <- as.integer(seq(from = 0, to = input$years, by = 1))
    no_contrib <- year
    fixed_contrib <- year
    growing_contrib <- year
    
    for(i in year){
      
      no_contrib[i+1] <- 
        future_value(initial = input$initial, rate = input$rate/100, years = i)
      
      fixed_contrib[i+1] <- 
        future_value(input$initial, input$rate/100, i) +
        annuity(input$contrib, input$rate/100, i)
      
      growing_contrib[i+1] <- 
        future_value(input$initial, input$rate/100, i) +
        growing_annuity(input$contrib, input$rate/100, input$growth/100, i)
      
    }
    
    modalities <- data.frame(year, no_contrib, fixed_contrib, growing_contrib)
    return(modalities)
  })
  
  modalities_graph <- reactive({
    modalities_graph <- melt(modalities(), id = "year")
    names(modalities_graph) <- c("year", "modality", "balance")
    return(modalities_graph)
  })
  
  
  output$timelines <- renderPlot(
    if (input$facet == "No") {
      ggplot(modalities_graph(), aes(x = year, y = balance, color = modality)) + 
        geom_line(size = 1) + 
        geom_point() + 
        ggtitle("Three Modes of Investing") + 
        xlab("year") + 
        ylab("balance")
    } else {
      ggplot(modalities_graph(), aes(x = year, y = balance, color = modality)) +
        geom_area(aes(fill = modality), alpha = 0.5, linetype = 0) +
        geom_line(size = 1) + 
        geom_point() + 
        ggtitle("Three Modes of Investing") + 
        xlab("year") + 
        ylab("balance") +
        facet_grid(~modality) + 
        theme_bw()
        
    }
  )
  
  output$balances <- renderPrint({
    modalities()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

