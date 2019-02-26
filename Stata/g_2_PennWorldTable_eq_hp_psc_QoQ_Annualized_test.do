* File name: g_2_PennWorldTable_eq_hp_psc_QoQ_Annualized_test
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
	
	foreach i in reqsa rhpsa rpsc {
		by ifscode: gen double g_`i' = D.`i' / L.`i' *100
	}
	
	
	* 3. merge in ppp weight data from Penn World Tables
	merge m:1 ccode year using "original/data_pwt_weo2018apr.dta", keepusing(pppgdp)
	drop if _merge==2
	drop _merge
	
	*** Remove negative pppgdp weights
	n replace pppgdp=. if ccode=="BMU" & year >= 1999 & year <= 2003 // Bermuda
	
	sort ifscode date
	
	
	* 4. generate annualized growth rate
	foreach i in reqsa rhpsa rpsc {
		by ifscode: gen double `i'_a = ( 1 + g_`i' /100 ) ^ 4 - 1
		replace `i'_a = `i'_a * 100
	}
dddddddddd	
	* 5. generate weighted quarterly growth rate
	collapse (mean) reqsa_a rhpsa_a rpsc_a [aw=pppgdp], by(date)


	label var date "Date"
	label var reqsa_a "Equity growth rate, annualized qoq. Data source: reqsa. Weight: PWT"
	label var rhpsa_a "House price growth rate, annualized qoq. Data source: rhpsa. Weight: PWT"
	label var rpsc_a "Credit growth rate, annualized qoq. Data source: lnrpsc. Weight: PWT"

	tsset date
dddddddd
	save output/g_1_PennWorldTrade_eq_hp_psc_QoQ_Annualized_test.dta, replace
	

}
