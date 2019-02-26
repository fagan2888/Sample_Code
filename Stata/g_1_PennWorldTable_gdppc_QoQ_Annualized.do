* File name: g_1_PennWorldTrade_gdppc_QoQ_Annualized.do
* Description: calculate annualized qoq gdp growth rate
* Author: Shijie Shi
* Last updated: 09/05/2018
	
quietly{
	
	local date "201902"
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	cd "`projFolder'"

	* 1. readin qoq gdp growth rate
	use "output/g_1_PennWorldTrade_gdppc_QoQ_`date'.dta", replace
	
	* 2. generate variable: date, year, quarter
	split Date, p( "Q")
	rename (Date1 Date2) (year quarter)
	destring year quarter, replace
	
	gen date = yq(year, quarter)
	format date %tqCCYY!Qq
	drop Date
	
	* 3. extract yearly population growth rate
	preserve
		keep if pop_gr_a !=0 & pop_gr_a!=.
		keep pop_gr_a year
		
		tempfile pop
		save `pop', replace
	restore	
	
	drop pop_gr_a
	
	
	* 4. generate annualized qoq gdp growth rate
	gen double gdp_gr_a = ( 1 + gdp_gr_q /100 ) ^ 4 - 1
	replace gdp_gr_a = gdp_gr_a * 100
	
	* 5. merge in annulized population growth rate
	merge m:1 year using `pop', assert(1 3)
	drop _merge
	
	order date year quarter gdp_gr_q gdp_gr_a gdp_count pop_gr_a pop_count
	label var date "Date"
	label var year "Year"
	label var quarter "Quarter"
	label var gdp_gr_q "GDP growth rate, quarterly. Source: gdpsa. Weight: PWT"
	label var gdp_gr_a "Annualized qoq GDP growth rate. Source: gdpsa. Weight: PWT"
	label var gdp_count "No. of countries"
	label var pop_gr_a "Population growth rate, annual. Source: PWT"
	label var pop_count "No. of countries"
	
	* 6. generate per capita gdp growth rate
	gen gdppc = gdp_gr_a - pop_gr_a
	label var gdppc "Per capita GDP growth rate, const sample, aqoq. Source: gdpsa. Weight_Pop: PWT"

	tsset date
	save output/g_1_PennWorldTrade_gdppc_QoQ_Annualized_`date'.dta, replace
	

}
