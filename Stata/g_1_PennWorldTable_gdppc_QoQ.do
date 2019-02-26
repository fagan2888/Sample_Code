* File name: g_1_PennWorldTrade_gdppc_QoQ.do
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 09/05/2018
	
quietly{
	
	local date "201902"
	local projFolder "R:/Shi/Project_Business Financial Data"
	local dataFolder "R:/Shi/Project_Business Financial Data/output/`date'/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local CUTOFF = yq(2018, 4)
	
	cd "`dataFolder'"

	* 1. readin gdpsa data
	use `date'_gdp_sa_noted.dta, replace
	keep ccode-quarter gdpsa


	* 2. merge in population, and pppwgt data (the weight to calculate gdp growth rate) from Penn World Tables
	merge m:1 ccode year using "R:/Shi/Project_AK's book update_CollapseAndRevival/original/data_pwt_weo2018oct.dta", ///
									keepusing(pop pppgdp)
	drop if _merge==2
	drop _merge
	
	*** Remove negative pppgdp weights
	n replace pppgdp=. if ccode=="BMU" & year >= 1999 & year <= 2003 // Bermuda
	
	rename pppgdp pppwgt

	/*
	*********** Drop Outliers (for updating 201805 data)*************
	* outliers is detected by find_outliers.do
	replace gdpsa=. if ccode=="CMR" & date == yq(2018, 1) // gdpsa jumped from 3.89e+12 to 2.93e+14
	replace gdpsa=. if ccode=="IRN" & date >= yq(2013, 1) // gdpsa jumped from 1.19e+14 to 3.00e+16
	replace gdpsa=. if ccode=="MOZ" & date == yq(2018, 1) // gdpsa jumped from 1.22e+11 to 1.79e+13
	******************************************************************
	*/
	
	* 3. Sample constraints
	gen mark = 1 if gdpsa != . & pppwgt != . & pop !=.
	drop if mark != 1
	

	* 4. R datasets: pop_PWT.csv, gdp.csv, pppwgt_PWT.csv
	drop if date < yq(1960, 1) | date > `CUTOFF'
	preserve
		keep country date pop
		sort date country
		generate dateStr = string(date, "%tqCCYY!Qq")
		drop date
		reshape wide pop, i(country) j(dateStr) string
		export delimited using "`outputFolder'/pop_PWT.csv", replace
		n di "Dataset saved: pop_PWT.csv"
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
		export delimited using "`outputFolder'/pppwgt_PWT.csv", replace
		n di "Dataset saved: pppwgt_PWT.csv"

}
