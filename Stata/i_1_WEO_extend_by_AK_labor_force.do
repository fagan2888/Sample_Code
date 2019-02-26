* File name: i_1_WEO_extend_by_AK_labor_force.do
* Description: Labor force data from WEO. For 1970-1980, extrapolate back using
*			   AK's data
* Author: Shijie Shi
* Last updated: 10/01/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	
	* 1. Read in AK's data
	use "original/data_update_2018apr_sample.dta"
	keep ccode - year labor
	gen labor_source = "AK" if labor != .
	
	* 2. Merge in WEO data
	merge 1:1 ccode year using "original/WEO_April2018_All.dta", keepusing(llf)
	drop _merge
	gen llf_source = "WEO" if llf != .
	
	* 3. Backward extrapolation
	tab year if labor!=. &  llf==. // make sure no forward extrapolation will be implemented
	
	gen double lf = . // new labor force varaible
	gen lf_source = ""
	
	/*
	local pvar `1' //"ccode"
	local tvar `2'	//"year"
	local data1 `3'	//"base data series" 
	local data2 `4'	//"data series 2"
	local final `5'	//"final data series"
	*/
	do "R:\Shi\Stata\do\extending data series_extension only_y.do" ccode year llf labor lf

	save "`outputFolder'/i_1_WEO_extend_by_AK_labor_force.dta", replace	
}

	


