* File name: c_1_Fig2.1A_paperFig1A_update.do
* Description: use Nao's data to update figure 2.1.A
* Author: Shijie Shi
* Last updated: 08/09/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	
	* 1. Read in data from Nao
	use "original/data_update_2018apr_sample.dta", replace
	drop if adv==. & emd==.

	* 2. Aggregate GDP for AEs and EMDEs
	sort ccode year

	bysort year: egen ae_ppp0 = total(pppwgt) if adv==1
	bysort year: egen ae_ppp = mean(ae_ppp0)
	bysort year: egen emde_ppp0 = total(pppwgt) if emd==1
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

	export excel using "`outputFolder'/c_1_Fig2.1A_paperFig1A_update.xlsx", firstrow(variables) replace	
}
