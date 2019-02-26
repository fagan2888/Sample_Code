* File name: h_1_PennWorldTable_trade_flows_ae_emde.do
* Description: Calculate trade flows using PWT data (extended by WEO)
* Author: Shijie Shi
* Last updated: 10/02/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	cd "`projFolder'"
	
	* 1. Read in PWT data
	use "original/PWT_9.dta", replace
	keep ccode - year q_x_na q_m_na xr_na i_xr
	
	* 2. Get the exchange rate (market-based) in 2011
	gen xr_na_2011 = xr_na if year==2011 & i_xr== 0
	bysort ccode: egen erate = mean(xr_na_2011)
	
	* 3. Convert the constant national 2011 prices to US dollars
	gen ex = q_x_na / erate
	gen im = q_m_na / erate
	
	* 4. Merge export, import growth rate from WEO
	merge 1:1 ccode ifscode country year using "original/WEO_April2018_Website.dta", keepusing(tm_rpch tx_rpch) update
	drop _merge
	
	* 5. Compare the growth rate of major countries: USA, Japan, China, Germany
/*
	tsset ifscode year
	gen gr_ex_pwt = D.ex / L.ex * 100
	gen gr_im_pwt = D.im / L.im * 100
	sort ccode year
	
	cd "R:/Shi/Project_AK's book update_CollapseAndRevival/output/gph"
	local clist "USA CHN JPN DEU"

	foreach country in `clist' {
		tsline tm_rpch gr_im_pwt if ccode=="`country'", title("`country'") saving("ex_`country'", replace) nodraw 
		tsline tx_rpch gr_ex_pwt if ccode=="`country'", title("`country'") saving("im_`country'", replace) nodraw 
	}
	
	local imGraph "im_USA.gph"
	local exGraph "ex_USA.gph"
	
	foreach country in "CHN" "JPN" "DEU" {
		local imGraph = "`imGraph'" + " " + "im_`country'.gph"
		local exGraph = "`exGraph'" + " " + "ex_`country'.gph"
	}
	graph combine `imGraph'
	graph export import.png, replace
	
	graph combine `exGraph'
	graph export export.png, replace
*/	
	
	
	*** Step 5 shows the growth rate is very similar. Use WEO data to extend PWT. ***
	
	* 6. Extend PWT data using growth rate from WEO
	tsset ifscode year
	n replace ex = L.ex * ( 1 + tx_rpch / 100) if ex == . & year >= 2014
	n replace im = L.im * ( 1 + tm_rpch / 100) if im == . & year >= 2014
	
	* 7. Get the total trade data
	gen totrade = ex + im 

	* 8. Prepare dataset for R (to compute the growth rate using common samples)
	keep ccode ifscode country year totrade
	
	* merge in AE, EMDE categories
	tsset ifscode year
	tsfill, full
	drop ccode country
	
	merge m:1 ifscode using "R:\Shi\Stata\data\countrycodes.dta", keepusing(ccode country)
	drop if _merge==2
	drop _merge
	
	
	merge m:1 ccode using "R:\Shi\Stata\data\AEs_NS.dta"
	drop if _merge==2
	drop _merge

	merge m:1 ccode using "R:\Shi\Stata\data\EMDEs_NS.dta", keepusing(emde)
	drop if _merge==2
	drop _merge

	preserve
		keep if ae==1
		keep ccode year totrade
		sort year ccode
		reshape wide totrade, i(ccode) j(year)
		export delimited using "output/h_1_PennWorldTable_trade_flows_ae.csv", replace
	restore
	
	preserve
		keep if emde==1
		keep ccode year totrade
		sort year ccode
		reshape wide totrade, i(ccode) j(year)
		export delimited using "output/h_1_PennWorldTable_trade_flows_emde.csv", replace
	restore
	
}
