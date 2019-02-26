* File name: c_1_Fig5.2_paperFig4B_update.do
* Description: use QUARTERLY data to update AK's book Fig 5.2 (paper Fig 4.B)
* Author: Shijie Shi (much credit to Nao's original work)
* Last updated: 08/08/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"
	local T = 4

	cd "`projFolder'"
	
	use "output/c_0_agg_updData_Q_1_wld.dta", clear
	keep date year quarter mrkwgtsumprodrcredit mrkwgtsumprodsp mrkwgtsumprodhp
	sort year
	tempfile wld
	save `wld', replace

	use "output/c_0_agg_updData_Q_2_adv.dta", clear
	keep date year quarter mrkwgtsumprodrstn mrkwgtsumprodrir mrkwgtsumprodcpiyoy
	sort year
	tempfile adv
	save `adv', replace

	use `wld', clear
	merge 1:1 date using `adv', assert(3)
	tab _merge
	drop _merge
	
	rename mrkwgtsumprodrcredit psc
	rename mrkwgtsumprodsp spr
	rename mrkwgtsumprodhp hsepr
	rename mrkwgtsumprodrstn nir
	rename mrkwgtsumprodrir rir
	rename mrkwgtsumprodcpiyoy infl
	
	collapse (mean) psc spr hsepr nir rir infl, by(year)
	
	*drop if year>=2015
	
	tsset year, yearly
	local tvar = r(timevar)

	label var psc "Credit"
	label var spr "Equity prices"
	label var hsepr "House prices"
	label var nir "Nominal shor-term interest rates"
	label var rir "Real short-term interest rates"
	label var infl "Inflation"
	
	local m = 1
	local vars "psc spr hsepr nir rir infl"
	
		foreach x of local vars{
		local lbl_`x': variable label `x'

		local n = 0
		foreach y in 1975 1982 1991 2009{
			preserve
			
				tsset year, yearly
					local tvar = r(timevar)

				keep `tvar' `x'
				sort `tvar'

				if "`x'"=="nir" | "`x'"=="rir" | "`x'"=="infl"{
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
					forvalues i = 1/`t'{
						replace `x'_`y' = f1.`x'_`y' / ((f1.`x' / 100) + 1) if `tvar'==`y' - `i' - 1
						replace `x'_`y' = l1.`x'_`y' * ((`x' / 100) + 1) if `tvar'==`y' + `i' - 1

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
				export excel using "`outputFolder'/c_1_Fig5.2_paperFig4B_update.xlsx", sheet("`x'") firstrow(varlabel) replace
			}
			else{
				export excel using "`outputFolder'/c_1_Fig5.2_paperFig4B_update.xlsx", sheet("`x'") firstrow(varlabel)
			}

			local m = `m' + 1

		restore
		
	} // End of "foreach x of local vars"
	
}	
