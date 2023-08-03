
  
  global graph_opts1 ///
  bgcolor(white) ///
  graphregion(color(white)) ///
  legend(region(lc(none) fc(none))) ///
  ylabel(,angle(0) nogrid) ///
  title(, justification(left) color(black) span position(11)) ///
  subtitle(, justification(left) color(black)) //子标题设置

use "https://gitee.com/arlionn/stata-visual-library/raw/master/Library/data/bar-over.dta" , clear

graph bar treat_correct ///
, ///
  over(type)  ///type包括Standardized Patient与Vignette
  asyvars     ///将第一个over()设置的变量作为Y轴变量
  bargap(20)  ///柱之间的距离
  over(study) ///study包括Bihar、China与Delhi
  over(case)  ///case包括Diarrhea (ORS)与Tuberculosis (AFB or CXR)
  nofill      ///忽略缺少的分类
  blabel(bar, format(%9.2f)) ///柱上端的数字设置
  ${graph_opts1} ///
  bar(1 , lcolor(black) lwidth(thin) fintensity(100)) ///柱格式设置
  bar(2 , lcolor(black) lwidth(thin) fintensity(100)) ///
  legend(rows(1) ///
  order(0 "Measurement:" 1 "Standardized Patient" 2 "Clinical Vignette")) ///
  ytitle("Providers ordering correct treatment {&rarr}", ///
  placement(bottom) ///
  justification(left)) ///
  ylabel(${pct})
  
  /**/
  global graph_opts1 ///
  bgcolor(white) ///
  graphregion(color(white)) ///
  legend(region(lc(none) fc(none))) ///
  ylabel(,angle(0) nogrid) ///
  title(, justification(left) color(black) span position(11)) ///
  subtitle(, justification(left) color(black)) //子标题设置
  use bar.dta,clear
 graph bar deaded  ///
 , ///
 over(type) ///
 bargap(20)   ///
 over(country) ///
 over(home)   ///
 nofill      ///忽略缺少的分类
  blabel(bar, format(%9.2f)) ///柱上端的数字设置
  ${graph_opts1} ///
  bar(1 , lcolor(black) lwidth(thin) fintensity(100)) ///柱格式设置
  bar(2 , lcolor(black) lwidth(thin) fintensity(100)) ///
  legend(rows(1) ///
  order(0 "deaded reasons:" 1 "kill" 2 "old" 3 "ill")) ///
  ytitle("deaded situation {&rarr}", ///
  placement(bottom) ///
  justification(left)) 
 
 use "https://gitee.com/arlionn/stata-visual-library/raw/master/Library/data/bar-two-axes.dta", clear

* Adjust variable for bar position
gen x = int1mo+.5

* Create individual graphs
* ------------------------
foreach foodGroup in animal fruit grain veg starch processed_sugar {

  if "`foodGroup'" == "animal"  local graphTitle Animal Sourced
  if "`foodGroup'" == "fruit"   local graphTitle Fruit
  if "`foodGroup'" == "grain"   local graphTitle Grain
  if "`foodGroup'" == "veg"     local graphTitle Vegetables
  if "`foodGroup'" == "starch"  local graphTitle Starchy Foods
  if "`foodGroup'" == "processed_sugar"  local graphTitle Processed/Sugar
  
  twoway ///
    bar number_group x if food_group=="`foodGroup'",    ///设置为柱状图
      yaxis(1) ytitle("Avg. Number of Foods from" "Group Consumed Last Month", axis(1)) ///指左边Y轴
      barwidth(.9) fintensity(inten0) lcolor(black)     ///
      xlabel(0 "0" 3 "3" 6 "6" 9 "9" 12 "12")           ///
      ylabel(0 "0" 1 "1" 2 "2" 3 "3", axis(1)) ||       ///不同Y轴图形设置之间用"||"隔开
    line total_exp int1mo if food_group=="`foodGroup'", ///设置为折线图
      yaxis(2) ytitle("Total Value of Exp." "1000 Real Tz Sh.", axis(2)) ///
      ylabel(0 "0" 500 "500" 1000 "1000" 1500 "1500" 2000 "2000" 2500 "2500", axis(2)) ///指右边Y轴
      xlabel(3 "3" 6 "6" 9 "9" 12 "12") lwidth(1.2)     ///
  title("`graphTitle'") xtitle("Month of Interview")    ///整体图片设置
  graphregion(color(white)) bgcolor(white)              ///
  legend(off) ///
  name("`foodGroup'")                                   //将图片进行临时存储，方便后续组合各图
}

* Combine graphs into one
* -----------------------
graph combine starch animal fruit grain processed_sugar veg, ///需组合的图片名
              graphregion(color(white)) plotregion(color(white))
			  
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
gen z10=z1+10
forvalues i=1(1)20 {

  if ID == `i'  local graphTitle "`i'"
  
  twoway ///
    bar z10 time if ID==`i',    ///设置为柱状图
      yaxis(1) ytitle("Avg. Number of Foods from" "Group Consumed Last Month", axis(1)) ///指左边Y轴
      barwidth(.9) fintensity(inten0) lcolor(black)     ///
      xlabel(0 "0" 4 "4" 8 "8" 12 "12" 16 "16" 20 "20")           ///
      ylabel(0 "0" 4 "4" 8 "8" 12 "12" 20 "20", axis(1))  ||       ///不同Y轴图形设置之间用"||"隔开
    line z3 time if ID==`i', ///设置为折线图
      yaxis(2) ytitle("Total Value of Exp." "1000 Real Tz Sh.", axis(2)) ///
      ylabel(-25 "-25" -10 "-10" 5 "-5" 10 "10" 25 "-25", axis(2)) ///指右边Y轴
      xlabel(0 "0" 4 "4" 8 "8" 12 "12" 16 "16" 20 "20") lwidth(1.2)     ///
  title("`graphTitle'") xtitle("Month of Interview")    ///整体图片设置
  graphregion(color(white)) bgcolor(white)              ///
  legend(off) ///
  name("ID`i'")                                   //将图片进行临时存储，方便后续组合各图
}

* Combine graphs into one
* -----------------------
graph combine ID1 ID2 ID3 ID4 ID5 ID6 ID7 ID8 ID9 ID10 ID11 ID12 ID13 ID14 ID15 ID16 ID17 ID18 ID19 ID20, ///需组合的图片名
              graphregion(color(white)) plotregion(color(white))