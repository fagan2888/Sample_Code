* File name: 2_calc_nsa_0_house.do
* Description: Get the non-seasonal adjusted GDP data ready for further seasonal adjustment.
* Author: Shijie Shi
* Last updated: 2018/07/23

clear all
set more off

quietly{

	local date "201902"
	local base 2010
	local projFolder "R:/Shi/Project_Business Financial Data"
	local dataFolder "R:/Shi/Project_Business Financial Data/output/`date'"
	local outputFolder "R:/Shi/Project_Business Financial Data/output/`date'/dta"

	local CUTOFF = yq(2010, 1)

	cd "`dataFolder'"

	* Step 1: Extract data
		use `date'_GDP_HA_GDP_Q.dta, clear
		
		drop S* H* Z*
		* (S* H* Z* are seasonal-adjusted data, no need for further process)

	* Step 2: Data extension
	
		* Note: Below is the variable sequence following the do-file line
		*		local pvar `1' //"ccode"
		*		local tvar `2'	//"date"
		*		local data1 `3'	//"base data series" 
		*		local data2 `4'	//"data series 2"
		*		local final `5'	//"final data series"
		gen gdpnsa = .
		gen str gdpnsa_source = ""
		n di "Processing NNGPC and NNGPCX to get gdpnsa"
		do "`projFolder'/do/extending data series2.do" ccode date NNGPC NNGPCX gdpnsa
		n tab gdpnsa_source

		n di "Processing gdpnsa and ONGPCX to get gdpnsa"
		do "`projFolder'/do/extending data series1.do" ccode date gdpnsa ONGPCX gdpnsa
		* (when extrapolating targe are the same as one of the input series, use extending data series1.do)
		n tab gdpnsa_source

	* Step 3: Sample period
		keep if year>=1960

		preserve
			keep ccode ifscode country
			duplicates drop
			sort ifscode
			tempfile ccode
			save `ccode', replace
		restore
		
		tsset ifscode date
		drop ccode country
		tsfill, full

		merge m:1 ifscode using `ccode', assert(3)
			tab _merge
			drop _merge
			
		replace year = year(dofq(date)) if year==.
		replace quarter = quarter(dofq(date)) if quarter==.

		compress _all
		order ccode ifscode country date year quarter
		sort ifscode date
		label var gdpnsa "Gross domestic product, level, NSA"
		label var gdpnsa_source "[Note] Gross domestic product, NSA"
	
	* Step 4: Remove gaps
		* remove gaps.do
		* Note: Below is the sequence of the variables following the do-file line
		* 		local pvar `1' //"ccode"
		* 		local tvar `2'	//"date"
		* 		local var `3'	// the target variable
		* 		local var_source `4'	// the source of target variable
		* 		local CUTOFF `5' // the cutoff date
		do "`projFolder'/do/remove gaps.do" ccode date gdpnsa gdpnsa_source `CUTOFF'
		n tab gdpnsa_source
		
	* Step 5: generate gdpnsa.csv file
		preserve
			xtset, clear
			keep ccode date gdpnsa

			egen count = count(gdpnsa), by(ccode)
			drop if count<=12 //For SA, data at least over three years are needed *
			drop count

			reshape wide gdpnsa, i(date) j(ccode) string

			renpfix gdpnsa

			tsset date, quarterly

			sort date
			egen rown = rownonmiss(???)
			egen seq = seq() if rown!=0

			sum date if seq==1
			drop if date<r(mean)
			drop rown seq

			sort date
			export delimited using sadj\fin\gdpnsa.csv, replace

		restore

		compress _all
		rename gdpnsa_source gdpnsa_note
		sort ifscode date
		save "`outputFolder'/`date'_gdp_nsa.dta", replace
		n di "Finished: Data are saved in `outputFolder'/`date'_gdp_nsa.dta"
}
