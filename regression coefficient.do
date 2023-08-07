webuse womenwk, clear

tab educ, gen(ed)
label variable age "Age in years"
rename ed1 no_ed
rename ed2 low_education
rename ed3 medium_education
rename ed4 high_education
label variable no_ed "No education"
label variable low_education "Low education"
label variable medium_education "Medium education"
label variable high_education"High education"

reg wage low_education medium_education high_education age
coefplot, vertical baselevels drop(_cons age) yline(0,lpattern(dash))  ///
          ytitle("Regression Coefficient")   ///
		  xtitle("Education Level")    ///
		  title("Regression Model of Women's Hourly Wage", ///
		   size(medium) justification(right) )   ///
		   subtitle("Educational Levels", size(medsmall) justification(right))  ///
		   graphregion(color(white)) ///
		   scheme(s1mono)

qui reg wage low_education medium_education high_education age
est store model1

qui reg wage low_education medium_education high_education age married
est store model2
coefplot (model1, label(model 1)) (model2, label(model 2)), vertical baselevels drop(_cons age married) yline(0,lpattern(dash))  ///
          ytitle("Regression Coefficient")   ///
		  xtitle("Education Level")    ///
		  title("Regression Model of Women's Hourly Wage", ///
		   size(medium) justification(right) )   ///
		   subtitle("Educational Levels", size(medsmall) justification(right))  ///
		   graphregion(color(white)) ///
		   scheme(s1mono)
		   
reg wage low_education medium_education high_education age married
  plotbeta wage|low_education|medium_education|high_education|age|married, ///
    ytitle("variables")   ///
		  xtitle("values")    ///
		  title("Regression Model of Women's Hourly Wage", ///
		   size(medium) justification(right) )   ///
		   graphregion(color(white)) ///
		   xline(0,lpattern(dash)) ///
		   scheme(s1mono)