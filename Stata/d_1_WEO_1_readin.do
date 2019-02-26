* File name: d_1_WEO_1_readin.do
* Description: Read in WEOApr2018all.xls
* Author: Naotaka Sugawara (edited by Shijie Shi)
* Last updated: 08/10/2018

drop _all
clear all
clear mata
set more off
capture log close
#delimit;

/*--------------------------------------------------------------------------*/

****************************************
** CHANGE OR ADD A DIRECTORY TO WORK IN
****************************************;
local projFolder "R:/Shi/Project_AK's book update_CollapseAndRevival";
local outputFolder "R:/Shi/Project_AK's book update_CollapseAndRevival/output/";

cd "`projFolder'";

/*---------------------------------------------------------------------------*/

quietly{;

	import delimited using original\WEOApr2018all.csv, varname(noname) clear;

	preserve;

		keep in 1;
		tostring _all, replace;

		gen t = 1;
		reshape long v, i(t) j(num);

		replace v = "Series Name" if num==1;
		replace v = strtoname(v);

		count;
		local varn = r(N);
		forvalues i = 1/`varn'{;
			local num`i' = num[`i'];
			local var`i' = v[`i'];
		};

	restore;

	drop in 1;

	forvalues i = 1/`varn'{;
		rename v`num`i'' `var`i'';
	};

	count;
	local nldata = r(N);

	local db = Series_Name[`nldata'];
	gen str db = "`db'";
	split db, gen(db_) parse(", ");
	
	local database = db_2[1];
	local update = db_3[1];

	drop db*;
	drop if ISO=="";
	
	noisily display as text "Data: " as result "`database'" as text ": " as result "`update'";

	preserve;

		gen t = 1;	
		collapse (sum) t, by(Subject_Descriptor WEO_Subject_Code);

		split WEO_Subject_Code, gen(code_) parse("_");
		egen Series_Var = concat(`r(varlist)');

		count;
		local sern = r(N);
		forvalues i = 1/`sern'{;
			local sname_`i' = Subject_Descriptor[`i'];
			local scode_`i' = WEO_Subject_Code[`i'];
			local svar_`i' = Series_Var[`i'];
		};

	restore;

	forvalues i = 1/`sern'{;
		preserve;

			keep if WEO_Subject_Code=="`scode_`i''";
			
			keep Country ISO _????;
				rename Country cname;
				rename ISO ccode;	

			drop if ccode=="";

			reshape long _, i(cname ccode) j(year);

			replace _ = "" if _=="n/a";

			destring _ , force ignore(",") replace;

			noisily confirm numeric variable _;
			
			rename _ `svar_`i'';
			label var `svar_`i'' "`sname_`i'': WEO (`update'): `scode_`i''";

			compress _all;
			order ccode cname year;

			sort ccode year;
			tempfile data_`i';
			save `data_`i'', replace;

		restore;
	};

	use `data_1', clear;

	if `sern'>=2{;
		forvalues i = 2/`sern'{;
			merge 1:1 ccode year using `data_`i'';
				tab _merge;
				drop _merge;
		};
	};
	
	
	replace ccode = "XKX" if cname=="Kosovo";

	merge m:1 ccode using "R:\Shi\Stata\data\countrycodes", keepusing(ifscode country);
		tab _merge;
		noisily tab cname if _merge==1;
		
		keep if _merge==3;
		drop _merge;

	drop cname;

	renvars _all, lower;

	compress _all;
	order ccode ifscode country year;
		label var ccode "Country Code";
		label var ifscode "IMF Country Code";
		label var country "Country";
		label var year "Year";

	sort ifscode year;
	saveold "output\WEOApr2018all.dta", replace;
	
	#delimit cr
}

