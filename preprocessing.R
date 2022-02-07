# MA 5790 Final Project
# Data Preprocessing

# libraries
library(caret)
library(e1071)

# read in data 
# set your current working directory to the project folder using the following command
# setwd("C:/...")
student <- read.csv("data/student-por.csv", header=TRUE, sep=";")
stu.target <- student$G3

# view distribution and skewness of target
hist(stu.target, main="Distribution of Final Grade", xlab="Final Grade")
# skewness = -0.9087 => moderately skewed
skewness(stu.target)
