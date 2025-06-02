# ReadMe
Este código esta pensado para realizar un análisis de varianza de tipo ANOVA de 1 factor intersujeto con hasta 4 niveles de factor o sus alternativas no paramétricas (no se ha probado con más de 4 niveles por el momento). Es decir, comparará los datos relativos a los distintos grupos experimentales entre si para una variable, pero no comparará entre variables.
## Pre-requisitos
- Tener instalado MATLAB (el código fué hecho con MATLAB R2024a).
- Tener los datos a analizar en una única hoja de un archivo Excel (.xlsx). El nombre del archivo no debe contenter espacios, signos de puntuación o caracteres especiales. La primera fila del archivo se corresponderá con los nombres de las variables y a partir de ahí cada fila será un sujeto del estudio. Cada columna se corresponderá con una variable a analizar. Es necesario que una de estas variables sea una variable categórica, es decir, una variable de agrupación en función de la que se va a distinguir a que grupo pertenece cada sujeto (*en este caso "Genotipo", en la columna A, será nuestra variable categórica*). ![image](https://github.com/user-attachments/assets/dec0a335-7cd0-432e-861e-5406c4d53b3e)
## Descarga del repositorio
- Descarga el .zip desde la opción "CODE > Local > Download ZIP" y guárdalo en tu PC.
- Descomprime el archivo. Al hacerlo deberías encontrar la siguiente estructura:
  - 📁 data: unica carpeta a modificar por el ususario.
    - Archivo "instructionsANOVA1f.json" es un archivo de texto que deberás modificar.
    - Aquí deberás pegar el Excel con tus datos.
  - 📁 requirements: funciones ajenas necesarias para el funcionamiento del código.
  - 📁 results: aquí se generarán los archivos Excel (.xlsx) y figuras de MATLAB (.fig) resultantes del análisis.
  - 📁 utils: funciones propias necesarias para el funcionamiento del código.
  - Archivo de MATLAB "ANOVA1f.m" : archivo con el código a ejecutar.
  - Archivo "README.md".
  - Puede haber otros archivos que no son relevantes para el usuario. No los borre.
 ## Inportar los datos a analizar
 Abre la carpeta "data" y copia el archivo Excel con tus datos.
 ## Modificar el archivo .json
 En la carpeta "data" abre el archivo "instructionsANOVA1f.json". Si no tienes un editor de código hazlo con el block de notas. Verás la siguiente estructura:
 
  ![image](https://github.com/user-attachments/assets/444dc0ea-cee4-4b63-8613-408184fab314)
  
 NO MODIFIQUES NINGÚN ELEMENTO A LA IZQUIERDA DE LOS DOS PUNTOS ( : ). 
 A continuación iremos viendo paso por paso como modificar el archivo .json:
   1. 
