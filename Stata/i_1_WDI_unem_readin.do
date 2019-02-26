* File name: i_1_WDI_unem_readin.do
* Description: Read in WDI unemployment data
* Author: Shijie Shi
* Last updated: 10/01/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	
	* 1. Read in IPm.csv
	import delimited "original/WDI_unem.csv"
	
	do R:/Shi/Stata/do/readin_WDI.do country	
	rename sluemtotlnezs unem
	
	save "`outputFolder'/WDI_unem.dta", replace	
}
