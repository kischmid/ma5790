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

## ----linear-setup
ctrl <- trainControl(method = "cv", number = 10)

## ----ridge
ridgemod <- train(
  x = x_train,
  y = grade_train,
  method = "ridge",
  tuneLength = 20,
  trControl = ctrl,
  metric = "Rsquared")
ridgemod
### plot
plot(ridgemod)

## ----lasso
lassomod <- train(
  x = x_train,
  y = grade_train,
  method = "lasso",
  tuneLength = 20,
  trControl = ctrl,
  metric = "Rsquared")
lassomod
### plot
plot(lassomod)

## ----enet
options(max.print=1000000)
enetmod <- train(
  x = x_train,
  y = grade_train,
  method = "enet",
  tuneLength = 20,
  trControl = ctrl,
  metric = "Rsquared")
enetmod
### plot
plot(enetmod)

## ----linear
lmmod <- train(
  x = x_train,
  y = grade_train,
  method = "lm",
  tuneLength = 20,
  trControl = ctrl,
  metric = "Rsquared")
lmmod
### plot
plot(lmmod)



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


########## TEST SET EVALUATION ##########

## ----enet-test
eneest <- postResample(predict(enetmod, x_test),grade_test)
eneest

## ----svm-test
svm_pred <- predict(svmTrain, newdata = x_test)
print(postResample(pred=svm_pred, obs=grade_test))

## ----svm-varImp
plot(varImp(svmTrain), top=20)


