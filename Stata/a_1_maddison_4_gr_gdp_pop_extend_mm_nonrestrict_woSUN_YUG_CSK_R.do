* File name: a_1_maddison_4_gr_gdp_pop_extend_mm_nonrestrict_woSUN_YUG_CSK_R.do
* Description: use mm data to extend gdp and population data, 
*			   then calculate per capita gdp growth rate
* Author: Shijie Shi
* Last updated: 07/31/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

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

	egen group = group(ccode)

	n tsset group year
	tsfill, full
	n tsset group year
			
	bysort group: carryforward ccode, replace
	bysort group: carryforward country, replace
	
	gsort group -year
	bysort group: carryforward ccode, replace
	bysort group: carryforward country, replace
	
	gen gdp = rgdpnapc * pop
	drop group
	
	sort ccode year

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
	egen group = group(ccode)
	tsset group year
	
	foreach var in "gdp" "pop" {
		gen double lg_`var'_mm = log(`var'_mm)
		gen double gr_`var'_mm = D.lg_`var'_mm	
	}
	
	drop *lg*
	
	* 	4.1 since 2017	
	foreach var in "gdp" "pop" {
		gen `var'2017 = `var'
		replace `var'2017 = exp(log(L1.`var'2017) + gr_`var'_mm) if ///
							`var'2017==. & gr_`var'_mm !=. & year > 2015 		
	}	
	* 	4.2 since 2016
	replace gdp=. if year==2016

		
	foreach var in "gdp" "pop" {
		gen `var'2016 = `var'
		replace `var'2016=. if year==2016
		replace `var'2016 = exp(log(L1.`var'2016) + gr_`var'_mm) if ///
							`var'2016==. & gr_`var'_mm !=. & year > 2015 		
	}
	
	
	* 5. DROP: SUN, YUG, CSK
	drop if ccode == "SUN" | ccode == "YUG" | ccode == "CSK" 	

	* 6. R datasets
	forval i = 2016/2017 {
		foreach var in "gdp" "pop" {
			preserve
				keep ccode year `var'`i'
				sort year ccode
				reshape wide `var'`i', i(ccode) j(year)
				export delimited using "`outputFolder'/a_1_maddison_4_`var'`i'_woSUN_YUG_CSK.csv", replace
			restore
		}
	}
	
}
