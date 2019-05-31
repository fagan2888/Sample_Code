* File name: 5_1_merge_gdp_eq_hp_cr.do
* Description: merge turning points datasets with data
* Data source: 
* Author: Shijie Shi 
* Last updated: 2019/04/23

clear all 
set more off

local date "201904"
local projFolder "R:/Shi/Project_Confidence"
local outputFolder "`projFolder'/output/`date'"

cd "`outputFolder'"

quietly{

	local gdp gdp
	use `date'_3_1_calc_`gdp'.dta	
	merge 1:1 ccode date using `date'_4_1_find_turning_points_`gdp'.dta, assert(1 3)
	drop _merge
	label var l_`gdp'_new_point "Turning point, `var'"
	
	* Merge in cr, eq and hp
	local num 2 3 4
	local var cr eq hp
	
	local n : word count `num'
	tokenize "`num'"

	forvalues i = 1/`n' {
	
		merge 1:1 ccode date using `date'_3_``i''_calc_`: word `i' of `var''.dta
		drop _merge
		
		merge 1:1 ccode date using `date'_4_``i''_find_turning_points_`: word `i' of `var''.dta, assert(1 3)
		drop _merge
		label var l_`: word `i' of `var''_new_point "Turning point, `: word `i' of `var''"	
	}
	
	* Merge in the IMF country classification
	merge m:1 ifscode using "`projFolder'/fromNao/2018 update/Data/group_codes.dta", assert(2 3)
	drop if _merge==2
	drop _merge

	sort ifscode date
	save `date'_5_1_merge_gdp_eq_hp_cr, replace
	
}



