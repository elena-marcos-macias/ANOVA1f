# ReadMe
Este código esta pensado para realizar un análisis de varianza de tipo ANOVA de 1 factor intersujeto con hasta 4 niveles de factor o sus alternativas no paramétricas (no se ha probado con más de 4 niveles por el momento). Es decir, comparará los datos relativos a los distintos grupos experimentales entre si para una variable, pero no comparará entre variables.
## Pre-requisitos
- Tener instalado MATLAB (el código fué hecho con MATLAB R2024a).
- Tener los datos a analizar en una única hoja de un archivo Excel (.xlsx). El nombre del archivo no debe contenter espacios, signos de puntuación o caracteres especiales. La primera fila del archivo se corresponderá con los nombres de las variables y a partir de ahí cada fila será un sujeto del estudio. Cada columna se corresponderá con una variable a analizar. Es necesario que una de estas variables sea una variable categórica, es decir, una variable de agrupación en función de la que se va a distinguir a que grupo pertenece cada sujeto (*en este caso "Genotipo", en la columna A, será nuestra variable categórica*). ![image](https://github.com/user-attachments/assets/dec0a335-7cd0-432e-861e-5406c4d53b3e)
## Descarga del repositorio
- Descarga el .zip desde la opción "CODE > Local > Download ZIP" y guárdalo en tu PC.
- Descomprime el archivo. Al hacerlo deberías encontrar la siguiente estructura:
  - 📁 data: única carpeta a modificar por el ususario.
    - Archivo "instructionsANOVA1f.json" es un archivo de texto que deberás modificar.
    - Aquí deberás pegar el Excel con tus datos.
  - 📁 requirements: funciones ajenas necesarias para el funcionamiento del código.
  - 📁 results: aquí se generarán los archivos Excel (.xlsx) y figuras de MATLAB (.fig) resultantes del análisis.
  - 📁 utils: funciones propias necesarias para el funcionamiento del código.
  - Archivo de MATLAB "ANOVA1f.m" : archivo con el código a ejecutar.
  - Archivo "README.md".
  - Puede haber otros archivos que no son relevantes para el usuario. No los borre.
 ## Importar los datos a analizar
 Abre la carpeta "data" y copia el archivo Excel con tus datos.
 ## Modificar el archivo .json
 En la carpeta "data" abre el archivo "instructionsANOVA1f.json". Si no tienes un editor de código (yo he usado VisualStudio) hazlo con el block de notas. Verás la siguiente estructura:
 
   ![image](https://github.com/user-attachments/assets/444dc0ea-cee4-4b63-8613-408184fab314)
   
 A continuación iremos viendo paso por paso como modificar el archivo .json:
   1. Conceptos previos:
      - NO MODIFIQUES NINGÚN ELEMENTO A LA IZQUIERDA DE LOS DOS PUNTOS ( : ). Los elementos a la derecha de los dos puntos son modificables. Si lo que vas a introducir es texto, siempre debe ir entre comillas (*por ejemplo "FUS_20250527.xlsx"*). Si por el contrario son números, deben ir entre corchetes (*por ejemplo [3,19]*).
      - Si te fijas los elementos estan organizados en bloques separados por llaves ( { } ) o corchetes ( [ ] ), NO LOS MODIFIQUES. Todos los elementos dentro de un mismo bloque deben estar separados por comas ( , ) salvo el último.
   2. "fileName" : nombre del archivo Excel que previamente has copiado en la carpeta "data". Es importante que esté escrito exactamente igual, incluida la extensión (.xlsx). Mi recomendación es que lo copies y lo pegues en lugar de escribirlo.
   4. "columnCriteria" : criterio que le permitirá al programa distinguir entre aquellas columnas del excel que contienen datos con los que debe operar frente a los que no. Las columnas con la variable categórica o el ID de los sujetos NO se consideran datos con los que se vaya a operar.
      - "target_columns" : aquellas que contienen datos con los que SI se va a operar. Puede rellenarse de dos maneras:
          - Texto: palabra que compartan todas las columnas a utilizar, deben coincidir también mayúsculas y minúsculas. *Por ejemplo, si quiero distinguir entre columnas que contengan datos de media que se llamen Mean_1, Mean_2, ..., Mean_n; escribiré el string "Mean" entrecomillado.*
          - Números: debemos indicar los intervalos de columnas entre los que se encuentran los datos. Los números siempre se introducirán por pares, siendo siempre el primer número el número de columna en el que se inicia el intervalo y el segundo el número en el que se termina. *Por ejemplo, si los datos están entre la columna C y la H y entre la M y la U tendría que introducir [3,8,13,21].*
      - "ignore_columns" : aquellas que contienen datos con los que NO se van a operar. Puede rellenarse de dos maneras:
          - Texto: seran aquellas que no contengan el string que se haya introducido como target. En este caso rellenar con *"None"*.
          - Números: también debemos indicar los intervalos de columnas que queremos ignorar. Los números siempre se introducirán por pares, siendo siempre el primer número el número de columna en el que se inicia el intervalo y el segundo el número en el que se termina. *Por ejemplo, si los datos están entre la columna A y la B y entre la I y la L tendría que introducir [1,2,9,12].*
   5. "groupName" : nombre de la variable de agrupación. Tiene que coincidir con el encabezado de la columna que contenga dicha variable. *En el caso de los datos que se presentaban al principio sería la columna A, "Genotipo".*
   6. "groupOrder" : categorías de la variable de agrupación, en el orden en el que quieres que se representen los datos en el gráfico. Puedes incluir hasta 4. *Por ejemplo, para representar 1º WT, 2º Het y 3º Hom, escribiríamos ["WT", "Het", "Hom"].*
   7. "groupControl" : estas variables, "controlGroup1" y "controlGroup2" definen aquellos grupos que van a ser definidos como controles para el análisis posthoc de tipo Dunnet y su alternativa no paramétrica.
   8. "descriptiveStatistics" : nombre que queremos darle al archivo excel que contiene los datos de la estadística descriptiva. Importante incluir la extensión (.xlsx). El programa devuelve el número de muestras por grupo, la media y la desviación estandar.
   9. "varianceAnalysis" : nombre que queremos darle al archivo excel que contiene los datos de la estadística descriptiva. Importante incluir la extensión (.xlsx). El programa devuelve el estadístico F para aquellas comparaciones en las que se puedo hacer ANOVA y Chi^2 para aquellas en las que se realizó la alternativa no paramétrica, además devuleve el valor de la p y si este es significativo o no.
   10. "posthoc_AllComparisons" : nombre que queremos darle al archivo excel que contiene los datos de los post hoc tipo Tukey y su alternativa no paramétrica. Importante incluir la extensión (.xlsx). El programa devuelve el valor de la p y si este es significativo o no.
   11. "posthoc_vsControl1" : nombre que queremos darle al archivo excel que contiene los datos de los post hoc tipo Dunnet y su alternativa no paramétrica contra el grupo que hayamos establecido como "controlGroup1". Importante incluir la extensión (.xlsx). El programa devuelve el valor de la p y si este es significativo o no.
   12. "posthoc_vsControl2" : nombre que queremos darle al archivo excel que contiene los datos de los post hoc tipo Dunnet y su alternativa no paramétrica contra el grupo que hayamos establecido como "controlGroup2". Importante incluir la extensión (.xlsx). El programa devuelve el valor de la p y si este es significativo o no.
   13. "graphBar" : nombre que queremos darle al archivo de figura de MATLAB. Importante incluir la extensión (.fig). Con "graphTiltle" se específica el título del gráfico y con "xAxisLabel" y "yAxisLabel" los títulos de los ejes x e y respectivamente. ![image](https://github.com/user-attachments/assets/e419d805-6402-4252-b432-cf312358dcf2)
Una vez modificadas todas las variables necesarias guardar el archivo .json. No es necesario cerrar para ejecutar el código correctamente pero si guardar.
## Ejecutar el script
En la carpeta principal abrir el archivo de MATLAB "ANOVA1f.m" y ejecutar (botón de RUN).
## Extraer los resultados
En la carpeta "results" deberían haber aparecido tantos exceles como archivos .xlsx hubieses nombrado en el apartado "outputFileNames" del .json y un archivo .fig con el gráfico de MATLAB. Este ultimo archivo es modificable para poder personalizar las longitudes de los ejes, si se quiere o no escala, etc.
