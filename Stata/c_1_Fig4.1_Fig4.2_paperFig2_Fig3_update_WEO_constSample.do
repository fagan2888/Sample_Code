* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update_WEO_constSamples_datasetForR
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 08/28/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output"
	
	cd "`projFolder'"
	
	use "output/WEOApr2018all.dta", clear	
	
	keep ccode - year pppgdp ngdpr ngdpd lp

	sort ccode year
	tempfile weo
	save `weo', replace

	* Restrict the country sample to 163 countries (the same as the original analysis)
	use "original\data_update_2018apr_sample.dta", clear
	keep ccode
	duplicates drop
	tempfile sample
	save `sample', replace

	use `weo', clear
	merge m:1 ccode using `sample', assert(1 3)
	keep if _merge==3
	drop _merge
	
	tempfile data
	save `data', replace
	
	
	*** Prepare datasets to calculate Market weights
	keep ccode - year ngdpr lp ngdpd  // ngdpd is the weight variable	
	n replace ngdpr=. if lp == . | ngdpd == .
	n replace lp=. if ngdpr == . | ngdpd == .
	n replace ngdpd=. if ngdpr == . | lp == .
	
	foreach var in "ngdpr" "lp" "ngdpd"{
		preserve
			keep ccode year `var'
			sort year ccode
			reshape wide `var', i(ccode) j(year)
			export delimited using "output/c_1_fig3_mktweight_`var'.csv", replace
		restore
	}
	
	*** Prepare datasets to calculate PPP weights
	use `data', replace
	keep ccode - year ngdpr lp pppgdp  // pppgdp is the weight variable
	n replace ngdpr=. if lp == . | pppgdp == .
	n replace lp=. if ngdpr == . | pppgdp == .
	n replace pppgdp=. if ngdpr == . | lp == .
	
	foreach var in "ngdpr" "lp" "pppgdp"{
		preserve
			keep ccode year `var'
			sort year ccode
			reshape wide `var', i(ccode) j(year)
			export delimited using "output/c_1_fig3_pppweight_`var'.csv", replace
		restore
	}
