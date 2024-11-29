#########################################################
# Purpose:

# Traders depend on the economy as it impacts their portfolio.
# Real GDP is the best measure of the economy.
# Ironically, traders do not derive the most value from the Real GDP figure. 
# They use leading indicators to have a rough estimate of what GDP growth will be.
# This is because GDP is yesterday's news. It is crucial to use leading and not lagging indicators.


# The following notes were taken from Bloomberg's Market Concepts Course (Economic Indicators)
# They are important because of the GDP equation:
# GDP = C + I + G + (X - M)
# C is consumer spending (like groceries) (related to housing starts)
# I is investment (like a factory) (tracked by business confidence)


# Indicators:
#   1. PMI Business Confidence Indicator (ISM Manufacturing)
# https://fred.stlouisfed.org/series/BSXRLV02USM086S used in place of ISM

# While consumers form the US economy, individual business leaders make bigger decisions 
# (investments, hiring) than individual consumers. It reflects their confidence in economic growth.

# The PMI Business Confidence Indicator is published on the first business day of 
# the following month. For example, the confidence for January is published on Monday Feb 3. 
# Actual is the actual published indicator value. Surv(M) is to the left of it, meaning survey. 
# It is a median value from analysts of what the value of the economic indicator will be upon release. 
# If actual > estimate it is a pleasant surprise; if actual < estimate is an unpleasant surprise. 
# AKA Alan Greenspan's desert island statistic. The one statistic to choose to 
# conduct US policy if stranded on a desert island.

# 2. Change in Non-farm payrolls (not used in analysis)
#    Indicator is also published on the first business day of the following month.
#    Actual is the actual published indicator value. Surv(M) is to the left of it, 
# meaning survey. It is a median value from analysts of what the value of the economic 
# indicator will be upon release. If actual > estimate it is a pleasant surprise; 
# if actual < estimate is an unpleasant surprise. 


# 3. Housing Starts
# https://fred.stlouisfed.org/series/HOUST
# If a builder builds a house, it means they are confident that consumers are 
# confident enough to assume a 30 year mortgage.
# When someone buys a house, they don't just buy the construction, they buy the furniture, 
# housing appliances, landscaping, tools, and all kinds of products so they can make the house livable.
# This is why the nominal impact of 3% of housing starts is a gross underestimate.

#    Indicator is published in the middle of the following month.
#    Actual is the actual published indicator value. Surv(M) is to the left of it, 
# meaning survey. It is a median value from analysts of what the value of the economic 
# indicator will be upon release. If actual > estimate it is a pleasant surprise; 
# if actual < estimate is an unpleasant surprise. 

# 4. Inflation (not used in analysis)
# erodes the value of bonds. Crucial for fixed income investors.
# Inflation is both a predictor of future prospects and a KPI for central banks.
#    Comes out around the middle of the month.


# 5. GDP
#    GDP for the quarter is released one month after the end of the quarter.
# Source; Bloomberg Market Concepts Course: Economic Indicators: Monitoring GDP
# https://portal.bloombergforeducation.com/courses/79/modules/345/watch


# Essential economic indicators:
# economic growth (real GDP), Inflation (CPI), Unemployment, Business confidence,
# housing (private housing starts total)
# Source: Bloomberg Market Concepts Course: The Primacy of GDP
# https://portal.bloombergforeducation.com/courses/79/modules/359/watch

# Unemployment
# Consumers make up 2/3rds of US economy. This is driven by salaries.
# Economy shrinks when people lose their jobs since people must tighten their 
# belts while they look for new jobs.

# This analysis uses the U6 rate instead of the widely used, more official U3 rate.

# Captures underemployment: The U6 unemployment rate includes individuals who are
# employed part-time for economic reasons, which means they would prefer to work
# full-time but cannot find full-time work. This accounts for the problem of underemployment, 
# which is not captured by the U3 unemployment rate.

# Includes discouraged workers: The U6 unemployment rate includes people who have
#become discouraged and have stopped actively looking for work. This means it
#captures the long-term unemployed who have given up hope of finding a job, which
# is not accounted for by the U3 unemployment rate.

# Provides a more complete picture: By including both the unemployed and underemployed,
# the U6 unemployment rate provides a more complete picture of the labor market than
# the U3 unemployment rate. It gives policymakers and analysts a better understanding
# of the level of joblessness and the extent of economic insecurity.

# Reflects the quality of jobs: The U6 unemployment rate can help to reflect the
# quality of jobs being created and the wages being earned. This is because it
# includes those who are employed part-time for economic reasons, which can help
# to identify trends in precarious and low-paying jobs.

# Different unemployment rates:
# U-1: The percentage of the civilian labor force that has been unemployed for 15 weeks or longer.
# U-2: The percentage of the civilian labor force that lost jobs or completed temporary jobs.
# U-3 (OFFICIAL): The percentage of the civilian labor force that is unemployed and has sought work in the past four weeks.
# U-4: The number of unemployed plus the number of discouraged job-seekers as a percentage of the total labor force.
# U-5: The total of the unemployed plus discouraged job-seekers plus marginally attached workers, as a percentage of the total labor force.
# U-6 (COMPLETE): All of the people counted in U-5 plus those working part-time due to economic conditions, as a percentage of the total labor force.

##########################################################


# load libraries
library(shiny)
library(fpp2)
library(quantmod)
library(shinythemes)
library(tseries) # for adf test for stationarity

# load data from FRED
symbols <- c( "BSXRLV02USM086S","U6RATE","HOUST" )
m = length(symbols)

getSymbols(symbols,src="FRED")

BUSINESS_EXPORT_ORDERS <- BSXRLV02USM086S # from symbols line
U6_COMPREHENSIVE_UNEMPLOYMENT_RATE <- U6RATE
NEW_PRIVATE_HOUSING_STARTS <- HOUST


# Define UI 
ui <- fluidPage(
  shinythemes::themeSelector(),
  #theme = shinytheme("cyborg"),
  pageWithSidebar(
    
    # Application title
    headerPanel("US Economy Leading Indicators"),
    
    # Sidebar with controls to select the dataset and forecast ahead duration
    sidebarPanel(
      # Select variable
      h6(selectInput("variable", "Variable:",
                     choices=c("BUSINESS_EXPORT_ORDERS", "U6_COMPREHENSIVE_UNEMPLOYMENT_RATE","NEW_PRIVATE_HOUSING_STARTS"))), # menu selector (crashing) must match line 123, 118, etc
      h6(textOutput("text1")),
      br(),
      h6(sliderInput("ahead", "Periods to Forecast Ahead:", min = 1, max = 24, value = 12, step = 1)),
      h6(numericInput("start", "Starting year:", 2010)),
      h6(checkboxInput("cleand", "Clean data", FALSE)),
      
      submitButton("Update View"),
      br(),
      p("All data sourced from St. Louis Federal Reserve. URL codes used:"),
      # notice the difference
      h6(p("Business Tendency Surveys for Manufacturing: Export Order Books or Demand: BSXRLV02USM086S")),
      h6(p("U-6 Comprehensive unemployment rate: U6RATE")),
      h6(p("New Privately-Owned Housing Units Started: Total Units: HOUST")),
      br(),
      
      img(src='logo.png', align = "left"),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br()
    ),
    
    
    
    # Show the caption and forecast plots
    mainPanel(
      h3(textOutput("caption")),
      #img(src='logo.png', align = "right"),
      tabsetPanel(
        tabPanel("ETS Forecast", plotOutput("etsForecastPlot"), verbatimTextOutput("etsForecastTable")), 
        tabPanel("Arima Forecast", plotOutput("arimaForecastPlot"), verbatimTextOutput("arimaForecastTable")),
        tabPanel("TBATS Forecast", plotOutput("tbatsForecastPlot"), verbatimTextOutput("tbatsForecastTable")),
        tabPanel("Holt-Winters Forecast", plotOutput("hwForecastPlot"), verbatimTextOutput("hwForecastTable")),
        tabPanel("TSLM Forecast", plotOutput("tslmForecastPlot"), verbatimTextOutput("tslmForecastTable")),
        tabPanel("Timeseries Decomposition", plotOutput("dcompPlot")),
        tabPanel("Timeseries plot", plotOutput("tsPlot"), verbatimTextOutput("adfTable")),
        tabPanel("Average (arima, ets, tbats, hw, tslm) forecasts", verbatimTextOutput("averageForecastTable"))
        
        
      )
    )
    
  ))



server <- (function(input, output) {
  
  getDataset <- reactive({
    data1 <- switch(input$variable,
                    BUSINESS_EXPORT_ORDERS = BUSINESS_EXPORT_ORDERS, # must match line 123 with BUSINESS_EXPORT_ORDERS <- BSXRLV02USM086S
                    U6_COMPREHENSIVE_UNEMPLOYMENT_RATE = U6_COMPREHENSIVE_UNEMPLOYMENT_RATE, # from symbols line; must match line with sidebar
                    NEW_PRIVATE_HOUSING_STARTS = NEW_PRIVATE_HOUSING_STARTS)
  })
  
  
  
  output$caption <- renderText({
    paste("Dataset: ", input$variable)
  })
  
  output$tsPlot <- renderPlot({
    
    y <- getDataset()
    date.start = input$start
    y   <-  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    # p1 = autoplot(y) + ylab("")
    # p2 = ggAcf(y) + ggtitle("")
    p1 = autoplot(y) + ylab("Value") + xlab("Time") + ggtitle("Change in Value over Time") + theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"), axis.title = element_text(size = 12)) + geom_line(color = "purple", size = 1.5)
    p2 = ggAcf(y) + ggtitle("") + theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"), axis.title = element_text(size = 12))
    
    gridExtra::grid.arrange(p1, p2, nrow=2)
  })
  
  output$adfTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    adf.test(y)
    #     fit <- auto.arima(y)
    # forecast(fit, h=input$ahead)
  })
  
  output$dcompPlot <- renderPlot({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    f <- decompose(y)
    autoplot(f)
  })
  
  output$arimaForecastPlot <- renderPlot({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- auto.arima(y)
    autoplot(forecast(fit, h=input$ahead))
  })
  
  output$arimaForecastTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- auto.arima(y)
    forecast(fit, h=input$ahead)
  })
  
  ################################################# ETS
  output$etsForecastPlot <- renderPlot({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- ets(y)
    autoplot(forecast(fit, h=input$ahead))
  })
  
  output$etsForecastTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- ets(y)
    forecast(fit, h=input$ahead)
  })
  
  ######################################################## TBATS
  output$tbatsForecastPlot <- renderPlot({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- tbats(y)
    autoplot(forecast(fit, h=input$ahead))
  })
  
  output$tbatsForecastTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- tbats(y)
    forecast(fit, h=input$ahead)
    
  })
  
  ############################################# Holt-Winters (see line 167)
  output$hwForecastPlot <- renderPlot({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- hw(y)
    autoplot(forecast(fit, h=input$ahead))
  })
  
  output$hwForecastTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- hw(y)
    forecast(fit, h=input$ahead)
    
  })
  
  ################################################# TSLM
  output$tslmForecastPlot <- renderPlot({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- tslm(y ~ trend + season)
    autoplot(forecast(fit, h=input$ahead))
  })
  
  output$tslmForecastTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit <- tslm(y ~ trend + season)
    forecast(fit, h=input$ahead)
  })
  
  ############################################################## Average
  
  output$averageForecastTable <- renderPrint({
    y <- getDataset()
    date.start = input$start
    y   =  ts(y[paste(date.start,end(y),sep="/")], start=date.start, freq=12 )
    
    # clean data
    if(isTRUE(input$cleand)){
      y <- tsclean(y)
    }
    # If clean is FALSE
    if(!isTRUE(input$cleand)){
      y <- y
    }
    
    fit1 <- ets(y)
    fc1 = forecast(fit1, h=input$ahead)
    
    fit2 = auto.arima(y)
    fc2 = forecast(fit2, h=input$ahead)
    
    fit3 = tbats(y)
    fc3 = forecast(fit3, h=input$ahead)
    
    fit4 = hw(y)
    fc4 = forecast(fit4, h=input$ahead)
    
    fit5 <- tslm(y ~ trend + season)
    fc5=forecast(fit5, h=input$ahead)
    
    fc = (fc1$mean + fc2$mean + fc3$mean + fc4$mean + fc5$mean)/5
    fc
  })
  
  
  
  output$text1 <- renderText({
    
    switch(input$variable,
           BUSINESS_EXPORT_ORDERS = "Business sentiment.",
           U6_COMPREHENSIVE_UNEMPLOYMENT_RATE = "US monthly unemployment rate.", # line 191 get Dataset (non crashing)
           NEW_PRIVATE_HOUSING_STARTS = "New Privately-Owned Housing Units Started (Total)")
  })
  
})


# Run the application 
shinyApp(ui = ui, server = server)
