* File name: c_1_Fig2.1A_paperFig1A_update_decpg.do
* Description: use mm data to update figure 2.1.A
* Author: Shijie Shi
* Last updated: 08/06/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	
	* 1. Read in MM_PPP
	use "original/MM_PPP.dta", replace
	do "R:/Shi/Stata/do/yearly_mm.do" nygdpmktpkp
	rename var ppp_mm
	
	n merge m:1 ccode using "R:/Shi/Stata/data/countrycodes.dta", keepusing(country)

	keep if _merge==3
	drop _merge

	* 2. Mark AEs and EMDEs
	merge m:1 ccode using "R:/Shi/Stata/data/AEs.dta", keepusing(ae)
	drop if _merge==2
	drop _merge
	
	merge m:1 ccode using "R:/Shi/Stata/data/EMDEs.dta", keepusing(emde)
	drop if _merge==2
	drop _merge

	drop if ae==. & emde==.
	
	* 3. Aggregate GDP for AEs and EMDEs
	sort ccode year
	
	*collapse (sum) ppp_mm, by(year ae)
	bysort year: egen ae_ppp0 = total(ppp_mm) if ae==1
	bysort year: egen ae_ppp = mean(ae_ppp0)
	bysort year: egen emde_ppp0 = total(ppp_mm) if emde==1
	bysort year: egen emde_ppp = mean(emde_ppp0)
	
	keep year ae_ppp emde_ppp
	duplicates drop
	
	gen str group = "1960s" if year >= 1960 & year <=1969
	replace group = "1970s" if year >= 1970 & year <=1979
	replace group = "1980s" if year >= 1980 & year <=1989
	replace group = "1990s" if year >= 1990 & year <=1999
	replace group = "2000s" if year >= 2000 & year <=2009
	replace group = "2010s" if year >= 2010 & year <=2018
	drop if group==""
	
	collapse (mean) ae_ppp (mean) emde_ppp, by(group)
	
	gen share_ae = ae_ppp / (ae_ppp + emde_ppp) * 100
	gen share_emde = emde_ppp / (ae_ppp + emde_ppp) * 100 

	keep group share*

	export excel using "`outputFolder'/c_1_Fig2.1A_paperFig1A_update_decpg.xlsx", firstrow(variables) replace	
}
