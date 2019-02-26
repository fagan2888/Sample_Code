* File name: g_1_PennWorldTrade_gdppc_YoY.do
* Description: prepare dataset for processing data in R
* Author: Shijie Shi
* Last updated: 09/05/2018
	
quietly{

	local projFolder "R:/Shi/Project_Business Financial Data"
	local dataFolder "R:/Shi/Project_Business Financial Data/output/201805/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local CUTOFF = yq(2018, 1)
	
	cd "`dataFolder'"

	* 1. readin gdpsa data
	use 201805_gdp_sa_noted.dta, replace
	keep ccode-quarter gdpsa

	
	* 2. merge in population, and pppwgt data (the weight to calculate gdp growth rate)
	merge m:1 ccode year using "R:/Shi/Project_AK's book update_CollapseAndRevival/original/data_pwt_weo2018apr.dta", ///
									keepusing(pop pppgdp)
	rename pppgdp pppwgt
	drop if _merge==2
	drop _merge


	*********** Drop Outliers*************
	replace gdpsa=. if ccode=="CMR" & date == yq(2018, 1)
	replace gdpsa=. if ccode=="IRN" & date >= yq(2013, 1)
	replace gdpsa=. if ccode=="MOZ" & date == yq(2018, 1)
	**************************************
	
	* 3. Sample constraints
	gen mark = 1 if gdpsa != . & pppwgt != . & pop !=.
	drop if mark != 1
	

	* 4. R datasets: pop_PWT.csv, gdp.csv, pppwgt.csv
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
