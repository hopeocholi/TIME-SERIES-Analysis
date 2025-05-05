# TIME-SERIES-Analysis

#1. Description:

The aim of my analysis is to investigate the relationship between the gold price (GOLDPM), the dollar exchange rate (EURUSD), and the “fear” index (VIX)using the dataset Fred data
file(“FRED.xlsx"). It was stated that the important drivers of the gold price could be the dollar exchange rate and/or market sentiment (measured by the “fear” index VIX). Therefore, in this analysis, “fear” index VIX is considered as the explanatory variable(s) and the gold price (GOLDPM) is used as the dependent variable.

2. Loading the packages:
The following packages were used throughout this analysis to arrive at specific results;
library(ggplot2)
library(readxl)
library(openxlsx)
library(tidyquant)
library(tidyverse)
library(lubridate)
library(xts)
library(quantmod)
library(tseries)
library(stargazer)


3. Stationary test of the variables:
hope$GOLDPM %>% na.omit() %>% adf.test(k=0)
Augmented Dickey-Fuller Test
data: .
Dickey-Fuller = -1.4986, Lag order = 0, p-value = 0.7908
alternative hypothesis: stationary
hope$EURUSD %>% na.omit() %>% adf.test(k=0)
Augmented Dickey-Fuller Test
data: .
Dickey-Fuller = -5.0199, Lag order = 0, p-value = 0.6924
alternative hypothesis: stationary
hope$VIX %>% na.omit() %>% adf.test(k=0)
Augmented Dickey-Fuller Test
data: .
Dickey-Fuller = -8.8798, Lag order = 0, p-value = 0.01
alternative hypothesis: stationary

Table 1: Stationary test of the variables


From Table 1, we can see the specific results for the short analysis regarding the variables, the investigation further derives the p-values of both GOLDPM and EURUSD variables as 0.7908 and 0.692 respectively, here we accept the hypothesis for GOLDPM because it is higher than 0.05 and we also accept the hypothesis for EURUSD because it does satisfy the above conditions as stated for the first hypothesis. We also identified that the p-value for VIX is 0.01 which is less than 0.05 and does not satisfy the hypothetical conditions. We therefore reject the hypothesis because VIX is a stationary variable and GOLDPM & EURUSD are non-stationary.


4. Investigating the linear regression:
Table 2: Linear regression analysis
This analysis resulted in a table showing the information and application of the linear regression
model on the related variables. The F-statistic and p-value of the explanatory variable are 0.842 and
p<0.01 respectively, which defines the model does not predict higher gold prices including low
currency fluctuations.


5. Correcting the coefficients for heteroskedasticity and autocorrelation by
using the HAC correction (vcovHAC).
(Intercept) Delt(EURUSD) VIX
-8.291518e-06 NA 1.674697e-05
Table 3: Correcting the coefficients for heteroskedasticity and autocorrelation by using the
HAC correction (vcovHAC)
GoldPrice Explanation
Dependent variable:
Delt(GOLDPM)
Delt(EURUSD)
VIX 0.00002
(0.00002)
Constant -0.00001
(0.0004)
Observations 4,465
R2 0.0002
Adjusted R2
-0.00004
Residual Std. Error 0.011 (df = 4463)
F Statistic 0.842 (df = 1; 4463)
Note: *p
**p
***p<0.01



6. Presenting the results:
I am presenting my results in the stargazer table which shows the intercept of -0.00001 and VIX
of 0.00002.


<img src="https://i.imgur.com/DUWxNMt.png" height="65%" width="65%" alt="Image Analysis Dataflow"/>
Table 4: Presenting the results in a (stargazer) table


7. Explaining the model chart of the gold price:
Figure 1 shows the impact of gold price and the movement in frequency. Following the model, we
investigated that GOLDPM had a bearish price movement over the years which indicates an
accelerating value also in the future.
heteroskedasticity and autocorrelation correction
(Intercept) Delt(EURUSD) VIX
-0.00001 0.00002

   
   

<img src="https://i.imgur.com/NoulwLP.png" height="65%" width="65%" alt="Image Analysis Dataflow"/>

Figure 1: Model chart of the gold price (GOLDPM)
Figure 1 shows the impact of gold price and the movement in frequency. Following the model, we investigated that GOLDPM had a bearish price movement over the years which indicates an
accelerating value also in the future.
