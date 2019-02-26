* File name: e_1_WDI_1_readin_gdp_pop.do
* Description: readin WDI data
* Author: Shijie Shi
* Last updated: 08/30/2018

set more off
clear all


quietly{

	cd "R:/Shi/Project_AK's book update_CollapseAndRevival"

	import delimited "original/WDI_gdp_pop.csv", clear
	
	do "R:/Shi/Stata/do/readin_WDI.do" country

	rename nygdpmktpkn ngdpr
	rename nygdpmktpppkd pppgdp
	rename sppoptotl lp
	
	save output/WDI_gdp_pop, replace	
	
}
