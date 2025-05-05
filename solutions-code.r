###Solutions to Exercises in Time Series

# Set your directory
setwd('C:/')

####Changing frequencies

library(tidyverse)
library(tidyquant)
library(lubridate)


##Read in data from FRED database ##

usd10y <- tq_get("DGS10", 
                 get  = "economic.data", 
                 from = "2000-01-02",
                 to   = "2020-08-31")
head(usd10y)


# Transform to weekly, monthly, quarterly and annual frequencies  #
usd10y <- usd10y %>% mutate(first.day.month=floor_date(date,week_start = 1,unit="month"),
                            first.day.quarter=floor_date(date,week_start = 1,unit="quarter"),
                            first.day.year=floor_date(date,week_start = 1,unit="year"),
                            last.day.week= ceiling_date(date,week_start = 1,unit="week")-1,
                            last.day.month= ceiling_date(date,week_start = 1,unit="month")-1,
                            last.day.quarter= ceiling_date(date,week_start = 1,unit="quarter")-1,
                            last.day.year= ceiling_date(date,week_start = 1,unit="year")-1)
########  
usd10y <- usd10y %>% na.omit() %>% group_by(first.day.week) %>% mutate(av.price=mean(price,na.rm=T),
                                                                       max.price=max(price,na.rm=T),
                                                                       min.price=min(price,na.rm=T))
                                                                      
week_data <- usd10y %>% group_by(last.day.week) %>% summarise(av.price=mean(price,na.rm=T)) %>% ungroup()
month_data <- usd10y %>% group_by(last.day.month) %>% summarise(av.price=mean(price,na.rm=T))%>% ungroup()
quarter_data <- usd10y %>% group_by(last.day.quarter) %>% summarise(av.price=mean(price,na.rm=T))%>% ungroup()
year_data <- usd10y %>% group_by(last.day.year) %>% summarise(av.price=mean(price,na.rm=T))%>% ungroup()

## Making graphs  ##

# DAY #
usd10y %>% ggplot(aes(x=date,y=price))+geom_line(size = 1,color = palette_light()[[1]])+
  labs(title = "UST 10Y (Daily)", x = "", y = "Percent (%)") +
  scale_y_continuous() +
  scale_x_date(date_breaks = "4 year", date_labels = "%Y") +
  theme_tq()

# WEEK #
week_data %>% ggplot(aes(x=last.day.week,y=av.price))+geom_line(size = 1,color = palette_light()[[3]])+
  labs(title = "UST 10Y (Weekly)", x = "", y = "Percent (%)") +
  scale_y_continuous() +
  scale_x_date(date_breaks = "4 year", date_labels = "%Y") +
  theme_tq()

# MONTH #
month_data %>% ggplot(aes(x=last.day.month,y=av.price))+geom_line(size = 1,color = palette_light()[[2]])+
  labs(title = "UST 10Y (Monthly)", x = "", y = "Percent (%)") +
  scale_y_continuous() +
  scale_x_date(date_breaks = "5 year", date_labels = "%Y") +
  theme_tq()

# QUARTER #
quarter_data %>% ggplot(aes(x=last.day.quarter,y=av.price))+geom_line(size = 1,color = palette_light()[[5]])+
  labs(title = "USD 10Y (Qtr)", x = "", y = "Percent (%)") +
  scale_y_continuous() +
  scale_x_date(date_breaks = "5 year", date_labels = "%Y") +
  theme_tq()

# YEAR #
year_data %>% ggplot(aes(x=last.day.year,y=av.price))+geom_line(size = 1,color = palette_light()[[11]])+
  labs(title = "UST 10Y (Annual)", x = "", y = "Percent (%)") +
  scale_y_continuous() +
  scale_x_date(date_breaks = "5 year", date_labels = "%Y") +
  theme_tq()

####2) Calculating returns      
library(tidyquant)
library(tidyverse)

## Tesla ##
## Import data from Yahoo finance ##

tesla  <- tq_get("TSLA", get = "stock.prices", from = " 2005-01-01", to = " 2020-09-15")

head(tesla)
tail(tesla)

############################################################################################

## Find daily, weekly and monthly returns: Return logarithmic daily returns using periodReturn()

tesla_dreturns <- tq_get("TSLA", get  = "stock.prices", from = "2010-01-01", to   = "2020-08-31") %>%
  tq_transmute(adjusted, periodReturn, period = "daily", col_rename = "tesla.dreturns")

tesla_returns <- tq_get("TSLA", get  = "stock.prices", from = "2010-01-01", to   = "2020-08-31") %>%
  tq_transmute(adjusted, periodReturn, period = "weekly", col_rename = "tesla.returns")

tesla_mreturns <- tq_get("TSLA", get  = "stock.prices", from = "2005-01-01", to   = "2020-08-31") %>%
  tq_transmute(adjusted, periodReturn, period = "monthly", col_rename = "tesla.mreturns")

#### Plot monthly returns  ####
tesla_returns %>%
  ggplot(aes(x = date, y = tesla.returns)) +
  geom_line(size = 0.5,color = palette_light()[[2]]) +
  labs(title = " Tesla (TSLA) ", y = "Weekly returns", x = "") + 
  theme_tq()


####3)  What happens when we use non-stationary data? ##
##                                                     ##
##        OLS regressions level and change             ##
##   Remember to test all variables for stationarity   ##

library(tidyverse)
library(tidyquant) 
library(tseries)
library(stargazer)
library(sweep)
library(openxlsx)
#### Import time series data as a csv file ####
fred<-read.xlsx("C:/Users/2907813/Dropbox/Master_DataAnalytics/data/FRED.xlsx",detectDates=T)

### Set date format ###
fred$DATE <- as.Date(fred$DATE)
class(fred$DATE)

### Regression using levels ###
reg.model<- USDNOK~BRENT+GBP3M+VIX
r1<-lm(reg.model, data=fred)
r1 %>% summary()

####  Result  ####
stargazer(r1, title="Explaining the USDNOK exchange rate", align=TRUE,  no.space=TRUE,type="text", out="r1.html") 
#######################################################################

### Testing for stationarity  ###
#################################
adf.test(na.omit(fred$USDNOK,k=0))
adf.test(na.omit(fred$BRENT,k=0))
adf.test(na.omit(fred$GBP3M,k=0))
adf.test(na.omit(fred$VIX,k=0))
#######################################
adf.test(na.omit(Delt(fred$USDNOK),k=0))
adf.test(na.omit(Delt(fred$BRENT),k=0))
########################################

### Regression using differences ###
reg.model2<- Delt(USDNOK)~Delt(BRENT)+Delt(GBP3M)+VIX
r2<-lm(reg.model2, data=fred)
r2 %>% summary()

####  Result with wrongly specified model ####
stargazer(r2, title="Explaining changes in USDNOK", align=TRUE,  no.space=TRUE,type="text", out="r2.html") 
##########################################################################################################

## According to theory there is no reason the UK interest rate
## should be related to the USDNOK exchange rate
## However, the US interest rate may be
## so, we want to change the model by
## replacing EUR3M by USD3M
##################################################################
adf.test(na.omit((fred$USD3M),k=0))
adf.test(na.omit(Delt(fred$USD3M),k=0))
#######################################

reg.model3<- Delt(USDNOK)~Delt(BRENT)+Delt(USD3M)+VIX
r3<-lm(reg.model3, data=fred)
r3 %>% summary()
####  Result with correct model ####
stargazer(r3, title="Explaining changes in USDNOK", align=TRUE,  no.space=TRUE,type="text", out="r4.html") 
