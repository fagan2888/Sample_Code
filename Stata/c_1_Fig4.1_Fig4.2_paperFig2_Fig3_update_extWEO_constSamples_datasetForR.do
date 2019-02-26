* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update_extWEO_constSamples_datasetForR.do
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 08/28/2018

clear all
set more off

local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

cd "`projFolder'"


/*---------------------------------------------------------------------------*/


quietly{

	use "original\data_update_2018apr_sample.dta", clear
	
	keep ccode - year pppwgt ngdpr ngdpd population

	rename pppwgt pppgdp
	rename population lp

	rename country cname	
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
			export delimited using "output/c_1_fig3_extWEO_mktweight_`var'.csv", replace
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
			export delimited using "output/c_1_fig3_extWEO_pppweight_`var'.csv", replace
		restore
	}
}

