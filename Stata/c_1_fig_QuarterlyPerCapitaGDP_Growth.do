* File name: c_1_fig_QuarterlyPerCapitaGDP_Growth.do
* Description: prepare date to produce figure: Quarterly Per Capita Global Output Growth
* Author: Shijie Shi
* Last updated: 02/21/2019
clear all
set more off

local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
local date "201902"

cd "`projFolder'"

	
* 1. gdppc annualized aqoq
use "output/g_1_PennWorldTrade_gdppc_QoQ_Annualized_`date'.dta", replace
keep date gdppc gdp_count
rename (gdppc gdp_count) (gdppc_aqoq gdppc_aqoq_n)
order date gdppc_aqoq gdppc_aqoq_n

export excel "output/c_1_fig_QuarterlyPerCapitaGDP_Growth_`date'.xlsx", firstrow(variables) replace
