use DID_sim_data,clear
tsset ID time
tfdiff y treat z1 z2 z3,t(10)tvar(time) pvar(ID) datatype(panel) vce(cluster ID) graph 
bysort treat time: egen y_mean = mean(y)
 bysort treat time: keep if _n == _N
 keep y_mean treat time
reshape wide y_mean, i(time) j(treat)

  twoway scatter y_mean1  time, c(1) xlabel(0(5)20)      ///
    || scatter  y_mean0 time, c(1) xlabel(0(5)20) ,      /// 
    ytitle("E[y(t)]") xtitle("Time")                          ///
    yline(0 , lpattern(dash)) xline(10, lw(thick) lp(dash)) ///
    note(Average Effect of the Policy = 2)                    ///
    legend(ring(0) cols(1) order(1 2) position(5)             ///
    label(1 "Treated") label(2 "Untreated"))                  ///
    graphregion(fcolor(white)) scheme(s1mono)	  
