* File name: 1_compare_gdp_6_population_weo_wdi.do
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
	
	* 1. Read in WDI_population.csv
	*	1.1 Population growth rate: World
		import delimited using "`projFolder'/original/GDP/FromMiyoko&Nao/WDI_population/WDI_POP.csv", varname(noname) clear
		do "R:/Shi/Stata/do/readin_WDI.do" WLD
		rename sppopgrow pop_yoy_wld_wdi
		rename sppoptotl pop_wld_wdi
		tempfile wld_wdi
		save `wld_wdi', replace
		
	*	1.2 Population growth rate: Advanced economies
		import delimited using "`projFolder'/original/GDP/FromMiyoko&Nao/WDI_population/WDI_POP.csv", varname(noname) clear
		do "R:/Shi/Stata/do/readin_WDI.do" country
		rename sppopgrow pop_gr
		rename sppoptotl pop
		
		merge m:1 ccode using "R:/Shi/Stata/data/AEs.dta"
		drop if _merge==2 
		drop _merge
		sort ccode year
		
		keep if ae==1
		collapse (mean) pop_gr [aw=pop], by(year)
		rename pop_gr pop_yoy_ae_wdi
		tempfile ae_wdi
		save `ae_wdi', replace

	* 2. Read in WEO_population.csv	
	*	2.1 Population growth rate: World
		import delimited using "`projFolder'/original/GDP/FromMiyoko&Nao/WEO_population/WEO_POP.csv", varname(noname) clear
		do "R:/Shi/Stata/do/readin_WDI.do" WLD
		sort year
		gen pop_yoy_wld_weo = (lp[_n] - lp[_n-1] ) / lp[_n-1] * 100
		tempfile wld_weo
		save `wld_weo', replace

	*	2.2 Population growth rate: Advanced economies	
		import delimited using "`projFolder'/original/GDP/FromMiyoko&Nao/WEO_population/WEO_POP.csv", varname(noname) clear
		do "R:/Shi/Stata/do/readin_WDI.do" AE
		sort year
		gen pop_yoy_ae_weo = (lp[_n] - lp[_n-1] ) / lp[_n-1] * 100
		tempfile ae_weo
		save `ae_weo', replace

	* 3. Read in the population growth data calculated with constraining the samples with gdpsa and pppwt 
	import excel using "`outputFolder'/`date'_1_compare_gdp_5_population.xlsx", firstrow clear

	gen year= year(date)
	gen month= month(date)
	keep if month==1
	drop date month outlier
	order year

	n merge 1:1 year using `wld_wdi', keepusing(pop_yoy_wld_wdi)
		n tab year if _merge==2
		drop if _merge==2
		drop _merge
	
	n merge 1:1 year using `ae_wdi', keepusing(pop_yoy_ae_wdi)
		n tab year if _merge==2
		drop if _merge==2
		drop _merge
	
	n merge 1:1 year using `wld_weo', keepusing(pop_yoy_wld_weo)
		n tab year if _merge==2
		drop if _merge==2
		drop _merge
	
	n merge 1:1 year using `ae_weo', keepusing(pop_yoy_ae_weo)
		n tab year if _merge==2
		drop if _merge==2
		drop _merge
			
	drop gdp*
	
	label var pop_yoy_wld_wdi "pop_yoy_wld_wdi"
	label var pop_yoy_ae_wdi "pop_yoy_ae_wdi"
	label var pop_yoy_wld_weo "pop_yoy_wld_weo"
	label var pop_yoy_ae_weo "pop_yoy_ae_weo"

	sort year
	tsset year
	
	tsline pop_yoy_ae*
	tsline pop_yoy_wld* 
	tsline count*
	
	export excel using "`outputFolder'/`date'_1_compare_gdp_6_population_weo_wdi.xlsx", firstrow(variables) replace
}
