* File name: 1_compare_gdp_4.do
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

	cd "`dataFolder'"
	use `date'_gdp_sa_noted.dta, replace

	keep ccode-quarter gdpsa
	n merge m:1 ccode year using "`projFolder'/original/GDP/FromMiyoko&Nao/data_update_2018apr_sample.dta", keepusing(pppwgt)
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

	* 1. Generate annualized quarterly growth rate
	by ccode: gen grQ= (gdpsa[_n] - gdpsa[_n-1] ) / gdpsa[_n-1] * 100
	by ccode: gen grAQ = ( (1 + grQ /100 )^4 - 1 ) * 100
	
	* 2. Generate yoy growth rate
	by ccode: gen grYOY = (gdpsa[_n] - gdpsa[_n-4] ) / gdpsa[_n-4] * 100

	* 3. Number of countries
	gen markAQ = 1 if grAQ != . & pppwgt != .
	gen markYOY = 1 if grYOY != . & pppwgt != .

	* 4. Weighted average
	*		World
	preserve
		egen grAQ_wld = wtmean(grAQ), weight(pppwgt) by(date)
		egen grYOY_wld = wtmean(grYOY), weight(pppwgt) by(date)
		*collapse (mean) grAQ (mean) grYOY [aw=pppwgt], by(date) // to verify
		
		keep country date mark* *_wld

		bysort date: egen count_AQ_wld = total(markAQ)
		bysort date: egen count_YOY_wld = total(markYOY)
		keep date *_wld
		duplicates drop
		sort date
		order date *AQ* *YOY*
		tempfile tmp
		save `tmp', replace
	restore
	
	keep if ae==1
	egen grAQ_ae = wtmean(grAQ), weight(pppwgt) by(date)
	egen grYOY_ae = wtmean(grYOY), weight(pppwgt) by(date)
	*collapse (mean) grAQ (mean) grYOY [aw=pppwgt], by(date) // to verify
		
	keep country date mark* *_ae
	bysort date: egen count_AQ_ae= total(markAQ)
	bysort date: egen count_YOY_ae = total(markYOY)
	keep date *_ae
	duplicates drop
	sort date
	order date *AQ* *YOY*
	
	
	merge 1:1 date using `tmp', assert(3)
	drop _merge
	
	gen outlier = 1 if (grAQ_ae > 100 & grAQ_ae !=. ) | ///
					   (grYOY_ae > 100 & grYOY_ae !=. ) | ///
					   (grAQ_wld > 100 & grAQ_wld !=. ) | ///
					   (grYOY_wld > 100 & grYOY_wld !=.)
	tsline gr* if outlier != 1
	tsline count*
	
	export excel using "`outputFolder'/`date'_1_compare_gdp_4.xlsx", firstrow(variables) replace
}
