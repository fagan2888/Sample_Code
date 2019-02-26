* File name: 1_compare_gdp_7_pcg.do
* Description: generate annualized weighted average GDP growth rate for World and Advanced Economies
* Author: Shijie Shi
* Last updated: 07/24/2018

set more off
clear all

quietly{
	local date "201805"
	local projFolder "R:/Shi/Business Financial Data"
	local dataFolder "R:/Shi/Business Financial Data/output/201805/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/`date'"
	
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
	cd "`dataFolder'"
	use `date'_gdp_sa_noted.dta, replace

	keep ccode-quarter gdpsa
	n merge m:1 ccode year using "`projFolder'/original/GDP/FromMiyoko&Nao/data_update_2018apr_sample.dta", ///
									keepusing(pppwgt)
	drop if _merge==2
	drop _merge

	merge m:1 ccode year using `mm', keepusing(pop_mm)
	drop if _merge==2
	drop _merge
	
	n merge m:1 ccode using "R:/Shi/Stata/data/AEs.dta"
	drop if _merge==2
	drop _merge
	sort ccode date
	
	
	*********** Drop Outliers*************
	replace gdpsa=. if ccode=="CMR" & date == yq(2018, 1)
	replace gdpsa=. if ccode=="IRN" & date >= yq(2013, 1)
	replace gdpsa=. if ccode=="MOZ" & date == yq(2018, 1)

	**************************************
	
	* 1. GDP: Generate yoy growth rate
	by ccode: gen gdp_yoy = (gdpsa[_n] - gdpsa[_n-4] ) / gdpsa[_n-4] * 100
	
	* 2. Population: Generate yoy growth rate
	by ccode: gen pop_yoy = (pop_mm[_n] - pop_mm[_n-4] ) / pop_mm[_n-4] * 100
	
	* 3. Number of countries
	gen mark = 1 if gdp_yoy != . & pppwgt != . & pop_yoy !=.
	drop if mark != 1
	
	* 4. Weighted average
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
	*collapse (mean) pop_yoy [aw=pop_mm], by(date) // to verify
		
	keep country date mark* *_ae
	bysort date: egen count_ae= total(mark)
	keep date *_ae
	duplicates drop
	sort date
	
	merge 1:1 date using `tmp', assert(3)
	drop _merge

	* Per capita growth
	gen pcg_ae = gdp_yoy_ae - pop_yoy_ae
	gen pcg_wld = gdp_yoy_wld - pop_yoy_wld
	
	gen pcg_ae_neg = 1 if pcg_ae < 0
	gen pcg_wld_neg = 1 if pcg_wld < 0
	
	tsline pcg_ae pcg_wld
	*tsline count*
	
	export excel using "`outputFolder'/`date'_1_compare_gdp_7_pcg_mm.xlsx", firstrow(variables) replace
}
