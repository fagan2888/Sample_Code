* File name: 1_compare_gdp_1.do
* Description: compare the lengthes of gdp data collected from Haver and OECD
* Author: Shijie Shi
* Last updated: 07/20/2018

set more off
clear all

quietly{
	local date "201805"
	local projFolder "R:/Shi/Business Financial Data"
	local dataFolder "R:/Shi/Business Financial Data/output/`date'"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/`date'"

	cd "`dataFolder'"

	use `date'_GDP_HA_GDP_Q.dta
	merge 1:1 ccode date using `date'_GDP_OECD_GDP_CONS_INV_Q.dta, keepusing(gdp_oec)
	drop _merge

	foreach var of varlist SNGPC - gdp_oec {
		
		sort ccode date
		by ccode: egen seq = seq() if `var' != .
		by ccode: egen `var'seqMin = min(seq)
		by ccode: egen `var'seqMax = max(seq)
		
		* start date
		gen startY = year if seq == `var'seqMin & seq != . 
		gen startQ = quarter if seq == `var'seqMin & seq != . 
		by ccode: egen `var'y1 = mean(startY)
		by ccode: egen `var'q1 = mean(startQ)
		tostring `var'y1 `var'q1, replace
		gen str `var't1 = `var'y1 + "q" + `var'q1 if `var'y1 != "."
		
		* end date
		gen endY = year if seq == `var'seqMax & seq != . 
		gen endQ = quarter if seq == `var'seqMax  & seq != . 
		by ccode: egen `var'yn = mean(endY)
		by ccode: egen `var'qn = mean(endQ)
		tostring `var'yn `var'qn, replace
		gen str `var'tn = `var'yn + "q" + `var'qn if `var'yn != "."
		
		gen str `var'_T = `var't1 + " - " + `var'tn if `var't1 != ""
	
		drop seq start* end* `var'*Min `var'*1 `var'*n
	}
	
	keep ccode country *_T *Max
	rename *seqMax *_N
	duplicates drop

	gen OECD = 1 if gdp_oec_T != ""
	
	order ccode country OECD gdp*
	
	export excel "`outputFolder'/`date'_1_compare_gdp_1.xlsx", firstrow(variables) replace
	n di "Finished: Data are saved in `outputFolder'/`date'_1_compare_gdp_1.xlsx"
}
