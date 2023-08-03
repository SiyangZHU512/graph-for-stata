sysuse sp500, clear // 导入软件自带数据文件
#d ;
twoway (line high date) (line low date),
 title("这是图选项：标题", box)
 subtitle("这是副标题""图1：股票最高价与最低价时序图")
 xtitle("这是 x 轴标题：交易日期", margin(medsmall))
 ytitle("这是 y 轴标题：股票价格")
 ylabel(900(200)1400) ymtick(##5)
 legend(title("图例")label(1 "最高价") label(2 "最低价"))
 note("这是注释：数据来源于 Stata 公司")
 caption("这是说明：欢迎加入 Stata 连享会!")
 saving(myfig.gph, replace);
 /**/
 clear all
import excel "D:\桌面\cne.xlsx", sheet("Sheet1") firstrow 
encode country,gen(country1)
graph bar (asis) GDP, ///
  over(country1)   ///
  over(year) ///
  asyvars   ///
  ylabel(100(20)350,tposition(indside) labsize(*0.8) angle(0))   ///
  ytitle(GDP for different country)  ///
  blabel(bar,size(vsmall) format(%3.1f)) /// 
  bar(1,color(red))   ///
  bar(2,color(green))  ///
  bar(3,color(orange))  ///
graphregion(color(white))

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
		  /*over(...) 表示按什么变量进行分组；
hor 表示横向展示条形图；
stack 表示堆叠；
bar(#, ...) 对第 # 个堆叠成分设置填充颜色、边框颜色、边框线条等；
legend(...，order(...)) 设置图例文字。*/
