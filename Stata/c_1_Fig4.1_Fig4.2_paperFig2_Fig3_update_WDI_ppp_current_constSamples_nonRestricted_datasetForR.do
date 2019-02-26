* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update_WDI_ppp_current_constSamples_nonRestricted_datasetForR
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 08/30/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output"
	
	cd "`projFolder'"

	* 1 Read in data from WEO
	use "output/WDI_gdp_pop_ppp_current.dta",replace
		
	merge m:1 ccode using "R:/Shi/Stata/data/AEs_aggs.dta"
	drop if _merge==2
	drop _merge
	
	merge m:1 ccode using "R:/Shi/Stata/data/EMDEs_aggs.dta"
	drop if _merge==2
	drop _merge

	* Manually adjust AE and EMDE category
	drop if country == "European Union"
	
	replace ae=1 if ccode == "MAC" | ccode == "PRI" | country == "Andorra" | ///
					country == "Bermuda" | country == "Channel Islands" | ///
					country == "Gibraltar" | country == "Greenland" | ///
					country == "Guam" | country == "Isle of Man" | ///
					country == "Liechtenstein" | country == "Monaco"
	
	replace emde = 1 if ae==. & emde==.

	rename (ae emde) (adv emd)
	gen wld=1
	sort ccode year
	
	tempfile data
	save `data', replace

	*** Prepare datasets to calculate PPP weights
	n replace ngdpr=. if lp == . | pppgdp == .
	n replace lp=. if ngdpr == . | pppgdp == .
	n replace pppgdp=. if ngdpr == . | lp == .
	
	foreach var in "ngdpr" "lp" "pppgdp"{
		preserve
			keep ccode year `var'
			sort year ccode
			reshape wide `var', i(ccode) j(year)
			export delimited using "output/c_1_fig3_WDI_ppp_current_pppweight_`var'_nonRestricted.csv", replace
		restore
	}
}	
