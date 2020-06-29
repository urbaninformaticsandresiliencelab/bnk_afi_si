log using main_l.log, replace
use "expv13.dta", clear
xtset citnum

* Basic associations
foreach fi in b a {
foreach mode in cr pt ft {
sum t`fi'_`mode'mn, det
}
}
pwcorr t*mn blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt
foreach mode in cr pt ft {
bysort aclsr_`mode': sum blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt
}

* PREDICTIONS FOR pr AFI is closer
* CAR and FOOT
foreach mode in cr ft {
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15, re vce(robust) 
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15, re vce(robust) 
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15, re vce(robust) 
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00, re vce(robust) 
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust)
}
* PUBLIC TRANSIT after excluding Memphis, due to data issues
xtlogit aclsr_pt blc15 lat15 asi15 oth15 if cityname~="memphis", re vce(robust) 
xtlogit aclsr_pt blc15 lat15 asi15 oth15 pov15 if cityname~="memphis", re vce(robust) 
xtlogit aclsr_pt blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 if cityname~="memphis", re vce(robust) 
xtlogit aclsr_pt blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 if cityname~="memphis", re vce(robust) 
xtlogit aclsr_pt blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt if cityname~="memphis", re vce(robust) 

* PREDICTIONS FOR PROXIMITY TO BANK, TO AFI
* CAR and FOOT
foreach type in b a {
display "* FOR INSTITUTION:`type'"
foreach mode in cr ft {
xtreg t`type'_`mode'mn blc15 lat15 asi15 oth15, mle 
xtreg t`type'_`mode'mn blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, mle 
 }
 }
* PUBLIC TRANSIT after excluding Memphis, due to data issues
foreach type in b a {
xtreg t`type'_ptmn blc15 lat15 asi15 oth15 if cityname~="memphis", mle 
xtreg t`type'_ptmn blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt if cityname~="memphis", mle
}


* TO CREATE FIGURE 1, WE ADD PROPORTION WHITE AND SUPRESS CONSTANT
* CAR and FOOT
foreach mode in cr ft {
****** UNADJUSTED *****
xtlogit aclsr_`mode' wht15 blc15 lat15 asi15 oth15, re vce(robust) nocons
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
* For blc = 10, 30, 50, 70, 90
margins, atmeans at(blc15=10 wht15=40 lat15=40 asi15=8 oth15=2) at(blc15=30 wht15=30 lat15=30 asi15=8 oth15=2) at(blc15=50 wht15=20 lat15=20 asi15=8 oth15=2)  at(blc15=70 wht15=10 lat15=10 asi15=8 oth15=2) at(blc15=90 wht15=0 lat15=0 asi15=8 oth15=2)
* For lat = 10, 30, 50, 70, 90
margins, atmeans at(lat15=10 wht15=40 blc15=40 asi15=8 oth15=2) at(lat15=30 wht15=30 blc15=30 asi15=8 oth15=2) at(lat15=50 wht15=20 blc15=20 asi15=8 oth15=2)  at(lat15=70 wht15=10 blc15=10 asi15=8 oth15=2) at(lat15=90 wht15=0 blc15=0 asi15=8 oth15=2)

****** ADJUSTED *****
xtlogit aclsr_`mode' wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) nocons
****** FOR POV=10
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=10 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=10 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=10 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
* For blc = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 blc15=10 wht15=40 lat15=40 asi15=8 oth15=2) at(pov15=10 blc15=30 wht15=30 lat15=30 asi15=8 oth15=2) at(pov15=10 blc15=50 wht15=20 lat15=20 asi15=8 oth15=2)  at(pov15=10 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2) at(pov15=10 blc15=90 wht15=0 lat15=0 asi15=8 oth15=2)
* For lat = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 lat15=10 wht15=40 blc15=40 asi15=8 oth15=2) at(pov15=10 lat15=30 wht15=30 blc15=30 asi15=8 oth15=2) at(pov15=10 lat15=50 wht15=20 blc15=20 asi15=8 oth15=2)  at(pov15=10 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2) at(pov15=10 lat15=90 wht15=0 blc15=0 asi15=8 oth15=2)
****** FOR POV=50
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=50 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=50 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=50 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
* For blc = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 blc15=10 wht15=40 lat15=40 asi15=8 oth15=2) at(pov15=50 blc15=30 wht15=30 lat15=30 asi15=8 oth15=2) at(pov15=50 blc15=50 wht15=20 lat15=20 asi15=8 oth15=2)  at(pov15=50 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2) at(pov15=50 blc15=90 wht15=0 lat15=0 asi15=8 oth15=2)
* For lat = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 lat15=10 wht15=40 blc15=40 asi15=8 oth15=2) at(pov15=50 lat15=30 wht15=30 blc15=30 asi15=8 oth15=2) at(pov15=50 lat15=50 wht15=20 blc15=20 asi15=8 oth15=2)  at(pov15=50 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2) at(pov15=50 lat15=90 wht15=0 blc15=0 asi15=8 oth15=2)
 }

* PUBLIC TRANSIT after excluding Memphis, due to data issues
****** UNADJUSTED *****
xtlogit aclsr_pt wht15 blc15 lat15 asi15 oth15 if cityname~="memphis", re vce(robust) nocons
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
* For blc = 10, 30, 50, 70, 90
margins, atmeans at(blc15=10 wht15=40 lat15=40 asi15=8 oth15=2) at(blc15=30 wht15=30 lat15=30 asi15=8 oth15=2) at(blc15=50 wht15=20 lat15=20 asi15=8 oth15=2)  at(blc15=70 wht15=10 lat15=10 asi15=8 oth15=2) at(blc15=90 wht15=0 lat15=0 asi15=8 oth15=2)
* For lat = 10, 30, 50, 70, 90
margins, atmeans at(lat15=10 wht15=40 blc15=40 asi15=8 oth15=2) at(lat15=30 wht15=30 blc15=30 asi15=8 oth15=2) at(lat15=50 wht15=20 blc15=20 asi15=8 oth15=2)  at(lat15=70 wht15=10 blc15=10 asi15=8 oth15=2) at(lat15=90 wht15=0 blc15=0 asi15=8 oth15=2)

****** ADJUSTED *****
xtlogit aclsr_pt wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt if cityname~="memphis", re vce(robust) nocons
****** FOR POV=10
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=10 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=10 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=10 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
* For blc = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 blc15=10 wht15=40 lat15=40 asi15=8 oth15=2) at(pov15=10 blc15=30 wht15=30 lat15=30 asi15=8 oth15=2) at(pov15=10 blc15=50 wht15=20 lat15=20 asi15=8 oth15=2)  at(pov15=10 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2) at(pov15=10 blc15=90 wht15=0 lat15=0 asi15=8 oth15=2)
* For lat = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 lat15=10 wht15=40 blc15=40 asi15=8 oth15=2) at(pov15=10 lat15=30 wht15=30 blc15=30 asi15=8 oth15=2) at(pov15=10 lat15=50 wht15=20 blc15=20 asi15=8 oth15=2)  at(pov15=10 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2) at(pov15=10 lat15=90 wht15=0 blc15=0 asi15=8 oth15=2)
****** FOR POV=50
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=50 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=50 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=50 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
* For blc = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 blc15=10 wht15=40 lat15=40 asi15=8 oth15=2) at(pov15=50 blc15=30 wht15=30 lat15=30 asi15=8 oth15=2) at(pov15=50 blc15=50 wht15=20 lat15=20 asi15=8 oth15=2)  at(pov15=50 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2) at(pov15=50 blc15=90 wht15=0 lat15=0 asi15=8 oth15=2)
* For lat = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 lat15=10 wht15=40 blc15=40 asi15=8 oth15=2) at(pov15=50 lat15=30 wht15=30 blc15=30 asi15=8 oth15=2) at(pov15=50 lat15=50 wht15=20 blc15=20 asi15=8 oth15=2)  at(pov15=50 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2) at(pov15=50 lat15=90 wht15=0 blc15=0 asi15=8 oth15=2)


*** TO CREATE FIGURE 2
* CAR and FOOT
foreach mode in cr ft {
xtlogit aclsr_`mode' wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) nocons
** FOR POOR, UNEMPLOYED, LOW-COLLEGE ED, RENTERS N'HOOD
* For poor=50% and wht=70%, blc=70%, or lat=70%
margins, atmeans at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) at(pov15=50 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) at(pov15=50 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) 
** FOR NONPOOR, EMPLOYED, COLLEGE ED, HOME-OWNERS N'HOOD
* For poor=10% and wht=70%, blc=70%, or lat=70%
margins, atmeans at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) at(pov15=10 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) at(pov15=10 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) 
 }
 * PUBLIC TRANSIT after excluding Memphis, due to data issues
 xtlogit aclsr_pt wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt if cityname~="memphis", re vce(robust) nocons
** FOR POOR, UNEMPLOYED, LOW-COLLEGE ED, RENTERS N'HOOD
* For poor=50% and wht=70%, blc=70%, or lat=70%
margins, atmeans at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) at(pov15=50 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) at(pov15=50 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) 
** FOR NONPOOR, EMPLOYED, COLLEGE ED, HOME-OWNERS N'HOOD
* For poor=10% and wht=70%, blc=70%, or lat=70%
margins, atmeans at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) at(pov15=10 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) at(pov15=10 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) 
log close
