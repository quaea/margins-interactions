* Linear Regression
* Written by Ani Katchova
* Extended by Carlos Mendez -20200921

* clear dataset and global macros
clear all
set more off

* load data (stata file)
*use regression_auto
use "https://github.com/quarcs-lab/data-open/raw/master/auto/regression_auto.dta", clear

* define global parameters (list of variables)
global ylist  mpg
global x1list weight1
global xlist  weight1 price foreign

* describe and summarize the data
describe  $ylist $xlist
summarize $ylist $xlist
summarize $ylist, detail

* Correlation
correlate $ylist $xlist

* Plotting the data
graph twoway (scatter $ylist $x1list), name(scatter1, replace)
graph save   "scatter1.gph", replace
graph export "scatter1.png", replace

* Simple regression
reg $ylist $x1list

* Plotting a regression line
graph twoway (scatter $ylist $x1list)(lfit $ylist $x1list), name(linearFit, replace)
graph save   "linearFit.gph", replace
graph export "linearFit.png", replace

* Predicted values for the dependent variable
predict y1hat, xb
summarize $ylist y1hat
graph twoway (scatter $ylist $x1list)(scatter y1hat $x1list), name(predictedValues, replace)
graph save   "predictedValues.gph", replace
graph export "predictedValues.png", replace

* Regression residuals
predict e1hat, resid
summarize e1hat
graph twoway (scatter e1hat $x1list), name(residuals, replace)
graph save   "residuals.gph", replace
graph export "residuals.png", replace

* Hypothesis testing (coefficient significantly different from zero)
test $x1list

* Marginal effects (at the mean and average marginal effect)
quietly reg $ylist $x1list
margins, dydx(*) atmeans
margins, dydx(*)


* Multiple regression
reg $ylist $xlist

* Predicted values for the dependent variable
predict yhat, xb
summarize $ylist yhat

* Regression residuals
predict ehat, resid
summarize ehat

* Hypothesis testing (coefficients jointly significantly different from zero)
test $xlist

* Marginal effects (at the mean and average marginal effect)
margins, dydx(*) atmeans
margins, dydx(*)

* Save and export new dataset
save "DO_prediction_and_residuals-dat", replace
export delimited using "DO_prediction_and_residuals-dat.csv", replace

* After installing outreg2 module, generate professional regression table
* findit outreg2
reg $ylist $x1list, robust
outreg2 using "DO_prediction_and_residuals-tab.xls", replace

reg $ylist $xlist, robust
outreg2 using "DO_prediction_and_residuals-tab.xls", append