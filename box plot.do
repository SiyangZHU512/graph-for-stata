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
	
	gen y=0.1*z1*z2+1.2*z1+0.6*z2+e+z3*2+10+20*treat*index2
save "DID_simu_data1.dta", replace  /// save the data
gen y10=log(y)
#d ;
graph hbox y10,   /// 
  over(ID, sort(1)) nooutside  ///
  ytitle("") ylabel(`labels')    ///
  title("GDP for different country", span)   ///
  subtitle(" ")   ///
  note("Source:DID_simu_data1", span) ;
#d cr 

///
graph export "F6_box_plot.png", ///
      replace width(431) height(394)
