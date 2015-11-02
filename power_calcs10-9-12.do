*log using powercalcs, text replace
*Power Calcs

/*
 Assumptions: - standard deviation of agricultural output equals mean - treatment effect increases output by 30% (or the take-up differential is .3) - intra-cluster correlation of 10% - correlation between baseline and endline of 40% - power of 80%
 */
 
 
*starting adoption rate=30%, ending adoption rate is 60%, alpha=.05, 1-b=.8, correlation between baseline and endline=.4
 sampsi .3 .6, alpha(.05) power(.8) r01(.4) 

*With 40 observations per cluster, intraclass corr=.1, the sample is about 850*2

 sampclus, obsclus(40) rho(.1)

*Wiht 10 observations per cluster, the sampel is about 330*2

 sampclus, obsclus(10) rho(.1) 

 
 
 *starting output=100, ending output=13-, 1-b=.8, alpha=.05, correlation between baseline and endline=.4, sd=mean output

 sampsi 100 130, alpha(.05) power(.8) r01(.4) sd1(100)

*With 40 observations per cluster, intraclass corr=.1, the sample is about 850*2

 sampclus, obsclus(40) rho(.1)

*Wiht 10 observations per cluster, the sampel is about 330*2

 sampclus, obsclus(10) rho(.1) 

 
*log close

sampsi .5 .65, alpha(.05) power(.8) 
sampsi .5 .60, alpha(.05) power(.8) 
sampsi .5 .55, alpha(.05) power(.8) 

sampsi .5 .65, alpha(.05) power(.8)
sampclus, obsclus(20) rho(.1) 
sampsi .5 .60, alpha(.05) power(.8) 
sampclus, obsclus(20) rho(.1) 
sampsi .5 .55, alpha(.05) power(.8) 
sampclus, obsclus(20) rho(.1) 
