* File name: 1_compare_gdp_5_population_mm.do
* Description: generate annualized weighted average GDP growth rate and
*			   population growth rate for World and Advanced Economies
* Author: Shijie Shi
* Last updated: 07/25/2018

set more off
clear all

quietly{
	local date "201805"
	local projFolder "R:/Shi/Business Financial Data"
	local dataFolder "R:/Shi/Business Financial Data/output/201805/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/`date'"
	
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
	
	* 3. merge in pppwgt date (the weight for gdpsa)
	merge m:1 ccode year using "`projFolder'/original/GDP/FromMiyoko&Nao/data_update_2018apr_sample.dta", ///
									keepusing(pppwgt)
	drop if _merge==2
	drop _merge
	
	* 4. merge in population data
	merge m:1 ccode year using `mm', keepusing(pop_mm)
	drop if _merge==2
	drop _merge
	
	* 5. mark AEs
	merge m:1 ccode using "R:/Shi/Stata/data/AEs.dta", keepusing(ae)
	drop if _merge==2
	drop _merge
	sort ccode date
	
	*********** Drop Outliers*************
	replace gdpsa=. if ccode=="CMR" & date == yq(2018, 1)
	replace gdpsa=. if ccode=="IRN" & date >= yq(2013, 1)
	replace gdpsa=. if ccode=="MOZ" & date == yq(2018, 1)
	**************************************
	
	*gen mark = 1 if gdpsa != . & pppwgt != . & pop_mm !=.
	*drop if mark != 1

	
	* 6. GDP: Generate yoy growth rate
	by ccode: gen gdp_yoy = (gdpsa[_n] - gdpsa[_n-4] ) / gdpsa[_n-4] * 100
	
	* 7. Population: Generate yoy growth rate
	by ccode: gen pop_yoy = (pop_mm[_n] - pop_mm[_n-4] ) / pop_mm[_n-4] * 100

	* 8. Number of countries
	**gen mark = 1 if gdp_yoy != . & pppwgt != . & pop_yoy !=.
	gen mark = 1 if gdpsa != . & pppwgt != . & pop_mm !=.
	drop if mark != 1

	* 9. Weighted average
	*		World
	
	preserve
		egen gdp_yoy_wld = wtmean(gdp_yoy), weight(pppwgt) by(date)
		egen pop_yoy_wld = wtmean(pop_yoy), weight(pop_mm) by(date)
		*collapse (mean) gdp_yoy [aw=pppwgt], by(date) // to verify
		*collapse (mean) pop_yoy [aw=pop_mm], by(date) // to verify
		keep country date mark *_wld
		bysort date: egen count_wld = total(mark)	
		keep date *_wld
		duplicates drop
		sort date
		tempfile tmp
		save `tmp', replace
	restore
	
	keep if ae==1
	egen gdp_yoy_ae = wtmean(gdp_yoy), weight(pppwgt) by(date)
	egen pop_yoy_ae = wtmean(pop_yoy), weight(pop_mm) by(date)
	*collapse (mean) gdp_yoy [aw=pppwgt], by(date) // to verify
	*collapse (mean) pop_yoy [aw=population], by(date) // to verify
		
	keep country date mark* *_ae
	bysort date: egen count_ae= total(mark)
	keep date *_ae
	duplicates drop
	sort date
	
	merge 1:1 date using `tmp', assert(3)
	drop _merge

	gen outlier = 1 if (gdp_yoy_wld > 100 & gdp_yoy_wld !=. ) | ///
					   (pop_yoy_wld > 100 & pop_yoy_wld !=. ) | ///
					   (gdp_yoy_ae > 100 & gdp_yoy_ae !=. ) | ///
					   (pop_yoy_ae > 100 & pop_yoy_ae !=.)
	*tsline gdp* pop*
	tsline pop*
	*tsline count*

	*export excel using "`outputFolder'/`date'_1_compare_gdp_5_population_mm.xlsx", firstrow(variables) replace
}
