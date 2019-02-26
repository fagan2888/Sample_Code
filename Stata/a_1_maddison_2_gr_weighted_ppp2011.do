* File name: a_1_maddison_2_gr_weighted_ppp2011.do
* Description: by different cutoff years, calculate weighted GDP growth rate using 2011 PPP.
* Author: Shijie Shi
* Last updated: 07/31/2018

set more off
clear all
* ssc install carryforward

quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local CUTOFF 1820 1900 1940 1950

	cd "`projFolder'"

	* Read in WDI PPP data
	import delimited using "original/WDI_PPP_2011.csv", varn(1)
	rename (countrycode yr2011) (ccode ppp2011)
	destring ppp2011, force replace
	drop if ccode==""
	/*
	merge 1:1 ccode using "R:/Shi/Stata/data/countrycodes.dta", keepusing(ifscode country)
	keep if _merge==3
	drop _merge
	*/
	keep ccode ppp2011
	
	tempfile tmp
	save `tmp', replace
	
	* Read in Maddison data
	use "original/mpd2018.dta", replace
	rename countrycode ccode
	drop cgdppc pop i*

	foreach START of numlist `CUTOFF' {
		preserve
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
			
			
			* Merge in processed WDI PPP data
			n merge m:1 ccode using `tmp', keepusing(ppp2011)
			drop if _merge==2
			drop _merge
			
			* Compute growth rates for each country, then weighted growth rates using ppp2011
			sort ccode year
			by ccode: gen gr`START' = ( rgdpnapc / rgdpnapc[_n-1] - 1 ) * 100
			gen count`START'=1 if gr`START' !=. & ppp2011!=.
			
			collapse (sum) count`START' (mean) gr`START' [aw=ppp2011], by(year)
	
			tempfile temp`START'
			save `temp`START'', replace

		restore	
	}
	
	use `temp1820', replace
	local years 1900 1940 1950
	foreach START of numlist `years'  {
		merge 1:1 year using `temp`START'', assert(1 3)
		drop _merge
	}
	export excel "`outputFolder'/a_1_maddison_2_gr_weighted_ppp2011.xlsx", ///
				firstrow(variables) replace
				
}
