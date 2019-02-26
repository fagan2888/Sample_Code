* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update_PennWorldTable_constSample_nonRestricted
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 09/05/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output"
	
	cd "`projFolder'"
	
	use "original/data_pwt_weo2018apr.dta", clear
	
	rename (rgdp pop) (ngdpr lp)
	sort ccode year
	
	*** Remove negative pppgdp weights
	n replace pppgdp=. if ccode=="BMU" & year >= 1999 & year <= 2003 // Bermuda
	
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
			export delimited using "output/c_1_fig3_mktweight_`var'_PWT.csv", replace
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
			export delimited using "output/c_1_fig3_pppweight_`var'_PWT.csv", replace
		restore
	}

}
