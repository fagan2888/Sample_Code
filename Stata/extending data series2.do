* File name: extending data series.do
* Description: With two data series, Use the longer series as the base, 
*			   forward and backward extrapolate the base with the second series.
* Author: Shijie Shi
* Last updated: 2018/06/04

* Note: This is a helper function that needs to be used with other do files.

local pvar `1' //"ccode"
local tvar `2'	//"date"
local data1 `3'	//"data series 1"
local data2 `4'	//"data series 2"
local final `5'	//"final data series"


****** Step 2: For each panel variable, find the length of two data series
sort `pvar' `tvar'

egen group = group(`pvar')
tsset group `tvar'

bysort group: egen length1 = count (`data1') 
bysort group: egen length2 = count (`data2') 

****** Step 3.1: For each panel variable, define the longer series data as the base
sum group, meanonly
local group_max = r(max) 

forval i = 1 / `group_max' {
	preserve
		keep if group == `i'

		if length1 >= length2 {	// if data1 is equal to or longer than data2, use data1 as the base
			local base = "`data1'"
			local basesource = "`data1'"
			
			local helper = "`data2'"
			gen double lg_`data2' = log(`data2')
			gen double gr_`data2' = D.lg_`data2'
		}
		else { 					// if data1 is shorter than data2, use data2 as the base			
			local base = "`data2'"
			local basesource = "`data2'"
			
			local helper = "`data1'"
			gen double lg_`data1' = log(`data1')
			gen double gr_`data1' = D.lg_`data1'
		}
		
		egen seq_b = seq() if `base' !=.
		egen seq_h = seq() if `helper' !=.
		
		sum seq_b, meanonly
		gen start_b = date if seq_b==1
		gen end_b = date if seq_b==r(max)
		egen start_b1 = mean(start_b)
		egen end_b1 = mean(end_b)
		
		sum seq_h, meanonly
		gen start_h = date if seq_h==1
		gen end_h = date if seq_h==r(max)
		egen start_h1 = mean(start_h)
		egen end_h1 = mean(end_h)
	
****** Step 3.2: For each panel variable, use the helper variable to extend the base variable
		replace `final' = `base'
		replace `final'_source = "`basesource'" if `base' !=.
			
		// if base and helper do not overlap
		if start_b1 > end_h1 | end_b1 < start_h1 { 
			// do nothing
		}
		
		local length = _N
		// backward extrapolation & fill in missing values in `final' using the growth rate of `helper' variable 
		forvalues j = `length'(-1)1{
			replace `final' = exp(log(F1.`final') - F1.gr_`helper') if `final'==. & _n==`j' & F1.gr_`helper' !=.
			replace `final'_source = "extrapolated by " +  "`helper'" if `final'_source=="" & _n==`j' & F1.gr_`helper' !=. & `final' !=.
		}

		// forward extrapolation & fill in missing values in `final' using the growth rate of `helper' variable 
		forvalues j = 1/`length'{
			replace `final' = exp(log(L1.`final') + gr_`helper') if `final'==. & _n==`j' & gr_`helper' !=.
			replace `final'_source = "extrapolated by " +  "`helper'" if `final'_source=="" & _n==`j' & gr_`helper' !=. & `final' !=.
		}
			
		replace `final'_source = ""  if `final' ==. 
		
		tempfile tmp`i'
		save `tmp`i'', replace
	restore
}

****** Step 4: put each country file together
use `tmp1', replace
forval i =  2 / `group_max' {
	append using `tmp`i''
}

drop seq* start* end* gr_* lg_* length* group
