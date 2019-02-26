* File name: 1_compare_gdp_3.do
* Description: check the newly created gdp file(201805_gdp_sa_noted.dta) with the old files made by Miyoko and Nao.
* Author: Shijie Shi
* Last updated: 07/24/2018

set more off
clear all

quietly{
	local date "201805"
	local projFolder "R:/Shi/Business Financial Data"
	local dataFolder "R:/Shi/Business Financial Data/output/201805/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/`date'"

	import excel using "`outputFolder'/`date'_1_compare_gdp_2.xlsx", firstrow
	tempfile tmp1
	save `tmp1', replace

	cd "`dataFolder'"	
	use `date'_gdp_sa_noted.dta, replace
	
		local var gdpsa
	
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
		
		keep ccode country *_T *Max gdpsa_note
		rename *seqMax *_N
		duplicates drop
		drop if gdpsa_note==""
		
	sort ccode
	by ccode: egen seq = seq()

	preserve
		keep if seq==1
		drop seq
		tempfile tmp2
		save `tmp2', replace
	restore
		keep if seq==2
		keep ccode gdpsa_note
		rename gdpsa_note gdpsa_note_2
		tempfile tmp3
		
		merge 1:1 ccode using `tmp2', assert(2 3)
		drop _merge
		
		merge 1:1 ccode using `tmp1', assert(3)
		drop _merge
		
		sort length ccode
		order ccode country avai gdpsa_N gdpsa_T gdpsa_note gdpsa_note_2
		
		export excel using "`outputFolder'/`date'_1_compare_gdp_3.xlsx", firstrow(variables) replace
		
		
	
}
