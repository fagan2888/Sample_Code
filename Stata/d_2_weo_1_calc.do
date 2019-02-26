* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update.do
* Description: use WEO new data to update figure 4.2
* Author: Shijie Shi
* Last updated: 08/10/2018

clear all
set more off

local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

local START = 1980
local END = 2020

cd "`projFolder'"


/*---------------------------------------------------------------------------*/


quietly{

	use "output\WEOApr2018all.dta", clear	
	
	keep ccode - year pppgdp ngdpr ngdpd lp

	rename pppgdp pppwgt
	rename lp population

	rename country cname	
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

	
	xtset
	local pvar = r(panelvar)
	local tvar = r(timevar)

	sort `pvar' `tvar'

	local v "ngdpr"
	local lbl_`v' "Output growth"

******************
*(2)
replace population=. if ccode == "NGA" | ccode == "YEM" ///
					  | ccode == "RUS"  | ccode == "UKR"  | ccode == "UZB"

*(3)
*replace population=. if ccode == "RUS"  | ccode == "UKR"  | ccode == "UZB" 

*******************	
	* Generate population growth rate: wld & by country. 
	gen double pop`v' = population if `v'!=.
	egen double totpop`v' = total(pop`v'), by(`tvar') missing
	sort `pvar' `tvar'
	gen double pop_gr`v' = ((totpop`v' / l1.totpop`v') - 1) * 100 if totpop`v'!=0 & l1.totpop`v'!=0
	gen double pop2_gr`v' = ((pop`v' / l1.pop`v') - 1) * 100
	label var pop_gr`v' "Population growth (%): samples restricted to `lbl_`v'' availability"
	
	* Generate real GDP growth rate: by country. 
	gen double `v'_gr = ((`v' / l1.`v') - 1) * 100 if `v'!=0
		
	* PPP weights *
	egen double pppwgtsumprod`v' = wtmean(`v'_gr), weight(pppwgt) by (`tvar')
	label var pppwgtsumprod`v' "`lbl_`v'', PPP-weighted"

	* Market weights *
	egen double totngdpd = total(ngdpd), by(`tvar') missing
	gen double wtotngdpd = ngdpd / totngdpd
	sort `pvar' `tvar'
	gen double ngdpd_tot = wtotngdpd + l1.wtotngdpd + l2.wtotngdpd	
	gen double ngdpd_avg = ngdpd_tot / 3
			
	egen double mrkwgtsumprod`v' = wtmean(`v'_gr), weight(ngdpd_avg) by (`tvar')
	label var mrkwgtsumprod`v' "`lbl_`v'', market-weighted"
	
	* Per capita variables
		* Market weights
	gen double pcmrkwgt`v' = mrkwgtsumprod`v' - pop_gr`v' if mrkwgtsumprod`v'!=0 & mrkwgtsumprod`v'!=. & pop_gr`v'!=.
	label var pcmrkwgt`v' "`lbl_`v'', per capita (minus weighted pop growth), market-weighted"
	
		* PPP weights
	gen double pcpppwgt`v' = pppwgtsumprod`v' - pop_gr`v' if pppwgtsumprod`v'!=0 & pppwgtsumprod`v'!=. & pop_gr`v'!=.
	label var pcpppwgt`v' "`lbl_`v'', per capita (minus weighted pop growth), PPP-weighted"

************************
/*
	keep if year>=1988 & year <= 1993
	by `pvar': egen seq = seq() if pop`v'!=.
	by `pvar': egen maxseq0 = max(seq)
	by `pvar': egen maxseq = mean(maxseq0)

	br ccode cname year ngdpr ngdpd pppwgt pop`v' totpop`v' pop_gr`v' if maxseq <6
	n tab cname if maxseq <6

ddddddd
*/
******************	

	keep year mrkwgtsumprodngdpr pppwgtsumprodngdpr pcmrkwgtngdpr pcpppwgtngdpr
	duplicates drop
	
	tsset year, yearly

	local var1 "pppwgtsumprodngdpr pcpppwgtngdpr"
	foreach var of local var1 {
		gen `var'_i = 100 if year==`START'+1
		replace `var'_i = (1 + `var'/100 ) * l1.`var'_i if `var'_i==.
			
		local lbl_`var': var label `var'
		label var `var'_i "[Index]`lbl_`var''"
	}
		
	local var2 "mrkwgtsumprodngdpr pcmrkwgtngdpr"
	foreach var of local var2 {
		gen `var'_i = 100 if year==`START'+1
		replace `var'_i = (1 + `var'/100 ) * l1.`var'_i if `var'_i==.
			
		local lbl_`var': var label `var'
		label var `var'_i "[Index]`lbl_`var''"
	}
		

	order year mrkwgtsumprodngdpr mrkwgtsumprodngdpr_i ///
				  pppwgtsumprodngdpr pppwgtsumprodngdpr_i ///
				  pcmrkwgtngdpr pcmrkwgtngdpr_i ///
				  pcpppwgtngdpr pcpppwgtngdpr_i
				  
	export excel using "`outputFolder'/d_2_Fig4.2_paperFig3_WEOnew2.xlsx", firstrow(varlabels) replace	

}

