*Purpose: Merging midline and endline data

*Author: 
*Date Created: Tushi September ?, 2015
*Last edited: Katya Septer 24th, 2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

// Housekeeping//
clear all           
capture log close    
set more off        
set logtype text 
set linesize 200
pause on
set excelxlsxlargefile on


*********************************
*      ANALYSING DATA SETS       *
*********************************
global link1= "~\Dropbox\DigitalGreen\Midline plan\Analysis\Working Data"
global link2= "~\Dropbox\DigitalGreen\Endline\Analysis\Output Data"

tempfile mid
insheet using "$link1/Midline_Cleaning_Non_PII_All Sections.csv", names clear
*use "$link1/Midline_Cleaning_Non_PII_All Sections.dta", replace
*HHID
save `mid'

insheet using "$link2/Endline_Cleaning_Non_PII_All Sections.csv", names clear
*use "$link2/Endline_Cleaning_Non_PII_All Sections.dta", replace
*HHID

merge m:m hhid using `mid'
*merge m:m record_id using "$link2/Endline_Cleaning_Non_PII_All Sections.dta", generate (_merge_all_1)


save "$link2/endline_midline merged data.dta", replace	
outsheet using "$link2/endline_midline merged data.csv", comma

