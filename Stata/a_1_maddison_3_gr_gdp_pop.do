* File name: a_1_maddison_3_gr_gdp_pop.do
* Description: calculate per capital gdp growth rate using two ways
* Author: Shijie Shi
* Last updated: 07/31/2018

set more off
clear all
* ssc install carryforward

quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local START 1860

	cd "`projFolder'"
	
	* Read in Maddison data
	use "original/mpd2018.dta", replace
	rename countrycode ccode
	drop cgdppc i*

	gen mark=1 if year == `START' & rgdpnapc != .
	replace mark=1 if year == `START' + 1 & rgdpnapc != .
	bysort ccode: egen mark1 = total(mark)

	keep if mark1==2
	drop mark*
			
	egen group = group(ccode)

	drop if year < `START'

	n tsset group year
	tsfill, full
	n tsset group year
			
	bysort group: carryforward ccode, replace
	bysort group: carryforward country, replace
	gen gdp = rgdpnapc * pop
	
	gen count = 1 if rgdpnapc!=. & pop!=.
	collapse (sum) gdp (sum) pop (sum) count, by(year)	

	* Method 1
	preserve
		gen pc_1 = gdp/pop
		gen pc_gr_1 = ( pc_1 / pc_1[_n-1] - 1 ) * 100
		
		keep year pc_gr_1
		tempfile tmp
		save `tmp', replace
	restore

	* Method 2
	sort year
	gen gdp_gr = ( gdp / gdp[_n-1] - 1 ) * 100
	gen pop_gr = ( pop / pop[_n-1] - 1 ) * 100
	gen pc_gr_2 = gdp_gr - pop_gr
	
	merge 1:1 year using `tmp', assert(3)
	drop _merge
	
	order year gdp* pop* count *_1

	export excel "`outputFolder'/a_1_maddison_3_gr_gdp_pop_`START'.xlsx", ///
				firstrow(variables) replace
				
}
