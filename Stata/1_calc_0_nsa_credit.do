* File name: 2_calc_nsa_0_credit.do
* Description: 
* Data source: 
* Author: Naotaka Sugawara (edited by Shijie Shi)
* Last updated: 2018/07/19
drop _all
clear all
clear mata
set more off
capture log close
#delimit;

/*------------------------------------------
*** CONFIDENCE DATABASE
*** --- ***
*** CALCULATION
*** PRIVATE SECTOR CREDIT
*-------------------------------------------*/

/*--------------------------------------------------------------------------*/

****************************************
** CHANGE OR ADD A DIRECTORY TO WORK IN
****************************************;

cd "R:/Shi/Project_Business Financial Data/output/201805";
local CUTOFF = 1980;


***************
** DATA FOLDER
***************;
capture mkdir dta;
capture mkdir sadj;
capture mkdir sadj\fin;

/*---------------------------------------------------------------------------*/

quietly{;
	*===* CALCULATION: PRIVATE SECTOR CREDIT *===*;
	** HA/IFS **;
	
	*read in IFS data downloaded from Haver;
	use 201805_HA_IFS_PSC_Q, clear;
	
	*merge in IFS data downloaded by Nao;
	n merge 1:1 ccode date using 201805_IFS_PSC22D_42D_ZF;
	drop if _merge==2 & year > `CUTOFF';
	n tab _merge;
	drop _merge;
	
	*replace psc22_zf with psc22d_zf when year is early than 1980(the cutoff year);
	*replace psc42_zf with psc42d_zf when year is early than 1980(the cutoff year);
	replace psc22_zf = psc22d_zf if year < `CUTOFF';
	replace psc42_zf = psc42d_zf if year < `CUTOFF';
	
	drop psc22d_zf psc42d_zf;
	
	
	gen curdate = "`c(current_date)'";
	split curdate, gen(curdate_) parse(" ");

	rename curdate_2 cmonth;
	rename curdate_3 cyear;

	gen cquarter = .;
		replace cquarter = 1 if cmonth=="Jan" | cmonth=="Feb" | cmonth=="Mar";
		replace cquarter = 2 if cmonth=="Apr" | cmonth=="May" | cmonth=="Jun";
		replace cquarter = 3 if cmonth=="Jul" | cmonth=="Aug" | cmonth=="Sep";
		replace cquarter = 4 if cmonth=="Oct" | cmonth=="Nov" | cmonth=="Dec";

	destring cyear, replace;

	gen cur_q = yq(cyear,cquarter);

	sum cur_q;
	local prev_q = r(mean) - 1;

	drop curdate* cmonth cyear cquarter cur_q;

	noisily xtset ifscode date, quarterly;
		local pvar = r(panelvar);
		local tvar = r(timevar);

	local psc_vars "psc22_zf psc22_zk psc42_zf psc42_zk";

	* Euro Area *;
	preserve;

		import excel using "R:\Shi\Project_Business Financial Data\original\euro_conv.xlsx", sheet("euro_conv") firstrow clear;

		count;
		local eur_n = r(N);
		forvalues i = 1/`eur_n'{;
			local ecode`i' = ccode[`i'];
			local erate`i' = conv_rate[`i'];
		};

	restore;

	gen byte ea = .;
	forvalues i = 1/`eur_n'{;
		replace ea = 1 if ccode=="`ecode`i''";
	};
	label var ea "Dummy: = 1 for Euro Area";

	* Dummy for breaks *;
	merge 1:1 `pvar' `tvar' using 201805_IFS_PSC_Dummy;
		tab _merge;
		noisily tab country if _merge==1;
		noisily tab country if _merge==2;
		drop if _merge==2;
		drop _merge;

	local pscnum "22 42";
	foreach v of local pscnum{;
		* ZF expressed in legacy currency --> convert to euro *;
		forvalues i = 1/`eur_n'{;
			replace psc`v'_zf = psc`v'_zf / `erate`i'' if ccode=="`ecode`i''";

			if "`ecode`i''"=="CYP"{;
				replace psc`v'_zk = psc`v'_zk / `erate`i'' if ccode=="`ecode`i''" & `tvar'<=q(2005q3);
			};
		};

		* Zambia: Currency redenomination *;
		replace psc`v'_zf = psc`v'_zf / 1000 if ccode=="ZMB";

		* Israel: Data prior to 1978Q1 = not quarterly --> Drop *;
		replace psc`v'_zf = . if ccode=="ISR" & year<=1977;

		* Use ZK as the main series *;
		egen count_1 = count(psc`v'_zk), by(`pvar');
		egen count_2 = count(psc`v'_zf), by(`pvar');

		egen rown = rownonmiss(psc`v'_zk psc`v'_zf);
		egen rownmax = max(rown), by(`pvar');

		noisily tab country if count_1!=0 & count_2!=0 & rownmax!=2 & ea==.;
		noisily tab country if count_1!=0 & count_2!=0 & rownmax!=2 & ea==1;

		gen str psc`v'_zf_use = "";
		label var psc`v'_zf_use "Use of `v'D.ZF";

		replace psc`v'_zk = psc`v'_zf if count_1!=0 & count_2!=0 & rownmax!=2 & psc`v'_zf!=.;
		replace psc`v'_zf_use = "ZF" if count_1!=0 & count_2!=0 & rownmax!=2 & psc`v'_zf!=.;

		noisily tab country if count_1==0 & count_2!=0;

		replace psc`v'_zk = psc`v'_zf if count_1==0 & count_2!=0 & psc`v'_zf!=.;
		replace psc`v'_zf_use = "ZF" if count_1==0 & count_2!=0 & psc`v'_zf!=.;

		drop count_1 count_2 rown rownmax;

		sort `pvar' `tvar';

		gen double g = ((psc`v'_zf / l1.psc`v'_zf) - 1) * 100;

		* Backward extrapolation *;
		sort `pvar' `tvar';

		egen seq = seq() if psc`v'_zk==. & f1.g!=., by(`pvar');
		egen max = max(seq) if seq!=., by(`pvar');

		sum seq;
		if r(N)==0{;
		};
		else{;
			replace seq = max - seq;

			sum seq;
				local begin = r(min);
				local end = r(max);

			forvalues i = `begin'/`end'{;
				gen double psc`v'_`i' = f1.psc`v'_zk / ((f1.g / 100) + 1) if seq==`i' & psc`v'_zk==.;

				gen byte d = 1 if seq==`i' & psc`v'_`i'!=.;

				replace psc`v'_zk = psc`v'_`i' if d==1;
				replace psc`v'_zf_use = "Epol: ZF" if d==1;

				drop psc`v'_`i' d;
			};
		};

		drop seq max g;
		drop psc`v'_zf;

		recode psc`v'_zk (0 = .);

		rename psc`v'_zk psc`v';
	};

	** Add 22 and 42 if there are enough observations in both series **;
	* Japan *;
	replace psc42 = 0 if ccode=="JPN" & `tvar'<=q(2001q3);

	egen rown = rownonmiss(psc22 psc42);
	recode rown (0 = .);

	egen num_1 = count(rown) if rown==1, by(`pvar');
	egen num_2 = count(rown) if rown==2, by(`pvar');

	egen n1 = mean(num_1), by(`pvar');
	egen n2 = mean(num_2), by(`pvar');

	gen sh12 = (n2 / n1) * 100;	* Data availability of 22 & 42 relative to 22 only (%) *;

	gen count = 1 if rown==2 & year>=2016;
	egen count_latest = mean(count), by(`pvar');

	sort `pvar' `tvar';

	gen gap = (rown!=l1.rown & rown==2);
	egen gap_sum = total(gap), by(`pvar');

	gen str use_psc42 = "";
		replace use_psc42 = "Add IFS-42D" if count_latest==1 & gap_sum==1 & ((n1==. & n2!=.) | sh12>140);
		label var use_psc42 "Add 42D to 22D in IFS";

	drop rown num_1 num_2 n1 n2 sh12 count count_latest gap gap_sum;

	gen double pscifs = psc22;
	gen pscifs_note = "psc22" if pscifs!=.;

		replace pscifs = psc22 + psc42 if use_psc42!="";
		replace pscifs_note = "" if pscifs==.;
		
		label var pscifs "Private sector credit, LCU [IFS 22D + 42D]";
		local lbl_pscifs: variable label pscifs;
		
		replace pscifs_note = "psc22+psc42" if use_psc42!="" & pscifs != .;

	** Adjust breaks in the seris **;
	sort `pvar' `tvar';
	gen double g = ((pscifs / l1.pscifs) - 1) * 100;

	gen byte psc_zf_use = .;
		replace psc_zf_use = 1 if psc22_zf_use!="";

	gen break = .;
		replace break = 1 if g!=. & psc_zf_use==. & (psczk_d==1 | psczk_d==2);
		replace break = 1 if g!=. & psc_zf_use!=. & (psczf_d==1 | psczf_d==2);
		replace break = 1 if g!=. & l1.psc_zf_use!=. & (psczf_d==1 | psczf_d==2);

	drop psc_zf_use;

	* Quarters to be used to fill growth in break year *;
	local q = 1;

	replace g = . if break==1;

	forvalues i = 1/`q'{;
		gen double l`i'_g = l`i'.g if break==1;
		gen double f`i'_g = f`i'.g if break==1;
	};

	local q2 = `q' * 2;

	egen nmiss = rownonmiss(l*_g f*_g);
	egen double g_2 = rowmean(l*_g f*_g) if nmiss==`q2';

	replace g = g_2 if break==1 & g_2!=.;

	drop l*_g f*_g nmiss g_2;

	sort `pvar' `tvar';
	egen nbreak = count(break), by(`pvar');
	egen seq = seq() if break!=., by(`pvar');

	bys `pvar' (`tvar'): gen ord = cond(break==. | break==1, sum(break), .);

	gen double pscifsnew = pscifs if nbreak==ord;

	drop nbreak seq ord;

	* Backward extrapolation *;
	gen byte pscifs_badj = .;

	sort `pvar' `tvar';

	egen seq = seq() if pscifsnew==. & f1.g!=., by(`pvar');
	egen max = max(seq) if seq!=., by(`pvar');

	sum seq;
	if r(N)==0{;
	};
	else{;
		replace seq = max - seq;

		sum seq;
			local begin = r(min);
			local end = r(max);

		forvalues i = `begin'/`end'{;
			gen double pscifsnew_`i' = f1.pscifsnew / ((f1.g / 100) + 1) if seq==`i' & pscifsnew==.;

			gen byte d = 1 if seq==`i' & pscifsnew_`i'!=.;

			replace pscifsnew = pscifsnew_`i' if d==1;
			replace pscifs_badj = 1 if d==1;

			drop pscifsnew_`i' d;
		};
	};

	drop seq max g;

	rename pscifs pscifs_orig;
	rename pscifsnew pscifs;
	rename break psc_break;
		label var pscifs "[Breaks adj.] `lbl_pscifs'";
		label var psc_break "=1 if break identified";
		label var pscifs_badj "=1 if break adjusted in IFS-PSC";

	drop psc22 psc42;

	replace pscifs_note = "" if pscifs==.;

	*== HA ==*;
	gen double nfcp2 = nfch + nfcn;

	egen count_1 = count(nfcp), by(`pvar');
	egen count_2 = count(nfcp2), by(`pvar');

	noisily tab country if count_1==0 & count_2!=0;

	gen str nfcp_note = "HA: nfcp" if nfcp !=. ;
		replace nfcp_note = "HA: (nfch + nfcn)" if count_1==0 & count_2!=0 & nfcp2!=.;
		label var nfcp_note "Note for Private sector credit from HA";

	replace nfcp = nfcp2 if count_1==0 & count_2!=0;

	drop count_1 count_2 nfcp2 nfch nfcn;

	compress _all;
	order ccode ifscode country year;

	sort `pvar' `tvar';
	tempfile ha_ifs;
	save `ha_ifs', replace;

	** BIS **;
	use 201805_BIS_CREDIT_Q, clear;

	noisily xtset ifscode date, quarterly;
		local pvar = r(panelvar);
		local tvar = r(timevar);

	keep ccode ifscode country date year quarter pbmxdca;

	rename pbmxdca pscbis;

	sort `pvar' `tvar';
	tempfile bis;
	save `bis', replace;

	** Merge HA/IFS with BIS **;
	use `ha_ifs', clear;

	merge 1:1 `pvar' `tvar' using `bis';
		tab _merge;
		drop if _merge==2;
		drop _merge;

	sort `pvar' `tvar';

	* Use BIS *;
	egen count_bis = count(pscbis), by(`pvar');

	gen str use_bis = "";
		replace use_bis = "BIS" if (count_bis!=0 & ea==1)
			| ccode=="AUS" | ccode=="CAN" | ccode=="DNK" | ccode=="IND" | ccode=="NZL" | ccode=="SWE" | ccode=="KOR";
		label var use_bis "Use of BIS PSC data";

	gen double psc1 = .;
	replace psc1 = pscbis if use_bis=="BIS";
	replace psc1 = pscifs if use_bis=="";
	replace psc1 = nfcp if ccode=="LVA" | ccode=="LTU" | ccode=="HRV" | ccode == "TWN";
	
	gen str psc1_note = "";
	replace psc1_note = "pscbis" if use_bis=="BIS" & pscbis !=.;
	replace psc1_note = "pscifs" if use_bis=="" & pscifs !=. ;
	replace psc1_note = "HA: nfcp" if (ccode=="LVA" | ccode=="LTU" | ccode=="HRV" | ccode == "TWN") & nfcp !=.;	
	
	drop count_bis;

	gen double psc2 =.;
	replace psc2 = nfcp if nfcp !=.;
	replace psc2 = pscifs if ccode=="LVA" | ccode=="LTU" | ccode=="HRV" | ccode == "TWN";

	gen str psc2_note="";
	replace psc2_note = "HA: nfcp" if nfcp !=.;	
	replace psc2_note = "pscifs" if (ccode=="LVA" | ccode=="LTU" | ccode=="HRV" | ccode == "TWN") & pscifs !=.;

	* HA to extrapolate the main IFS series *;
	* (psc1 is the main, use psc2 to extrapolate);

	gen str psc_note = "";
	replace psc_note = "psc1" if psc1 != .;

	* Forward extrapolation *;
	sort `pvar' `tvar';

	gen double g = ((psc2 / l1.psc2) - 1) * 100;

	egen max_1 = max(`tvar') if psc1!=., by(`pvar');
	egen max1 = mean(max_1), by(`pvar');

	egen max_2 = max(`tvar') if psc2!=., by(`pvar');
	egen max2 = mean(max_2), by(`pvar');

	drop max_?;

	gen max_gap = max2 - max1;
	sum max_gap;
	if r(max)<=0{;
	};
	else{;
		gen maxseq = `tvar' - max1 if `tvar'>max1 & max1!=. & psc2!=.;

		sum maxseq;
			local begin = r(min);
			local end = r(max);

		sort `pvar' `tvar';

		forvalues i = `begin'/`end'{;
			gen double psc1_`i' = l1.psc1 * (1 + (g / 100));

			replace psc_note = "Epol: psc2" if maxseq==`i' & psc1==. & psc1_`i'!=.;
			replace psc1 = psc1_`i' if maxseq==`i' & psc1==. & psc1_`i'!=.;

			drop psc1_`i';
		};

		drop maxseq;
	};

	drop max? max_gap;

	* Backward extrapolation *;
	sort `pvar' `tvar';

	egen seq = seq() if psc1==. & f1.g!=., by(`pvar');
	egen max = max(seq) if seq!=., by(`pvar');

	sum seq;
	if r(N)==0{;
	};
	else{;
		replace seq = max - seq;

		sum seq;
			local begin = r(min);
			local end = r(max);

		forvalues i = `begin'/`end'{;
			gen double psc1_`i' = f1.psc1 / ((f1.g / 100) + 1) if seq==`i' & psc1==. & f1.psc1!=. & f1.g!=.;

			gen byte d = 1 if seq==`i' & psc1_`i'!=.;

			replace psc1 = psc1_`i' if d==1;
			replace psc_note = "Epol: psc2" if d==1;

			drop psc1_`i' d;
		};
	};

	drop seq max g;

	drop psc2;

	rename psc1 psc;
	

	label var psc "Private sector credit, LCU";
	label var psc_note "[Note] PSC";

	* Merge CPI *;
	merge 1:1 `pvar' `tvar' using dta\201805_cpi_nsa;
		tab _merge;
		noisily tab country if _merge==2;
		drop if _merge==2;
		drop _merge;

	sum year if baseyr==1;
	local base = r(mean);
	noisily display as text "Base year = " as result "`base'";

	drop cpi_* baseyr;

	*** Real private sector credit (deflated by CPI) ***;
	gen double rpsc = psc / (cpi / 100);
	label var rpsc "Real private sector credit, constant `base' LCU";
	local lbl_rpsc: variable label rpsc;

	vallist ccode, local(all);

	*--> Remove gaps *;
	gen double rpsc_raw = rpsc;
	label var rpsc_raw "[Raw] `lbl_rpsc'";

	gen byte rpsc_fill = .;
	label var rpsc_fill "=1 if interpolated: `lbl_rpsc'";

	foreach z of local all{;
		noisily display as text "Country: " as result "`z'";
		count if ccode=="`z'" & rpsc!=.;
		if r(N)==0{;
		};
		else{;
			if r(N)==1{;
				noisily display as error "Data only for a quarter. Drop.";
				replace rpsc = . if ccode=="`z'";
			};
			else{;
				tsreport rpsc if ccode=="`z'", detail;
				local gap = r(N_gaps1);

				if r(N_gaps1)==0{;
				};
				else{;
					matrix rpsc`z' = r(table1);

					forvalues j = 1/`gap'{;
						local g`j' = rpsc`z'[`j',5];
						local l`j' = rpsc`z'[`j',6];

						if `l`j''==1{;
							replace rpsc_fill = 1 if ccode=="`z'" & date==`g`j'';
						};
					};

					count if ccode=="`z'" & rpsc_fill==1 & year>=2010;
					if r(N)==1{;
						sum `tvar' if ccode=="`z'" & rpsc_fill==1 & year>=2010;
						local date`z' = r(mean);

						noisily display as text "--> Fill: " as result "`z'" as result %tqCCYY!Qq `date`z'';

						sort `pvar' `tvar';

						replace rpsc = (l1.rpsc + f1.rpsc) / 2
								if ccode=="`z'" & rpsc_fill==1 & year>=2010;

						replace rpsc_fill = 9 if ccode=="`z'" & rpsc_fill==1 & year>=2010;

						local gap1 = `gap' - 1;
						if `gap1'==0{;
						};
						else{;
							replace rpsc = . if ccode=="`z'" & date<=`g`gap1'';
						};
					};
					else{;
						noisily display as text "--> Delete before: " as result %tqCCYY!Qq `g`gap'';

						replace rpsc = . if ccode=="`z'" & date<=`g`gap'';
					};

					recode rpsc_fill (1 = .) (9 = 1) if ccode=="`z'";

					tsreport rpsc if ccode=="`z'";

					if r(N_gaps1)!=0{;
						error 1;
					};
					else{;
						count if ccode=="`z'" & rpsc!=.;
						if r(N)==1{;
							noisily display as error "Data only for a quarter. Drop.";
							replace rpsc = . if ccode=="`z'";
						};
					};
				};
			};
		};
	};
	
	gen rpsc_note = psc_note;
	replace rpsc_note = "" if rpsc ==.;
	replace rpsc_note = "(L1+F1)/2" if rpsc_fill==1;

	preserve;

		xtset, clear;

		keep ccode date rpsc;

		egen count = count(rpsc), by(ccode);
		drop if count<=12;	* For SA, data at least over three years are needed *;
		drop count;

		reshape wide rpsc, i(date) j(ccode) string;

		renpfix rpsc;

		tsset date, quarterly;

		sort `tvar';
		egen rown = rownonmiss(???);
		egen seq = seq() if rown!=0;

		sum `tvar' if seq==1;
		drop if `tvar'<r(mean);
		drop rown seq;

		sort `tvar';
		export delimited using sadj\fin\rpscnsa.csv, replace;

	restore;


	compress _all;
	order ccode ifscode country date year quarter rpsc rpsc_raw rpsc_fill;

	sort `pvar' `tvar';
	
	save "R:/Shi/Project_Business Financial Data/output/201805/dta/201805_rpsc_nsa", replace;
	


	#delimit cr

	** END **
}

