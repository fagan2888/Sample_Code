* File name: b_1_ip_1_readin.do.do
* Description: Read in monthly ip data
* Author: Shijie Shi
* Last updated: 08/01/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	
	* 1. Read in IPm.csv
	import delimited "original/IPm.csv"
	rename country ccode
	
	preserve
		keep if variable=="IPTOTSA"
		rename value ip
		drop variable
		tempfile tmp
		save `tmp', replace
	restore
	
	keep if variable=="IPTOTSAKD"
	rename value ipkd
	drop variable
	
	merge 1:1 ccode date using `tmp', update
	drop _merge

	gen year = substr( date, 1, 4) 
	gen month = substr( date, -2, .)
	destring year month, replace
	
	drop date
	gen date = ym(year, month)
	format date %tm
	
	merge m:1 ccode using "R:/Shi/Stata/data/countrycodes.dta", keepusing(country)
	n tab ccode if _merge==1
	keep if _merge==3
	drop _merge
	
	sort ccode date
	order ccode country date year month ip ipkd
	
	egen group=group(ccode)
	tsset group date
	tsfill, full
	n tsset group date
	
	bysort group: carryforward ccode, replace
	bysort group: carryforward country, replace
	
	gsort group -date
	bysort group: carryforward ccode, replace
	bysort group: carryforward country, replace
	
	drop group
	
	sort ccode date
	save "`outputFolder'/IPm.dta", replace
	export delimited "`outputFolder'/IPm.csv", replace
}
