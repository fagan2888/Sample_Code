* File name: 1_compare_gdp_5_population_1_sample_diff_mm.do
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
	
	* Read in MM_population data
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
	
	merge m:1 ccode using "R:/Shi/Stata/data/AEs.dta"
	drop if _merge==2
	drop _merge
	sort ccode date
	
	* 1. GDP: Generate yoy growth rate
	by ccode: gen gdp_yoy = (gdpsa[_n] - gdpsa[_n-4] ) / gdpsa[_n-4] * 100
	
	* 2. Population: Generate yoy growth rate
	by ccode: gen pop_yoy = (pop_mm[_n] - pop_mm[_n-4] ) / pop_mm[_n-4] * 100

	* 3. Number of countries
	gen mark = 1 if gdp_yoy != . & pppwgt != . & pop_yoy !=.

	drop if mark != 1
	
	* 4. Weighted average
	*		World
		egen pop_yoy_wld = wtmean(pop_yoy), weight(pop_mm) by(date)
		*collapse (mean) gdp_yoy [aw=pppwgt], by(date) // to verify
		*collapse (mean) pop_yoy [aw=pop_mm], by(date) // to verify
		keep country date mark pop_mm pop_yoy pop_yoy_wld
		bysort date: egen count_wld = total(mark)	

		
		local n = 0 
		forval i = 1980 / 2000 {
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

		
		forval i = 1980 / 2000 {
			forval j = 1 / 4 {
				preserve
					keep if date == yq(`i', `j')

					local count = count_wld[1]
					rename pop_yoy gr_`i'Q`j'_`count'
					rename pop_mm pop_`i'Q`j'_`count'
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
		
		local vars "*1980Q1* *1980Q2* *1980Q3* *1980Q4*"
		forval i = 1981 / 2000 {
			forval j = 1 / 4 {
				local vars = "`vars'" + " *`i'Q`j'*"
			}	
		}

	order country `vars'
				  
	export excel using "`outputFolder'/`date'_1_compare_gdp_5_population_1_sample_diff_mm.xlsx", firstrow(variables) replace
}
