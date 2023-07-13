# lm_project2
---
title: "GroupProj2"
author: "Addison"
date: "2023-07-11"
output: html_document
---
```{r}
library(dplyr)
library(tidyverse)
library(ggplot2)
library(gapminder)
library(MASS)
library(palmerpenguins)
library(leaps)
library(car)
library(faraway)
library(ROCR)
```


```{r}
Data <- read.csv("kc_house_data.csv", header=T)
```

```{r}
Data <- Data %>%
  mutate(expensive = ifelse(price >= 1129575, 1, 0))
```

```{r}
#Removing variables for the regression that are not important to the model
Data2 <- dplyr::select(Data, -price, -id, -date, -lat, -long)
```



```{r}
set.seed(6021)
sample.data<-sample.int(nrow(Data2), floor(.50*nrow(Data2)), replace=F)
train<-Data2[sample.data, ]
test<-Data2[-sample.data, ]
```
IQR 1st=321950  3rd=645000 IQR=484575
1.5 * IQR Rule, upper threshold: 1129575

```{r}
regnull <- glm(expensive~1, family=binomial, data=train)
##model with all predictors
regfull <- glm(expensive~., family=binomial, data=train)
```

```{r}
#forward selection
step(regnull, scope=list(lower=regnull, upper=regfull), direction="forward")
```
```{r}
f_model <- glm(formula = expensive ~ grade + yr_built + sqft_living + view + 
    waterfront + sqft_lot15 + bathrooms + zipcode + condition + 
    yr_renovated + sqft_lot, family = binomial, data = train)

AIC(f_model) #1922.3
faraway::vif(f_model)
```



```{r}
#Stepwise selection
step(regnull, scope=list(lower=regnull, upper=regfull), direction="both")
#AIC = AIC: -5941
```

```{r}
#Stepwise model
step_model <- glm(formula = expensive ~ grade + yr_built + sqft_living + view + 
    waterfront + sqft_lot15 + bathrooms + zipcode + condition + 
    yr_renovated + sqft_lot, family = binomial, data = train)
faraway::vif(step_model)
# AIC = 1922
anova_step<-anova(step_model)
summary(anova_step)
```

```{r}
par(mfrow=c(2,2))
plot(b_model_r)
```


```{r}
step(regfull, scope=list(lower=regnull, upper=regfull), direction="backward")
```

```{r}
#Backwards model
back_model <- glm(formula = expensive ~ bathrooms + sqft_living + sqft_lot + 
    waterfront + view + condition + grade + yr_built + yr_renovated + 
    zipcode + sqft_lot15, family = binomial, data = train)
AIC(back_model) #1922
faraway::vif(back_model)
```


Conducting Hypothesis Tests
```{r}
#F) Carry out the relevant hypothesis test to check if this logistic regression model with 15 predictors is useful in estimating the odds of heart disease. Clearly state the null and alternative hypotheses, test statistic, and conclusion in context.
summary(step_model)
deltaG2 = step_model$null.deviance-step_model$deviance
deltaG2

1-pchisq(2634.27,11) #pval = 0
qchisq(0.95,10794) #  crit =  11.0705
```

```{r}
#summary(step_model)
#Comparing to a reduced model
step_model <- glm(formula = expensive ~ grade + yr_built + sqft_living + view + 
    waterfront + sqft_lot15 + bathrooms + zipcode + condition + 
    yr_renovated + sqft_lot, family = binomial, data = train)


reduced_step <- glm(formula = expensive ~ grade + yr_built + sqft_living + view +
    waterfront + bathrooms + zipcode + condition + 
    yr_renovated, family = binomial, data = train)

full <- step_model
AIC(full) #1924.647
AIC(reduced_step) #1924.647
faraway::vif(reduced_step)
faraway::vif(step_model)


summary(reduced_step) #Resid DF = 10796  
summary(full) #Resid DF= 10794  
TS<-reduced_step$deviance-full$deviance #TS = 14.53429

1-pchisq(TS,1) ##pvalue = 0.03705097
```
Ho: The reduced model is preferred.
Ha: The full model is preferred.

```{r}

#Conducting Wald tests
summary_model <- summary(step_model)

# Extract the z-statistics
z_stats <- summary_model$coefficients[, "z value"]
z_stats
#sqft_loft, sqft_lot15, and 


#Wald test for sqft_lot
2*(1-pnorm(abs(-1.751562))) # =  0.07984915
#with this pvalue ( > alpha=.05), we should remove sqft_lof from the predictors


#Wald test for sqft_lot15    
2*(1-pnorm(abs(-2.398451))) # = 0.01646458

#Wald test for yr_renovated         
2*(1-pnorm(abs(2.142454))) # = 0.03215697

#Wald test for condition         
2*(1-pnorm(abs(3.291873))) # = 0.03215697
```


```{r}

reduced <- glm(formula = expensive ~ grade + yr_built + sqft_living + view + 
    waterfront + sqft_lot15 + bathrooms + zipcode + condition + 
    yr_renovated, family = binomial, data = train)

```




#Despite the hypothesis test saying the full model is better, high VIFs mean we must remove certain values.
```{r}
faraway::vif(reduced_step)
faraway::vif(step_model)
```

```{r}
step_model <- glm(formula = expensive ~ grade + yr_built + sqft_living + view + 
    waterfront + sqft_lot15 + bathrooms + zipcode + condition + 
    yr_renovated + sqft_lot, family = binomial, data = train)

#Removing sqft_lot15 due to high VIF,

reduced <- glm(formula = expensive ~ grade + yr_built + sqft_living + view + 
    waterfront + bathrooms + zipcode + condition + 
    yr_renovated + sqft_lot, family = binomial, data = train)

faraway::vif(reduced_step)
faraway::vif(step_model)
faraway::vif(reduced)
faraway::vif(step_model)
```

```{r}
#likelyhood ratio test
```

