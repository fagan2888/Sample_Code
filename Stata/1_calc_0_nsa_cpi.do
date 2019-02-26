* File name: 2_calc_nsa_0_cpi.do
* Description: 
* Data source: 
* Author: Shijie Shi (Much credit to Nao's original work)
* Last updated: 2018/06/07

clear all
set more off
*ssc install vallist

quietly{

	local projFolder "R:/Shi/Business Financial Data"
	local dataFolder "R:/Shi/Business Financial Data/output/201805"
	local outputFolder "R:/Shi/Business Financial Data/output/201805/dta"
	local date "201805"
	local CUTOFF = yq(2010, 1)

	cd "`dataFolder'"
/*	
	use `date'_HA_IFS_CPI_Q, clear
 
	* Data Extension
	* Note: Below is the variable sequence following the do do-file line
	*		local pvar `1' //"ccode"
	*		local tvar `2'	//"date"
	*		local data1 `3'	//"data series 1"
	*		local data2 `4'	//"data series 2"
	*		local final `5'	//"final data series"
	gen double cpi = .
	gen str cpi_source =""
	n di "Processing cpi_ha and cpi_ifs to get cpi"
	do "`projFolder'/do/extending data series2.do"  ccode date cpi_ha cpi_ifs cpi
	n tab cpi_source
	
	sort ccode date
	*tempfile tmp
	*save `tmp', replace
	
	save tmp, replace
*/
	*************************************
	* Argentina
	* 	use HA_CPI_Argentina (bis_npc) as the main
	*	backward extending using:
	*						(1) 2013Q4 - 2017Q1: BIS_CPI_Argentina
	*						(2) start - 2017Q1:  HA_CPI_Argentina( bis_opc).
	use `date'_HA_CPI_Argentina, replace
	merge 1:1 ccode date using `date'_BIS_CPI_Argentina.dta
	drop _merge
	sort ccode date
	/*
	local pvar `1' //"ccode"
	local tvar `2'	//"date"
	local data1 `3'	//"base data series" 
	local data2 `4'	//"data series 2"
	local final `5'	//"final data series"
	*/
	gen double cpi = .
	gen str cpi_source =""
	
	n di "Processing cpi_ha_npc and cpi_bis to get cpi for Argentina"
	do "`projFolder'/do/extending data series_extension only.do"  ccode date cpi_ha_npc cpi_bis cpi
	n tab cpi_source
	
	replace cpi=. if date < yq(2013, 4) 
	replace cpi_source="" if date < yq(2013, 4)

	gen cpi_note = cpi_source 
	n di "Processing cpi and cpi_ha_opc to get cpi for Argentina"
	do "`projFolder'/do/extending data series_extension only.do"  ccode date cpi cpi_ha_opc cpi
	n tab cpi_source
	
	drop cpi_note 
	
	sort ccode date
	tempfile tmp1
	save `tmp1', replace
	*************************************

	use tmp, clear
	merge 1:1 ccode date using `tmp1', update replace 
	drop if _merge==2
	drop _merge
	
	* Base year: 2010
	local base = 2010
	gen double cpi_b = cpi if year==`base'
	egen double cpi_base = mean(cpi_b), by(ccode)
	replace cpi = cpi / (cpi_base / 100)
	replace cpi_source ="" if cpi == .

	label var cpi "CPI, NSA, `base' = 100"
	label var cpi_source "Sources of cpi" 
	local lbl_cpi: variable label cpi
	drop cpi_b cpi_base

	gen byte baseyr = 1 if year==`base'
	label var baseyr "=1 if base year"
	
	* Remove gaps
	* remove gaps.do
	* Note: Below is the sequence of the variables following the do-file line
	* 		local pvar `1' //"ccode"
	* 		local tvar `2'	//"date"
	* 		local var `3'	// the target variable
	* 		local var_source `4'	// the source of target variable
	* 		local CUTOFF `5' // the cutoff date
	do "`projFolder'/do/remove gaps.do" ccode date cpi cpi_source `CUTOFF'
	n tab cpi_source

	compress _all
	order ccode ifscode country date year quarter cpi cpi_raw cpi_fill
	sort ccode date
	save "`outputFolder'\\`date'_cpi_nsa.dta", replace
	n di "Finished: Data are saved in `outputFolder'/`date'_cpi_nsa.dta"
}
