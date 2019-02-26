* File name: j_3_WEO_WDI_AK_unem_agg_paperFig_4C_5C_unem_ae_emde.do
* Description: unemployment rate: WEO_extend_by_WDI
*			   labor force: WEO_extend_by_AK_labor_force
* Author: Shijie Shi
* Last updated: 10/02/2018

*!!!!! need to change the country group in local to get data for AE and EMDE

set more off
clear all
	
*local group "ae"
local group "emde"


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	cd "`projFolder'"
	local T = 4

	* unemployment rate
	use "output/j_1_WEO_extend_by_WDI_unem.dta"
	keep ccode year unemp

	* labor force
	merge 1:1 ccode year using "output/i_1_WEO_extend_by_AK_labor_force.dta", keepusing(lf)
	drop if _merge==2
	drop _merge
	
	gen count = 1 if unemp!=. & lf!=.
	
	sort ccode year
	
	drop if ccode=="EUR" | ccode=="EUU"

	* merge in AE, EMDE categories
	merge m:1 ccode using "R:\Shi\Stata\data\countrycodes.dta", keepusing(ifscode)
	drop if _merge==2
	drop _merge
	
	tsset ifscode year
	tsfill, full
	drop ccode
	
	merge m:1 ifscode using "R:\Shi\Stata\data\countrycodes.dta", keepusing(ccode country)
	drop if _merge==2
	drop _merge
	
	merge m:1 ccode using "R:\Shi\Stata\data\AEs_NS.dta"
	drop if _merge==2
	drop _merge

	merge m:1 ccode using "R:\Shi\Stata\data\EMDEs_NS.dta", keepusing(emde)
	drop if _merge==2
	drop _merge

	keep if `group' == 1


	* Aggregate by labor force
	
	
			collapse (sum) count (mean) unemp [aw=lf], by(year)
			
			export excel "output/j_3_WEO_WDI_AK_unem_agg_`group'.xlsx", firstrow(variables) replace

			* Event study
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
						export excel using "`outputFolder'/c_1_Fig5.4_Fig6.4_paperFig4C_5C_WDI_WEO_AK_unemp_j_3_`group'.xlsx", sheet("`x'") firstrow(varlabel) replace
					}
					else{
						export excel using "`outputFolder'/c_1_Fig5.4_Fig6.4_paperFig4C_5C_WDI_WEO_AK_unemp_j_3_`group'.xlsx", sheet("`x'") firstrow(varlabel)
					}

					local m = `m' + 1

				restore
			
		} // End of "foreach x of local vars"
		
}

	


