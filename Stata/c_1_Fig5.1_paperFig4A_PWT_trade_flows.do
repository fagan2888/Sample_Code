* File name: c_1_Fig5.1_paperFig4A_PWT_trade_flows
* Description: use YEARLY data to update AK's book Fig 5.1 Trade flows (paper Fig 4A)
* Author: Shijie Shi (much credit to Nao's original work)
* Last updated: 09/26/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local T = 4

	cd "`projFolder'"
	
	use "output/h_1_PennWorldTable_trade_flows.dta", clear
	destring year, replace
	rename trade_gr pwt_tr
	
	tsset year, yearly
	local tvar = r(timevar)
	
	local m = 1
	local vars "pwt_tr"
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
				else{
					gen double `x'_`y' = 100 if `tvar'==`y' - 1
					gen tvar = 0 if `tvar'==`y'

					local t= `T' + 1
					forvalues i = 1/ `t' {
						replace `x'_`y' = f1.`x'_`y' / ( f1.`x'/100 + 1) if `tvar'==`y' - `i' - 1
						replace `x'_`y' = l1.`x'_`y' * ( `x'/100 + 1) if `tvar'==`y' + `i' - 1

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
				export excel using "`outputFolder'/c_1_Fig5.1_paperFig4A_PWT_trade_flows.xlsx", sheet("`x'") firstrow(varlabel) replace
			}
			else{
				export excel using "`outputFolder'/c_1_Fig5.1_paperFig4A_PWT_trade_flows.xlsx", sheet("`x'") firstrow(varlabel)
			}

			local m = `m' + 1

		restore
		
	} // End of "foreach x of local vars"
	
}	
