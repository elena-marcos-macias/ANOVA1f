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
  - :matlab: 
