# MA5790 Final Project
# Modeling (Regression)


## ----libraries
library(caret)


## ----data-setup
# set this to be your directory 
setwd("C:\\Users\\kathe\\Documents\\MTU\\Spring2022\\MA 5790\\Final Project")
student <- read.csv("./data/preprocessed.csv")
grade <- student[, "G3"]
descriptors <- student[, -73]


## ----data-splitting
set.seed(42)
trainRows <- createDataPartition(grade, p=0.8, list=FALSE)
x_train <- descriptors[trainRows, ]
x_test <- descriptors[-trainRows, ]
grade_train <- grade[trainRows]
grade_test <- grade[-trainRows]


########## Linear Models ##########






########## Non-Linear Models ##########

## ----neural-net
set.seed(802)
nnetGrid <- expand.grid(.decay = c(0, 0.01, .1),
                        .size = c(1:10),
                        .bag = FALSE)
nnetTune <- train(x=x_train, y=grade_train,
                  method = "avNNet",
                  tuneGrid = nnetGrid,
                  trControl = trainControl(method="cv", number=10),
                  linout = TRUE,
                  trace = FALSE,
                  MaxNWts = 10 * (ncol(x_train) + 1) + 10 + 1,
                  maxit = 500,
                  metric="Rsquared")
print(nnetTune)
plot(nnetTune)

## ----mars
set.seed(290)
marsGrid <- expand.grid(degree = 1:3, nprune = 2:15)
marsTrain <- train(x=x_train, y=grade_train, 
                        method="earth",
                        metric="Rsquared", 
                        trControl=trainControl(method="cv", number=10), 
                        tuneGrid=marsGrid)
print(marsTrain)
plot(marsTrain)

## ----svm
set.seed(625)
svmTrain <- train(x=x_train, y=grade_train,
                  method = "svmRadial",
                  tuneLength = 10,
                  metric="Rsquared",
                  trControl = trainControl(method = "cv", number=10))
print(svmTrain)
ggplot(svmTrain)+coord_trans(x='log2')

## ----knn
set.seed(678)
knnTrain <- train(x=x_train, y=grade_train, method="knn", 
                  tuneLength=15, metric="Rsquared", 
                  trControl=trainControl(method="cv", number=10))
print(knnTrain)
plot(knnTrain)


