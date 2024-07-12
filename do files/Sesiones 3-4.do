******************************************************************
******************************************************************
**				Manejo de la GEIH 2024							**	
**	Indicadores principales del Mercado Laboral en Colombia		**	
**																**
**	Codigo escrito por: Henry Andres Gomez						**
**																**
**	Fecha: 05/07/2024											**
******************************************************************
******************************************************************

**Ruta de la carpeta**
global pc = "C:\Users\Lenovo\Desktop\TREES\Taller Stata-GEIH\Bases" //Ruta de carpeta (cambiar)

 *****************************************************
/*1. Importe de los datos y consolidación de la base*/
******************************************************

**Importe: Solo meses Enero, Febrero, Marzo y Abril**
tokenize `""Características generales, seguridad social en salud y educación" "Fuerza de trabajo" "No ocupados" "Ocupados" "Otras formas de trabajo" "Otros ingresos e impuestos""'
local i = 1
while `i' <= 6 {
foreach mes in "Enero" "Febrero" "Marzo" {
		dis "Este es el mes: `mes' del modulo: ``i''"
		use "${pc}/`mes'/``i''.dta", clear
		rename _all, lower
		destring _all, replace
		cap tostring p3147s*, replace
		cap tostring p3362s*, replace
		cap tostring p3363, replace
		cap tostring p3364, replace
		cap tostring p6030s1, replace
		cap tostring p6030s3, replace 
		gen meses = "`mes'"
		gen year = 2022
		compress
		tempfile `mes'`i'
		save ``mes'`i'', replace
		}
	local ++i
	}
	
**Union Horizontal: Merge** 
foreach mes in "Enero" "Febrero" "Marzo" {
	dis "Este es el mes: `mes'"
	use ``mes'1', clear
	forvalue i = 1/6 {
		merge 1:1 directorio secuencia_p orden using ``mes'`i'', nogen
	}
	cap tostring p3147s*, replace
	cap tostring p3362s*, replace
	cap tostring p3363, replace
	cap tostring p3364, replace
	tempfile `mes'
	save ``mes'', replace
} 	
	
**Union Vertical: Append**  
use `Enero', clear
foreach mes in "Febrero" "Marzo" {
	append using ``mes''
}	
	
compress
save "${pc}/GEIH_2022.dta", replace

 *****************************************************
/*3. Tratamiento variables							*/
******************************************************
di "${pc}"
use "${pc}output/GEIH_2024.dta", clear // Llamar base de datos

/*********************************************
*	Locales, globales, temporales, loops
*********************************************

*Local (solo existe en dofile o programa que es definido)
*Si llama otro local de otro dofile, este cesa
local a "variable_local"
generate `a'=1
generate a_local=1

local a "variable"
local i = 4
generate `a'`i' = 1

* Global ()
global a "variable"
generate $a = 1
generate a = 1

global i=2
generate $a$i = 1

global b1 "variable3"
global i = 1
di "${b1}"
di "${b$i}"
generate ${b$i} = 1

*Temporal
tempfile GEIH
save `GEIH'

clear all
ta periodo

use `GEIH', clear
ta periodo

*Loop

******************Foreach

*foreach x in mpg fff-ddd {}
*foreach x of varlist mpg foreach name in "Annette Fett" "Ashley Poole" "Marsha Martinez" {


foreach var of varlist clase p2059 p2061 {
quietly summarize `var'
summarize `var' if `var' > r(mean)
}

*foreach x of local varlist {}
foreach name in "Andres Gomez" "David Becerra" "Yeraldo Sandoval" {
display length("`name'") " numero de carácteres -- `name'"
}

local grains "arroz frijoles lentejas"
foreach x of local grains {
display "`x'"
}

******************Forvalues

 forvalues i = 1(1)5 {
display `i'
}

 forvalues i = 1(2)5 {
display `i'
}

 forvalues i = 5(-1)1 {
display `i'
}

 forvalues i = 1/5 {
display `i'
}

 forvalues i = 5 10:25 {
display `i'
}

 forvalues i = 25 20 to 5 {
display `i'
}

local n 3
forvalues i = 1(1)`n' {
local n = `n' + 1
display `i'
}

******************While
local i = 1
while `i'<10 {
display "i es ahora `i'"
local e = `i'
local i = `i' + 1
}
display "hecho, ahora i es `e'"
*/
********************************************
*label values variablename labelname
/*2.2. Sexo al nacer*/
********************************************
rename p3271 sexo

label var sexo "Sexo al nacer"

label define sexo 1 "Hombre" 2 "Mujer", replace
label values sexo sexo

/*2.3. Parentesco*/
******************
rename p6050 parentesco
label var parentesco "Parentesco"

label define parentesco 1 "Jefe del Hogar" 2 "Pareja, conyugue" 3 "Hijo, Hijastro" 4 "Padre o madre" 5 "Suegro" 6 "Hermano o hermana" 7 "Yerno o nuera" 8 "Nieto" 9 "Otro" 10 "Empleado doméstico" 11 "Pensionista" 12 "Trabajador" 13 "Otro no pariente", replace
label values parentesco parentesco

/*2.4. Estado Civil*/
********************
rename p6070 est_civil 
label var est_civil "Estado Civil"

forvalues i = 2/6 {
	replace est_civil = `i'-1 if est_civil == `i'
}

label define est_civil 1 "Unión libre" 2 "Casado" 3 "Separado o divorciado " 4 "Viudo" 5 "Soltero", replace
label values est_civil est_civil

/*2.5. Creacion de grupo de edad*/
*********************************

**Grupo de edad en quinquenios**
gen edad_quin =. 
replace edad_quin = 1  if p6040 >= 0  & p6040 <= 4
replace edad_quin = 2  if p6040 >= 5  & p6040 <= 9 
replace edad_quin = 3  if p6040 >= 10 & p6040 <= 14
replace edad_quin = 4  if p6040 >= 15 & p6040 <= 19
replace edad_quin = 5  if p6040 >= 20 & p6040 <= 24
replace edad_quin = 6  if p6040 >= 25 & p6040 <= 29
replace edad_quin = 7  if p6040 >= 30 & p6040 <= 34
replace edad_quin = 8  if p6040 >= 35 & p6040 <= 39 
replace edad_quin = 9  if p6040 >= 40 & p6040 <= 44
replace edad_quin = 10 if p6040 >= 45 & p6040 <= 49
replace edad_quin = 11 if p6040 >= 50 & p6040 <= 54
replace edad_quin = 12 if p6040 >= 55 & p6040 <= 59
replace edad_quin = 13 if p6040 >= 60 & p6040 <= 648
replace edad_quin = 14 if p6040 >= 65

**Grupo de edad ciclo de vida**
gen g_edad = .
replace g_edad = 1  if p6040 >= 0  & p6040 <= 4
replace g_edad = 2  if p6040 >= 5  & p6040 <= 14 
replace g_edad = 3  if p6040 >= 15 & p6040 <= 28
replace g_edad = 4  if p6040 >= 29 & p6040 <= 59
replace g_edad = 5  if p6040 >= 60

rename p6040 edad

label var edad "Edad de la persona"
label var edad_quin "Edad en quinquenio"
label var g_edad "Grupo de edad"

label define g_edad 1 "0-4" 2 "5-14" 3 "15-28" 4 "29-59" 5 "60 o más", replace 
label values g_edad g_edad

label define quin 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65 o más", replace
label values edad_quin quin

/*2.6. Capital Humano*/
**********************

**Años de educación** 
*(Ley 115 de 1994; decreto 3012 de 1997 Art. 3; Ley 30 de 1993 Art. 26)

gen escolaridad = .
replace escolaridad = p3042s1 if p3042== 1 //Ningun nivel educativo
replace escolaridad = p3042s1 if p3042== 2 //Preescolar
replace escolaridad = p3042s1 if p3042== 3 //Primaria
replace escolaridad = p3042s1+5 if p3042== 4 //Secundaria
replace escolaridad = p3042s1+9 if p3042== 5 | p3042== 6 //Media
replace escolaridad = p3042s1+9 if p3042== 7 //Normalista
replace escolaridad = (p3042s1/2)+11 if p3042== 8 //Técnica profesional
replace escolaridad = (p3042s1/2)+11 if p3042== 9 //Tecnológica
replace escolaridad = (p3042s1/2)+11 if p3042== 10 //Universitaria
replace escolaridad = (p3042s1/2)+16 if p3042== 11 //Especialización
replace escolaridad = (p3042s1/2)+16 if p3042== 12 //Maestría
replace escolaridad = (p3042s1/2)+16 if p3042== 13 //Doctorado

label var escolaridad "Años de escolaridad"


/*2.13. Rama de Actividad Economica*/
************************************
**CIIU Sección Q: Actividades de atención de la salud humana y asistencia sociproportional**
gen rama1d_r4 = .
replace rama1d_r4=1   if  (rama2d_r4 ==01|rama2d_r4 ==02|rama2d_r4 ==03)
replace rama1d_r4=2   if  (rama2d_r4 ==05|rama2d_r4 ==06|rama2d_r4 ==07|rama2d_r4 ==08|rama2d_r4 ==09)
replace rama1d_r4=3   if  (rama2d_r4 >=10 & rama2d_r4<=33)
replace rama1d_r4=4   if  rama2d_r4 ==35 
replace rama1d_r4=5   if  (rama2d_r4 >=36 & rama2d_r4<=39)
replace rama1d_r4=6   if  (rama2d_r4 >=41 & rama2d_r4<=43)
replace rama1d_r4=7   if  (rama2d_r4 >=45 & rama2d_r4<=47)
replace rama1d_r4=8   if  (rama2d_r4 >=49 & rama2d_r4<=53)
replace rama1d_r4=9   if  (rama2d_r4 >=55 & rama2d_r4<=56)
replace rama1d_r4=10  if  (rama2d_r4 >=58 & rama2d_r4<=63)
replace rama1d_r4=11  if  (rama2d_r4 >=64 & rama2d_r4<=66)
replace rama1d_r4=12  if  rama2d_r4 ==68
replace rama1d_r4=13  if  (rama2d_r4 >=69 & rama2d_r4<=75)
replace rama1d_r4=14  if  (rama2d_r4 >=77 & rama2d_r4<=82)
replace rama1d_r4=15  if  rama2d_r4 ==84 
replace rama1d_r4=16  if  rama2d_r4 ==85 
replace rama1d_r4=17  if  (rama2d_r4 >=86 & rama2d_r4<=88) //Actividades de atención de salud Humana
replace rama1d_r4=18  if  (rama2d_r4 >=90 & rama2d_r4<=93)
replace rama1d_r4=19  if  (rama2d_r4 >=94 & rama2d_r4<=96)
replace rama1d_r4=20  if  (rama2d_r4 >=97 & rama2d_r4<=98)
replace rama1d_r4=21  if  rama2d_r4 ==99 
replace rama1d_r4=99  if rama2d_r4== 0

label define rama1d_r4 1 "Agricultura, ganadería, caza, silvicultura y pesca" 2	"Explotación de minas y canteras" 3	"Industrias manufactureras" 4 "Suministro de electricidad, gas, vapor y aire acondicionado" 5 "Distribución de agua; evacuación y tratamiento de aguas residuales, gestión de desechos y actividades de saneamiento ambiental" 6 "Construcción" 7 "Comercio al por mayor y al por menor; reparación de vehículos automotores y motocicletas" 8 "Transporte y almacenamiento" 9 "Alojamiento y servicios de comida" 10 "Información y comunicaciones" 11	"Actividades financieras y de seguros" 12 "Actividades inmobiliarias" 13 "Actividades profesionales, científicas y técnicas" 14	"Actividades de servicios administrativos y de apoyo" 15 "Administración pública y defensa; planes de seguridad social de afiliación obligatoria" 16 "Educación" 17	"Actividades de atención de la salud humana y de asistencia social" 18 "Actividades artísticas, de entretenimiento y recreación" 19	"Otras actividades de servicios" 20	"Actividades de los hogares individuales en calidad de empleadores; actividades no diferenciadas de los hogares individuales como productores de bienes y servicios para uso propio" 21	"Actividades de organizaciones y entidades extraterritoriales" 99 "No informa", replace
label values rama1d_r4 rama1d_r4


/*
Guarde la base de datos. En este ejemplo la llamaré Taller1.dta
*/

save "${pc}output/Taller1.dta", replace

	
 *****************************************************
/*3. Descriptivas e indicadores						*/
******************************************************

use "${pc}output/Taller1.dta", clear


/* 3.1. Distribución de la población por grupo de edad*/
*******************************************************

*Tabulación*
tab (g_edad) (sexo) [iw=round(fex_c18/4)] //Por sexo

*Estructura poblacional*
ta g_edad sexo [iw=fex_c/4]

***************************
* Variables dadas por DANE
***************************

*Variables indicadoras (PT)
ta pt 
ta pt [iw=round(fex_c)]
ta pt [iw=round(fex_c/4)]

ta mes pt [iw=round(fex_c)]
ta mes pt [iw=(fex_c)]

gen pop=1 //Creada
ta pop pt, m // Verificamos creación


*Variables indicadoras (PET)

ta pet
ta pet [iw = fex_c/4]
ta mes pet [iw=fex_c]

gen PET = cond(edad>=15,1,0) //Creada
ta PET pet, m // Verificamos creación

*Variables indicadoras (OCI)

ta oci
ta oci [iw = fex_c/4]
ta mes oci [iw=fex_c]

gen OCI= cond(p6240==1 | p6250==1 | p6260==1 | p6270==1,1,0) //Creada
ta OCI oci, m // Verificamos creación
*drop OCI

*Variables indicadoras (DSI)

ta dsi
ta dsi [iw = fex_c/4]
ta mes dsi [iw=fex_c]

gen DSI=cond(p6351==1,1,0) //Creada
ta DSI dsi, m // Verificamos creación
*drop DSI


*Variables indicadoras (FT)

ta ft
ta ft [iw = fex_c/4]
ta mes ft [iw=fex_c]

gen FT =cond(OCI==1 | DSI==1,1,0) //Creada
ta FT ft, m // Verificamos creación

*Variables indicadoras (PFFT)

ta fft
ta fft [iw=fex_c/4]
ta mes fft [iw=fex_c]

/* 			 Tablas sectores 					*/
**************************************************

ta rama1d_r4 mes [iw= fex_c18]


/* 			 Tablas sexo	 					*/
**************************************************

by mes, sort : summarize pt pet ft oci dsi fft [iweight = fex_c] if sexo==1

/* Dummies de indicadores de mercado laboral*/
**************************************************
gen pob = 1

label var pob "Población"
label var pet "Población en edad de trabajar"
label var fft "Fuera de la fuerza laboral"
label var ft "Fuerza laboral"
label var oci "Ocupados"
label var dsi "No ocupados"

foreach var of varlist pet fft ft oci dsi {
	replace `var' = 0 if `var' == .
}

sort directorio secuencia_p orden


/*3.3.1. Calculo de los indicadores*/
************************************

**Toda la Población**
preserve
	collapse (sum) pet fft ft oci dsi [iw=round(fex_c18)], by(year mes)
	gen t_gp  = ft/pet*100
	gen t_i = fft/pet*100
	gen t_d = dsi/ft*100
	gen t_o = oci/pet*100
	keep year mes t_*
	tempfile todo
	save `todo', replace
	twoway (line t_gp mes) (connected t_d mes) (line t_o mes), ytitle(`"(%)"')
restore

**Por sexo**
preserve
	collapse (sum) pet fft ft oci dsi [iw=round(fex_c18)], by(year mes sexo)
	gen t_gp_  = ft/pet*100
	gen t_i_ = fft/pet*100
	gen t_d_ = dsi/ft*100
	gen t_o_ = oci/pet*100
	keep year mes t_* sexo
	reshape wide t_gp_ t_i_ t_d_ t_o_, i(year mes) j(sexo) 
	rename (t_gp_1 t_i_1 t_d_1 t_o_1 t_gp_2 t_i_2 t_d_2 t_o_2) (t_gp_h t_i_h t_d_h t_o_h t_gp_m t_i_m t_d_m t_o_m)
	tempfile sexo
	save `sexo', replace
restore

*inglabo

***Ejercicio

*Sacar indicadores del percado laboral (tgp to td) para 

*Parentesco
*Estado Civil
*Grupos de Edad
*Escolaridad (rangos de 5, 12, 20, +20)
*Ocupaciones
*Otros






/*Extra. Informalidad*/
	******************
	destring oficio_c8, replace
	gen str4 oficio_oci_str = string(oficio_c8,"%04.0f")
	replace oficio_oci_str = substr(oficio_oci_str,1,2)
	destring oficio_oci_str, g(oficio_oci_num)

	gen formal = .
	replace formal = . if p6430 == 3
	replace formal = 0 if inlist(p6430,6,8)		
	replace formal = 1 if inlist(rama2d_r4,84,99)	

	**Asalariados**
	replace formal = 1 if p6430 == 2
	replace formal = 1 if inlist(p6430,1,7) & p3045s1 == 1
	replace formal = 1 if inlist(p6430,1,7) & inlist(p3045s1,2,9) & p3046 == 1
	replace formal = 0 if inlist(p6430,1,7) & inlist(p3045s1,2,9) & p3046 == 2
	replace formal = 1 if inlist(p6430,1,7) & inlist(p3045s1,2,9) & p3046 == 9 & (p3069 >= 4)
	replace formal = 0 if inlist(p6430,1,7) & inlist(p3045s1,2,9) & p3046 == 9 & (p3069 < 4)

	**Independientes sin negocio**
	replace formal = 1 if inlist(p6430,4,5) & inlist(p6765,1,2,3,4,5,6,8) & p3065 == 1
	replace formal = 1 if inlist(p6430,4,5) & inlist(p6765,1,2,3,4,5,6,8) & inlist(p3065,2,9) & p3066 == 1 
	replace formal = 0 if inlist(p6430,4,5) & inlist(p6765,1,2,3,4,5,6,8) & inlist(p3065,2,9) & p3066 == 2
	replace formal = 1 if inlist(p6430,5) & inlist(p6765,1,2,3,4,5,6,8) & inlist(p3065,2,9) & p3066 == 9 & (p3069 >= 4) 
	replace formal = 0 if inlist(p6430,5) & inlist(p6765,1,2,3,4,5,6,8) & inlist(p3065,2,9) & p3066 == 9 & p3069 < 4 
	replace formal = 1 if inlist(p6430,4) & inlist(p6765,1,2,3,4,5,6,8) & inlist(p3065,2,9) & p3066 == 9 & (oficio_oci_num >= 0 & oficio_oci_num <= 20) 
	replace formal = 0 if inlist(p6430,4) & inlist(p6765,1,2,3,4,5,6,8) & inlist(p3065,2,9) & p3066 == 9 & oficio_oci_num > 20 

	**Independientes con negocio y registro mercartil**
	replace formal = 1 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 1 & (p3067s2 == 2022 | p3067s2 == 2021)
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 1 & (p3067s2 < 2021)
	replace formal = 1 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 1 
	replace formal = 1 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 3 & oficio_oci_num >= 0 & oficio_oci_num <= 20
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 3 & oficio_oci_num > 20
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 2
	replace formal = 1 if inlist(p6430,4) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 9 & (oficio_oci_num >= 0 & oficio_oci_num <= 20)
	replace formal = 0 if inlist(p6430,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 9 & oficio_oci_num > 20
	replace formal = 1 if inlist(p6430,4) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 9 & (p3069 >= 4)
	replace formal = 0 if inlist(p6430,5) & p6765 == 7 & p3067 == 1 & p3067s1 == 2 & p6775 == 9 & p3069 < 4 

	**Independientes con negocio y sin registro mercartil**
	replace formal = 1 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 2 & p6775 == 1 & p3068 == 1
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 2 & p6775 == 1 & p3068 == 2
	replace formal = 1 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 2 & p6775 == 3 & (oficio_oci_num >= 0 & oficio_oci_num <= 20)
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 2 & p6775 == 3 & oficio_oci_num > 20
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 2 & p6775 == 1 & p3068 == 9 
	replace formal = 0 if inlist(p6430,4,5) & p6765 == 7 & p3067 == 2 & p6775 == 2
	replace formal = 1 if inlist(p6430,5) & p6765 == 7 & p3067 == 2 & p6775 == 9 & (p3069 >= 4)
	replace formal = 0 if inlist(p6430,5) & p6765 == 7 & p3067 == 2 & p6775 == 9 & p3069 < 4 
	replace formal = 1 if inlist(p6430,4) & p6765 == 7 & p3067 == 2 & p6775 == 9 & (oficio_oci_num >= 0 & oficio_oci_num <= 20)
	replace formal = 0 if inlist(p6430,4) & p6765 == 7 & p3067 == 2 & p6775 == 9 & oficio_oci_num > 20

	**Salud**
	cap gen salud = .
	replace salud = 0 if inlist(p6430,1,2,3,7)
	replace salud = 1 if inlist(p6430,1,2,3,7) & inlist(p6100,1,2) & inlist(p6110,1,2,4)
	replace salud = 1 if inlist(p6430,1,2,3,7) & p6100 == 9 & p6450 == 2
	replace salud = 1 if inlist(p6430,1,2,3,7) & p6110 == 9 & p6450 == 2

	**Pensión**
	cap gen pension = .
	replace pension = 0 if inlist(p6430,1,2,3,7) 
	replace pension = 1 if inlist(p6430,1,2,3,7) & p6920 ==3
	replace pension = 1 if inlist(p6430,1,2,3,7) & p6920 ==1 & inlist(p6930,1,2,3) & inlist(p6940,1,3)

	**Ocupación Informal**
	gen informal=.
	replace informal = 0 if inlist(p6430,6,7)
	replace informal = formal if inlist(p6430,4,5)
	replace informal = 0 if inlist(p6430,1,2,3,7) 
	replace informal = 1 if inlist(p6430,1,2,3,7) & salud == 1 & pension == 1 

	gen ocu_informal = 1 if informal == 0
	replace ocu_informal = 0 if informal == 1

	label var ocu_informal "Ocupado Informal"














































	
	
	
	
	
	
	
	
	
	