quietly{
	* File name: 6_2_cumulative_loss.do
	* Description: create variables
	*			   `i'_closs "Cumulative loss of a recession"
	* Data source: `date'_6_1_mark_cycles_duration_amp_slope_`i'.dta
	*			   `date'_5_1_merge_gdp_eq_hp_cr.dta
	* Author: Shijie Shi 
	* Last updated: 2019/05/06

	clear all 
	set more off

	local date "201904"
	local projFolder "R:/Shi/Project_Confidence"
	local outputFolder "`projFolder'/output/`date'"

	cd "`outputFolder'"

	local var gdp cr eq hp	
	foreach i of local var {
		n di "`i'"
		
		use `date'_5_1_merge_gdp_eq_hp_cr.dta
		merge 1:1 ccode date using `date'_6_1_mark_cycles_duration_amp_slope_`i', assert(1 3)
		drop _merge
		
		keep ccode - date *`i'_*  advanced - developing
	
		gen int `i'_recession = l_`i'_new_point
		
		* mark recession period
		tsset ifscode date
		by ifscode: replace `i'_recession = . if `i'_recession==1 & `i'_duration==. // edge condition: last unfinished cycle
		by ifscode: replace `i'_recession = 1 if L.`i'_recession==1 & `i'_recession==.
		by ifscode: replace `i'_recession = . if `i'_recession==-1 & L.`i'_recession==. 
		
		by ifscode: replace `i'_peak = L.`i'_peak if `i'_recession!=. & L.`i'_recession!=.
		replace `i'_peak = . if `i'_recession==.
		
		
		if ( "`i'" == "gdp") | ( "`i'" == "cr") { // gdp, cr, in Logs
			gen double loss = `i'_new - `i'_peak
		}
		else { // eq, hp, index 2010=100
			gen double loss = ln(`i'_new) - ln(`i'_peak)
		
		}		
		
		tempfile tmp
		save `tmp', replace
	
		keep if loss == 0
		sort ccode date
		egen seq=seq()
		keep ccode date seq
	
		tempfile recess
		save `recess', replace
		
		use `tmp', replace
		merge 1:1 ccode date using `recess', assert(1 3)
		drop _merge
		
		tsset ifscode date
		replace seq = L.seq if L.seq!=. & seq==. & loss!=.
		
		bysort ifscode seq: egen double `i'_loss = total(loss), missing
		replace `i'_loss = `i'_loss * 100	
	
		tsset ifscode date
		
		keep if loss==0
	
		keep ccode date `i'_loss
		
		tempfile loss
		save `loss', replace		
		
		use `date'_6_1_mark_cycles_duration_amp_slope_`i', replace
		merge 1:1 ccode date using `loss', assert(1 3)
		drop _merge 
		
		gen double `i'_closs = `i'_loss - (`i'_amp)/2
		drop `i'_new `i'_peak `i'_loss 
		
		merge m:1 ifscode using "`projFolder'/fromNao/2018 update/Data/group_codes.dta", assert(2 3)
		drop if _merge==2
		drop _merge
	
		label variable `i'_incom "Incomplete cycles"
		label variable `i'_duration "Duration of a recession/expansion "
		label variable `i'_amp "Amplitude of a recession/expansion"
		label variable `i'_slope "Slope of a recession/expansion"
		label variable `i'_comP "Complete cycles, PTP"
		label variable `i'_comT "Complete cycles, TPT"
		label variable `i'_closs "Cumulative loss of a recession"
		
		compress _all
		order ccode - date l_`i'_new_point `i'_*com* `i'*
		sort ccode date
		gen int all = 1
		save `date'_6_2_cumulative_loss_`i'.dta, replace
	}
}



