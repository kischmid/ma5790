# MA 5790 Final Project
# Data Preprocessing


################# SET UP #################
# libraries
library(caret)
library(e1071)
library(mlbench)
library(corrplot)

## ----preproc-setup
# read in data
# set your current working directory to the project folder using
# setwd("C:/...")
student <- read.csv("data/student-por.csv", header=TRUE, sep=";")
stu.target <- student$G3
# separate predictors into continuous, categorical, and binary
# Note: categorical and binary will be almost the same,
#       except when making dummy variables binary will only have one output
#       column while categorical may have several
stu.continuous <- student[,c("age","failures","absences")]
stu.categorical <- student[,c("Medu", "Fedu", "Mjob", "Fjob", "reason", 
                              "guardian", "traveltime", "studytime", "famrel", 
                              "freetime", "goout", "Dalc", "Walc", "health")]
stu.binary <- student[,c("school", "sex", "address", "famsize", "Pstatus", 
                         "schoolsup", "famsup", "paid", "activities", "nursery", 
                         "higher", "internet", "romantic")]


################# DISTRIBUTION OF CONTINUOUS VARS #################
## ----original-distribution-continuous
par(mfrow=c(3,2))
for (i in 1:ncol(stu.continuous)) {
  hist(stu.continuous[, i], main=paste("Distribution of ", 
                                       colnames(stu.continuous)[i]),
       xlab=colnames(stu.continuous)[i])
  boxplot(stu.continuous[, i], main=paste("Distribution of ", 
                                          colnames(stu.continuous)[i]),
          xlab=colnames(stu.continuous)[i], horizontal=TRUE)
}


################# DISTRIBUTION OF CATEGORICAL VARS #################
## ----original-distribution-categorical
par(mfrow=c(3,5))
for (i in 1:ncol(stu.categorical)) {
  barplot(table(stu.categorical[, i]), main=paste("Distribution of \n", 
                                                  colnames(stu.categorical)[i]),
           xlab=colnames(stu.categorical)[i])
}
## ----original-distribution-binary
par(mfrow=c(3,5))
for(i in 1:ncol(stu.binary)) {
  barplot(table(stu.binary[, i]), main=paste("Distribution of \n", 
                                             colnames(stu.binary)[i]),
          xlab=colnames(stu.binary)[i])
}


################# DISTRIBUTION OF TARGET #################
## ----distribution-target
# view distribution and skewness of target
hist(stu.target, main="Distribution of Final Grade", xlab="Final Grade")
## ----target-skew
# skewness = -0.9087 => moderately skewed
skewness(stu.target)


################# MISSING DATA #################
## ----missing
# check for missing values in all the data
# no missing data
par(mfrow=c(1,1))
image(!is.na(student), main="Missing Values in Student Data", xlab="Observation",
      ylab="Predictor", col.axis="white")


################# SKEWNESS #################
## ----apply-boxcox
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

stu.continuous.boxcox <- data.frame(age = stu.continuous$age,
                                    failures = failures.boxcox,
                                    absences = absences.boxcox)

## ----boxcox-beforeafter
# Side by side histogram comparisons
par(mfrow=c(2,2))
hist(stu.continuous$failures, main="Distribution of Failures \nbefore Box and Cox", 
     xlab="failures")
hist(failures.boxcox, main="Distribution of Failures \nafter Box and Cox", 
     xlab="failures")
hist(stu.continuous$absences, main="Distribution of Absences \nbefore Box and Cox", 
     xlab="absences")
hist(absences.boxcox, main="Distribuiton of Absences \nafter Box and Cox", 
     xlab="absences")


################# CENTER AND SCALE #################
## ----apply-centerscale
# center and scale continuous predictors
stu.continuous.centerScale <- as.data.frame(scale(stu.continuous.boxcox))
apply(stu.continuous.centerScale, 2, mean) # means are appx = 0
var(stu.continuous.centerScale)            # variance = 1.0

## ----after-centerscale
# Histograms after center and scale
par(mfrow=c(3,2))
hist(stu.continuous.boxcox$age, 
     main="Distribution of Age \nbefore Center and Scale", xlab="age")
hist(stu.continuous.centerScale$age, 
     main="Distribution of Age \nafter Center and Scale", xlab="age")
hist(stu.continuous.boxcox$failures, 
     main="Distribution of Failures \nbefore Center and Scale", xlab="failures")
hist(stu.continuous.centerScale$failures, 
     main="Distribution of Failures \nafter Center and Scale", xlab="failures")
hist(stu.continuous.boxcox$absences, 
     main="Distribution of Absences \nbefore Center and Scale", xlab="absences")
hist(stu.continuous.centerScale$absences, 
     main="Distribution of Absences \nafter Center and Scale", xlab="absences")

## ----dummyvars
# Changing Categorical variables to dummy variables
dmy1 <- dummyVars(" ~ .", 
                  data = as.data.frame(apply(stu.categorical, 2, as.character)))
dummy <- data.frame(predict(dmy1, newdata = as.data.frame(apply(stu.categorical, 
                                                                2, 
                                                                as.character))))
#binary
dmy2 <- dummyVars(" ~ .", data = as.data.frame(apply(stu.binary, 2, as.character)))
dummy2 <- data.frame(predict(dmy2, newdata = as.data.frame(apply(stu.binary, 
                                                                 2, 
                                                                 as.character))))
dummy2 <- dummy2[, c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26)]


# combine dummy categoricals together
stu.categorical.dummy <- data.frame(dummy, dummy2)
colnames(stu.categorical.dummy) <- c(colnames(dummy), colnames(dummy2))

#Checking for near-zero variance
nzero <- nearZeroVar(stu.categorical.dummy)
#Dropped problem predict from near-zero variance
stu.categorical.dummy <- stu.categorical.dummy[,-nzero]

#Combine all predictors
stu.all <- data.frame(stu.categorical.dummy, stu.continuous.centerScale)
colnames(stu.all) <- c(colnames(stu.categorical.dummy), 
                       colnames(stu.continuous.centerScale))

## ----corrplot
#Remove highly-correlated predictors
par(mfrow=c(1,1))
corrM <- cor(stu.all)
corrplot(corrM, method="color")
## ----apply-highlyCorrelated
hc <- findCorrelation(corrM, cutoff=0.85) #any value as a "cutoff"
length(hc)
hc
stu.all.noCorr <- stu.all[,-c(hc)]

## ----spatialSign
#Spatial Sign to remove outliers
a <- spatialSign(stu.continuous.centerScale)
par(mfrow=c(3,1))
for (i in 1:ncol(a)) {
  boxplot(a[, i], main=paste("Distribution of ", colnames(a)[i]),
          xlab=colnames(a)[i], horizontal=TRUE)
}

## ----final-dataset
# add everything back together into one data frame
stu.all.noCorr[,70:72] <- a

student.final <- stu.all.noCorr
student.final[73] <- stu.target
colnames(student.final)[73] <- "G3"

write.csv(student.final, "data/preprocessed.csv")
