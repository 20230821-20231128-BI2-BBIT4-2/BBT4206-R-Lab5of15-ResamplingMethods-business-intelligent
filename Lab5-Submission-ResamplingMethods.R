#installing necessary packages

if(require("caret")){
  require("caret")
}else{
  install.packages("caret", dependencies = TRUE,
                   repos= "https://cloud.r-project.org")
}

if(require("klaR")){
  require("klaR")
}else{
  install.packages("klaR", dependencies = TRUE,
                   repos = "https://cloud.r-prject.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## LiblineaR ----
if (require("LiblineaR")) {
  require("LiblineaR")
} else {
  install.packages("LiblineaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naivebayes ----
if (require("naivebayes")) {
  require("naivebayes")
} else {
  install.packages("naivebayes", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}




#installing ML Bench

if (require("mlbench")){
  require("mlbench")
} else {
  install.packages("mlbench", dependencies= TRUE,
                   repos= "https://cloud.r-project.org")
}

#getting/loading the Pima Indians Diabetes dataset from mlbench

data("PimaIndiansDiabetes")


#splitting the dataset
train_index <- createDataPartition(PimaIndiansDiabetes$diabetes,
                                   p=0.80, list=FALSE)
diabetes_dataset_train <- PimaIndiansDiabetes[train_index,]
diabetes_dataset_test <- PimaIndiansDiabetes[-train_index,]

#performing naive bayes

diabetes_dataset_nb_e1071 <-
  e1071::naiveBayes(diabetes~ pregnant+ glucose+ pressure+
                      triceps+ insulin+ mass+ pedigree+ age,
                    data=diabetes_dataset_train)

#testing the model using the test dataset

prediction_nb_e1071 <-
  predict(diabetes_dataset_nb_e1071,
          diabetes_dataset_test[, c("pregnant", "glucose",
                                    "pressure","triceps","insulin", "mass",
                                    "pedigree","age")
            
          ])

print(prediction_nb_e1071)

caret::confusionMatrix(prediction_nb_e1071,
                       diabetes_dataset_test[, c("pregnant", "glucose",
                                                 "pressure","triceps","insulin", "mass",
                                                 "pedigree","age","diabetes")]$diabetes)
#visualizing the prediction
plot(table(prediction_nb_e1071,
           diabetes_dataset_test[, c("pregnant", "glucose",
                                     "pressure","triceps","insulin", "mass",
                                     "pedigree","age","diabetes")]$diabetes))


#bootstrapping train control
train_control <- trainControl(method = "boot", number = 500)

str(diabetes_dataset_test)


diabetes_dataset_model_lm <- # nolint
  caret::train(diabetes ~
                 pregnant+ glucose+ pressure+
                 triceps+ insulin+ mass+ pedigree+ age,
               data = diabetes_dataset_train,
               trControl = train_control,
               na.action = na.omit, method = "glm", metric = "Accuracy")


predictions_lm <- predict(diabetes_dataset_model_lm,
                          diabetes_dataset_test[, 1:8])

## 4. View the RMSE and the predicted values for the 12 observations ----
print(diabetes_dataset_model_lm)
print(predictions_lm)


#perfoming 10 fold cross validation

train_control <- trainControl(method = "cv", number = 10)

diabetes_dateset_model_lm_cv <-
  caret::train(diabetes ~ .,
               data = diabetes_dataset_train,
               trControl = train_control, na.action = na.omit,
               method = "glm", metric = "Accuracy")


predictions_lm_cv <- predict(diabetes_dateset_model_lm_cv, diabetes_dataset_test[, -9])


print(diabetes_dateset_model_lm_cv)
print(predictions_lm_cv)



#performing Classification: SVM with Repeated k-fold Cross Validation

train_control <- trainControl(method = "repeatedcv", number = 5, repeats = 3)


diabetes_dateset_model_svm <-
  caret::train(diabetes ~ ., data = diabetes_dataset_train,
               trControl = train_control, na.action = na.omit,
               method = "svmLinearWeights2", metric = "Accuracy")

predictions_svm <- predict(diabetes_dateset_model_svm, diabetes_dataset_test)


print(diabetes_dateset_model_svm)
caret::confusionMatrix(predictions_svm, diabetes_dataset_test$diabetes)


#training a Naive Bayes classifier based on an LOOCV

train_control <- trainControl(method = "LOOCV")


diabetes_dataset_model_nb_loocv <-
  caret::train(diabetes ~ ., data = diabetes_dataset_train,
               trControl = train_control, na.action = na.omit,
               method = "naive_bayes", metric = "Accuracy")

predictions_nb_loocv <-
  predict(diabetes_dataset_model_nb_loocv, diabetes_dataset_test[, 1:14])

print(diabetes_dataset_model_nb_loocv)
caret::confusionMatrix(predictions_nb_loocv, diabetes_dataset_test$Churn)