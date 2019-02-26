* File name: compare_gdp_2.do
* Description: compare the data availability
* Author: Shijie Shi
* Last updated: 07/23/2018

set more off
clear all

local date "201805"
local projFolder "R:/Shi/Business Financial Data"
local dataFolder "R:/Shi/Business Financial Data/original/GDP/FromMiyoko&Nao"
local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/`date'"

cd "`dataFolder'"

import excel using "data_availability_Miyoko_Nao.xlsx", sheet("miyoko") firstrow
keep country oecd_MA haver_MA
tempfile tmp1
save `tmp1', replace

import excel using "data_availability_Miyoko_Nao.xlsx", sheet("nao") firstrow clear
*keep country oecd_NS haver_NS

merge 1:1 country using `tmp1'

gen str avai = "NS" if _merge==1
replace avai = "MA" if _merge==2
replace avai = "NS_MA" if _merge==3
drop _merge
tempfile tmp2
save `tmp2', replace


import excel using "`outputFolder'/`date'_1_compare_gdp_1.xlsx", firstrow clear
merge 1:1 country using `tmp2'

replace avai = avai + "SS" if _merge==1
replace avai = avai + "_SS" if _merge==3
drop _merge

order ccode country avai
gen length = length(avai)
sort length avai country
export excel "`outputFolder'/`date'_1_compare_gdp_2.xlsx", firstrow(variables) replace

