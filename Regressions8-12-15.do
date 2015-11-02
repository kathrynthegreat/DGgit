/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Project: DG

Purpose: Analyse Midline Non-PII data of all sections and produce summary statistics for Midline report

Author: Vasilaky
Date Created: 12 August 2015
Last edited: 12 August 2015


DG0: Regular SRI videos only.DG1: SRI videos with additional messaging about labour costs of SRI.DG2: SRI videos with additional messaging about a personÕs ability to implement SRI.DG3: SRI videos with additional messaging about labor costs of SRI and about a personÕs ability to implement SRI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

// Housekeeping//
clear all           
capture log close    
set more off        
set logtype text 
set linesize 200
pause on
set excelxlsxlargefile on

//Setting paths//
if c(os) == "Windows" {

    cd "C:/Users/`c(username)'/Dropbox" 

}

else if c(os) == "MacOSX" {

  cd   "/Users/kathrynvasilaky/Dropbox"
}

local DROPBOX `c(pwd)'

local DROPBOX_ROOT "`DROPBOX'/DigitalGreen"

local RAW_Non_PII "`DROPBOX_ROOT'/Midline plan/Raw Data/Non-PII"

local RAW_PII "`DROPBOX_ROOT'/Midline plan/Raw Data/PII"

local WORK "`DROPBOX_ROOT'/Midline plan/Analysis/"

local OUTPUT "`DROPBOX_ROOT'/Midline plan/Analysis/Output"

local DO "`DROPBOX_ROOT'/Midline plan/Analysis/Do files"

*********************************
*      ANALYSING DATA SETS       *
*********************************


//To merge all data sets//
use "`WORK'/Midline_Cleaning_Non_PII_All Sections.dta"
cd "/Users/`c(username)'/Documents/OneDrive/Kentaro/Paper/output"

//To ensure that there is one data row for each HHID//
sort HHID
by HHID: gen dup_HHID = cond(_N==1,0,_n)
drop if dup_HHID>1

//To create a dummy variable for self-reported SRI adoption//
gen sri_adoption = s7_0_method_plant
replace sri_adoption = "0" 
replace sri_adoption = "1" if s7_0_method_plant == "1" | s7_0_method_plant == "3"
drop if s7_0_method_plant == "-222" | s7_0_method_plant == "-555"
destring sri_adoption, replace

//To create a dummy variable for treatment//
gen ITT = dgorcontrol
replace ITT = "0"
replace ITT = "1" if dgorcontrol != "Control"
destring ITT, replace

//To regress self-reported adoption on treatment and cluster standard errors at village level//
regress sri_adoption ITT, robust cluster (vill_id)
probit sri_adoption ITT, robust cluster (vill_id)
mfx
*outreg2 using tables,  pvalue tex replace ctitle(ITT) title(Adoption) label

//To create a dummy variable for self-reported treatment//
gen self_reported_treatment = s13_9_vrp_movie
replace self_reported_treatment = "0" if self_reported_treatment == "2"
preserve
drop if self_reported_treatment != "1" & self_reported_treatment != "0"
destring self_reported_treatment, replace

//To regress self-reported adoption on self-reported treatment and cluster standard errors at village level//
regress sri_adoption self_reported_treatment, robust cluster (vill_id)
regress sri_adoption self_reported_treatment, robust cluster (vill_id)
mfx
ivprobit sri_adoption self_reported_treatment (self_reported_treatment = ITT), robust cluster(vill_id)

*outreg2 using tables,  pvalue tex append ctitle(Self Reported Treatment) title(Adoption) label

restore

//To create a dummy variable for DG-reported treatment//
gen dg_reported_treatment = Dissemination
replace dg_reported_treatment = "0" 
replace dg_reported_treatment = "1" if Dissemination == "Yes" 
destring dg_reported_treatment, replace

//To regress self-reported adoption on DG-reported treatment and cluster standard errors at village level//
regress sri_adoption dg_reported_treatment, robust cluster(vill_id)
probit sri_adoption dg_reported_treatment, robust cluster(vill_id)
mfx
ivprobit sri_adoption dg_reported_treatment (dg_reported_treatment = ITT), robust cluster (vill_id)

*outreg2 using tables,  pvalue tex append ctitle(DG Reported Treatment) title(Adoption) label

 
//To regress self-reported adoption on sub treatment labor costs//
encode nestedtreatmentgroup , gen (nested_treatments)
regress sri_adoption i.nested_treatments , robust cluster(vill_id)
probit sri_adoption i.nested_treatments , robust cluster(vill_id)
mfx
*outreg2 using tables,  pvalue tex append ctitle(Nested ITT) title(Adoption ) label


save "`WORK'/Midline_Summary Statistics_World Development Report.dta", replace


****************
*Unbalanced data
****************
*Notice that if we control for s5_3_hard_sri in our regressions, that hte effect of DG disspears

probit sri_adoption ITT s5_3_hard_sri, robust cluster (vill_id)





