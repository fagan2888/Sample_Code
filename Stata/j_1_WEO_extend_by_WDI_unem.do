* File name: j_1_WEO_extend_by_WDI_unem.do
* Description: Unemployment data from WEO. For 1970-1980, extrapolate back using
*			   WDI's data
* Author: Shijie Shi
* Last updated: 10/01/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"

	cd "`projFolder'"
	
	* 1. Read in WDI data
	use "output/WDI_unem.dta"	
	gen unem_source = "WDI" if unem != .

	* 2. Read in WEO data
	merge 1:1 ccode year using "original/WEO_April2018_All.dta", keepusing(lur)
	drop _merge
	gen lur_source = "WEO" if lur != .

	* 3. Backward extrapolation	
	gen double unemp = . // new unemployment rate varaible
	gen unemp_source = ""
	
	/*
	local pvar `1' //"ccode"
	local tvar `2'	//"year"
	local data1 `3'	//"base data series" 
	local data2 `4'	//"data series 2"
	local final `5'	//"final data series"
	*/
	do "R:\Shi\Stata\do\extending data series_extension only_y.do" ccode year lur unem unemp

	save "output/j_1_WEO_extend_by_WDI_unem.dta", replace	
}

	


