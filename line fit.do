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
	
	gen y=0.7*z1*z2+1.2*z1+0.6*z2+e*4.3+z3*2+10+20*treat*index2
save "DID_simu_data1.dta", replace  //保存一份数据以备后用
gen DID=treat*index2	
reg y z1 z2 z3 DID treat index2
predict y_hat

twoway ///
  (lfitci y_hat z1 if DID == 1, color("222 235 247") lwidth(.05)) ///  CI added into line fit graph
  (lfitci y_hat z1 if DID == 0, color(gs15)) ///
  (lfit	 z1 z1	if DID == 1, color(red) lwidth(.5) lpattern(dash)) ///
  (lfit y_hat z1 if DID == 0, color(gs8) lwidth(.5)) ///
  (lfit y_hat z1 if DID == 1, color(edkblue) lwidth(.5)), ///
  text(110 18 "Pre-treatment""regression line Y vs Z1"  ///
  190 18 "Post-treatment""regression line Y vs Z1" , ///
  orient(horizontal) size(vsmall) justification(center) fcolor(white) box margin(small)) ///
   xtitle("Independent variable value") ///
  ytitle("Predicted value of dependent variable") ///
  legend(order (6 "Pre-treatment" 7 "Post-treatment" 3 "Pre-treatment 95%CI" 1    "Pre-treatment 95%CI")) ///
  graphregion(color(white)) bgcolor(white)
  /**/
  twoway ///
  (lfitci y z1 ) ///
  (scatter y z1 ///
     if ID ==1, mcolor(cranberry) m(O) )  ///
  (scatter y z1 ///
     if ID==2,   mcolor(dkgreen) m(D) ) ///
  (scatter y z1 ///
     if ID == 3, mcolor(ebblue) m(T) ) ///
  (scatter y z1 ///
     if ID == 4, mcolor(dkorange) m(O)) ///
  (scatter y z1  ///
     if ID == 5, mcolor(navy) m(D) ) ///
  (scatter y z1  ///
    if ID== 6, mcolor(red) m(T)),  ///
  xlabel(-5(5)15) 		///
  xtitle("z1", axis(1)) ///
  ytitle("y" ) ///
  legend(order( 3 4 5 6 7 8) ///
        label(3 "1") label(4 "2")  ///
        label(5 "3") label(6 "4") ///
        label(7 "5") label(8 "6")    ///
  ring(0) position(4)) ///
  title("Gender Value Indicator and GDP per Capita Growth" "Correlation")  ///
  note("Source: World Values Survey (2014 or last available year) and World Bank") ///
  graphregion(color(white)) bgcolor(white)