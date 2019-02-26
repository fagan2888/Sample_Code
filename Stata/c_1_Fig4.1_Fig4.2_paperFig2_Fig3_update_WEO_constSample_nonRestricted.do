* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update_WEO_constSamples_nonRestricted_datasetForR
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 08/28/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output"
	
	cd "`projFolder'"

	* 1 Read in data from WEO
	use "output/WEOApr2018all.dta",replace
	keep ccode - year pppgdp ngdpr ngdpd lp
	
	
	merge m:1 ccode using "R:/Shi/Stata/data/AEs_aggs.dta"
	drop if _merge==2
	drop _merge
	
	merge m:1 ccode using "R:/Shi/Stata/data/EMDEs_aggs.dta"
	drop if _merge==2
	drop _merge
	
	* Manually adjust AE and EMDE category
	replace ae=1 if ccode == "MAC" | ccode == "PRI"
	
	rename (ae emde) (adv emd)
	gen wld=1
	sort ccode year
	
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
			export delimited using "output/c_1_fig3_mktweight_`var'_nonRestricted.csv", replace
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
			export delimited using "output/c_1_fig3_pppweight_`var'_nonRestricted.csv", replace
		restore
	}
}	
