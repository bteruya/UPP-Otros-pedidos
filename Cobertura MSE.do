*************************************************
*Project:		Cobertura MSE					*
*Institution:	MINEDU             				*
*Author:		Brenda Teruya					*
*Last edited:	2019-10-09          			*
*************************************************
global ue C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UE\Proyecciones\3. Data\4. Student level
global cobertura C:\Users\analistaup2\Google Drive\Trabajo\MINEDU_trabajo\UPP\Actividades\Otros\Cobertura MSE

cd "$ue"
use "2018.dta", clear
destring id_persona, gen(identificacion)

merge 1:1 identificacion using 2017.dta

use "2018.dta", clear


