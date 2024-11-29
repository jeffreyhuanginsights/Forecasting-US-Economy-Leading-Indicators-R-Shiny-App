# Forecasting-US-Economy-Leading-Indicators-R-Shiny-App
## Purpose
This app uses a variety of statistical models to forecast leading indicators that will affect the US economy, allowing a user of the app to make predictions. For example, traders may use the app to predict the economy.

Traders depend on the economy as it impacts their portfolio. Usually, Real GDP or Real GDP Per Capita is the best measure of the economy.
The problem is, GDP is yesterday's news (a lagging indicator). Traders need to use leading indicators to have a rough estimate of what GDP growth will be.

They are important because of the GDP equation:
GDP = C + I + G + (X - M)

C is consumer spending (like groceries) (related to housing starts)

I is investment (like a factory) (tracked by business confidence)

The app uses these statistical techniques: ETS Forecast, Arima Forecast, TBATS Forecast, Holt-Winters Forecast, TSLM Forecast, Timeseries Decomposition, Timeseries Plot, Average (arima, ets, tbats, hw, tslm) Forecasts.

## Using the App
Please note that the app takes some time to load the data and perform the calculations. You may have to wait a few seconds for the analysis to load.

At the top right, you can use a dropdown menu to change the theme of the App (which may be useful if you prefer dark modes). Using the menu on the left side you can control the parameters of the analysis. 

## Indicators Used in this App
The following notes were taken from Bloomberg's Market Concepts Course (Economic Indicators)
### 1. PMI Business Confidence Indicator (ISM Manufacturing)
Source: https://fred.stlouisfed.org/series/BSXRLV02USM086S (used in place of ISM)

While consumers form the US economy, individual business leaders make bigger decisions (investments, hiring) than individual consumers. It reflects their confidence in economic growth.

The PMI Business Confidence Indicator is published on the first business day of the following month. For example, the confidence for January is published on Monday Feb 3. 
Actual is the actual published indicator value. Surv(M) is to the left of it, meaning survey. 
It is a median value from analysts of what the value of the economic indicator will be upon release. If actual > estimate it is a pleasant surprise; if actual < estimate is an unpleasant surprise. 
AKA Alan Greenspan's desert island statistic. The one statistic to choose to conduct US policy if stranded on a desert island.

### 2. Change in Non-farm payrolls (not used in analysis)
Indicator is also published on the first business day of the following month.
Actual is the actual published indicator value. Surv(M) is to the left of it, meaning survey. It is a median value from analysts of what the value of the economic indicator will be upon release. If actual > estimate it is a pleasant surprise; if actual < estimate is an unpleasant surprise. 

### 3. Housing Starts
https://fred.stlouisfed.org/series/HOUST

If a builder builds a house, it means they are confident that consumers are confident enough to assume a 30 year mortgage.
When someone buys a house, they don't just buy the construction, they buy the furniture, housing appliances, landscaping, tools, and all kinds of products so they can make the house livable.
This is why the nominal impact of 3% of housing starts is a gross underestimate.

Indicator is published in the middle of the following month. Actual is the actual published indicator value. Surv(M) is to the left of it, meaning survey. It is a median value from analysts of what the value of the economic indicator will be upon release. If actual > estimate it is a pleasant surprise; 
if actual < estimate is an unpleasant surprise. 

### 4. Inflation (not used in analysis)
Inflation erodes the value of bonds, so it is a crucial consideration for fixed income investors. Inflation is both a predictor of future prospects and a KPI for central banks. It Comes out around the middle of the month.

### 5. GDP
GDP for the quarter is released one month after the end of the quarter.

Source; Bloomberg Market Concepts Course: Economic Indicators: Monitoring GDP
https://portal.bloombergforeducation.com/courses/79/modules/345/watch

Essential economic indicators:
economic growth (real GDP), Inflation (CPI), Unemployment, Business confidence, housing (private housing starts total)

Source: Bloomberg Market Concepts Course: The Primacy of GDP
https://portal.bloombergforeducation.com/courses/79/modules/359/watch

### Unemployment
Consumers make up 2/3rds of US economy. This is driven by salaries. Economy shrinks when people lose their jobs since people must tighten their belts while they look for new jobs.

This analysis uses the U6 rate instead of the widely used, more official U3 rate. Here are some reasons why:

Captures underemployment: The U6 unemployment rate includes individuals who are employed part-time for economic reasons, which means they would prefer to work full-time but cannot find full-time work. This accounts for the problem of underemployment, which is not captured by the U3 unemployment rate.

- Includes discouraged workers: The U6 unemployment rate includes people who have become discouraged and have stopped actively looking for work. This means it captures the long-term unemployed who have given up hope of finding a job, which is not accounted for by the U3 unemployment rate.
- Provides a more complete picture: By including both the unemployed and underemployed, the U6 unemployment rate provides a more complete picture of the labor market than the U3 unemployment rate. It gives policymakers and analysts a better understanding of the level of joblessness and the extent of economic insecurity.
- Reflects the quality of jobs: The U6 unemployment rate can help to reflect the quality of jobs being created and the wages being earned. This is because it includes those who are employed part-time for economic reasons, which can help to identify trends in precarious and low-paying jobs.

### Different unemployment rates:
- U-1: The percentage of the civilian labor force that has been unemployed for 15 weeks or longer.
- U-2: The percentage of the civilian labor force that lost jobs or completed temporary jobs.
- U-3 (OFFICIAL): The percentage of the civilian labor force that is unemployed and has sought work in the past four weeks.
- U-4: The number of unemployed plus the number of discouraged job-seekers as a percentage of the total labor force.
- U-5: The total of the unemployed plus discouraged job-seekers plus marginally attached workers, as a percentage of the total labor force.
- U-6 (COMPLETE): All of the people counted in U-5 plus those working part-time due to economic conditions, as a percentage of the total labor force.
