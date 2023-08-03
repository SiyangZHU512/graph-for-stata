clear all
global graph_opts1 ///
  bgcolor(white) graphregion(color(white)) ///
  legend(region(lcolor(none) fcolor(none))) ///
  ylabel(,angle(0) nogrid) ///
  subtitle(, justification(left) color(black) span position(11)) ///
  title(, color(black) span)

global pct `" 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%" "'

use "https://gitee.com/arlionn/stata-visual-library/raw/master/Library/data/bar-stack-by.dta", clear

graph bar med_b2_antister_cat?? ///
          if dr_3 == 1   ///
           , ///
          stack over(checkgroup) nofill ///
          legend(order(5 "No Medication" ///
                       4 "Antibiotic and Steroid" ///
                       3 "Antibiotic" ///
                       2 "Steroid" ///
                       1 "No Antibiotic or Steroid") ///
                cols(1) position(3) ///
                symxsize(small) symysize(small) size(small)) ///
          ${graph_opts1} ///
          bar(5, color(white) lcolor(black) lpattern(solid) lwidth(thin)) ///
          bar(1,lwidth(thin) lcolor(black)) bar(2,lwidth(thin) lcolor(black)) ///
          bar(3,lwidth(thin) lcolor(black)) bar(4,lwidth(thin) lcolor(black)) ///
          subtitle("Referral", color(black) justification(center) position(12)) ///
          name(figure_1)
        
graph bar med_b2_antister_cat?? ///
          if dr_3 == 0 ///
          , ///
          stack over(checkgroup) nofill ///
          legend(order(5 "No Medication" ///
                       4 "Antibiotic and Steroid" ///
                       3 "Antibiotic" ///
                       2 "Steroid" ///
                       1 "No Antibiotic or Steroid") ///
                cols(1) position(3) ///
                symxsize(small) symysize(small) size(small)) ///
          ${graph_opts1} ///
          bar(5, color(white) lcolor(black) lpattern(solid) lwidth(thin)) ///
          bar(1,lwidth(thin) lcolor(black)) ///
          bar(2,lwidth(thin) lcolor(black)) ///
          bar(3,lwidth(thin) lcolor(black)) ///
          bar(4,lwidth(thin) lcolor(black)) ///
          subtitle("No Referral", color(black) justification(center) position(12)) ///
          name(figure_2)

grc1leg figure_2 figure_1 ///
        , ///
        position(3) ///
        graphregion(color(white)) ///
        xsize(7) ///
        rows(1) ///
        legendfrom(figure_2)
		
/**/
clear all
import excel "D:\桌面\enfuihew.xlsx", sheet("enfuihew") firstrow
encode home,gen(home1)
encode deaded,gen(deaded1)
encode dead_1,gen(deaded1_1)
encode dead_2,gen(deaded1_2)
encode dead_3,gen(deaded1_3)
encode love,gen(love1)
recast byte home1
recast byte deaded1
recast byte deaded1_1
recast byte deaded1_2
recast byte deaded1_3
recast float love1

global graph_opts1 ///
  bgcolor(white) graphregion(color(white)) ///
  legend(region(lcolor(none) fcolor(none))) ///
  ylabel(,angle(0) nogrid) ///
  subtitle(, justification(left) color(black) span position(11)) ///
  title(, color(black) span)

global pct `" 0 "0%" 1 "25%" 2 "50%" 3 "75%" 4 "100%" "'

graph bar deaded1?? ///
          if home1 == 1 ///
          , ///
          stack over(love1) nofill ///
		   ylabel(${pct}) ///
          legend(order(3 "old" ///
                       1 "kill" ///
                       2 "not kill") ///
                cols(1) position(3) ///
                symxsize(small) symysize(small) size(small)) ///
          ${graph_opts1} ///
          bar(1,lwidth(thin) lcolor(black)) ///
		  bar(2,lwidth(thin) lcolor(black)) ///
          bar(3,lwidth(thin) lcolor(black))  ///
          subtitle("in home", color(black) justification(center) position(12)) ///
          name(figure_11)
        
graph bar deaded1?? ///
          if home1 ==2 ///
          , ///
          stack over(love1) nofill ///
		   ylabel(${pct}) ///
          legend(order(3 "old" ///
                       1 "kill" ///
                       2 "not kill") ///
                cols(1) position(3) ///
                symxsize(small) symysize(small) size(small)) ///
          ${graph_opts1} ///
          bar(1,lwidth(thin) lcolor(black)) ///
          bar(2,lwidth(thin) lcolor(black)) ///
          bar(3,lwidth(thin) lcolor(black)) ///
         subtitle("No in home", color(black) justification(center) position(12)) ///
          name(figure_21)

grc1leg figure_21 figure_11 ///
        , ///
        position(3) ///
        graphregion(color(white)) ///
        xsize(7) ///
        rows(1) ///
        legendfrom(figure_21)