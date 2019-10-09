*************************************************
*Project:		Cobertura MSE					*
*Institution:	MINEDU             				*
*Author:		Brenda Teruya					*
*Last edited:	2019-10-09          			*
*************************************************
global ue C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UE\Proyecciones\3. Data\4. Student level
global cobertura C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UPP\Actividades\Otros\Cobertura MSE
global datos C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UPP\Actividades\Focalizacion\Datos
cd "$ue"


use "2018.dta", clear
destring id_persona, gen(identificacion)
keep identificacion id_grado
merge 1:1 identificacion using "2017.dta", ///
	keepusing(dsc_grado cod_dreugel dsc_nivel sf_a_diciembre cod_mod)
*dsc_grado en 2017 tiene 0 missing

destring id_grado, gen(grado18)
encode dsc_grado, gen(dsc_grado_)
label list dsc_grado_

encode dsc_nivel, gen(dsc_nivel_)
label list dsc_nivel_

keep if inlist(dsc_nivel_, 7, 8) //solo primaria y secundaria del 2017
codebook dsc_grado_ dsc_nivel_  
tab dsc_grado_  grado18
tab dsc_grado_ dsc_nivel_

gen grado17 = .
replace grado17 = 4 if dsc_grado_ == 9 & dsc_nivel_ == 7
replace grado17 = 5 if dsc_grado_ == 17 & dsc_nivel_ == 7
replace grado17 = 6 if dsc_grado_ == 19 & dsc_nivel_ == 7
replace grado17 = 7 if dsc_grado_ == 5 & dsc_nivel_ == 7
replace grado17 = 8 if dsc_grado_ == 16 & dsc_nivel_ == 7
replace grado17 = 9 if dsc_grado_ == 18 & dsc_nivel_ == 7

replace grado17 = 10 if dsc_grado_ == 9 & dsc_nivel_ == 8
replace grado17 = 11 if dsc_grado_ == 17 & dsc_nivel_ == 8
replace grado17 = 12 if dsc_grado_ == 19 & dsc_nivel_ == 8
replace grado17 = 13 if dsc_grado_ == 5 & dsc_nivel_ == 8
replace grado17 = 14 if dsc_grado_ == 16 & dsc_nivel_ == 8

drop if inlist(grado17, 4, 5, 6, 7, 8, 14) // solo de sexto de primaria a 4to secundaria

tab dsc_grado_  grado18

drop if sf_a_diciembre == "Fallecidos                                                  "

tab _m //en esta bd están todos los alumnos de sexto de primaria a 4to secun
*vivos

keep if _m == 2 //ahora están todos los alumnos de sexto de priamria 2017 a 4to sec
*vivos, que no se matricularon en el 2018

tabstat identificacion , by(cod_dreugel) stat(count)

collapse (count) n_deser = identificacion , by(cod_mod)
gen anexo = 0
merge 1:1 cod_mod anexo using "$datos\BasePuraIntegrada.dta", keep(3) nogen

collapse (sum) n_deser, by(ruralidad_rm093)

export excel using "$cobertura\desercion.xlsx", replace firstrow(variables)

