
  clear all // Esto borra la memoria de Stata para comenzar de cero.
  cls  // Esto elimina el contenido de la ventana de resultados. 
  cap log close // Crear un archivo .Log
  global Log "C:\Users\SAML207\Downloads\Taller Stata" 
  macro dir //Nos muestra el directorio (dir) de las macros (un global es una macro, después lo veremos mejor) 
  log using "${Log}/sesion1.log", replace

  *==========================================================================*
  *                    SESIÓN UNO - INTRODUCCIÓN A STATA                     *
  *==========================================================================*
  
  clear all
  
**# Inicio
  
**# Directorio: 

  * Se establecen las rutas donde se almacenan las bases y donde se quieren 
  * guardar los archivos de resultados.
  
  global Bases "C:\Users\SAML207\Downloads\Taller Stata\Bases"
**# Bookmark #1
  global Resultados "C:\Users\SAML207\Downloads\Taller Stata\Resultados"

**# Tipos de Archivos: 

/* 

  Hay dos categorías grandes de archivos en Stata:

	1. Archivos de Datos:
	
		- Estos son archivos que contienen la información sobre la cual haremos
		  el análisis econométrico. 
		
		- En Stata, estas bases de datos suelen seguir una estructura del tipo:
			- Filas: Unidad de obervación, i. 
			- Columnas: Variables. 
			  
		- Stata puede leer múltiples tipos de archivos con datos. Por ejemplo:
			- .dta:  Archivos en formato de base de datos de Stata.
			- .txt:  Archivos en formato de texto simple. 
			- .xlsx: Archivos en formato de excel. 
			
		- Stata también puede exportar bases de datos en múltiples tipos de 
		  archivos. 
	
	2. Archivos de Análisis y Manipulación de Datos:
	
		- Estos archivos contienen información del proceso de análisis y 
		  manipulación de datos en Stata. 
		  
		- Nos concentraremos en dos tipos de archivos:
		
			- do-files: Este archivo es un do-file. Son archivos de texto simple
			  que contienen de forma ordenada un proceso de análisis de datos.
			  En esta clase SOLO trabjaremos a partir de do-files, nunca haremos
			  el análisis directamente en la ventana principal de Stata. 
				* Replicación / Replication!
				
			- log-files: Estos son archivos que contienen la información que 
			  sale en la ventana de resultados de Stata. Estos archivos se usan 
			  para guardar información de una sesión de Stata que queramos 
			  revisar en el futuro. 
				
		 
*/


**# Do-files:

*** Correr do-files:

	* Windows: Control + d
	* Mac: Command + Shift + d
	
**** ¿Cómo incorporar comentarios en los do-files?

	* Comentario de linea completa.

	// Comentario de linea parcial.
	display 2+1 //esto usualmente da 3

    /* Comentario cerrado */ 
	/*
	dis "Hola"
	dis 2+1
	*/
	
	/// Comentario dando continuidad a siguiente linea.
	dis ///
		"Hola"	
	
*** Algunos comandos básicos desde el do-file:

display "Muy buenos días estudiantes"	
				   /* Con este comando se le puede pedir a Stata que nos muestre 
					  un texto determinado */
	
display 20+10-5*3  /* Este comando también puede ser empleado como una 
					  calculadora */	

*** ¿Qué hacer si la línea de código está demasaido larga?
**** Por lo general no queremos que el código pase de la línea vertical. 

   display "Bienvenidos al Taller de Stata Intersemestral 2024"	
	
**** Opciones:
	
***** Dividir la línea con ///	
   display ///
   "Bienvenidos al Taller de Stata Intersemestral 2024"	
   
**# D) Importar Archivos: 

** Importar Archivos de Excel a Stata 
  	
  import excel "${Bases}/data_test_scores.xlsx", sheet("Hoja1") firstrow clear
  
** Importar separados por comas a Stata 

  import delimited "${Bases}/data_test_scores.csv", clear 

** Abrir Archivos .dta (Formato de Stata)

  use "${Bases}/data_test_scores.dta", clear 

**# E) Comandos Básicos: 

* Importamos los datos de nuevo:

  use "${Bases}/data_test_scores.dta", clear 

* Explorar los datos:
  display _N
  describe //describe el tipo de variables 
  codebook //int son número enteros, float son decimales.

* Cambiar el orden de las columnas:
  
  h order
  order gender parenteduc mathscore readingscore ///
  ethnicgroup lunchtype v1 testprep writingscore

* Cambiar el orden de las filas:
  
  gsort  mathscore // orden ascendente por puntaje. 
  gsort -mathscore // orden descendiente por puntaje. 

* Operadores Lógicos en Stata:

  *-------------------------------------------------------------------*
  *	  Expresiones Lógicas 					             			  *
  *-------------------------------------------------------------------*
  *			&, |						  Y (And), O (Or)			  *
  *			>,<							Mayor que, Menor que		  *
  *		   ==, !=						Igual a, Diferente a		  *
  *		   >=, <=					Mayor Igual, Menor o Igual 		  *
  *-------------------------------------------------------------------*
  *	  Expresiones Aritméticas 										  *
  *-------------------------------------------------------------------*
  *			+, -							Mas, Menos				  *
  *			*, /					 Multiplicación, División 		  *
  *			_n					Número de observación corriente		  *  
  *			_N					Número de observaciones totales		  *
  *-------------------------------------------------------------------*

** Algunos ejemplos:

  list mathscore if _n<10 // Muestra el valor para las primera 9 filas 

  list mathscore if _n<10 | _n>30630 // Muestra primeras 9 o desde la 4996. 

  list mathscore if _n<10 & gender=="female" // Primeras 9 mujeres en puntaje
                                                   

* Tipos de variables:

/*
  Inicialmente vamos a trabajar con dos tipos de variables:
	- Numéricas 
	- De texto (strings en ingles)
*/
  
** Renombrar y etiquetar variables

  rename gender genero
  browse genero //ya no está en la base bajo ese nombre
  
  codebook genero
  h label
  label var genero "Género del estudiante"

** Queremos crear una nueva variable para el género
  
  count if genero == "female" // contar observaciones con una condición 
                              // particular

* Operaciones con variables: 

* Crear variable del género del estudiante

  generate gen_estudiante = 0

  replace gen_estudiante = 1 if genero == "female"

  label define genero 0 "Masculino" 1 "Femenino"
  
  label values gen_estudiante genero
  
  tab gen_estudiante
  
  label var gen_estudiante "Género del estudiante"
  
  tab gen_estudiante
  
 * Crear variable de pérdida del examen
  
  gen reprobado_mat = 1 if mathscore <60 
  
  replace reprobado_mat = 0 if mathscore >= 60
  replace reprobado_mat = 0 if reprobado_mat == .
  
  tab reprobado_mat
  
/*
  EJERCICIO SENCILLO: Hasta ahora trabajamos creando categóricas. 
  Hay 3 variables de resultados de tests (mathscore, readingscore y writingscore)
  Creen una variable que promedie los resultados de los 3 tests, utilizando dos 
  métodos: Calculando el promedio manualmente (sumar las 3 y dividir), utilizando
  la función integrada de Stata (usen la herramienta de ayuda).
  ***PREMIO*** para los que hagan este ejercicio.
*/
	
* Estadísticas descriptivas básicas: comando summarize (abreviación sum)

  summarize mathscore, d
  
* ¿Qué pasa si hago summarize sobre una de las variables tipo string?  