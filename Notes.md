# Notes About the Project

## Goal

Predict the final grade (G3) for each student. Using only the portuguese studnets since there's more observations there. 

## Dataset

G1, G2, and G3 are target variables. We'll probably only use G3 as a target in order to predict their final grade. Final grade is much more interesting than G1 or G2. 

Binary Variables (13):

* school
* sex
* address
* famsize
* Pstatus
* schoolsup
* famsup
* paid
* activities
* nursery
* higher
* internet
* romantic

Categorical Variables (14):

* Medu
* Fedu
* Mjob
* Fjob
* reason
* guardian
* traveltime
* studytime
* famrel
* freetime
* goout
* Dalc
* Walc
* health

Continuous Variables (3):
* age
* failures
* absences

## Preprocessing Steps

### Continuous Variables
1. Graph histograms and box plots to see distribution and outliers   -- Done
2. Correct skew (AS NEEDED) with boxcox   -- Done
3. Center and scale   -- Done

### Categorical Variables
1. Bar charts to see distribution   -- Done
2. Convert to dummy variables (binary one column of 0/1, everthing else several 0/1 columns)   -- Done
3. Check for near zero variance   -- Done

### All Variables Together
1. Remove highly correlated predictors (corr >= 90%)   -- Done

### Continuous Variables
1. Spatial Sign to remove outliers   -- Done

## Things to Make Sure We Do
* When showing distribution of predictors, use percent as y, not count
* Do remove correlation=1, otherwise you'll have problems
* Have summary of what is left after preprocessing
* Make sure we are done within 10 minutes

## Modeling Steps

### Linear Models (Dana)

### Non-Linear Models (Katie)
