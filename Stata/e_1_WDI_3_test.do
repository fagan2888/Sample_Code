quietly{

	local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival"
	local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output"
	
	cd "`projFolder'"
	*use "output\WDI_gdp_pop_extended.dta", clear
	*capture drop if country == "European Union"
	
	
	use "original\data_update_2018apr_sample.dta", clear
	rename (pppwgt population) (pppgdp lp)
	
	n replace ngdpr=. if lp == . | pppgdp == .
	n replace lp=. if ngdpr == . | pppgdp == .
	n replace pppgdp=. if ngdpr == . | lp == .
	

	xtset ifscode year
	
	by ifscode: gen gr = ( ngdpr / l1.ngdpr - 1 ) *  100

	gen mark =1 if year==1991
	br country year ngdpr pppgdp lp gr mark if ccode=="SAU"
	/*
	keep if year==1991
	
	gsort -gr
	br country year ngdpr pppgdp lp gr
	*/
}
