* File name: i_2_WDI_WEO_AK_unem.do
* Description: Labor force data from WEO. For 1970-1980, extrapolate back using
*			   AK's data
* Author: Shijie Shi
* Last updated: 10/01/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	cd "`projFolder'"
	local T = 4

	
	use "output/WDI_unem.dta"
	merge 1:1 ccode year using "output/i_1_WEO_extend_by_AK_labor_force.dta", keepusing(lf) 
	drop if _merge==2
	drop _merge
	
	gen count = 1 if unem!=. & lf!=.
	
	sort ccode year
	
	* Aggregate by labor force
	collapse (sum) count (mean) unem [aw=lf], by(year)
	
	save output/i_2_WDI_WEO_AK_unem_agg, replace

	* Event study
	rename unem unemp
	tsset year, yearly
	local tvar = r(timevar)
	
	local m = 1
	local vars "unemp"
	foreach x of local vars{
		local lbl_`x': variable label `x'

		local n = 0
		foreach y in 1975 1982 1991 2009{
			preserve

				tsset year, yearly
					local tvar = r(timevar)

				keep `tvar' `x'
				sort `tvar'

				if "`x'"=="kflow" | "`x'"=="unemp"{
					gen double `x'_`y' = `x' if `tvar'==`y'
					gen tvar = 0 if `tvar'==`y'

					forvalues i = 1/`T'{
						replace `x'_`y' = `x' if `tvar'==`y' - `i'
						replace `x'_`y' = `x' if `tvar'==`y' + `i'

						replace tvar = -`i' if `tvar'==`y' - `i'
						replace tvar = `i' if `tvar'==`y' + `i'
					}
					
				}

				keep if tvar>=-`T' & tvar<=`T'

				keep tvar `x'_`y'
				label var `x'_`y' "`lbl_`x'', `y'"

				compress _all
				order tvar
				
				sort tvar
				
				local n = `n' + 1

				tempfile `x'_`n'
				save ``x'_`n'', replace
				
			restore
		}

		preserve
		
			use ``x'_1', clear
			if `n'>=2{
				forvalues i = 2/`n'{
					merge 1:1 tvar using ``x'_`i''
						tab _merge
						drop _merge
				}
			}

			egen double `x'_avg = rowmean(`x'_????)
			egen double `x'_avg2 = rowmean(`x'_19??)
				label var `x'_avg "`lbl_`x'', average of four recessions"
				label var `x'_avg2 "`lbl_`x'', average of three recessions (excl. 2009)"

			label var tvar "Time"

			sort tvar
			if `m'==1{
				export excel using "`outputFolder'/c_1_Fig5.1_paperFig4A_WDI_WEO_AK_`x'_agg.xlsx", sheet("`x'") firstrow(varlabel) replace
			}
			else{
				export excel using "`outputFolder'/c_1_Fig5.1_paperFig4A_WDI_WEO_AK_`x'_agg.xlsx", sheet("`x'") firstrow(varlabel)
			}

			local m = `m' + 1

		restore
		
	} // End of "foreach x of local vars"

	/*
	* 2. Prepare data for R
	foreach var in "unem" "lf" {
		preserve
			keep ccode year `var'
			sort year ccode
			reshape wide `var', i(ccode) j(year)
			export delimited using "output/i_2_WDI_WEO_AK_`var'.csv", replace
		restore
	}
	*/
}

	


