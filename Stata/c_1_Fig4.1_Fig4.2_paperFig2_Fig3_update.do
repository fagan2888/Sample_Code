* File name: c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update.do
* Description: use Nao's data to update figure 4.1.
* Author: Shijie Shi
* Last updated: 08/09/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"
	local START = 1960
	local END = 2020
	
	* 1. Read in data from Nao
	use "original/data_wld.dta", replace
	
	keep year mrkwgtsumprodngdpr pppwgtsumprodngdpr pcmrkwgtngdpr pcpppwgtngdpr
	
	label var mrkwgtsumprodngdpr "[World] Market-weighted growth"
	label var pppwgtsumprodngdpr "[World] PPP-weighted growth"
	label var pcmrkwgtngdpr "[World] Market-weighted growth, per capita"
	label var pcpppwgtngdpr "[World] PPP-weighted growth, per capita"
	
	keep if year>=`START' & year <=`END'
	
	local vars "mrkwgtsumprodngdpr pppwgtsumprodngdpr pcmrkwgtngdpr pcpppwgtngdpr"
	foreach var of local vars {
		gen `var'_i = 100 if year==`START'
		replace `var'_i = (1 + `var'/100 ) * l1.`var'_i if `var'_i==.
		
		local lbl_`var': var label `var'
		label var `var'_i "[Index]`lbl_`var''"
	}
	
	order year mrkwgtsumprodngdpr mrkwgtsumprodngdpr_i ///
			   pppwgtsumprodngdpr pppwgtsumprodngdpr_i ///
			   pcmrkwgtngdpr pcmrkwgtngdpr_i ///
			   pcpppwgtngdpr pcpppwgtngdpr_i
	
	export excel using "`outputFolder'/c_1_Fig4.1_Fig4.2_paperFig2_Fig3_update.xlsx", firstrow(varlabels) replace	
}
