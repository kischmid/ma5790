# Notes About the Project

## Goal

Predict the final grade (G3) for each student. 

Potentially just the grade in their Portuguese class because there's more observations for Portuguese?
Could also do two models, one for math, one for Portuguese?
Do one that predicts both math and Portuguese?

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
