clear all
	global dir d:/RDDStata
	capture mkdir $dir
	cd $dir
	
	set obs 400
	set seed 123
	
/*set panel*/	
 forvalues j=1(1)20{
     display"`j'"
     gen X`j'=.
	 forvalues i=`j'(20)400{
 	display"`i'"
	replace X`j'=`j' in `i'
 }
    replace X`j'=0 if X`j'==.
 }
 
gen ID=X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X11+X12+X13+X14+X15+X16+X17+X18+X19+X20

drop X*
gen index=.
forvalues i=1(1)400{
	replace index=`i' in `i'
}

gen time=.
forvalues i=1(1)20{
	replace time=`i' if inrange(index,(`i'-1)*20+1,`i'*20)
}
/*set ID=10 is the subject that get treated*/
	gen z1=rnormal()*4+10
	gen z2=rnormal()*5+8
	gen z3=rnormal()*9+2
	gen e=rnormal()
	gen treat=1 if inrange(ID,2,9)
	replace treat=0 if treat==.
	gen index2=1 if time>=10
	replace index2=0 if index2==.
	
	gen y=0.1*z1*z2+1.2*z1+0.6*z2+e+z3*2+10+10*treat*index2
save "DID_simu_data1.dta", replace  //保存一份数据以备后用
/*k----density*/
sum y if treat == 0
local pre_mean = r(mean)
sum y if treat == 1
local post_mean = r(mean)
twoway 	(kdensity y if treat == 0, color(gs10)) ///
        (kdensity y if treat == 1, color(emerald)), ///
        xline(`pre_mean', lcolor(gs12) lpattern(dash)) /// 
        xline(`post_mean', lcolor(eltgreen) lpattern(dash)) ///
        legend(order(1 "non treatment group" 2 " treatment group")) ///
        xtitle(Agriculture revenue (BRL thousands)) ///
        ytitle(Density) ///
        bgcolor (white) graphregion(color(white))
/*k_density*/
sum y if time >= 10
local pre_mean = r(mean)
sum y if time < 10
local post_mean = r(mean)
twoway 	(kdensity y if time >= 10, color(gs10)) ///
        (kdensity y if time < 10, color(emerald)), ///
        xline(`pre_mean', lcolor(gs12) lpattern(dash)) /// 
        xline(`post_mean', lcolor(eltgreen) lpattern(dash)) ///
        legend(order(1 "before event happend" 2 "after event")) ///
        xtitle(Agriculture revenue (BRL thousands)) ///
        ytitle(Density) ///
        bgcolor (white) graphregion(color(white))
		/**/
gen DID=treat*index2		
sum y if DID== 0
local pre_mean = r(mean)
sum y if DID == 1
local post_mean = r(mean)
twoway 	(kdensity y if DID == 0, color(gs10)) ///
        (kdensity y if DID== 1, color(emerald)), ///
        xline(`pre_mean', lcolor(gs12) lpattern(dash)) /// 
        xline(`post_mean', lcolor(eltgreen) lpattern(dash)) ///
        legend(order(1 "pre_treatment" 2 " post_treatment ")) ///
        xtitle(Agriculture revenue (BRL thousands)) ///
        ytitle(Density) ///
        bgcolor (white) graphregion(color(white))
/*with point*/
 tw /// 
  (kdensity y if treat == 0 ,lp(dash) lc(maroon) yaxis(2)) ///
  (kdensity y if treat== 1 ,lp(dash) lc(navy) yaxis(2)) ///
  (histogram y if treat== 0 ,freq w(.1) ///
     recast(scatter) msize(small) mc(maroon)) ///
  (histogram y if treat == 1 ,freq w(.1) ///
     recast(scatter) msize(small) mc(navy)),  ///
  legend(symxsize(small) ///
    order(0 "" 0 "" 0 "{bf: treatment:}" ///
          3 "untreated group" ///
          4 "treated") ///
          c(1) pos(11) ring(0))  ///
  xtitle("y_value {&rarr}") ///
  xlab(-50(50)100) ///
  yline(0 1 2 , lc(gs12) lp(dot)) ///
  xsize(7)