drop _all
clear all
clear mata
set more off
capture log close
#delimit;

/*------------------------------------------
*** GLOBAL RECESSIONS AND EXPANSIONS
*** --- ***
*** CALCULATION
*** SHARE OF COUNTRIES IN RECESSIONS
*-------------------------------------------*/

/*--------------------------------------------------------------------------*/

****************************************
** CHANGE OR ADD A DIRECTORY TO WORK IN
****************************************;
cd "R:\Shi\Project_AK's book update_CollapseAndRevival";
	


***************
** DATA FOLDER
***************;
capture mkdir out;

/*---------------------------------------------------------------------------*/

quietly{;
	
	* Read in pwt data;
	use "original\data_pwt_weo2018apr.dta", clear;
	xtset ifscode year;
dddddd	
	*** Remove negative pppgdp weights;
	n replace pppgdp=. if ccode=="BMU" & year >= 1999 & year <= 2003;
	rename (rgdp pop pppgdp) (ngdpr population pppwgt);
	tempfile pwt;
	save `pwt', replace;

	*===* SHARE OF COUNTRIES IN RECESSIONS *===*;
	local aggs "wld adv emd";

	** Unweighted **;
	local n = 1;
	foreach x of local aggs{;
		use `pwt', clear;

		keep if `x'==1;
		local lbl_`x': variable label `x';

		xtset;
			local pvar = r(panelvar);
			local tvar = r(timevar);

		sort `pvar' `tvar';

		gen double pcy = ngdpr / population;
		gen double g = ((pcy / l1.pcy) - 1) * 100;
		label var g "Real GDP per capita growth, %";

		if "`x'"=="wld"{;
			sort `pvar' `tvar';
			tempfile `x'_data;
			save ``x'_data', replace;
		};

		gen `x'_all = 1 if g!=.;
		gen `x'_neg = 1 if g!=. & g<0;

		xtset, clear;

		collapse (sum) `x'_all `x'_neg, by(`tvar');

		replace `x'_neg = . if `x'_all==0;
		recode `x'_all (0 = .);

		label var `x'_all "`lbl_`x'': Growth data";
		label var `x'_neg "`lbl_`x'': Negative per capita growth";

		tsset `tvar', yearly;

		sort `tvar';
		tempfile unwt_`n';
		save `unwt_`n'', replace;

		local n = `n' + 1;
	};

	use `unwt_1', clear;

	local n1 = `n' - 1;
	if `n1'>=2{;
		forvalues j = 2/`n1'{;
			merge 1:1 `tvar' using `unwt_`j'';
				tab _merge;
				drop _merge;
		};
	};

	foreach x of local aggs{;
		gen double sh_`x' = `x'_neg * 100 / wld_all;
		label var sh_`x' "`lbl_`x''";
	};

	drop if sh_wld==.;

	compress _all;
	order `tvar' sh_adv sh_emd sh_wld;

	sort `tvar';

	gen str note = "";
		label var note "Note";
		replace note = "Unweighted: Share of countries in recessions, %" in 1;

	export excel using "output\c_1_Fig7_paperFig6_update_PWT_nonRestricted.xlsx", sheet("unwt_recess") firstrow(varlabel) datestring("%ty") replace;


	** Weighted **;
	use `wld_data', clear;

	sort `pvar' `tvar';

	foreach x of local aggs{;
		gen `x'_neg = 0 if g!=.;
			replace `x'_neg = 1 if g!=. & g<0 & `x'==1;
	};

	gen double wt = pppwgt if wld_neg!=.;

	xtset, clear;

	collapse (mean) *_neg [aw=wt], by(`tvar');

	foreach x of local aggs{;
		rename `x'_neg `x';

		replace `x' = `x' * 100;
		label var `x' "`lbl_`x''";
	};

	tsset `tvar', yearly;

	compress _all;
	order `tvar' adv emd wld;

	sort `tvar';

	gen str note = "";
		label var note "Note";
		replace note = "Weighted by GDP in PPP: Share of countries in recessions, %" in 1;

	export excel using "output\c_1_Fig7_paperFig6_update_PWT_nonRestricted.xlsx", sheet("wt_recess") firstrow(varlabel) datestring("%ty");



	#delimit cr

	** END **
}

