* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update_WEO_constSamples_datasetForR
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 08/28/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output"
	
	cd "`projFolder'"
	
	use "output/WDI_gdp_pop_extended.dta", clear	
	
	sort ccode year
	tempfile wdi
	save `wdi', replace

	* Restrict the country sample to 163 countries (the same as the original analysis)
	use "original\data_update_2018apr_sample.dta", clear
	keep ccode
	duplicates drop
	tempfile sample
	save `sample', replace

	use `wdi', clear
	merge m:1 ccode using `sample'
	keep if _merge==3
	drop _merge
	
	*** Prepare datasets to calculate PPP weights
	n replace ngdpr=. if lp == . | pppgdp == .
	n replace lp=. if ngdpr == . | pppgdp == .
	n replace pppgdp=. if ngdpr == . | lp == .
	
	foreach var in "ngdpr" "lp" "pppgdp"{
		preserve
			keep ccode year `var'
			sort year ccode
			reshape wide `var', i(ccode) j(year)
			export delimited using "output/c_1_fig3_WDI_pppweight_`var'.csv", replace
		restore
	}
}
