* File name: c_0_agg_updData_Q_wld_adv_emd.do
* Description: Aggregate the quarterly data
* Author: Shijie Shi (much credit to Nao's original contribution)
* Last updated: 08/07/2018

set more off
clear all


quietly{
	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/"

	cd "`projFolder'"

	* 1. Read in the quarterly data
	use "20180712 AK's book/output/data_AK's book.dta", replace

	* 2. Merge in weight variables -pppwgt- and -ngdpd- and 
	*	 dummies for World, AEs and EMDEs
	merge m:1 ccode year using "original/data_update_2018apr_sample.dta", ///
		keepusing(pppwgt ngdpd wld adv emd)
	drop if _merge==2
	drop _merge
dddddddddd	
	* 3. Aggregate by each country group
	n xtset
		local pvar = r(panelvar)
		local tvar = r(timevar)
	
	bysort year: egen double totngdpd = total(ngdpd), missing
	gen double wtotngdpd = ngdpd / totngdpd
	
	sort `pvar' `tvar'
	gen double ngdpd_tot = wtotngdpd + L4.wtotngdpd + L8.wtotngdpd
	gen double ngdpd_avg = ngdpd_tot / 3
	
	local n = 0
	local group "wld adv emd"
	
	foreach g of local group{
		
		preserve
			keep if `g'==1
			
			gen double inflqoq = ((cpi / L1.cpi) - 1) * 100
			
			*local vars "rcredit hp sp cpi oilsa foodsa goldsa ip";
			local vars "cpi ip hp sp rcredit foodsa oilsa goldsa"
			foreach v of local vars{
				sort `pvar' `tvar'
				gen double `v'yoy = ((`v' / L4.`v') - 1) * 100
				gen double `v'qoq = ((`v' / L1.`v') - 1) * 100
			}

			gen double inflyoy = cpiyoy - L4.cpiyoy
			replace inflyoy = . if (year>=1988 & year<=1994) & ///
						(ccode=="PER" | ccode=="BRA" | ccode=="ARG" | ccode=="VEN")
			
			gen double wldinflyoy = ((wldcpi / L4.wldcpi) - 1) * 100

			local vars2 "oilsa foodsa goldsa"
			foreach v of local vars2{
				gen double `v'_gr = ( (1 + `v'yoy/100) / (1 + wldinflyoy/100) - 1 ) * 100
			}
			
			gen double nominal_oilsa_gr = oilsayoy
			
			local vars_int "rir rstn"
			foreach v of local vars_int{
				gen double `v'yoy = `v' - L4.`v'
			}
			
			sort `pvar' `tvar'
			
			local varsmrk "rcredit hp sp ip"
			local varsppp "rcredit hp sp ip"
			local varsmrk2 "rstn cpiyoy rir inflyoy riryoy rstnyoy"
			local comm "oilsa foodsa goldsa"
			
			gen double liboryoy = libor - L4.libor
			
			foreach v of local varsppp{
				gen double pppwgt`v' = pppwgt
					replace pppwgt`v' = . if `v'yoy==.

				egen double totpppwgt`v' = total(pppwgt`v'), by(`tvar') missing
				gen double wpppwgt`v' = pppwgt`v' / totpppwgt`v'

				sort `pvar' `tvar'
				gen double pppwgtprod`v' = wpppwgt`v' * `v'yoy

				egen double pppwgtsumprod`v' = total(pppwgtprod`v'), by(`tvar') missing
			}
			
			foreach v of local varsmrk2{
				gen double pppwgt`v' = pppwgt
					replace pppwgt`v' = . if `v'==.

				egen double totpppwgt`v' = total(pppwgt`v'), by(`tvar') missing
				gen double wpppwgt`v' = pppwgt`v' / totpppwgt`v'

				sort `pvar' `tvar'
				gen double pppwgtprod`v' = wpppwgt`v' * `v'

				egen double pppwgtsumprod`v' = total(pppwgtprod`v'), by(`tvar') missing
			}
			
			foreach v of local varsmrk{
				gen double mrkwgt`v' = ngdpd_avg
					replace mrkwgt`v' = . if `v'yoy==.

				egen double totmrkwgt`v' = total(mrkwgt`v'), by(`tvar') missing
				gen double wmrkwgt`v' = mrkwgt`v' / totmrkwgt`v'

				gen double mrkwgtprod`v' = wmrkwgt`v' * `v'yoy

				egen double mrkwgtsumprod`v' = total(mrkwgtprod`v'), by(`tvar') missing
			}
			
			foreach v of local varsmrk2{
				gen double mrkwgt`v' = ngdpd_avg
					replace mrkwgt`v' = . if `v'==.

				egen double totmrkwgt`v' = total(mrkwgt`v'), by(`tvar') missing
				gen double wmrkwgt`v' = mrkwgt`v' / totmrkwgt`v'
				
				gen double mrkwgtprod`v' = wmrkwgt`v' * `v'

				egen double mrkwgtsumprod`v' = total(mrkwgtprod`v'), by(`tvar') missing
			}
			
			
			keep year quarter date libor liboryoy oilsa_gr goldsa_gr foodsa_gr ///
					mrkwgtsumprod* pppwgtsumprod* nominal_oilsa_gr wldinflyoy
			duplicates drop
	
			sort date
			local n = `n' + 1
			if `n'==1{
				export excel "`outputFolder'/c_0_agg_updData_Q_wld_adv_emd.xlsx", ///
										sheet("`g'") firstrow(variable) replace
			}
			else{
				export excel "`outputFolder'/c_0_agg_updData_Q_wld_adv_emd.xlsx", ///
										sheet("`g'") firstrow(variable)
			}

			saveold "`outputFolder'/c_0_agg_updData_Q_`n'_`g'.dta", replace
		
		restore
		
	} // End of "foreach g"

	
}
