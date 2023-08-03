
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
graph bar  deaded1_1 deaded1_2 deaded1_3, ///
    $graph_opts1 hor stack over(love1) xsize(6) ///
    bar(1, lc(black) lw(thin)) ///
    bar(2, lc(black) lw(thin)) ///
    bar(3, lc(black) lw(thin)) ///
    legend(pos(5) ring(0) c(1) symxsize(small) symysize(small)  ///
    order(1 "kill" ///
          2 "not kill" ///
          3 "old")   ///
		  placement(bottom) ///
		  justification(left)) 
	  /*over(...) Indicates by what variable the bars are grouped;
hor indicates to display the bars horizontally;
stack indicates stacking;
bar(#, ...) Set the fill colour, border colour, border line, etc. for the # stack component;
legend(... legend(..., order(...)) Set the legend text. */
