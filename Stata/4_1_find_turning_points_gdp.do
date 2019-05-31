* File name: 4_1_find_turning_points_gdp.do
* Description: Find turining points in GDP
* Data source: 
* Author: Shijie Shi 
* Last updated: 2019/04/23

clear all 
set more off

local date "201904"
local projFolder "R:/Shi/Project_Confidence"
local outputFolder "`projFolder'/output/`date'"

cd "`outputFolder'"

quietly{
	
	local var gdp_new
	
	
	*use "R:\Shi\Project_Confidence\fromNao\2018 update\Data\Data from Nao\gdp_updated_v2.dta"
	use `date'_3_1_calc_gdp.dta
	sort ccode date

	*gen l_`var' = log(100000*`var')
	gen l_`var' = `var' //already in logs
	
	levelsof ccode, local(countries)
	
	local n = 0
	foreach i in `countries' {
		preserve
		
			keep if ccode == "`i'"			
			capture sbbq l_`var', p(2) c(5) w(2)
			
			if _rc == 0 {
				keep if l_`var'_point!=0
				sort ccode date
				
				replace l_`var'_point=. if (l_`var'_point==1 & l_`var'_point[_n+1]==-1 & `var' < `var'[_n+1]) 

				replace l_`var'_point=. if (l_`var'_point==-1 & l_`var'_point[_n-1]==. & `var' > `var'[_n-1])
				keep if l_`var'_point!=.
				
				keep l_`var'_point ccode country date
				sort country date
				
				local n = `n' + 1
				tempfile tmp`n'	
				save `tmp`n'', replace
							
			}
			else {
				n di "`i': no turning point, `var'"
			}
			
		restore		
	}
	
	use `tmp1', replace
	
	forval i = 2/`n' {
		append using `tmp`i''
	}
	
	sort country date
	format date %tq
	
	tempfile gdp
	save `gdp', replace
	
	clear 
	
	* Special cases
	*	l_gdp_new_point=1 if ccode=="USA" & date==q(1960q1)
	*	l_gdp_new_point=1 if ccode=="USA" & date==q(2000q4)
	*	l_gdp_new_point=-1 if ccode=="USA" & date==q(2001q3)
	
	input str3 ccode str20 country year quarter l_gdp_new_point
	"USA" "United States" 1960 1 1
	"USA" "United States" 2000 4 1
	"USA" "United States" 2001 3 -1
	end
	gen date= yq(year, quarter)
	format date %tq
	drop year quarter

	
	append using `gdp'
	sort ccode date
		
	*keep if date<=yq(2017, 3)
	save `date'_4_1_find_turning_points_gdp,replace
	
	*save helper_4_find_turning_points_GDP_2019_1m,replace
	*save helper_4_find_turning_points_GDP_2018_1m,replace

}



