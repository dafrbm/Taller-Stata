*SESIÓN 2 - TALLER DE STATA

cls

clear all

* Fijar globals para rutas

global Bases "C:\Users\d.becerramedina\Desktop\Taller Stata\Bases"

global Resultados "C:\Users\d.becerramedina\Desktop\Taller Stata\Resultados"

*Pegar módulos de la GEIH

use "$Bases/Enero/vivienda.dta", clear

foreach folder in Enero Febrero Marzo {
	
	use "$Bases/`folder'/vivienda.dta", clear
	
	merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "$Bases/`folder'/Ocupados.dta", force generate(_ocupados)
	
	merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "$Bases/`folder'/No ocupados.dta", force generate(_noocupados)
	
	save "$Bases/`folder'/pegue2.dta"
}

*Pegar meses

use "$Bases/`folder'/Enero.dta", clear
append using "$Bases/Febrero.dta" "$Bases/Marzo.dta"
save "Pegue_GEIH.dta"

*Keep y drop

*CARACTERES Y NUMERICAS

describe DPTO

destring DPTO, generate(DEPTO)

describe DEPTO

tostring DEPTO, generate (DEPART)

describe DEPART

*KEEP Y DROP

preserve

keep if DPTO == "68"

restore

drop 

*Descriptivas

codebook P3271

tab P3271

summarize INGLABO, detail

ssc install outreg2

preserve
keep INGLABO
outreg2 using myfile, sum(detail) replace ///
eqkeep(N mean sd max p50 min) keep(INGLABO)
restore

merge 1:m DIRECTORIO SECUENCIA_P ORDEN using "$Bases/`folder'/vivienda.dta", generate(_vivienda)
h foreach
use "$Bases/Enero/Características generales, seguridad social en salud y educación.dta"

h merge


use "$Bases/Enero/Datos del hogar y la vivienda", clear

