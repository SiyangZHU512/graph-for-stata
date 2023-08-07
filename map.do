
**# Bookmark #1
use"中华人民共和国.dta",clear
#d ;
spmap GDP using "中华人民共和国_shp.dta",id(_ID)
 clnumber(10) fcolor(Reds2) ocolor(none ..)   
 title("GDP for different province", size(*0.8))      
  subtitle("China, 1994-98" " ", size(*0.8));  
   legstyle(3) legend(ring(1) position(3) size(vsmall));  
#d cr
/**/
clear all
use "world-d.dta",clear
#d ;
spmap area using "world-c.dta",id(_ID)
 clnumber(10) fcolor(Reds2) ocolor(none ..)   
 title("Area for different countries", size(*0.8))      
   legstyle(3) legend(ring(1) position(3) size(vsmall));
#d cr