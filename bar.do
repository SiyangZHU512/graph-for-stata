
			  
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
save "DID_simu_data1.dta", replace  //save the data
gen z10=z1+10
forvalues i=1(1)20 {

  if ID == `i'  local graphTitle "`i'"
  
  twoway ///
    bar z10 time if ID==`i',     /// Set as bar chart
      yaxis(1) ytitle("Avg. Number of Foods from" "Group Consumed Last Month", axis(1)) /// Pointing to the left Y-axis
      barwidth(.9) fintensity(inten0) lcolor(black)     ///
      xlabel(0 "0" 4 "4" 8 "8" 12 "12" 16 "16" 20 "20")           ///
      ylabel(0 "0" 4 "4" 8 "8" 12 "12" 20 "20", axis(1))  ||        /// Separate different Y-axis settings with "||".
    line z3 time if ID==`i', /// Set as line graph
      yaxis(2) ytitle("Total Value of Exp." "1000 Real Tz Sh.", axis(2)) ///
      ylabel(-25 "-25" -10 "-10" 5 "-5" 10 "10" 25 "-25", axis(2)) ///Points to the right Y-axis
      xlabel(0 "0" 4 "4" 8 "8" 12 "12" 16 "16" 20 "20") lwidth(1.2)     ///
  title("`graphTitle'") xtitle("Month of Interview")    ///Overall picture settings
  graphregion(color(white)) bgcolor(white)              ///
  legend(off) ///
  name("ID`i'")                                  //Temporary storage of images to facilitate the subsequent combination of individual images
}

* Combine graphs into one
* -----------------------
graph combine ID1 ID2 ID3 ID4 ID5 ID6 ID7 ID8 ID9 ID10 ID11 ID12 ID13 ID14 ID15 ID16 ID17 ID18 ID19 ID20, /// Name of the image to be combined
              graphregion(color(white)) plotregion(color(white))
