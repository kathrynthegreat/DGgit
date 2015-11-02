/*****************************
Author: Kathryn Vasilaky 

Date Created: August 12, 2015
Date Last Edited: August 12, 2015

Purpose: This file computest a balance table of 
covariates using the midline data across treatment and control
******************************/

use "/Users/kathrynvasilaky/Dropbox/DigitalGreen/Midline plan/Analysis/Midline_Cleaning_Non_PII_All Sections.dta", clear
cd "/Users/kathrynvasilaky/Documents/OneDrive/Kentaro/Paper/output"
duplicates drop HHID, force


gen ITTreat =(dgorcontrol == "DG")
gen TOTreat = (Dissemination == "Yes")


*How many 
tab Dissemination

*What's the population by Distrcit and Intent to Treat
tab District ITTreat

*What's the population by Distrcit and Intent to Actual Treatment (TOT)
tab District TOTreat
tab District nestedtreatmentgroup

*Balance on observables
tab ITTreat, sum(s1_1_age)

replace s3_5_unit_size="3" if s3_5_unit_size=="03"
replace s3_4_parcel_size="3.5" if s3_4_parcel_size=="3/5"
replace s3_4_parcel_size="1.25" if s3_4_parcel_size=="01/25"

tostring  s1_1_age, replace
foreach var of varlist s1_1_age s1_2_relation s1_3_hig_sch s1_5_mem_hh ///
				s1_10_hig_sch_head s1_11_age_head s1_12_religion_head ///
				s3_3_walk_dist s3_4_parcel_size s3_5_unit_size ///
				s4_3_qlty_land s4_5_water_src s5_3_hard_sri s4_6_perc_irrigat s20_1_anu_income {
		destring `var', replace
		replace `var'=. if `var' < 0 
		
}



foreach var of varlist s14_6_electricity - s14_15_sch_kind  s14_16_spend_medi {
				destring `var', replace
				replace `var'=. if `var' < 0 
}


foreach var of varlist s1_1_age s1_2_relation s1_3_hig_sch s1_5_mem_hh ///
				s1_10_hig_sch_head s1_11_age_head s1_12_religion_head ///
				s3_3_walk_dist s3_4_parcel_size s3_5_unit_size ///
				s4_3_qlty_land s4_5_water_src s5_3_hard_sri  ///
				s4_6_perc_irrigat s4_5_water_src s4_3_qlty_land s20_1_anu_income /// 
				s14_6_electricity - s14_15_sch_kind  s14_16_spend_medi  {
			display "`var'"
			ttest `var', by(ITTreat)				
}


*Balanced Table
file open fh using "$results\descriptives.xls", write replace
file write fh "variable" _tab "meanC" _tab "meanD" _tab "sdC" _tab "sdD" _tab "pval"
foreach v of varlist s1_1_age s1_2_relation s1_3_hig_sch s1_5_mem_hh ///
				s1_10_hig_sch_head s1_11_age_head s1_12_religion_head ///
				s3_3_walk_dist s3_4_parcel_size s3_5_unit_size ///
				s4_3_qlty_land s4_5_water_src s5_3_hard_sri  ///
				s4_6_perc_irrigat s4_5_water_src s4_3_qlty_land s20_1_anu_income /// 
				s14_6_electricity - s14_15_sch_kind  s14_16_spend_medi {
		 display "`v'" 			
		 ttest `v', by(ITTreat)
		 local _temp_muC = string(r(mu_1),"%04.2f")
		 local _temp_muD = string(r(mu_2),"%04.2f")
		 local _temp_sdC = string(r(sd_1),"%04.2f")
		 local _temp_sdD = string(r(sd_2),"%04.2f")
		 local _temp_pvalue = r(p)
		 file write fh _n "`v'" _tab "`_temp_muC'" _tab "`_temp_muD'" _tab "`_temp_sdC'" _tab "`_temp_sdD'" _tab "`_temp_pvalue'"
}
file close fh




*These are not balanced. 

ttest s5_3_hard_sri,by(ITTreat)
ttest s3_3_walk_dist,by(ITTreat)
ttest s14_6_electricity,by(ITTreat)
ttest s14_7_7_chair,by(ITTreat)
ttest s14_7_8_bed_num,by(ITTreat)







