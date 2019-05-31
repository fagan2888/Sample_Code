quietly{
	* File name: 6_1_mark_cycles_duration_amp_slope.do
	* Description: create variables
	*			   `i'_incom: incomplete cycles
	*			   `i'_comP : complete cycles, peak - trough - peak
	*			   `i'_comT : complete cycles, trough - peak - trough
	*			   `i'_duration : duration of a recession / expansion 
	*			   `i'_amp : amplitudes of contractions and expansions
	*			   `i'_slope : slopes of contractions and expansions
	* Data source: `date'_5_1_merge_gdp_eq_hp_cr.dta
	* Author: Shijie Shi 
	* Last updated: 2019/04/24

	clear all 
	set more off

	local date "201904"
	local projFolder "R:/Shi/Project_Confidence"
	local outputFolder "`projFolder'/output/`date'"

	cd "`outputFolder'"

	* open the merged data
	use `date'_5_1_merge_gdp_eq_hp_cr.dta
	*use "R:/Shi/Project_Confidence/fromNao/2018 update/Data/bones.dta" 
	sort ifscode date

	tsset ifscode date	
	sum if advanced==. & emergingall ==. & developing ==., meanonly	
	if r(N)!=0 { // check coverage
		n tab country if advanced==. & emergingall ==. & developing ==.
		n di "The countries above are not assigned to any country group."
		exit 
	}
	
	tempfile full
	save `full', replace
	
	
	local var gdp cr eq hp	
	
	* Mark the cycles
	foreach i of local var {
		n di "`i'"
		
		use `full', replace
		keep ccode - date `i'_new l_`i'_new_point
		keep if l_`i'_new_point !=.
		
		sort ccode date
		
		* incomplete cycles
		by ccode: egen int `i'_incom=seq()	
		
		* duration
		by ccode: gen int `i'_duration = date[_n+1] - date
		
		
		* amplitudes
		sort ccode date
		if ( "`i'" == "gdp") | ( "`i'" == "cr") { // gdp, cr, in Logs
			by ccode: gen double `i'_amp = ( `i'_new[_n+1] - `i'_new ) * 100
		}
		else { // eq, hp, index 2010=100
			by ccode: gen double `i'_amp = (`i'_new[_n+1] - `i'_new)  / `i'_new  * 100
		}
		
		
		* slope
		by ccode: gen double `i'_slope = `i'_amp / `i'_duration
		
		
		* complete cycles
		levelsof ccode, local(ccodes)
		
		local n=0
		foreach j of local ccodes {
			preserve
				keep if ccode=="`j'"
				sum `i'_incom, meanonly
				
				// cycle starts with a peak, more than one turning point
				if ( l_`i'_new_point[1]==1 ) & ( r(max)>1 ) { 
					
					// cycle ends with a peak
					if mod( r(max), 2)==1 {
						gen double `i'_comP = `i'_incom
						gen double `i'_comT = `i'_incom - 1 if (`i'_incom > 1 & `i'_incom < r(max) )
					}
					else { //ends with a trough
						gen double `i'_comP = `i'_incom if `i'_incom < r(max)
						gen double `i'_comT = `i'_incom - 1 if `i'_incom > 1 
					}
				}
				
				// cycle starts with a trough, more than one turning point
				if ( l_`i'_new_point[1]==-1 ) & ( r(max)>1 ) { 
					
					// cycle ends with a trough
					if mod( r(max), 2)==1 {
						gen double `i'_comP = `i'_incom - 1 if (`i'_incom > 1 & `i'_incom < r(max) )
						gen double `i'_comT = `i'_incom
					}
					else { //ends with a peak
						gen double `i'_comP = `i'_incom - 1 if `i'_incom > 1 
						gen double `i'_comT = `i'_incom if `i'_incom < r(max)
					}
				}
				
				local n = `n' + 1
				tempfile `i'_`n'
				save ``i'_`n'', replace
			restore
		}
		
		use ``i'_1', clear
		
		forval j = 2/`n'{
			append using ``i'_`j''
		}

		gen double `i'_peak = `i'_new if l_`i'_new_point==1
		
		sort ccode date 
		by ccode: replace `i'_peak = `i'_peak[_n-1] if `i'_peak==. & `i'_peak[_n-1] !=. & l_`i'_new_point ==-1
		
		sort ccode date
		save `date'_6_1_mark_cycles_duration_amp_slope_`i', replace
		
	}
	
	n di "Data saved in `outputFolder'"
}



