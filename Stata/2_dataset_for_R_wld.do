* File name: 2_dataset_for_R.do
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 07/26/2018
	
quietly{
	local date "201805"
	local projFolder "R:/Shi/Project_Business Financial Data"
	local dataFolder "R:/Shi/Project_Business Financial Data/output/201805/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/`date'"
	local CUTOFF = yq(2018, 1)
	
	cd "`dataFolder'"
	
	* 1. readin MM_population data
	use "`projFolder'/original/GDP/FromMiyoko&Nao/MM_population/annual.dta", clear
	do "R:/Shi/Stata/do/yearly_mm.do" sppoptotl
	
	rename var pop_mm
	merge m:1 ccode using "R:/Shi/Stata/data/countrycodes.dta", keepusing(country ifscode)
	keep if _merge==3
	drop _merge
	
	sort ccode year
	drop if year < 1960 | year > 2018
	
	tempfile mm
	save `mm', replace

	* 2. readin gdpsa data
	use `date'_gdp_sa_noted.dta, replace
	keep ccode-quarter gdpsa
	
	* 3. merge in pppwgt date (the weight to calculate gdp growth rate)
	merge m:1 ccode year using "`projFolder'/original/GDP/FromMiyoko&Nao/data_update_2018apr_sample.dta", ///
									keepusing(pppwgt)
	dddddddd
	drop if _merge==2
	drop _merge
	
	* 4. merge in population data
	merge m:1 ccode year using `mm', keepusing(pop_mm)
	drop if _merge==2
	drop _merge

	ddddddd
/*	
	* 5. mark AEs
	merge m:1 ccode using "R:/Shi/Stata/data/AEs.dta", keepusing(ae)
	drop if _merge==2
	drop _merge
	sort ccode date
*/	
	*********** Drop Outliers*************
	replace gdpsa=. if ccode=="CMR" & date == yq(2018, 1)
	replace gdpsa=. if ccode=="IRN" & date >= yq(2013, 1)
	replace gdpsa=. if ccode=="MOZ" & date == yq(2018, 1)
	**************************************
	
	* 6. Sample constraints
	gen mark = 1 if gdpsa != . & pppwgt != . & pop_mm !=.
	drop if mark != 1
	

	* 7. R datasets: pop.csv, gdp.csv, pppwgt.csv
	drop if date < yq(1960, 1) | date > `CUTOFF'
	preserve
		keep country date pop_mm
		sort date country
		generate dateStr = string(date, "%tqCCYY!Qq")
		drop date
		reshape wide pop_mm, i(country) j(dateStr) string
		export delimited using "`outputFolder'/pop.csv", replace
		n di "Dataset saved: pop.csv"
	restore
	
	preserve
		keep country date gdpsa
		sort date country
		generate dateStr = string(date, "%tqCCYY!Qq")
		drop date
		reshape wide gdpsa, i(country) j(dateStr) string
		export delimited using "`outputFolder'/gdp.csv", replace
		n di "Dataset saved: gdp.csv"
	restore
	
		keep country date pppwgt
		sort date country
		generate dateStr = string(date, "%tqCCYY!Qq")
		drop date
		reshape wide pppwgt, i(country) j(dateStr) string
		export delimited using "`outputFolder'/pppwgt.csv", replace
		n di "Dataset saved: pppwgt.csv"

}