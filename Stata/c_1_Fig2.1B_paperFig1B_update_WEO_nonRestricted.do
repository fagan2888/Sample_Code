* File name: c_1_Fig2.1B_paperFig1B_update_WEO_nonRestricted.do
* Description: use WEO data to update figure 2.1.B
* Author: Shijie Shi
* Last updated: 08/29/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	
	* 1 Read in data from WEO
	use "output/WEOApr2018all.dta",replace
	
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

	* 2. Calculation
	xtset ifscode year
		local pvar = r(panelvar)
		local tvar = r(timevar)

	sort `pvar' `tvar'

	gen double ngdpr_gr = ((ngdpr / l1.ngdpr) - 1) * 100

	local vars "ngdpr"
	foreach v of local vars{
		gen double pppwgt`v' = pppgdp
			replace pppwgt`v' = . if `v'_gr==.
			
		egen double totpppwgt`v' = total(pppwgt`v'), by(`tvar') missing
		gen double wpppwgt`v' = pppwgt`v' / totpppwgt`v'
	}

	foreach x in wld adv{
		gen double `x'ppp = wpppwgtngdpr if `x'==1
		gen double `x'gdp_gr = ngdpr_gr if `x'==1

		gen double `x'prod = `x'ppp * `x'gdp_gr

		egen double `x'pppgdp = total(`x'prod), by(`tvar') missing
	}

	sort `pvar' `tvar'

	keep if `pvar'==111

	xtset, clear

	keep year wldpppgdp advpppgdp
	gen emdpppgdp = wldpppgdp - advpppgdp
	drop wldpppgdp

	gen str group = "1960s" if year >= 1960 & year <=1969
	replace group = "1970s" if year >= 1970 & year <=1979
	replace group = "1980s" if year >= 1980 & year <=1989
	replace group = "1990s" if year >= 1990 & year <=1999
	replace group = "2000s" if year >= 2000 & year <=2009
	replace group = "2010s" if year >= 2010 & year <=2018
	drop if group==""
	
	collapse (mean) advpppgdp (mean) emdpppgdp, by(group)

	gen share_ae = advpppgdp / (advpppgdp + emdpppgdp) * 100
	gen share_emde = emdpppgdp / (advpppgdp + emdpppgdp) * 100 
	
	keep group share*

	export excel using "`outputFolder'/c_1_Fig2.1B_paperFig1B_update_WEO_nonRestricted.xlsx", firstrow(variables) replace	
}