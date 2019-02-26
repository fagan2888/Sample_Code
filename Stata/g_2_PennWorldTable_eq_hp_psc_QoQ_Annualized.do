* File name: g_2_PennWorldTable_eq_hp_psc_QoQ_Annualized
* Description: calculate annualized qoq gdp growth rate
* Author: Shijie Shi
* Last updated: 09/10/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	cd "`projFolder'"

	* 1. readin eq hp psc data
	use "R:/Shi/Project_Business Financial Data/output/201805/dta/201805_business_finance.dta", replace

	keep ccode - quarter reqsa lnrpsc rhpsa
	
	gen double rpsc = exp(lnrpsc)
	
	* 2. calculate growth rate per country per year
	n tsset ifscode date
	sort ifscode date
	foreach i in reqsa rhpsa rpsc {
		by ifscode: gen double `i'_qoq = D.`i' / L.`i' *100
	}
	
	* 3. merge in ppp weight data from Penn World Tables
	merge m:1 ccode year using "original/data_pwt_weo2018apr.dta", keepusing(pppgdp)
	drop if _merge==2
	drop _merge
	
	*** Remove negative pppgdp weights
	n replace pppgdp=. if ccode=="BMU" & year >= 1999 & year <= 2003 // Bermuda
	
	
	*** find sample size
	foreach i in reqsa rhpsa rpsc {
		gen `i'_aqoq_n = 1 if `i'_qoq !=. & pppgdp != .
	}

	* 4. generate weighted quarterly growth rate
	sort ifscode date
	collapse (sum) *_aqoq_n (mean) *_qoq [aw=pppgdp] , by(date)

	
	* 5. generate annualized growth rate
	foreach i in reqsa rhpsa rpsc {
		gen double `i'_aqoq = ( 1 + `i'_qoq /100 ) ^ 4 - 1
		replace `i'_aqoq = `i'_aqoq * 100
	}

	label var date "Date"
	label var reqsa_aqoq "Equity growth rate, annualized qoq. Data source: reqsa. Weight: PWT"
	label var rhpsa_aqoq "House price growth rate, annualized qoq. Data source: rhpsa. Weight: PWT"
	label var rpsc_aqoq "Credit growth rate, annualized qoq. Data source: lnrpsc. Weight: PWT"
	
	foreach i in reqsa rhpsa rpsc  {
		local lbl: variable label `i'_aqoq
		label var `i'_aqoq_n "[N] `lbl'"
	}
	
	tsset date

	save output/g_1_PennWorldTrade_eq_hp_psc_QoQ_Annualized.dta, replace
	

}
