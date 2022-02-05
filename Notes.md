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

Categorical Variables (6):

* Medu
* Fedu
* Mjob
* Fjob
* reason
* guardian

Continuous Variables (3):
* age
* failures
* absences

Binned Variables (8):
* traveltime
* studytime
* famrel
* freetime
* goout
* Dalc
* Walc
* health

## Preprocessing Steps

### Continuous Variables
1. Graph histograms and box plots to see distribution and outliers
2. Correct skew (AS NEEDED) with boxcox
3. Center and scale

### Categorical Variables
1. Bar charts to see distribution
2. Check for near zero variance
3. Convert to dummy variables (binary one column of 0/1, everthing else several 0/1 columns)

### All Variables Together
1. Remove highly correlated predictors (corr >= 85%)

### Continuous Variables
1. Spatial Sign to remove outliers (IF NEEDED)

test
