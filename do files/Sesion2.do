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

*Describiendo variables categóricas (nos limitamos a conteos)

codebook P3271

tab P3271

*Cuando son continuas, podemos revisar más cosas

summarize INGLABO, detail

*Exportamos una tabla para poner en un word, por ejemplo

*Instalamos el paquete outreg2

ssc install outreg2

*Un uso ingenioso del Ctrl + Z de Stata (preserve;restore)

preserve
keep INGLABO
outreg2 using myfile, sum(detail) replace ///
eqkeep(N mean sd max p50 min) keep(INGLABO)
restore

/*TAREA: Quiero que le trabajemos a generar tablas con descriptivas
desagregando por categorías. Voy a dejar unas instrucciones y algunos
tips. La idea es que hagan el código y lo peguen en el grupo. (El primero
se gana un premio especial)

INSTRUCCIONES

1. En su base de datos, conservar únicamente las variables correspondientes
a sexo, edad, auto-reconocimiento étnico e ingreso laboral (INGLABO). Busquen
en el diccionario sus códigos y valores correspondientes.

2. Tomen las variables categóricas de sexo y auto-reconocimiento étnico y cambienles
el nombre por "sexo" y "etnia" (sé que suena simple pero la idea es hacer todo replicable).
A su vez revisen el diccionario y etiqueten sus valores correspondientes (usando label
define y label values).

3. Para la edad, van a crear una variable de rangos de edad, de la siguiente manera.

a. Usen keep para limitar la base de datos únicamente a los individuos que tengan entre
25 y 65 años (tengan mucho cuidado usando los >, <, >= o <=).

b. Creen una nueva variable "edad_ran" que sea igual a 0. Luego reemplacen los valores de 1 en
adelante en ventanas de 10 años (como trabajo con límites, piensen en que toca decir "Reemplaceme
la variable x con tal valor, si la variable "edad" es mayor (o mayor igual) a "y" y menor (o
menor igual) a "z").

c. Al tener los rangos, etiqueten cada rango siguiendo "Entre "y" y "z" años).

4. Revisen en la ayuda de Stata el comando "table". Permite crear tablas con mayor flexibilidad.

5.
*/










