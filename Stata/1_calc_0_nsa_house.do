* File name: 2_calc_nsa_0_house.do
* Description: 
* Data source: 
* Author: Shijie Shi (Much credit to Nao's original work)
* Last updated: 2018/06/18

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

	* Step 1: organize data
	use 201805_OECD_HPR_Q, clear
	
	rename rhp rhpsa_oec
	drop sourceCountry
	keep if year>=1960
	
	xtset ifscode date, quarterly
	local pvar = r(panelvar)
	local tvar = r(timevar)

	sort `pvar' `tvar'

	merge 1:1 `pvar' `tvar' using 201805_BIS_PP_Q
	tab _merge
	drop _merge
	
	local bis_sa "USA ZAF" // Refer to the BIS documentation to see which ones have SA data
	
	gen byte bis_sa = .
	
	foreach x of local bis_sa{
		replace bis_sa = 1 if ccode=="`x'"
	}
	
	sort `pvar' `tvar'
	
	foreach x in n r{
		local lbl_`x'628: variable label `x'628

		gen double `x'hpnsa_bis0 = `x'628 if bis_sa!=1
		label var `x'hpnsa_bis0 "[NSA] `lbl_`x'628'"
		
		gen double `x'hpsa_bis0 = `x'628 if bis_sa==1
		label var `x'hpsa_bis0 "[SA] `lbl_`x'628'"

		drop `x'628
	}
	
	local lbl_nhsp1: variable label nhsp1	
	gen double nhpnsa_bis1 = nhsp1 if bis_sa!=1
	gen double nhpsa_bis1 = nhsp1 if bis_sa==1
	label var nhpnsa_bis1 "[NSA] `lbl_nhsp1'"
	label var nhpsa_bis1 "[SA] `lbl_nhsp1'"	
	
	drop nhsp1
	drop bis_sa
	
	order ccode - quarter nhpnsa* nhpsa*

	* Step 2: BIS--the series with more observations as the main
	* 	Data Extension: extending data series2.do
	* 	Note: 	Below is the variable sequence following the do do-file line
	*	    	local pvar `1' //"ccode"
	*			local tvar `2'	//"date"
	*			local data1 `3'	//"data series 1"
	*			local data2 `4'	//"data series 2"
	*			local final `5'	//"final data series"

	* Nominal house prices, NSA (nhpnsa_bis0, nhpnsa_bis1)
	n di "Processing nhpnsa_bis0 and nhpnsa_bis1 to get nhpnsa_bis"
	gen double nhpnsa_bis = .
	gen str nhpnsa_bis_source =""
	do "`projFolder'/do/extending data series2.do"  ccode date nhpnsa_bis0 nhpnsa_bis1 nhpnsa_bis
	n tab nhpnsa_bis_source
	label var nhpnsa_bis "[NSA] Nominal house prices"
	gen nhpnsa_bis_note = nhpnsa_bis_source
	local lbl_nhpnsa_bis: variable label nhpnsa_bis
	label variable nhpnsa_bis_note "[Note] `lbl_nhpnsa_bis'"
	drop nhpnsa_bis_source
	
	* Nominal house prices, SA (nhpsa_bis0, nhpsa_bis1)
	n di "Processing nhpsa_bis0 and nhpsa_bis1 to get nhpsa_bis"
	gen double nhpsa_bis = .
	gen str nhpsa_bis_source =""
	do "`projFolder'/do/extending data series2.do"  ccode date nhpsa_bis0 nhpsa_bis1 nhpsa_bis
	n tab nhpsa_bis_source
	label var nhpsa_bis "[SA] Nominal house prices"
	gen nhpsa_bis_note = nhpsa_bis_source
	local lbl_nhpsa_bis: variable label nhpsa_bis
	label variable nhpsa_bis_note "[Note] `lbl_nhpsa_bis'"
	drop nhpsa_bis_source
	
	* Real house prices, SA (rhpsa_oec, rhpsa_bis0)
	n di "Processing rhpsa_oec and rhpsa_bis0 to get rhpsa_oec"
	gen str rhpsa_oec_source =""
	do "`projFolder'/do/extending data series2.do"  ccode date rhpsa_oec rhpsa_bis0 rhpsa_oec
	n tab rhpsa_oec_source
	gen rhpsa_oec_note = rhpsa_oec_source
	local lbl_oec_note: variable label rhpsa_oec
	label variable rhpsa_oec_note "[Note] `lbl_oec_note'"
	drop rhpsa_oec_source
	
	
	* Step 3: Merge data from Haver 
	merge 1:1 `pvar' `tvar' using 201805_HA_HP_Q
	tab _merge
	drop _merge

	egen count1 = count(hg), by(`pvar')
	egen count2 = count(hj), by(`pvar')

	noisily tab country if count1<count2

	gen nhpnsa_ha_note = "HA_HP_Q: hg" if hg !=.

	replace hg = hj if count1<count2
	replace nhpnsa_ha_note = "HA_HP_Q: hj" if count1<count2 & hg !=.
	replace nhpnsa_ha_note = "" if hg ==.
	
	drop hj count?
	
	rename hg nhpnsa_ha
	
	
	*Step 4: Merge data from country sources
	merge 1:1 `pvar' `tvar' using 201805_HP_CtrySources_Q
	tab _merge
	drop _merge
	
	egen count1 = count(nhpnsa_ha), by(`pvar')
	egen count2 = count(hp_cc), by(`pvar')

	noisily tab country if count1<count2
	replace nhpnsa_ha = hp_cc if count1<count2
	replace nhpnsa_ha_note = "HP_CtrySources" if count1<count2 & nhpnsa_ha !=.
	replace nhpnsa_ha_note = "" if nhpnsa_ha ==.

	drop hp_cc count?
	
	*Step 5: Sample period
	keep if year>=1960
	preserve
		collapse (mean) year, by(`pvar' ccode country)
		drop year
		sort `pvar'
		tempfile ccode
		save `ccode', replace
	restore
	
	tsset `pvar' `tvar' 
	drop ccode country
	tsfill, full
	
	merge m:1 `pvar' using `ccode', assert(3)
		tab _merge
		drop _merge

	replace year = year(dofq(date)) if year==.
	replace quarter = quarter(dofq(date)) if quarter==.

	compress _all
	order ccode ifscode country date year quarter

	sort `pvar' `tvar'
	
	* Step 6: Nominal house prices,NSA: BIS vs. HA 
	*			(nhpnsa_bis, nhpnsa_ha)
	* Data Extension: extending data series2.do
	n di "Processing nhpnsa_bis and nhpnsa_ha to get nhpnsa"
	gen double nhpnsa = .
	gen str nhpnsa_source =""
	do "`projFolder'/do/extending data series2.do"  ccode date nhpnsa_bis nhpnsa_ha nhpnsa
	n tab nhpnsa_source
	gen nhpnsa_note = nhpnsa_source
	drop nhpnsa_source

	* Step 7: Compute real house price index (deflated by CPI)
	merge 1:1 `pvar' `tvar' using dta\201805_cpi_nsa
	tab _merge
	noisily tab country if _merge==2
	drop if _merge==2
	drop _merge

	sum year if baseyr==1
	local base = r(mean)
	noisily display as text "Base year = " as result "`base'"

	drop cpi_* baseyr
	
	gen double nhpnsa_b = nhpnsa if year==`base'
	egen double nhpnsa_base = mean(nhpnsa_b), by(`pvar')
	replace nhpnsa = nhpnsa / (nhpnsa_base / 100)
	replace nhpnsa_note = "" if nhpnsa==.
	label var nhpnsa "Nominal house prices, NSA, BIS/HA, `base' = 100"
	label var nhpnsa_note "[Note] Nominal house prices, NSA, BIS/HA, `base' = 100"
	
	drop nhpnsa_b nhpnsa_base
	
	gen double rhpnsa_com = nhpnsa / (cpi / 100)
	label var rhpnsa_com "Real house price index (computed), NSA, BIS/HA, `base' = 100"
	gen rhpnsa_com_note = "computed by nhpnsa" if rhpnsa_com !=.
	local lbl_rhpnsa_com: variable label rhpnsa_com
	label var rhpnsa_com_note "[Note] `lbl_rhpnsa_com'"
	
	
	* Step 8: BIS vs. Computed BIS/HA
	*			(rhpnsa_bis0, rhpnsa_com)
	* Data Extension: extending data series2.do
	n di "Processing rhpnsa_bis0 and rhpnsa_com to get rhpnsa"
	gen double rhpnsa = .
	gen str rhpnsa_source =""
	do "`projFolder'/do/extending data series2.do"  ccode date rhpnsa_bis0 rhpnsa_com rhpnsa
	n tab rhpnsa_source
	gen rhpnsa_note = rhpnsa_source
	drop rhpnsa_source
	label var rhpnsa "Real house price index, NSA, `base' = 100"
	label var rhpnsa_note "[Note] Real house price index, NSA, `base' = 100"
	
	* Base year adjustment
	gen double rhpnsa_b = rhpnsa if year==`base'
	egen double rhpnsa_base = mean(rhpnsa_b), by(`pvar')
	replace rhpnsa = rhpnsa / (rhpnsa_base / 100)
	drop rhpnsa_b rhpnsa_base
	
	
	* Step 9: Remove gaps
	* remove gaps.do
	* Note: Below is the sequence of the variables following the do-file line
	* 		local pvar `1' //"ccode"
	* 		local tvar `2'	//"date"
	* 		local var `3'	// the target variable
	* 		local var_source `4'	// the source of target variable
	* 		local CUTOFF `5' // the cutoff date
	gen rhpnsa_source = rhpnsa_note
	do "`projFolder'/do/remove gaps.do" ccode date rhpnsa rhpnsa_source `CUTOFF'
	n tab rhpnsa_source
	
	replace rhpnsa_note = rhpnsa_source
	drop rhpnsa_source
	
	* Step 10: generate rhpnsa.csv file
		preserve
		xtset, clear
		keep ccode date rhpnsa

		egen count = count(rhpnsa), by(ccode)
		drop if count<=12 //For SA, data at least over three years are needed *
		drop count

		reshape wide rhpnsa, i(date) j(ccode) string

		renpfix rhpnsa

		tsset date, quarterly

		sort `tvar'
		egen rown = rownonmiss(???)
		egen seq = seq() if rown!=0

		sum `tvar' if seq==1
		drop if `tvar'<r(mean)
		drop rown seq

		sort `tvar'
		export delimited using sadj\fin\rhpnsa.csv, replace

	restore

	compress _all
	order ccode ifscode country date year quarter rhpsa_oec rhpsa_oec_note rhpnsa rhpnsa_note rhpnsa_raw rhpnsa_fill
	sort `pvar' `tvar'
	save "`outputFolder'\\`date'_rhp_nsa.dta", replace
	n di "Finished: Data are saved in `outputFolder'/`date'_rhp_nsa.dta"
}
