* File name: 2_calc_nsa_0_equity.do
* Description: 
* Data source: 
* Author: Shijie Shi (Much credit to Nao's original work)
* Last updated: 2018/06/18

clear all
set more off
*ssc install vallist

local projFolder "R:/Shi/Business Financial Data"
local dataFolder "R:/Shi/Business Financial Data/output/201805"
local outputFolder "R:/Shi/Business Financial Data/output/201805/dta"
local date "201805"
local CUTOFF = yq(2010, 1)

cd "`dataFolder'"

quietly{
	
	* Step 1: organize data
	use 201805_IMFdata_EQT_Q, clear

	keep if year>=1960

	xtset ifscode date, quarterly
	local pvar = r(panelvar)
	local tvar = r(timevar)

	sort `pvar' `tvar'

	merge 1:1 `pvar' `tvar' using 201805_HA_EQT_Q
	tab _merge
	drop _merge

	preserve
		gen t = 1
		collapse (sum) t, by(`pvar' ccode country)
		drop t
		tempfile ctries
		save `ctries', replace
	restore
	
	drop ccode country
	tsfill, full
	merge m:1 `pvar' using `ctries', assert(3)
	drop _merge
	
	replace year = year(dofq(`tvar')) if year==.
	replace quarter = quarter(dofq(`tvar')) if quarter==.
	
	rename fpe eqa_imf
	rename fpe_eop eqe_imf
	rename eq eqa_ha
	rename eq_source eqa_ha_source
	rename eqe eqe_ha
	rename eqe_source eqe_ha_source
	
	* Step 2: IFS as the main source: if missing, use HA as the main;
	* 		  HA is used to extend the main source, if possible.
	local agg "a e"
	local src "imf ha"

	local lbl_a "period average"
	local lbl_e "end of period"
	
	foreach x of local agg{
	
		xtset ifscode date, quarterly
		
		foreach y of local src{
			egen count_eq`x'_`y' = count(eq`x'_`y'), by(`pvar')
		}
		
		* Data Extension
		* IFS as the main source: if missing, use HA as the main 
		* HA is used to extend the main source, if possible
		gen str eq`x'_note = "IFS" if eq`x'_imf!=.
		gen double eq`x' = eq`x'_imf
		label var eq`x'_note "[Note] Equity price index, `lbl_`x''"
		label var eq`x' "Equity price index, `lbl_`x''"
		
		replace eq`x'_note = "HA" if count_eq`x'_imf==0 & count_eq`x'_ha!=0 & eq`x'_ha!=.
		replace eq`x' = eq`x'_ha if count_eq`x'_imf==0 & count_eq`x'_ha!=0
		drop count_*
		
		n tab eq`x'_note

		* Note: Below is the variable sequence following the do-file line
		*		local pvar `1' //"ccode"
		*		local tvar `2'	//"date"
		*		local data1 `3'	//"base data series" 
		*		local data2 `4'	//"data series 2"
		*		local final `5'	//"final data series"
		gen str eq`x'_source = ""
		do "`projFolder'/do/extending data series_extension only.do" ccode date eq`x' eq`x'_ha eq`x'
		n tab eq`x'_source	
		
		replace eq`x'_note = eq`x'_source
		drop eq`x'_source

	} //End of "foreach x of local agg"


	* Step 3: Period average vs End of period: Use the one with more observations as the main;
	* 		  If possible, extend it with the secondary series
	* Data Extension
	* Note: Below is the sequence of the variables following the do-file line
	*		local pvar `1' //"ccode"
	*		local tvar `2'	//"date"
	*		local data1 `3'	//"data series 1" 
	*		local data2 `4'	//"data series 2"
	*		local final `5'	//"final data series"
	gen eq=.
	gen str eq_source = ""
	do "`projFolder'/do/extending data series2.do" ccode date eqa eqe eq
	n tab eq_source	
	gen eq_note = eq_source
	drop eq_source	


	* Step 4: Merge in CPI;
	*		  Calculate the real equity price index (deflated by CPI)
	merge 1:1 `pvar' `tvar' using dta\201805_cpi_nsa
		n tab country if _merge==2
		drop if _merge==2
		drop _merge
		
	sum year if baseyr==1
	local base = r(mean)
	noisily display as text "Base year = " as result "`base'"
	drop cpi_* baseyr

	gen double eq_b = eq if year==`base'
	egen double eq_base = mean(eq_b), by(`pvar')
	replace eq = eq / (eq_base / 100)
	replace eq_note = "" if eq ==.
	drop eq_b*

	label var eq "Equity price index, NSA, `base' = 100"
	label var eq_note "[Note] Equity price index, NSA, `base' = 100"
	
	gen double req = eq / (cpi / 100)
	label var req "Real equity price index, `base' = 100"

	* Step 5: Remove gaps
	* remove gaps.do
	* Note: Below is the sequence of the variables following the do-file line
	* 		local pvar `1' //"ccode"
	* 		local tvar `2'	//"date"
	* 		local var `3'	// the target variable
	* 		local var_source `4'	// the source of target variable
	* 		local CUTOFF `5' // the cutoff date
	gen req_source = eq_note if req !=. 
	do "`projFolder'/do/remove gaps.do" ccode date req req_source `CUTOFF'
	n tab req_source

	gen req_note = req_source
	local lbl_req: variable label req
	label var req_note "[Note] `lbl_req'"
	
	drop req_source
	
	* Step 6: generate reqnsa.csv file
	preserve

		xtset, clear

		keep ccode date req

		egen count = count(req), by(ccode)
		drop if count<=12	// For SA, data at least over three years are needed 
		drop count

		reshape wide req, i(date) j(ccode) string

		rename req* *

		tsset date, quarterly

		sort `tvar'
		egen rown = rownonmiss(???)
		egen seq = seq() if rown!=0

		sum `tvar' if seq==1
		drop if `tvar'<r(mean)
		drop rown seq

		sort `tvar'
		export delimited using sadj\fin\reqnsa.csv, replace

	restore
	
	compress _all
	order ccode ifscode country date year quarter req req_note req_raw req_fill
	sort `pvar' `tvar'
	save "`outputFolder'\\`date'_req_nsa.dta", replace
	n di "Finished: Data are saved in `outputFolder'/`date'_req_nsa.dta"

}
