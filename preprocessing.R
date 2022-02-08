# MA 5790 Final Project
# Data Preprocessing


################# SET UP #################
# libraries
library(caret)
library(e1071)
library(readr)
library(knitr)
library(car)
library(tidyverse)
library(MASS)
library(corrgram)
library(psych)
library(moments)
library(mice)
library(Amelia)
library(kableExtra)
library(mlbench)
library(corrplot)
library(impute)
library(fastDummies)

# read in data
# set your current working directory to the project folder using the following command
# setwd("C:/...")
student <- read.csv("data/student-por.csv", header=TRUE, sep=";")
stu.target <- student$G3
# separate predictors into continuous, categorical, and binary
# Note: categorical and binary will be almost the same,
#       except when making dummy variables binary will only have one output
#       column while categorical may have several
stu.continuous <- student[,c("age","failures","absences")]
stu.categorical <- student[,c("Medu", "Fedu", "Mjob", "Fjob", "reason", "guardian", "traveltime", "studytime", "famrel", "freetime", "goout", "Dalc", "Walc", "health")]
stu.binary <- student[,c("school", "sex", "address", "famsize", "Pstatus", "schoolsup", "famsup", "paid", "activities", "nursery", "higher", "internet", "romantic")]


################# DISTRIBUTION OF CONTINUOUS VARS #################
par(mfrow=c(3,2))
for (i in 1:ncol(stu.continuous)) {
  hist(stu.continuous[, i], main=paste("Distribution of ", colnames(stu.continuous)[i]),
       xlab=colnames(stu.continuous)[i])
  boxplot(stu.continuous[, i], main=paste("Distribution of ", colnames(stu.continuous)[i]),
          xlab=colnames(stu.continuous)[i], horizontal=TRUE)
}


################# DISTRIBUTION OF CATEGORICAL VARS #################
par(mfrow=c(3,5))
for (i in 1:ncol(stu.categorical)) {
  barplot(table(stu.categorical[, i]), main=paste("Distribution of ", colnames(stu.categorical)[i]),
           xlab=colnames(stu.categorical)[i])
}
par(mfrow=c(3,5))
for(i in 1:ncol(stu.binary)) {
  barplot(table(stu.binary[, i]), main=paste("Distribution of ", colnames(stu.categorical)[i]),
          xlab=colnames(stu.categorical)[i])
}


################# DISTRIBUTION OF TARGET #################
# view distribution and skewness of target
hist(stu.target, main="Distribution of Final Grade", xlab="Final Grade")
# skewness = -0.9087 => moderately skewed
skewness(stu.target)


################# MISSING DATA #################
# check for missing values in all the data
# no missing data
par(mfrow=c(1,1))
image(!is.na(student), main="Missing Values in Student Data", xlab="Observation",
      ylab="Predictor", col.axis="white")


################# SKEWNESS #################
# check skew of continuous predictors
apply(stu.continuous, 2, skewness)
# failures and absences are highly skewed (skew > 1.0)

# apply BoxCox transformations
# add 0.1 to avoid values = 0
failuresTrans <- BoxCoxTrans(stu.continuous$failures+0.1)
failures.boxcox <- predict(failuresTrans, stu.continuous$failures+0.1)
# original = 3.0784
# boxcox = 1.9119
skewness(failures.boxcox)

absencesTrans <- BoxCoxTrans(stu.continuous$absences+0.1)
absences.boxcox <- predict(absencesTrans, stu.continuous$absences+0.1)
# original = 2.0114
# boxcox = -0.2600
skewness(absences.boxcox)

# Side by side histogram comparisons
par(mfrow=c(2,2))
hist(stu.continuous$failures, main="Distribution of Failures \nbefore Box and Cox", xlab="failures")
hist(failures.boxcox, main="Distribution of Failures \nafter Box and Cox", xlab="failures")
hist(stu.continuous$absences, main="Distribution of Absences \nbefore Box and Cox", xlab="absences")
hist(absences.boxcox, main="Distribuiton of Absences \nafter Box and Cox", xlab="absences")

stu.continuous.boxcox <- data.frame(age = stu.continuous$age,
                                    failures = failures.boxcox,
                                    absences = absences.boxcox)


################# CENTER AND SCALE #################
# center and scale continuous predictors
stu.continuous.centerScale <- as.data.frame(scale(stu.continuous.boxcox))
apply(stu.continuous.centerScale, 2, mean) # means are appx = 0
var(stu.continuous.centerScale)            # variance = 1.0

# Histograms after center and scale
par(mfrow=c(3,2))
hist(stu.continuous.boxcox$age, main="Distribution of Age \nbefore Center and Scale", xlab="age")
hist(stu.continuous.centerScale$age, main="Distribution of Age \nafter Center and Scale", xlab="age")
hist(stu.continuous.boxcox$failures, main="Distribution of Failures \nbefore Center and Scale", xlab="failures")
hist(stu.continuous.centerScale$failures, main="Distribution of Failures \nafter Center and Scale", xlab="failures")
hist(stu.continuous.boxcox$absences, main="Distribution of Absences \nbefore Center and Scale", xlab="absences")
hist(stu.continuous.centerScale$absences, main="Distribution of Absences \nafter Center and Scale", xlab="absences")

# Changing Categorical variables to dummy variables
dummy <- fastDummies::dummy_cols(stu.categorical)
knitr::kable(dummy)
#binary
dummy2 <-fastDummies::dummy_cols(stu.binary)
knitr::kable(dummy2)

#Checking for near-zero variance
nearZeroVar(stu)
nearZeroVar(stu.categorical)
nearZeroVar(dummy)


#Remove highly-correlated predictors
df = cor(dummy)
hc = findCorrelation(df, cutoff=0.9) #any value as a "cutoff"
hc = sort(hc)
reduced = dummy[,-c(hc)]
print (reduced)

#Spatial Sign to remove outliers
a <- spatialSign(stu.continuous.centerScale)
par(mfrow=c(3,2))
for (i in 1:ncol(a)) {
  boxplot(a[, i], main=paste("Distribution of ", colnames(a)[i]),
          xlab=colnames(a)[i], horizontal=TRUE)
}
