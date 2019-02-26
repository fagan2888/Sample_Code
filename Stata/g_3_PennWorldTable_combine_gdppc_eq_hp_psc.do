* File name: g_3_PennWorldTable_combine_gdppc_eq_hp_psc.do
* Description: merge all processed data together
* Author: Shijie Shi
* Last updated: 09/11/2018
	
quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	cd "`projFolder'"

	
	* 1. gdppc annualized aqoq
	use "output/g_1_PennWorldTrade_gdppc_QoQ_Annualized.dta", replace
	keep date - quarter gdppc gdp_count
	rename (gdppc gdp_count) (gdppc_aqoq gdppc_aqoq_n)
	
	local lbl: variable label gdppc_aqoq
	label var gdppc_aqoq_n "[N] `lbl'"
	
	tempfile gdppc_aqoq
	save `gdppc_aqoq', replace
	
	* 2. gdppc yoy
	use "output/g_1_PennWorldTrade_gdppc_YoY.dta", replace
	keep date gdp_count gdppc_yoy
	rename gdp_count gdppc_yoy_n
	
		split date, parse(Q)
		rename date1 year
		rename date2 quarter
		destring year quarter, replace
		drop date
		gen date = yq(year,quarter)
		format date %tqCCYY!Qq
	
	label var gdppc_yoy "Per capita GDP growth rate, const sample, yoy. Source: gdpsa. Weight_Pop: PWT"
	local lbl: variable label gdppc_yoy
	label var gdppc_yoy_n "[N] `lbl'"
		
	tempfile gdppc_yoy
	save `gdppc_yoy', replace
	
	use `gdppc_aqoq', replace
	merge 1:1 date using `gdppc_yoy', assert(3)
	drop _merge
	
	* 3. eq, hp, psc, annualized anqoq
	
	merge 1:1 date using "output/g_1_PennWorldTrade_eq_hp_psc_QoQ_Annualized.dta", ///
								keepusing(*_aqoq *_aqoq_n) assert(3)
	drop _merge
	
	* 4. eq, hp, psc, yoy
	merge 1:1 date using "output/g_1_PennWorldTrade_eq_hp_psc_YoY.dta", ///
								keepusing(*_yoy *_yoy_n) assert(3)
	drop _merge
	
	order date - quarter gdppc* reqsa* rhpsa* rpsc*
	
	tsset date
	sort date
	save output/PWT_combine_gdppc_eq_hp_psc.dta, replace
}
