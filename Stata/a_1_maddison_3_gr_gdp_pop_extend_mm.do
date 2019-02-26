* File name: a_1_maddison_3_gr_gdp_pop_extend_mm.do
* Description: use mm data to extend gdp and population data, 
*			   then calculate per capita gdp growth rate
* Author: Shijie Shi
* Last updated: 07/31/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local START 1900

	cd "`projFolder'"
	
	* 1. Read in MM_GDP
	use "original/MM_GDP.dta", replace
	do "R:/Shi/Stata/do/yearly_mm.do" nygdpmktpkd

	rename var gdp_mm
	merge m:1 ccode using "R:/Shi/Stata/data/countrycodes.dta", keepusing(country)
	keep if _merge==3
	drop _merge
	
	sort ccode year
	keep if year >= 2015 & year <= 2018
	
	tempfile gdp
	save `gdp', replace
	
	* 2. Read in MM_POP
	use "original/MM_POP.dta", replace
	do "R:/Shi/Stata/do/yearly_mm.do" sppoptotl

	rename var pop_mm
	merge m:1 ccode using "R:/Shi/Stata/data/countrycodes.dta", keepusing(country)
	keep if _merge==3
	drop _merge
	
	sort ccode year
	keep if year >= 2015 & year <= 2018
	
	tempfile pop
	save `pop', replace
	
	* 3. Read in Maddison data
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

	* 4. merge in MM data
	merge 1:1 ccode year using `gdp'
	drop _merge
	
	merge 1:1 ccode year using `pop'
	drop _merge
	
	sort ccode year
	by ccode: egen seq1 = seq() if gdp !=. 
	by ccode: egen seq2 = max(seq1)
	drop if seq2==.
	drop seq*
	
	by ccode: egen seq1 = seq() if pop !=. 
	by ccode: egen seq2 = max(seq1)
	drop if seq2==.
	drop seq*

	* 4. Extrapolate
	drop group
	sort ccode year
	
	* 	4.1 since 2017
		foreach var in "gdp" "pop" {
			gen `var'2017 = .
			gen str `var'2017_source =""	
			n di "Processing `var' and `var'_mm to get `var'2017"
			do "R:/Shi/Stata/do/extending data series2_y.do" ccode year `var' `var'_mm `var'2017
			n tab country if `var'2017_source == "extrapolated by `var'_mm"
			drop `var'2017_source
		}
	
	* 	4.2 since 2016
		replace gdp=. if year==2016
		replace pop=. if year==2016
		
		foreach var in "gdp" "pop" {
			gen `var'2016 = .
			gen str `var'2016_source =""	
			n di "Processing `var' and `var'_mm to get `var'2016"
			do "R:/Shi/Stata/do/extending data series2_y.do" ccode year `var' `var'_mm `var'2016
			n tab country if `var'2016_source == "extrapolated by `var'_mm"
			drop `var'2016_source
		}

	
	* 5	Calculate per capita gdp growth rate
	forval i = 2016/2017 {
		preserve
			gen count`i' = 1 if gdp`i'!=. & pop`i'!=.
			collapse (sum) gdp`i' (sum) pop`i' (sum) count`i', by(year)	
			
			gen pc_`i' = gdp`i' / pop`i'
			gen pc_gr_`i' = ( pc_`i' / pc_`i'[_n-1] - 1 ) * 100
	
			keep year count`i' pc_`i' pc_gr_`i'
			tempfile tmp`i'
			save `tmp`i'', replace
		restore
	}
	
	use `tmp2016', replace
	merge 1:1 year using `tmp2017', assert(3)
	drop _merge
	
	order year count* pc_????
	
	export excel "`outputFolder'/a_1_maddison_3_gr_gdp_pop_extend_mm_`START'.xlsx", ///
				firstrow(variables) replace
				
}
