* File name: e_1_WDI_2_calc_extrapolate_pppgdp.do
* Description: extrapolate pppgdp data using ngdpr
* Author: Shijie Shi
* Last updated: 08/30/2018

set more off
clear all


quietly{

	cd "R:/Shi/Project_AK's book update_CollapseAndRevival"

	use output/WDI_gdp_pop.dta, clear
	
	local pvar `1' //"ccode"
	local tvar `2'	//"year"
	local data1 `3'	//"base data series" 
	local data2 `4'	//"data series 2"
	local final `5'	//"final data series"
	
	gen str pppgdp_note = "pppgdp" if pppgdp !=. 
	gen str ngdpr_note = "ngdpr" if ngdpr !=.
	
	gen str pppgdp_source = ""
	do "R:/Shi/Stata/do/extending data series_extension only_y.do" ccode year pppgdp ngdpr pppgdp
	drop *note *source

	save output/WDI_gdp_pop_extended, replace  	
	
}
