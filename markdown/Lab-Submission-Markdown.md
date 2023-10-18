Business Intelligence Project
================
<Specify your name here>
<Specify the date when you submitted the lab>

- [Student Details](#student-details)
- [Student Details](#student-details-1)
- [Setup Chunk](#setup-chunk)
- [Understanding the Dataset (Exploratory Data Analysis
  (EDA))](#understanding-the-dataset-exploratory-data-analysis-eda)
  - [Loading the Dataset](#loading-the-dataset)
    - [Source:](#source)
    - [Reference:](#reference)

# Student Details

# Student Details

|                                                                                                             |     |
|-------------------------------------------------------------------------------------------------------------|-----|
| *Student ID Number* \| 136346 \| \| \| 127559 \| \| 134775 \| \| 135863 \| \| 134141                        |     |
| *Student Name* \| Ngumi Joshua \| \| \| Joseph Watunu \| \| Hakeem Alavi \| \| Muema Ian \| \| Aicha Mbongo |     |
| *BBIT 4.2 Group* \| C \|                                                                                    |     |
| *BI Project Group Name/ID (if applicable)* \| Business Intelligent \|                                       |     |

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

    ##   [1] pos neg neg neg neg pos pos pos pos neg neg neg neg neg neg neg neg neg
    ##  [19] neg neg neg neg pos pos pos neg pos neg neg neg neg pos pos pos neg neg
    ##  [37] neg neg neg neg neg neg pos pos neg neg neg neg pos neg pos pos neg neg
    ##  [55] pos pos neg pos neg neg neg neg neg neg neg pos neg neg pos neg neg pos
    ##  [73] pos neg neg neg pos neg pos pos neg pos pos neg pos neg neg pos neg neg
    ##  [91] neg pos neg pos neg neg pos neg neg neg neg pos pos neg neg neg neg neg
    ## [109] pos pos neg neg neg neg pos pos neg neg pos pos pos pos neg pos pos neg
    ## [127] neg neg pos neg pos pos pos pos neg neg neg pos neg neg neg neg neg pos
    ## [145] neg neg neg neg pos neg neg pos neg
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
    ##        neg  75  23
    ##        pos  25  30
    ##                                           
    ##                Accuracy : 0.6863          
    ##                  95% CI : (0.6064, 0.7588)
    ##     No Information Rate : 0.6536          
    ##     P-Value [Acc > NIR] : 0.2234          
    ##                                           
    ##                   Kappa : 0.3133          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.8852          
    ##                                           
    ##             Sensitivity : 0.7500          
    ##             Specificity : 0.5660          
    ##          Pos Pred Value : 0.7653          
    ##          Neg Pred Value : 0.5455          
    ##              Prevalence : 0.6536          
    ##          Detection Rate : 0.4902          
    ##    Detection Prevalence : 0.6405          
    ##       Balanced Accuracy : 0.6580          
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
    ##  $ pregnant: num  10 7 7 1 1 13 11 9 0 2 ...
    ##  $ glucose : num  168 100 107 103 97 145 138 171 100 84 ...
    ##  $ pressure: num  74 0 74 30 66 82 76 110 88 0 ...
    ##  $ triceps : num  0 0 0 38 15 19 0 24 60 0 ...
    ##  $ insulin : num  0 0 0 83 140 110 0 240 110 0 ...
    ##  $ mass    : num  38 30 29.6 43.3 23.2 22.2 33.2 45.4 46.8 0 ...
    ##  $ pedigree: num  0.537 0.484 0.254 0.183 0.487 0.245 0.42 0.721 0.962 0.304 ...
    ##  $ age     : num  34 32 31 33 22 57 35 54 31 21 ...
    ##  $ diabetes: Factor w/ 2 levels "neg","pos": 2 2 2 1 1 1 1 2 1 1 ...

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
    ##   0.7757512  0.4829696

``` r
print(predictions_lm)
```

    ##   [1] pos neg neg neg neg neg pos pos neg neg pos neg neg neg neg pos neg neg
    ##  [19] neg neg neg neg pos pos pos neg pos neg neg neg neg pos pos pos neg neg
    ##  [37] neg neg neg neg neg pos pos pos neg neg pos neg pos neg neg pos neg neg
    ##  [55] pos pos pos pos neg pos neg neg neg neg neg pos neg neg pos neg neg pos
    ##  [73] neg neg neg neg neg neg neg neg neg pos pos neg pos neg neg neg neg neg
    ##  [91] neg pos neg pos neg neg pos neg neg neg neg pos pos neg neg neg neg neg
    ## [109] neg pos neg neg neg neg neg neg neg neg pos pos pos pos neg pos pos neg
    ## [127] neg neg pos neg pos pos pos pos neg neg neg neg neg neg pos neg neg neg
    ## [145] neg neg neg neg pos pos neg pos neg
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
    ##   0.7739556  0.4755557

``` r
print(predictions_lm_cv)
```

    ##   [1] pos neg neg neg neg neg pos pos neg neg pos neg neg neg neg pos neg neg
    ##  [19] neg neg neg neg pos pos pos neg pos neg neg neg neg pos pos pos neg neg
    ##  [37] neg neg neg neg neg pos pos pos neg neg pos neg pos neg neg pos neg neg
    ##  [55] pos pos pos pos neg pos neg neg neg neg neg pos neg neg pos neg neg pos
    ##  [73] neg neg neg neg neg neg neg neg neg pos pos neg pos neg neg neg neg neg
    ##  [91] neg pos neg pos neg neg pos neg neg neg neg pos pos neg neg neg neg neg
    ## [109] neg pos neg neg neg neg neg neg neg neg pos pos pos pos neg pos pos neg
    ## [127] neg neg pos neg pos pos pos pos neg neg neg neg neg neg pos neg neg neg
    ## [145] neg neg neg neg pos pos neg pos neg
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
    ##   0.25  L1    1       0.6130081  0.14089424
    ##   0.25  L1    2       0.6097561  0.08389020
    ##   0.25  L1    3       0.6135501  0.12704336
    ##   0.25  L2    1       0.7338753  0.36292151
    ##   0.25  L2    2       0.6932249  0.38367881
    ##   0.25  L2    3       0.4905149  0.12913491
    ##   0.50  L1    1       0.5886179  0.09528936
    ##   0.50  L1    2       0.5902439  0.07234465
    ##   0.50  L1    3       0.5560976  0.11436616
    ##   0.50  L2    1       0.7457995  0.39629784
    ##   0.50  L2    2       0.7051491  0.40486591
    ##   0.50  L2    3       0.4905149  0.12913491
    ##   1.00  L1    1       0.6233062  0.12969150
    ##   1.00  L1    2       0.6146341  0.12488697
    ##   1.00  L1    3       0.6357724  0.15054046
    ##   1.00  L2    1       0.7403794  0.38318847
    ##   1.00  L2    2       0.7029810  0.39818388
    ##   1.00  L2    3       0.4899729  0.12846201
    ## 
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were cost = 0.5, Loss = L2 and weight = 1.

``` r
caret::confusionMatrix(predictions_svm, diabetes_dataset_test$diabetes)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg  85  28
    ##        pos  15  25
    ##                                           
    ##                Accuracy : 0.719           
    ##                  95% CI : (0.6407, 0.7886)
    ##     No Information Rate : 0.6536          
    ##     P-Value [Acc > NIR] : 0.05152         
    ##                                           
    ##                   Kappa : 0.3414          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.06725         
    ##                                           
    ##             Sensitivity : 0.8500          
    ##             Specificity : 0.4717          
    ##          Pos Pred Value : 0.7522          
    ##          Neg Pred Value : 0.6250          
    ##              Prevalence : 0.6536          
    ##          Detection Rate : 0.5556          
    ##    Detection Prevalence : 0.7386          
    ##       Balanced Accuracy : 0.6608          
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
    ##   FALSE      0.7642276  0.4672143
    ##    TRUE      0.7577236  0.4488618
    ## 
    ## Tuning parameter 'laplace' was held constant at a value of 0
    ## Tuning
    ##  parameter 'adjust' was held constant at a value of 1
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were laplace = 0, usekernel = FALSE
    ##  and adjust = 1.

``` r
caret::confusionMatrix(predictions_nb_loocv, diabetes_dataset_test$diabetes)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction neg pos
    ##        neg  75  23
    ##        pos  25  30
    ##                                           
    ##                Accuracy : 0.6863          
    ##                  95% CI : (0.6064, 0.7588)
    ##     No Information Rate : 0.6536          
    ##     P-Value [Acc > NIR] : 0.2234          
    ##                                           
    ##                   Kappa : 0.3133          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.8852          
    ##                                           
    ##             Sensitivity : 0.7500          
    ##             Specificity : 0.5660          
    ##          Pos Pred Value : 0.7653          
    ##          Neg Pred Value : 0.5455          
    ##              Prevalence : 0.6536          
    ##          Detection Rate : 0.4902          
    ##    Detection Prevalence : 0.6405          
    ##       Balanced Accuracy : 0.6580          
    ##                                           
    ##        'Positive' Class : neg             
    ## 
