* File name: 3_1_calc_gdp.do
* Description: use new data as the base, forward/backward extend using AK's data.	  
* Update:	1. For the 7 countries below, use the “original” series as the main one and then 
* 			   extend it with the “new” series 
* 					Croatia (HRV)
* 					Denmark (DNK)
* 					Ireland (IRL)
* 					Portugal (PRT)
* 					New Zealand (NZL)
* 					Sweden (SWE)
* 					Switzerland (CHE)
* 			  2. Add Vietnam with all missing data to the whole dataset
* 			  3. Add variable ifscode, year and quarter to the whole dateset
* Data source: Please check the README.xlsx in "R:\Shi\Project_Confidence\original\GDP"
* Author: Shijie Shi 
* Last updated: 2019/04/09

clear all
set more off

local date "201904"
local projFolder "R:/Shi/Project_Confidence"
local outputFolder "`projFolder'/output/`date'"
local dataFolder `outputFolder'

cd "`dataFolder'"

quietly{
	
	* AK's data
	use "R:\Shi\20180313 confidence data\Data from Miyoko\bones_check_M2.dta", clear
	keep if logoutput!=.
	
	preserve
		keep ccode
		duplicates drop
		tempfile ak_ctris
		save `ak_ctris', replace
	restore 
	
	keep ccode date logoutput
	rename logoutput lngdpA

	tempfile ak
	save `ak', replace
	
	* New data
	use `date'_1_merge_GDP_OECD_Haver_Q, clear
	keep ccode - date lngdp
	rename lngdp lngdpN

	* Merge
	merge m:1 ccode using `ak_ctris', assert(1 3)
	keep if _merge==3
	drop _merge
	
	merge 1:1 ccode date using `ak', assert(1 3)	
	drop _merge
	
	sort ccode date
	tempfile full
	save `full', replace
	

	* 7countries, AK's data as base.
	keep if ccode == "HRV" | ccode == "DNK" | ccode == "IRL" | ccode == "PRT" | ///
			ccode == "NZL" | ccode == "SWE" | ccode == "CHE"
	
	/*
	local pvar `1' //"ccode"
	local tvar `2'	//"date"
	local data1 `3'	//"base data series, in Log" 
	local data2 `4'	//"data series 2, in log"
	local final `5'	//"final data series"
	*/
	
	gen double gdp=.
	gen gdp_source=""
	do "R:/Shi/Stata/do/extending data series_extension only_q.do" ccode date lngdpA lngdpN gdp
	
	tempfile 7countries
	save `7countries', replace
	
	* Other countries, Haver data as the base
	use `full', replace
	drop if ccode == "HRV" | ccode == "DNK" | ccode == "IRL" | ccode == "PRT" | ///
			ccode == "NZL" | ccode == "SWE" | ccode == "CHE"
	gen double gdp=.
	gen gdp_source=""
	do "R:/Shi/Stata/do/extending data series_extension only_q.do" ccode date lngdpN lngdpA gdp
	
	* Append 7 countries
	append using `7countries'
	
	* Label gdp_source
	gen gdp_source1=.
	replace gdp_source1 = 1 if gdp_source== "lngdpA"
	replace gdp_source1 = 2 if gdp_source== "extrapolated by lngdpA"
	replace gdp_source1 = 3 if gdp_source== "lngdpN"
	replace gdp_source1 = 4 if gdp_source== "extrapolated by lngdpN"

	label define data_source 1 "old" 2 "extrapolated by old" 3 "new" 4 "extrapolated by new"

	rename gdp gdp_new
	rename gdp_source gdp_new_source_detailed
	rename gdp_source1 gdp_new_source
	
	label values gdp_new_source data_source
	label variable gdp_new_source "The data source of gdp"
	label variable gdp_new_source_detailed "The data source of gdp, detailed"
	
	
	* Organize data
	gen year = yofd(dofq(date))
	gen quarter = quarter(dofq(date))
	
	compress _all
	sort ccode date
	order ccode ifscode country date year quarter gdp_new gdp_new_source gdp_new_source_detailed
	label variable ccode "Country Code"
	label variable ifscode "IMF Country Code"
	label variable country "Country"
	label variable date "Date"
	label variable year "Year"
	label variable quarter "Quarter"
	label variable lngdpN "[LN] Real GDP, new"
	label variable lngdpA "[LN] Real GDP, old"
	label variable gdp_new "[LN] Real GDP"
	
	save "`outputFolder'/`date'_3_1_calc_gdp", replace
	n di "Finished: Data are saved in `outputFolder'/`date'_3_1_calc_gdp.dta"

}
