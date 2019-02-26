* File name: g_2_PennWorldTable_eq_hp_psc_YoY
* Description: calculate yoy gdp growth rate
* Author: Shijie Shi
* Last updated: 09/10/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	cd "`projFolder'"

	* 1. readin eq hp psc data
	use "R:/Shi/Project_Business Financial Data/output/201805/dta/201805_business_finance.dta", replace

	keep ccode - quarter reqsa lnrpsc rhpsa
	
	gen double rpsc = exp(lnrpsc)
	
	* 2. calculate YOY growth rate per country per year
	tsfill, full
	n tsset ifscode date
	sort ifscode date
	
	foreach i in reqsa rhpsa rpsc {
		by ifscode: gen double `i'_yoy = ( `i'[_n] - `i'[_n-4] ) / `i'[_n-4] *100
	}
	
	* 3. merge in ppp weight data from Penn World Tables
	merge m:1 ccode year using "original/data_pwt_weo2018apr.dta", keepusing(pppgdp)
	drop if _merge==2
	drop _merge
	
	*** Remove negative pppgdp weights
	n replace pppgdp=. if ccode=="BMU" & year >= 1999 & year <= 2003 // Bermuda
	
	
	*** find sample size
	foreach i in reqsa rhpsa rpsc {
		gen `i'_yoy_n = 1 if `i'_yoy  !=. & pppgdp != .
	}

	* 4. generate weighted quarterly growth rate
	sort ifscode date
	collapse (sum) *_yoy_n (mean) *_yoy [aw=pppgdp] , by(date)

	label var date "Date"
	label var reqsa_yoy "Equity growth rate, yoy. Data source: reqsa. Weight: PWT"
	label var rhpsa_yoy "House price growth rate, yoy. Data source: rhpsa. Weight: PWT"
	label var rpsc_yoy "Credit growth rate, yoy. Data source: lnrpsc. Weight: PWT"
	
	foreach i in reqsa rhpsa rpsc  {
		local lbl: variable label `i'_yoy
		label var `i'_yoy_n "[N] `lbl'"
	}

	tsset date

	save output/g_1_PennWorldTrade_eq_hp_psc_YoY.dta, replace
	
  
}
