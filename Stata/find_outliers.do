* File name: find_outliers.do
* Description: find outliers in data `date'_gdp_sa_noted.dta
* Author: Shijie Shi
* Last updated: 02/21/2019

set more off 
clear all

quietly{

	local date "201902"
	local projFolder "R:/Shi/Project_Business Financial Data"
	local dataFolder "R:/Shi/Project_Business Financial Data/output/`date'/dta"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	
	cd "`dataFolder'"
	use `date'_gdp_sa_noted.dta, replace
	keep ccode-quarter gdpsa

	*Calculate GDP growth rate
	tsset ifscode date
	gen l_gdpsa = ln(gdpsa)
	gen g_gdpsa = D.l_gdpsa * 100
	
	sort g_gdpsa
	* check for extrem numbers that above 100 or below -100.

}
