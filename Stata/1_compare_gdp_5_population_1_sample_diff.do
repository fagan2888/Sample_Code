* File name: 1_compare_gdp_5_population_1_sample_diff.do
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
	n merge m:1 ccode year using "`projFolder'/original/GDP/FromMiyoko&Nao/data_update_2018apr_sample.dta", ///
									keepusing(pppwgt population)
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
	by ccode: gen pop_yoy = (population[_n] - population[_n-4] ) / population[_n-4] * 100

	* 3. Number of countries
	gen mark = 1 if gdp_yoy != . & pppwgt != . & pop_yoy !=.

	drop if mark != 1
	
	* 4. Weighted average
	*		World

		egen gdp_yoy_wld = wtmean(gdp_yoy), weight(pppwgt) by(date)
		egen pop_yoy_wld = wtmean(pop_yoy), weight(population) by(date)
		*collapse (mean) gdp_yoy [aw=pppwgt], by(date) // to verify
		*collapse (mean) pop_yoy [aw=population], by(date) // to verify
		keep country date mark population pop_yoy pop_yoy_wld
		bysort date: egen count_wld = total(mark)	
		
		local n = 0 
		forval i = 1989 / 1992 {
			forval j = 1 / 4 {
				preserve
					keep if date == yq(`i', `j')
					local count = count_wld[1]
					keep pop_yoy_wld
					rename pop_yoy_wld gr_`i'Q`j'_`count'
					duplicates drop
					gen country="World"
					order country
					
					local n = `n' + 1
					tempfile tmp`n'
					save `tmp`n'', replace
				restore
			}	
		}		

		
		forval i = 1989 / 1992 {
			forval j = 1 / 4 {
				preserve
					keep if date == yq(`i', `j')

					local count = count_wld[1]
					rename pop_yoy gr_`i'Q`j'_`count'
					rename population pop_`i'Q`j'_`count'
					keep country *_`i'Q`j'_`count'		
					local n = `n' + 1
					tempfile tmp`n'
					save `tmp`n'', replace
				restore
			}	
		}

		use `tmp1', clear
		forval i = 2 / `n' {
			merge 1:1 country using `tmp`i'', update
			drop _merge
		}

		sort country
	order country *1989Q1* *1989Q2* *1989Q3* *1989Q4* *1990Q1* *1990Q2* *1990Q3* *1990Q4* *1991Q1* *1991Q2* *1991Q3* *1991Q4* *1992Q1* *1992Q2* *1992Q3* *1992Q4*
				  

	export excel using "`outputFolder'/`date'_1_compare_gdp_5_population_1_sample_diff.xlsx", firstrow(variables) replace
}
