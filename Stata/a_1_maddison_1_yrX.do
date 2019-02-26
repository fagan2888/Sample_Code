* File name: a_1_maddison_1_yrX.do
* Description: exam the data availability of different cutoff years.
* Author: Shijie Shi
* Last updated: 07/31/2018

set more off
clear all
* ssc install carryforward

quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local START = 1820
	
	cd "`projFolder'"
	
	use "original/mpd2018.dta"
dddddddd
	rename countrycode ccode
	drop cgdppc pop i*

	gen mark=1 if year == `START' & rgdpnapc != .
	replace mark=1 if year == `START' + 1 & rgdpnapc != .
	bysort ccode: egen mark1 = total(mark)

	keep if mark1==2
	egen group = group(ccode)
	preserve
		keep ccode country group
		duplicates drop
		order group ccode country
		
		n tab country 
		n return list
		
		export excel "`outputFolder'/a_1_maddison_1_yr`START'.xlsx", ///
						sheet("`START'_list") firstrow(variables) sheetmodify
	restore
	
	drop if year < `START'

	n tsset group year
	tsfill, full
	n tsset group year
	
	bysort group: carryforward ccode, replace
	bysort group: carryforward country, replace
	
	gen mark2 = 1 if rgdpnapc == .
	keep if mark2==1
	bysort ccode: egen total_missing = total(mark2) 
	
	sort ccode year
	keep ccode country year total_missing
	
	n tab country 
	n return list
	
	export excel "`outputFolder'/a_1_maddison_1_yr`START'.xlsx", ///
				sheet("`START'_missing") firstrow(variables) sheetmodify
}
