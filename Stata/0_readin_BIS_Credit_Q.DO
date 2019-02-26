* File name: 1_readin_BIS_Credit.do
* Description: Read in the spreadsheet, re-organize data for later computation
* Data source: https://www.bis.org/statistics/full_data_sets.htm
*			   ("Credit to the non-financial sector")
* Author: Shijie Shi (Much credit to Nao's original work)
* Last updated: 2018/09/11

clear all
set more off

local projFolder "R:\Shi\Project_Business Financial Data"
local dataFolder "R:\Shi\Project_Business Financial Data\original\BIS\Credit\201805"
local fileName "WEBSTATS_TOTAL_CREDIT_DATAFLOW_csv_col.csv"
local outputFolder "R:\Shi\Project_Business Financial Data\output\201805"
local date "201805"
 
cd "`projFolder'"

quietly{

	import delimited using "`dataFolder'\\`fileName'", varnames(nonames)

	preserve

		keep in 1

		gen t = 1
		reshape long v, i(t) j(num)
		
		split v, parse(-Q)
		gen v3= "_"+v1+v2
		replace v3 = strtoname(v3)
		count
		local varn = r(N)
		forvalues i = 1/`varn'{
			local num`i' = num[`i']
			local var`i' = v3[`i']
		}
		
	restore
	
	drop in 1
	
	forvalues i = 1/`varn'{
		rename v`num`i'' `var`i''
	}
	
	
	* Make sure the frequency of the data are unified
	noisily tab _Frequency
	if r(r)!=1{
		error 1
	}
	else{
		drop _Frequency
	}
	
	noisily tab _FREQ
	if r(r)!=1{
		error 1
	}
	else{
		drop _FREQ
	}
	
	egen seq=seq()
	reshape long _, i(seq) j(date)
	
	noisily display "Step (1/4): The whole dataset has been succefully reshaped."
	noisily display "            Start generating each variable."
	*save tmp, replace
	
	*use tmp, replace
	destring _, replace
	tab seq
	local max = r(r)
	
	forval i = 1 / `max'{
		preserve
			
			keep if seq == `i'
			
			if _UNIT_TYPE[1]=="USD" | _UNIT_TYPE[1]=="XDC"{
				replace _ = _ * (10^9)  /* The original values are in billions */
			}
		
			local var`i' = strtoname( lower(_TC_BORROWERS[1]+_TC_LENDERS[1]+_VALUATION[1] + ///
												_UNIT_TYPE[1]+_TC_ADJUST[1]) )
			local var1Label = "Credit from " + _Lending_sector[1] + " to " ///
												+ _Borrowing_sector[1] + ", " + _Unit_type[1] + ", " ///
												+ _Type_of_adjustment[1]
			rename _  `var`i''
			label var `var`i'' "`var1Label'"
			keep _BORROWERS_CTY _Borrowers__country date `var`i''
			tempfile tmp_`i'
			save `tmp_`i'', replace
				
		restore
	}
	
	noisily display "Step (2/4): All variables have been successfully generated and labeled."
	noisily display "            Start merging files."

	use `tmp_1', replace
	forval i = 2 / `max'{
		merge 1:1 _BORROWERS_CTY date using `tmp_`i'', update
		tab _merge
		drop _merge
	}
	
	noisily display "Step (3/4): All files have been merged."
	noisily display "            Start organizing dataset."
	
	replace _BORROWERS_CTY = "5C" if _BORROWERS_CTY=="XM"	/* Euro Area */
	rename _BORROWERS_CTY biscode
	merge m:m biscode using R:\Shi\countrycodes, keepusing(ccode ifscode country)
		tab _merge
		noisily tab _Borrowers__country if _merge==1
		keep if _merge==3
		drop _merge
	drop biscode _Borrowers__country
	
	gen year = floor(date/10)
	gen quarter = mod(date, 10)
	drop date
	gen date = yq(year,quarter)
	format date %tqCCYY!Qq
	
	compress _all
	order _all, alpha
	order ccode ifscode country date year quarter
		label var ccode "Country Code"
		label var ifscode "IMF Country Code"
		label var country "Country"
		label var date "Date"
		label var year "Year"
		label var quarter "Quarter"
	sort ccode date
	
	save "`outputFolder'\\\`date'_BIS_CREDIT_Q", replace

	noisily display "Step (4/4): Finished: Data are saved in `outputFolder'\\`date'_BIS_CREDIT_Q.dta"
}
