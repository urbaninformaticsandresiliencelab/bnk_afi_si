log using main_p.log, replace
use "final_p.dta", clear
xtset citnum

******************** MAIN ANALYSES
* PRELIMINARIES
* Basic associations
foreach fi in b a {
foreach mode in ft pt cr {
sum t`fi'_`mode'mn, det
}
}
pwcorr t*mn blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt
foreach mode in ft pt cr {
bysort aclsr_`mode': sum blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt
}

* MODELS PREDICTING LOG ODDS THAT NEAREST AFI IS CLOSER THAN NEAREST BANK
* CAR and FOOT
foreach mode in ft pt cr {
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15, re vce(robust)
eststo `mode'_1
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15, re vce(robust) 
eststo `mode'_2
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15, re vce(robust) 
eststo `mode'_3
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00, re vce(robust) 
eststo `mode'_4
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust)
eststo `mode'_5
 }
* GENERATE SI TABLE 1
foreach mode in ft pt cr {
esttab `mode'_1	`mode'_2 `mode'_3 `mode'_4 `mode'_5 using table_`mode'.rtf, replace nogap onecell se	
esttab `mode'_1	`mode'_2 `mode'_3 `mode'_4 `mode'_5 using table_`mode'OddsRatios.rtf, replace nogap onecell eform ci
}

* TO CREATE FIGURE 1, WE ADD PROPORTION WHITE AND SUPRESS CONSTANT
foreach mode in ft pt cr {
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

* TO CREATE FIGURE 2, WE ADD PROPORTION WHITE AND SUPRESS CONSTANT
foreach mode in ft pt cr {
xtlogit aclsr_`mode' wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) nocons
** FOR POOR, UNEMPLOYED, LOW-COLLEGE ED, RENTERS N'HOOD
* For poor=50% and wht=70%, blc=70%, or lat=70%
margins, atmeans at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) at(pov15=50 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) at(pov15=50 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2 (p75)ump15 (p25)edu15 (p25)own15) 
** FOR NONPOOR, EMPLOYED, COLLEGE ED, HOME-OWNERS N'HOOD
* For poor=10% and wht=70%, blc=70%, or lat=70%
margins, atmeans at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) at(pov15=10 blc15=70 wht15=10 lat15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) at(pov15=10 lat15=70 wht15=10 blc15=10 asi15=8 oth15=2 (p25)ump15 (p75)edu15 (p75)own15) 
 }
 
* PREDICT PROXIMITY TO BANK AND PROXIMITY TO AFI
* Car and foot
foreach type in b a {
display "* FOR INSTITUTION:`type'"
foreach mode in ft pt cr {
xtreg t`type'_`mode'mn blc15 lat15 asi15 oth15, mle 
eststo `type'_`mode'_1
xtreg t`type'_`mode'mn blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, mle 
eststo `type'_`mode'_2
 }
 }
* GENERATE SI TABLE 2
foreach type in b a {
 foreach mode in ft pt cr {
esttab `type'_`mode'_1 `type'_`mode'_2 using table_`type'_`mode'.rtf, replace nogap onecell se
esttab `type'_`mode'_1 `type'_`mode'_2 using table_`type'_`mode'OddsRatios.rtf, replace nogap onecell eform ci
}
}


******************** SUPPLEMENTARY ANALYSES
* 1 EXPLORE NONLINEARITY
* 2 EXPLORE COVARIATES FURTHER
* 3 EXPLORE RACE*POVERTY INTERACTION TERMS
* 4 USE AVG HOUSEHOLD INCOME INSTEAD OF PERCENT POOR
* 5 EXCLUDE CASES WITH HIGH ACS MOE

* 1 EXPLORE NONLINEARITY
* PREPARE
* Racial composition thresholds at 10% increments, by race
foreach race in blc lat asi wht {
foreach base in 0 10 20 30 40 50 60 70 80 90 {
local top = `base' + 10
gen `race'`base'_`top' = 0
replace `race'`base'_`top' = 1 if `race'15 >= `base' & `race'15 < `top'
sum `race'15 if `race'`base'_`top' == 1 
}
replace `race'90_100 = 1 if `race'15 == 100
foreach base in 0 10 20 30 40 50 60 70 80 90 {
local top = `base' + 10
sum `race'15 if `race'`base'_`top' == 1 
}
}
* Additional variable to make some things easier
label define thrshld10  1 0_10 2 10_20 3 20_30 4 30_40 5 40_50 6 50_60 7 60_70 8 70_80 9 80_90 10 90_100
foreach race in blc wht lat asi {
egen `race'10s = group(`race'0_10-`race'90_100)
recode `race'10s 1=.
tab `race'10s
recode `race'10s 11=1 10=2 9=3 8=4 7=5 5=7 4=8 3=9 2=10
label values `race'10s thrshld10
tab `race'10s
}

* Simple bivariate prediction for core race variables
foreach mode in ft pt cr {
foreach race in blc wht lat {
xtlogit aclsr_`mode' i.`race'10s, re vce(robust)
margins `race'10s
marginsplot, saving(`race'10s`mode'gph, replace)
}
}
* After adding only poverty
foreach mode in ft pt cr {
foreach race in blc wht lat {
xtlogit aclsr_`mode' i.`race'10s pov15, re vce(robust)
margins `race'10s
marginsplot, saving(`race'10spov`mode'gph, replace)
}
}
* Produce combined graphs for ease of interpretation
foreach mode in ft pt cr {
graph combine blc10s`mode'gph.gph wht10s`mode'gph.gph lat10s`mode'gph.gph, saving(combrace`mode', replace) iscale (*.7) ycommon
graph combine blc10spov`mode'gph.gph wht10spov`mode'gph.gph lat10spov`mode'gph.gph, saving(combracepov`mode', replace) iscale (*.7) ycommon
}

* EXAMINE NONLINEARITY
* The bivariate relationship between percent white and outcome is somewhat concave, changing ~30% white for car travel and ~50% white for foot and public transit travel 
* Assess with quadratic term (all travel modes for comparison)
foreach mode in ft pt cr {
xtlogit aclsr_`mode' wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_`mode' wht15 c.wht15#c.wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
}
* Quadratic term does not capture nonlinearity
* Assess with interactions at 30% wht threshold for car and 50% threshold for public transit
gen whtabv30 = 0
replace whtabv30=1 if wht15>=30 & wht15~=.
replace whtabv30=. if wht15==.
bysort whtabv30: sum wht15, det
xtlogit aclsr_cr wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_cr wht15 whtabv30#c.wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
gen whtabv50 = 0
replace whtabv50=1 if wht15>=50 & wht15~=.
replace whtabv50=. if wht15==.
bysort whtabv50: sum wht15, det
xtlogit aclsr_ft wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_ft wht15 whtabv50#c.wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_pt wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_pt wht15 whtabv50#c.wht15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
* For car travel (only) the 30% threshold captures nonlinearity.
* We calculate margins for models with the threshold interaction, and compare to the original
* First the Fig 1 model for cars
xtlogit aclsr_cr wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) nocons
* FOR POV=10
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=10 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=10 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=10 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=10 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
marginsplot, saving(wht_baseNotPoor_cr_gph, replace) xlabel(none) title(Fig1WhtNotPoor)
* FOR POV=50
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=50 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=50 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=50 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
marginsplot, saving(wht_basePoor_cr_gph, replace)  xlabel(none) title(Fig1WhtPoor)
* Now the Fig 1 model for cars w/ different slopes above and below 30% white
xtlogit aclsr_cr wht15 whtabv30#c.wht15 blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) nocons
margins, atmeans at(pov15=10 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=10 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=10 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=10 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=10 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
marginsplot, saving(wht_ab30NotPoor_cr_gph, replace)  xlabel(none) title(With30%WhtThrshldhtNotPoor)
* FOR POV=50
* For wht = 10, 30, 50, 70, 90
margins, atmeans at(pov15=50 wht15=10 blc15=40 lat15=40 asi15=8 oth15=2) at(pov15=50 wht15=30 blc15=30 lat15=30 asi15=8 oth15=2) at(pov15=50 wht15=50 blc15=20 lat15=20 asi15=8 oth15=2) at(pov15=50 wht15=70 blc15=10 lat15=10 asi15=8 oth15=2) at(pov15=50 wht15=90 blc15=0 lat15=0 asi15=8 oth15=2) 
marginsplot, saving(wht_ab30Poor_cr_gph, replace) xlabel(none) title(With30%WhtThrshldWhtPoor)
graph combine wht_baseNotPoor_cr_gph.gph wht_basePoor_cr_gph.gph wht_ab30NotPoor_cr_gph.gph wht_ab30Poor_cr_gph.gph, saving(combwhtab30gph, replace) iscale (*.7) ycommon

* The bivariate relationship between percent Latino/a and outcome changes at the 60% threshold for car travel (less so for other modes) and at the 10% threshold for foot travel and public transit travel
* Assess with interactions at 60% lat threshold for car and 10% threshold for foot and public transit travel
gen latabv60 = 0
replace latabv60=1 if lat15>=60 & lat15~=.
replace latabv60=. if lat15==.
bysort latabv60: sum lat15, det
xtlogit aclsr_cr blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_cr blc15 lat15 latabv60#c.lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
gen latabv10 = 0
replace latabv10=1 if lat15>=10 & lat15~=.
replace latabv10=. if lat15==.
bysort latabv10: sum lat15, det
xtlogit aclsr_ft blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_ft blc15 lat15 latabv10#c.lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_pt blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
xtlogit aclsr_pt blc15 lat15 latabv10#c.lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
* For car travel, there is no detectable threshold effect at the 60% level.  The foot and public transit travel models suggest that below the 10% threshold there is no relationship; after the 10%, it is essentially linear

* 2 EXPLORE COVARIATES FURTHER
* Explore covariates
local othercovs "blc15 lat15 asi15 oth15 pov15 frn15 ppdnl15 cmdnpcpt"
foreach mode in ft pt cr {
xtlogit aclsr_`mode' `othercovs' edu15, re vce(robust)
eststo covs`mode'edu
xtlogit aclsr_`mode' `othercovs' ump15, re vce(robust)
eststo covs`mode'ump
xtlogit aclsr_`mode' `othercovs' own15, re vce(robust)
eststo covs`mode'own
xtlogit aclsr_`mode' `othercovs' hu15sqk, re vce(robust)
eststo covs`mode'husq
xtlogit aclsr_`mode' `othercovs' vacrat15, re vce(robust)
eststo covs`mode'vac
xtlogit aclsr_`mode' `othercovs' blb00, re vce(robust)
eststo covs`mode'blb
xtlogit aclsr_`mode' `othercovs' edu15 ump15 own15  hu15sqk vacrat15 blb00, re vce(robust)
eststo covs`mode'all
}
foreach mode in ft pt cr {
esttab covs`mode'edu covs`mode'ump covs`mode'own covs`mode'husq covs`mode'vac covs`mode'blb covs`mode'all using covs`mode'.rtf, replace nogap onecell se	
}

* 3 EXPLORE RACE*POVERTY INTERACTION TERMS
* Interactions between poverty and two race variables that were significant in original model
foreach mode in ft cr pt {
xtlogit aclsr_`mode' blc15 c.pov15#c.blc15 lat15 c.pov15#c.lat15 asi15 oth15 pov15 frn15 ppdnl15 edu15 ump15 own15 hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) 
eststo intrct_`mode'
}
esttab cr_5 intrct_cr ft_5 intrct_ft pt_5 intrct_pt using interactions.rtf, replace nogap onecell se

* 4 USE AVG HOUSEHOLD INCOME INSTEAD OF PERCENT POOR
gen ln_inc = ln(hmi)
hist ln_inc
pwcorr pov15 ln_inc blc15 lat15 asi15 oth15 frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcp
foreach mode in ft cr pt {
xtlogit aclsr_`mode' blc15 lat15 asi15 oth15 ln_inc frn15 ppdnl15 edu15 ump15 own15  hu15sqk vacrat15 blb00 cmdnpcpt, re vce(robust) nocons
eststo `mode'_5inc
}
esttab cr_5 cr_5inc ft_5 ft_5inc pt_5 pt_5inc using table_pov_v_inc.rtf, replace nogap onecell se	

* 5 EXCLUDE CASES WITH HIGH ACS MOE
use moe.dta, clear
xtset citnum
gen WHT =  b03002_003 / b03002_001 *100
gen BLK =  b03002_004 / b03002_001 *100
gen ASN =  b03002_006 / b03002_001 *100
gen LAT =  b03002_012 / b03002_001 *100
gen OTH = 100 - (WHT + BLK + ASN + LAT)
replace OTH = 0 if OTH <0 & OTH ~=.
gen POV =  b17021_002 /  b17021_001 *100
gen FOR =  b99051_005 / b99051_001
gen EDU = ((b15003_022 +  b15003_023 +  b15003_024 +  b15003_025) /  b15003_001) *100
gen UMP = (b23025_005 / (b23025_004 +  b23025_005)) *100
gen LNPOP = ln(b03002_001)
gen OWN  = (1 -  (b25008_003 / b25008_001)) *100
gen HU  = b25001_001
gen HUSQ = HU/area
gen VACRAT = b25004_001 / b25001_001 *100
gen BLB00 = ((b25036_012 + b25036_011 + b25036_010 + b25036_009 + b25036_008 + b25036_007 + b25036_006) + (b25036_023 + b25036_022 + b25036_021 + b25036_020 + b25036_019 + b25036_018 + b25036_017)) / b25036_001

* Based on margin of error, calculate coefficient of variation
* (ACS reports no MOE for foreign born, 99051_005 99051_001)
foreach var in 03002_001 03002_003 03002_004 03002_006 03002_012 17021_002 17021_001 15003_022 15003_023 15003_024 15003_025 15003_001 23025_005 23025_004 25008_003 25008_001 25001_001 25004_001 25036_012 25036_011 25036_010 25036_009 25036_008 25036_007 25036_006 25036_023 25036_022 25036_021 25036_020 25036_019 25036_018 25036_017 25036_001 {
* First, add 1 to all vars to avoid dividing by zero in CV
gen bb`var' = b`var'+1
sum bb`var' b`var'
* Next, calculate coefficient of variation
gen cv`var' = ((m`var'/1.645)/bb`var')*100
sum bb`var' m`var' cv`var'
}


* Create new var with the most reliable values
* The 99% most reliable values
foreach var in 03002_001 03002_003 03002_004 03002_006 03002_012 17021_002 17021_001 15003_022 15003_023 15003_024 15003_025 15003_001 23025_005 23025_004 25008_003 25008_001 25001_001 25004_001 25036_012 25036_011 25036_010 25036_009 25036_008 25036_007 25036_006 25036_023 25036_022 25036_021 25036_020 25036_019 25036_018 25036_017 25036_001 {
egen cv99pt`var' = pctile(cv`var'), p(99)
gen rel`var' = bb`var' if cv`var' < cv99pt`var' 
sum rel`var' 
}
gen relWHT =  rel03002_003 / rel03002_001 *100
gen relBLK =  rel03002_004 / rel03002_001 *100
gen relASN =  rel03002_006 / rel03002_001 *100
gen relLAT =  rel03002_012 / rel03002_001 *100
gen relOTH = 100 - (relWHT + relBLK + relASN + relLAT)
replace relOTH = 0 if relOTH <0 & relOTH ~=.
gen relPOV =  rel17021_002 /  rel17021_001 *100
gen relEDU = ((rel15003_022 +  rel15003_023 +  rel15003_024 +  rel15003_025) /  rel15003_001) *100
gen relUMP = (rel23025_005 / (rel23025_004 +  rel23025_005)) *100
gen relLNPOP = ln(rel03002_001)
gen relOWN  = (1 -  (rel25008_003 / rel25008_001)) *100
gen relHU  = rel25001_001
gen relHUSQ = relHU/area
gen relVACRAT = rel25004_001 / rel25001_001 *100
gen relBLB00 = ((rel25036_012 + rel25036_011 + rel25036_010 + rel25036_009 + rel25036_008 + rel25036_007 + rel25036_006) + (rel25036_023 + rel25036_022 + rel25036_021 + rel25036_020 + rel25036_019 + rel25036_018 + rel25036_017)) / rel25036_001
sum BLK relBLK LAT relLAT ASN relASN OTH relOTH POV relPOV FOR FOR LNPOP relLNPOP EDU relEDU UMP relUMP OWN relOWN HUSQ relHUSQ VACRAT relVACRAT BLB relBLB 
* Run regression
foreach mode in ft pt cr {
xtlogit aclsr_`mode' relBLK relLAT relASN relOTH relPOV FOR relLNPOP relEDU relUMP relOWN relHUSQ relVACRAT relBLB cmdnpcpt, re vce(robust) nocons
eststo `mode'rel99allvrs
* After excluding relOTH and relBLB
xtlogit aclsr_`mode' relBLK relLAT relASN relPOV FOR relLNPOP relEDU relUMP relOWN relHUSQ relVACRAT cmdnpcpt, re vce(robust) nocons
eststo `mode'rel99mostvrs
}

* Now, 95% most reliable values
drop rel*
foreach var in 03002_001 03002_003 03002_004 03002_006 03002_012 17021_002 17021_001 15003_022 15003_023 15003_024 15003_025 15003_001 23025_005 23025_004 25008_003 25008_001 25001_001 25004_001 25036_012 25036_011 25036_010 25036_009 25036_008 25036_007 25036_006 25036_023 25036_022 25036_021 25036_020 25036_019 25036_018 25036_017 25036_001 {
egen cv95pt`var' = pctile(cv`var'), p(95)
gen rel`var' = bb`var' if cv`var' < cv95pt`var' 
sum rel`var' 
}
gen relWHT =  rel03002_003 / rel03002_001 *100
gen relBLK =  rel03002_004 / rel03002_001 *100
gen relASN =  rel03002_006 / rel03002_001 *100
gen relLAT =  rel03002_012 / rel03002_001 *100
gen relOTH = 100 - (relWHT + relBLK + relASN + relLAT)
replace relOTH = 0 if relOTH <0 & relOTH ~=.
gen relPOV =  rel17021_002 /  rel17021_001 *100
gen relEDU = ((rel15003_022 +  rel15003_023 +  rel15003_024 +  rel15003_025) /  rel15003_001) *100
gen relUMP = (rel23025_005 / (rel23025_004 +  rel23025_005)) *100
gen relLNPOP = ln(rel03002_001)
gen relOWN  = (1 -  (rel25008_003 / rel25008_001)) *100
gen relHU  = rel25001_001
gen relHUSQ = relHU/area
gen relVACRAT = rel25004_001 / rel25001_001 *100
gen relBLB00 = ((rel25036_012 + rel25036_011 + rel25036_010 + rel25036_009 + rel25036_008 + rel25036_007 + rel25036_006) + (rel25036_023 + rel25036_022 + rel25036_021 + rel25036_020 + rel25036_019 + rel25036_018 + rel25036_017)) / rel25036_001
sum BLK relBLK LAT relLAT ASN relASN OTH relOTH POV relPOV FOR FOR LNPOP relLNPOP EDU relEDU UMP relUMP OWN relOWN HUSQ relHUSQ VACRAT relVACRAT BLB relBLB 
* Run regression
foreach mode in ft pt cr {
xtlogit aclsr_`mode' relBLK relLAT relASN relOTH relPOV FOR relLNPOP relEDU relUMP relOWN relHUSQ relVACRAT relBLB cmdnpcpt, re vce(robust) nocons
eststo `mode'rel95allvrs
* After excluding relOTH and relBLB
xtlogit aclsr_`mode' relBLK relLAT relASN relPOV FOR relLNPOP relEDU relUMP relOWN relHUSQ relVACRAT cmdnpcpt, re vce(robust) nocons
eststo `mode'rel95mostvrs
}

* Produce tables
foreach mode in ft pt cr {
esttab `mode'rel99mostvrs `mode'rel99allvrs `mode'rel95mostvrs `mode'rel95allvrs using moeREL`mode'.rtf, replace nogap onecell se mtitles
}

log close
