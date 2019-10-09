cd C:\Users\administrativoupp1\Downloads


import dbase using "Matricula_03.dbf", clear
keep if CUADRO == "C215"
keep if NROCED == "4AA"
egen alumnos = rowtotal (D01-D10)
codebook alumnos
tabstat alumnos, by(TIPDATO) stat(sum)
tab TIPDATO, gen(lengua)
gen lengua = 1*lengua1 + 2*lengua2 + 3*lengua3 + 4*lengua4 + 5*lengua5 ///
	+ 6*lengua6 + 7*lengua7
	
label def lengua 1 "Castellano" 2 "Quechua" 3 "Aymara" 4 "Ashaninka" ///
	5 "Shipibo - Conibo" 6 "Otra lengua" 7 "Lengua Extranjera" 
label val lengua lengua	
tabstat alumnos, by(lengua) stat(sum)

