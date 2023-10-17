Business Intelligence Project
================
<Specify your name here>
<Specify the date when you submitted the lab>

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [Understanding the Dataset (Exploratory Data Analysis
  (EDA))](#understanding-the-dataset-exploratory-data-analysis-eda)
  - [Loading the Dataset](#loading-the-dataset)
    - [Source:](#source)
    - [Reference:](#reference)

# Student Details

|                                              |     |
|----------------------------------------------|-----|
| **Student ID Number**                        | …   |
| **Student Name**                             | …   |
| **BBIT 4.2 Group**                           | …   |
| **BI Project Group Name/ID (if applicable)** | …   |

# Setup Chunk

``` r
#installing necessary packages

if(require("caret")){
  require("caret")
}else{
  install.packages("caret", dependencies = TRUE,
                   repos= "https://cloud.r-project.org")
}
```

    ## Loading required package: caret

    ## Loading required package: ggplot2

    ## Loading required package: lattice

``` r
if(require("klaR")){
  require("klaR")
}else{
  install.packages("klaR", dependencies = TRUE,
                   repos = "https://cloud.r-prject.org")
}
```

    ## Loading required package: klaR

    ## Loading required package: MASS

``` r
## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: e1071

``` r
## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: readr

``` r
## LiblineaR ----
if (require("LiblineaR")) {
  require("LiblineaR")
} else {
  install.packages("LiblineaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: LiblineaR

``` r
## naivebayes ----
if (require("naivebayes")) {
  require("naivebayes")
} else {
  install.packages("naivebayes", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: naivebayes

    ## naivebayes 0.9.7 loaded

**Note:** the following KnitR options have been set as the global
defaults: <BR>
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

# Understanding the Dataset (Exploratory Data Analysis (EDA))

## Loading the Dataset

``` r
if (require("mlbench")){
  require("mlbench")
} else {
  install.packages("mlbench", dependencies= TRUE,
                   repos= "https://cloud.r-project.org")
}
```

    ## Loading required package: mlbench

``` r
#getting/loading the Pima Indians Diabetes dataset from mlbench

data("PimaIndiansDiabetes")
```

### Source:

The dataset that was used can be downloaded here: *\<provide a link\>*

### Reference:

*\<Cite the dataset here using APA\>  
Refer to the APA 7th edition manual for rules on how to cite datasets:
<https://apastyle.apa.org/style-grammar-guidelines/references/examples/data-set-references>*

``` r
library(readr)

# Provide the executable R code inside the various code chunks as guided by the lab work.
```

\#splitting the dataset

``` r
train_index <- createDataPartition(PimaIndiansDiabetes$diabetes,
                                   p=0.80, list=FALSE)
diabetes_dataset_train <- PimaIndiansDiabetes[train_index,]
diabetes_dataset_test <- PimaIndiansDiabetes[-train_index,]
```

\#performing naive bayes

``` r
diabetes_dataset_nb_e1071 <-
  e1071::naiveBayes(diabetes~ pregnant+ glucose+ pressure+
                      triceps+ insulin+ mass+ pedigree+ age,
                    data=diabetes_dataset_train)
```

\#testing the model using the test dataset

``` r
prediction_nb_e1071 <-
  predict(diabetes_dataset_nb_e1071,
          diabetes_dataset_test[, c("pregnant", "glucose",
                                    "pressure","triceps","insulin", "mass",
                                    "pedigree","age")
            
          ])

print(prediction_nb_e1071)
```

    ##   [1] neg pos pos pos pos pos pos pos pos pos neg neg neg neg pos neg neg pos
    ##  [19] pos neg neg pos neg neg pos pos pos neg neg neg neg neg pos pos neg neg
    ##  [37] neg pos neg neg pos neg pos pos neg neg neg neg pos neg neg neg neg neg
    ##  [55] neg pos neg neg neg neg pos neg neg pos pos neg neg pos neg pos neg pos
    ##  [73] neg neg neg pos pos pos neg neg neg neg neg neg neg neg neg neg neg neg
    ##  [91] pos neg neg neg neg neg neg pos neg neg neg pos neg pos pos neg neg neg
    ## [109] neg neg pos neg pos neg neg pos neg neg pos neg neg neg neg neg neg pos
    ## [127] neg pos pos pos neg pos neg neg neg pos neg neg neg neg neg neg neg neg
    ## [145] neg neg neg pos pos pos neg pos neg
    ## Levels: neg pos

``` r
caret::confusionMatrix(prediction_nb_e1071,
                       diabetes_dataset_test[, c("pregnant", "glucose",
                                                 "pressure","triceps","insulin", "mass",
                                                 "pedigree","age","diabetes")]$diabetes)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg  86  15
    ##        pos  14  38
    ##                                           
    ##                Accuracy : 0.8105          
    ##                  95% CI : (0.7393, 0.8692)
    ##     No Information Rate : 0.6536          
    ##     P-Value [Acc > NIR] : 1.46e-05        
    ##                                           
    ##                   Kappa : 0.5796          
    ##                                           
    ##  Mcnemar's Test P-Value : 1               
    ##                                           
    ##             Sensitivity : 0.8600          
    ##             Specificity : 0.7170          
    ##          Pos Pred Value : 0.8515          
    ##          Neg Pred Value : 0.7308          
    ##              Prevalence : 0.6536          
    ##          Detection Rate : 0.5621          
    ##    Detection Prevalence : 0.6601          
    ##       Balanced Accuracy : 0.7885          
    ##                                           
    ##        'Positive' Class : neg             
    ## 

\#visualizing the prediction

``` r
plot(table(prediction_nb_e1071,
           diabetes_dataset_test[, c("pregnant", "glucose",
                                     "pressure","triceps","insulin", "mass",
                                     "pedigree","age","diabetes")]$diabetes))
```

![](Lab-Submission-Markdown_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

\#bootstrapping train control

``` r
train_control <- trainControl(method = "boot", number = 500)

str(diabetes_dataset_test)
```

    ## 'data.frame':    153 obs. of  9 variables:
    ##  $ pregnant: num  5 10 1 5 11 7 4 7 7 0 ...
    ##  $ glucose : num  116 115 189 166 143 147 111 159 187 146 ...
    ##  $ pressure: num  74 0 60 72 94 76 72 64 68 82 ...
    ##  $ triceps : num  0 0 23 19 33 0 47 0 39 0 ...
    ##  $ insulin : num  0 0 846 175 146 0 207 0 304 0 ...
    ##  $ mass    : num  25.6 35.3 30.1 25.8 36.6 39.4 37.1 27.4 37.7 40.5 ...
    ##  $ pedigree: num  0.201 0.134 0.398 0.587 0.254 ...
    ##  $ age     : num  30 29 59 51 51 43 56 40 41 44 ...
    ##  $ diabetes: Factor w/ 2 levels "neg","pos": 1 1 2 2 2 2 2 1 2 1 ...

``` r
diabetes_dataset_model_lm <- # nolint
  caret::train(diabetes ~
                 pregnant+ glucose+ pressure+
                 triceps+ insulin+ mass+ pedigree+ age,
               data = diabetes_dataset_train,
               trControl = train_control,
               na.action = na.omit, method = "glm", metric = "Accuracy")


predictions_lm <- predict(diabetes_dataset_model_lm,
                          diabetes_dataset_test[, 1:8])
```

\##View the RMSE and the predicted values for the 12 observations —-

``` r
print(diabetes_dataset_model_lm)
```

    ## Generalized Linear Model 
    ## 
    ## 615 samples
    ##   8 predictor
    ##   2 classes: 'neg', 'pos' 
    ## 
    ## No pre-processing
    ## Resampling: Bootstrapped (500 reps) 
    ## Summary of sample sizes: 615, 615, 615, 615, 615, 615, ... 
    ## Resampling results:
    ## 
    ##   Accuracy   Kappa   
    ##   0.7539606  0.428425

``` r
print(predictions_lm)
```

    ##   [1] neg pos neg pos pos pos pos pos pos pos neg neg neg neg pos neg neg pos
    ##  [19] pos neg neg pos neg neg neg neg pos neg neg neg neg pos pos pos neg neg
    ##  [37] neg pos neg neg pos pos pos pos neg neg neg neg pos neg neg neg neg pos
    ##  [55] neg pos neg neg neg neg pos neg neg pos pos neg neg pos neg pos neg pos
    ##  [73] neg neg neg pos pos pos neg neg pos neg neg neg neg neg neg neg neg neg
    ##  [91] pos neg neg neg neg neg neg pos neg neg neg pos pos neg pos neg neg neg
    ## [109] neg neg neg neg neg neg neg neg neg neg pos neg neg neg neg neg neg neg
    ## [127] neg neg pos pos neg pos neg neg neg pos neg neg neg neg neg neg neg neg
    ## [145] neg neg neg pos pos pos neg neg neg
    ## Levels: neg pos

\#perfoming 10 fold cross validation

``` r
train_control <- trainControl(method = "cv", number = 10)

diabetes_dateset_model_lm_cv <-
  caret::train(diabetes ~ .,
               data = diabetes_dataset_train,
               trControl = train_control, na.action = na.omit,
               method = "glm", metric = "Accuracy")


predictions_lm_cv <- predict(diabetes_dateset_model_lm_cv, diabetes_dataset_test[, -9])


print(diabetes_dateset_model_lm_cv)
```

    ## Generalized Linear Model 
    ## 
    ## 615 samples
    ##   8 predictor
    ##   2 classes: 'neg', 'pos' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 554, 553, 553, 554, 553, 554, ... 
    ## Resampling results:
    ## 
    ##   Accuracy   Kappa    
    ##   0.7608937  0.4390418

``` r
print(predictions_lm_cv)
```

    ##   [1] neg pos neg pos pos pos pos pos pos pos neg neg neg neg pos neg neg pos
    ##  [19] pos neg neg pos neg neg neg neg pos neg neg neg neg pos pos pos neg neg
    ##  [37] neg pos neg neg pos pos pos pos neg neg neg neg pos neg neg neg neg pos
    ##  [55] neg pos neg neg neg neg pos neg neg pos pos neg neg pos neg pos neg pos
    ##  [73] neg neg neg pos pos pos neg neg pos neg neg neg neg neg neg neg neg neg
    ##  [91] pos neg neg neg neg neg neg pos neg neg neg pos pos neg pos neg neg neg
    ## [109] neg neg neg neg neg neg neg neg neg neg pos neg neg neg neg neg neg neg
    ## [127] neg neg pos pos neg pos neg neg neg pos neg neg neg neg neg neg neg neg
    ## [145] neg neg neg pos pos pos neg neg neg
    ## Levels: neg pos

\#performing Classification: SVM with Repeated k-fold Cross Validation

``` r
train_control <- trainControl(method = "repeatedcv", number = 5, repeats = 3)


diabetes_dateset_model_svm <-
  caret::train(diabetes ~ ., data = diabetes_dataset_train,
               trControl = train_control, na.action = na.omit,
               method = "svmLinearWeights2", metric = "Accuracy")

predictions_svm <- predict(diabetes_dateset_model_svm, diabetes_dataset_test)


print(diabetes_dateset_model_svm)
```

    ## L2 Regularized Linear Support Vector Machines with Class Weights 
    ## 
    ## 615 samples
    ##   8 predictor
    ##   2 classes: 'neg', 'pos' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (5 fold, repeated 3 times) 
    ## Summary of sample sizes: 492, 492, 492, 492, 492, 492, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   cost  Loss  weight  Accuracy   Kappa     
    ##   0.25  L1    1       0.5631436  0.07702483
    ##   0.25  L1    2       0.6357724  0.12204649
    ##   0.25  L1    3       0.5924119  0.11646916
    ##   0.25  L2    1       0.6970190  0.25914575
    ##   0.25  L2    2       0.7252033  0.42652141
    ##   0.25  L2    3       0.4677507  0.10082632
    ##   0.50  L1    1       0.6000000  0.10666097
    ##   0.50  L1    2       0.6205962  0.10334025
    ##   0.50  L1    3       0.6086721  0.10454155
    ##   0.50  L2    1       0.7127371  0.30063852
    ##   0.50  L2    2       0.7230352  0.42389928
    ##   0.50  L2    3       0.4677507  0.10082632
    ##   1.00  L1    1       0.6146341  0.08685443
    ##   1.00  L1    2       0.5945799  0.11941516
    ##   1.00  L1    3       0.6433604  0.09246672
    ##   1.00  L2    1       0.7062331  0.28688758
    ##   1.00  L2    2       0.7284553  0.43075985
    ##   1.00  L2    3       0.4682927  0.10150575
    ## 
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were cost = 1, Loss = L2 and weight = 2.

``` r
caret::confusionMatrix(predictions_svm, diabetes_dataset_test$diabetes)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg  76   6
    ##        pos  24  47
    ##                                           
    ##                Accuracy : 0.8039          
    ##                  95% CI : (0.7321, 0.8636)
    ##     No Information Rate : 0.6536          
    ##     P-Value [Acc > NIR] : 3.3e-05         
    ##                                           
    ##                   Kappa : 0.599           
    ##                                           
    ##  Mcnemar's Test P-Value : 0.001911        
    ##                                           
    ##             Sensitivity : 0.7600          
    ##             Specificity : 0.8868          
    ##          Pos Pred Value : 0.9268          
    ##          Neg Pred Value : 0.6620          
    ##              Prevalence : 0.6536          
    ##          Detection Rate : 0.4967          
    ##    Detection Prevalence : 0.5359          
    ##       Balanced Accuracy : 0.8234          
    ##                                           
    ##        'Positive' Class : neg             
    ## 

\#training a Naive Bayes classifier based on an LOOCV

``` r
train_control <- trainControl(method = "LOOCV")


diabetes_dataset_model_nb_loocv <-
  caret::train(diabetes ~ ., data = diabetes_dataset_train,
               trControl = train_control, na.action = na.omit,
               method = "naive_bayes", metric = "Accuracy")

predictions_nb_loocv <-
  predict(diabetes_dataset_model_nb_loocv, diabetes_dataset_test[, 1:9])

print(diabetes_dataset_model_nb_loocv)
```

    ## Naive Bayes 
    ## 
    ## 615 samples
    ##   8 predictor
    ##   2 classes: 'neg', 'pos' 
    ## 
    ## No pre-processing
    ## Resampling: Leave-One-Out Cross-Validation 
    ## Summary of sample sizes: 614, 614, 614, 614, 614, 614, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   usekernel  Accuracy   Kappa    
    ##   FALSE      0.7463415  0.4261619
    ##    TRUE      0.7479675  0.4266683
    ## 
    ## Tuning parameter 'laplace' was held constant at a value of 0
    ## Tuning
    ##  parameter 'adjust' was held constant at a value of 1
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were laplace = 0, usekernel = TRUE
    ##  and adjust = 1.

``` r
caret::confusionMatrix(predictions_nb_loocv, diabetes_dataset_test$diabetes)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg  88  17
    ##        pos  12  36
    ##                                           
    ##                Accuracy : 0.8105          
    ##                  95% CI : (0.7393, 0.8692)
    ##     No Information Rate : 0.6536          
    ##     P-Value [Acc > NIR] : 1.46e-05        
    ##                                           
    ##                   Kappa : 0.5719          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.4576          
    ##                                           
    ##             Sensitivity : 0.8800          
    ##             Specificity : 0.6792          
    ##          Pos Pred Value : 0.8381          
    ##          Neg Pred Value : 0.7500          
    ##              Prevalence : 0.6536          
    ##          Detection Rate : 0.5752          
    ##    Detection Prevalence : 0.6863          
    ##       Balanced Accuracy : 0.7796          
    ##                                           
    ##        'Positive' Class : neg             
    ## 
