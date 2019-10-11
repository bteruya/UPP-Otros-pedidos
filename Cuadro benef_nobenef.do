*************************************************
*Project:		Cuadro benef vs no benef 		*
*Institution:	MINEDU             				*
*Author:		Brenda Teruya					*
*Last edited:	2019-10-09          			*
*************************************************
global bpura_datos C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UPP\Actividades\Focalizacion\Datos
global datos_otros C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UPP\Actividades\Otros\Cuadro beneficiarios vs no beneficiarios



import excel "$datos_otros\BBDD MPE 2018.xlsx", sheet("BBDD IE") cellrange(A1:DQ991) firstrow clear
keep CODIGO_MODULAR R106
gsort CODIGO_MODULAR -R106
bys CODIGO_MODULAR: gen n = _n 
keep if n == 1
destring CODIGO_MODULAR, gen(cod_mod)
keep cod_mod R106 
label var R106 "106. GESTIÓN DEL USO DEL TIEMPO"
gen anexo = 0
tempfile mpe
save `mpe'


use "$bpura_datos\BasePuraIntegrada.dta"
merge 1:1 cod_mod anexo using `mpe', gen(mpe)

merge 1:1  cod_mod anexo using "$datos_otros\padro_actual", gen(polidocente)

merge 1:1  cod_mod anexo using "$datos_otros\padron_eib", gen(eib)

merge 1:1  cod_mod anexo using "$datos_otros\padron_multigrado", gen(multigrad)

gen t_eib = eib == 3  
replace t_eib = . if missing(eib_rn) 
tab t_eib,m

label var t_eib "Total IIEE EIB beneficiarias y No beneficiarias"
label def t_eib 0 "EIB no focalizada" 1 "EIB focalizada"
label val  t_eib t_eib 
tab t_eib 


gen t_multigrad = multigrad == 3  
replace t_multigrad = . if inlist(cod_car , "a", "m")
tab t_multigrad,m

label var t_multigrad "Total IIEE multigrad beneficiarias y No beneficiarias"
label def t_multigrad 0 "multigrad no focalizada" 1 "multigrad focalizada"
label val  t_multigrad t_multigrad 
tab t_multigrad 


gen t_polidocente = 0 if t_eib ==. & t_multigrad == . 
replace t_polidocente = 1 if polidocente == 3
tab t_polidocente,m

label var t_polidocente "Total IIEE polidocente beneficiarias y No beneficiarias"
label def t_polidocente 0 "polidocente no focalizada" 1 "polidocente focalizada"
label val  t_polidocente t_polidocente 
tab t_polidocente 

gen mpe_106 = inlist(R106, 3, 4) if !missing(R106)

tab t_eib mpe
tab t_multigrad mpe
tab t_polidocente mpe
gen obs = 1
gen r_alum_doc = total_alumnos / total_docentes
gen obs_mpe = mpe == 3

tabstat total_alumnos ece18_500_L_prim mpe_106 tiempo_dre_ugel r_alum_doc, stat(mean) by(t_multigrad)
tabstat obs_mpe, stat(sum) by(t_multigrad)


tabstat total_alumnos ece18_500_L_prim mpe_106 tiempo_dre_ugel r_alum_doc, stat(mean) by(t_eib)
tabstat obs obs_mpe, stat(sum) by(t_eib)


tabstat total_alumnos ece18_500_L_prim mpe_106 tiempo_dre_ugel r_alum_doc, stat(mean) by(t_polidocente)
tabstat obs obs_mpe, stat(sum) by(t_polidocente)

preserve

collapse (mean) total_alumnos ece18_500_L_prim mpe_106 tiempo_dre_ugel r_alum_doc ///
	(sum) obs obs_mpe , by(t_multigrad)

drop if t_multigrad == .

xpose, clear varname
order _varname v*
export excel using "$datos_otros\Cuadro.xlsx" , ///
	sheet("multigrad") firstrow(varlabels) sheetreplace

restore

preserve

collapse (mean) total_alumnos ece18_500_L_prim mpe_106 tiempo_dre_ugel r_alum_doc ///
	(sum) obs obs_mpe , by(t_eib)

drop if t_eib == .

xpose, clear varname
order _varname v*
export excel using "$datos_otros\Cuadro.xlsx" , ///
	sheet("eib") firstrow(varlabels) sheetreplace

restore

preserve

collapse (mean) total_alumnos ece18_500_L_prim mpe_106 tiempo_dre_ugel r_alum_doc ///
	(sum) obs obs_mpe , by(t_polidocente)

drop if t_polidocente == .

xpose, clear varname
order _varname v*
export excel using "$datos_otros\Cuadro.xlsx" , ///
	sheet("polidocente") firstrow(varlabels) sheetreplace

restore
