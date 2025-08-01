# ReadMe

This code is designed to perform a one-way between-subjects ANOVA with up to four factor levels, or its non-parametric alternatives (note: functionality has not yet been tested for more than four levels). In other words, it compares data across different experimental groups for a single variable, but it does **not** compare across different variables.

## Prerequisites

- MATLAB must be installed (this code was developed using MATLAB R2024a).
- The data to be analyzed must be contained in a single sheet of an Excel file (.xlsx). The file name must **not** contain spaces, punctuation marks, or special characters. The contents of the table **MUST** be in english.  
  - **NO cells should be empty** unless the whole row is to be discarded. This script completely deletes a row if any of its cells are empty.
  - The **first row** of the file must contain the variable names.  
  - Each **subsequent row** corresponds to one subject in the study.  
  - Each **column** represents a variable to be analyzed.  
  - One of the variables must be a **categorical grouping variable**, which is used to determine each subject’s group membership. *In this case, the variable “Genotipo” in column A serves as the categorical variable.*
  - One of the variables can be another, **bimodal, categorical variable** which allow us to highlight certain subjects. *In column B, the variable "Muerte" indicates which animals died spontaneously during the experiment.* VOY A SACAR EL VALOR TRUE DE LA FUNCIÓN Y PONERLO EN EL JSON PARA QUE SEA MODIFICABLE!!!
  <img width="1172" height="569" alt="image" src="https://github.com/user-attachments/assets/97c14b2b-31b2-40e8-8f6a-3f5f7235fd98" />



## Downloading the Repository

- Download the `.zip` file using the "CODE > Local > Download ZIP" option and save it to your computer.
- Extract the contents of the `.zip` file. The directory should contain the following structure:

  - 📁 `data`: the only folder the user needs to modify.
    - The file `instructionsANOVA1f.json` is a text file that **must** be edited by the user.
    - Paste your Excel file with the data into this folder.
  - 📁 `requirements`: external functions necessary for the script to run.
  - 📁 `results`: output folder where the resulting Excel (.xlsx) and MATLAB figure (.fig) files will be saved.
  - 📁 `utils`: internal functions required for the script.
  - `ANOVA1f.m`: the main MATLAB script to be executed.
  - `README.md`: this documentation file.
  - There may be additional files not relevant to the user. **Do not delete them.**

## Importing the Data

Open the `data` folder and copy your Excel data file into it.

## Editing the JSON File

Within the `data` folder, open the file `instructionsANOVA1f.json`. If you do not have a code editor (such as Visual Studio Code), you may use Notepad. You will see a structure similar to this:

<img width="945" height="915" alt="image" src="https://github.com/user-attachments/assets/8d2cc5fe-96ff-4062-acb7-0bdd828cb351" />


Follow these steps to modify the JSON file appropriately:

1. **Preliminary Notes:**
   - **Do not edit** any element to the **left** of the colons (`:`). Only modify the elements on the **right**.
   - If the element is **text**, it must be enclosed in double quotation marks (e.g., `"FUS_20250527.xlsx"`).
   - If the element is **numeric**, it must be enclosed in square brackets (e.g., `[3, 19]`).
   - The elements are organized in blocks enclosed in curly braces `{}` or square brackets `[]`—**do not alter** this structure.
   - Elements within the same block must be separated by commas `,`, **except the last one**.

2. **"fileName"**: The name of the Excel file you copied into the `data` folder. It must match exactly, including the `.xlsx` extension. It is recommended to copy and paste the file name rather than typing it manually.

3. **"columnCriteria"**: Criteria for distinguishing columns that contain data that is going to be used to mathematically operate from those that do not (e.g., grouping variable or subject ID columns).

   - **"target_columns"**: Specifies the columns to be analyzed. Two methods are available:
     - **Text**: A shared keyword present in all column names to be included (case-sensitive).  
       *Example: if columns are named Mean_1, Mean_2, ..., use `"Mean"`.*
     - **Numeric**: Specify the column ranges using pairs of numbers (start and end column indices).  
       *Example: to include columns D–I and N–V, write `[4,9,14,22]`.*

   - **"ignore_columns"**: Specifies the columns to exclude from analysis. Two options:
     - **Text**: If using the text method above for target columns, enter `"None"`.
     - **Numeric**: Specify the ranges of columns to be ignored using pairs of indices.  
       *Example: to ignore columns A–C and J–M, write `[1,3,10,13]`.*

4. **"groupName"**: Name of the grouping variable. This must match the column header in the Excel file.  
   *In the example data, this would be column A, labeled "Genotipo".*

5. **"groupOrder"**: List the categories of the grouping variable in the order you want them displayed in the graph (up to four categories). **All of the existing categories must be listed, regardless of you wanting them to appear in the graph or not. (I want to change it so that you can select some categories and not necessarily all of them)**
   *Example: `["WT", "Het", "Hom"]`.*

6. **"groupControl"**: Specify the groups to be treated as control groups for the post-hoc Dunnett test (and its non-parametric equivalent).

7. **"descriptiveStatistics"**: File name (including `.xlsx` extension) for the Excel file containing descriptive statistics.  
   The output includes group sample sizes, means, and standard deviations.

8. **"varianceAnalysis"**: File name (including `.xlsx` extension) for the output Excel file containing ANOVA (or non-parametric equivalent) results. Includes F-statistic (for ANOVA), Chi² (for non-parametric), p-values, and significance indicators.

9. **"posthoc_AllComparisons"**: File name (including `.xlsx` extension) for the output Excel file containing results from Tukey’s post-hoc test (and non-parametric alternative). Includes p-values and significance indicators.

10. **"posthoc_vsControl1"**: File name (including `.xlsx` extension) for the output Excel file containing results from the Dunnett post-hoc test against `"controlGroup1"` (and its non-parametric alternative). Includes p-values and significance indicators.

11. **"posthoc_vsControl2"**: File name (including `.xlsx` extension) for the output Excel file containing results from the Dunnett post-hoc test against `"controlGroup2"` (and its non-parametric alternative). Includes p-values and significance indicators.

12. **"graphBar"**: File name (with `.fig` extension) for the MATLAB figure output.  
    - `"graphTitle"`: title of the graph.  
    - `"xAxisLabel"` and `"yAxisLabel"`: labels for the X and Y axes, respectively.
    - `"showDead"´: LO HE CAMBIADO POR HIGHLIGHTVARIABLE para que no dependiense del nombre del excel. Pero claro ahora hay que terminar de actualizar el README. Tb me gustaría hacer opcional que aparezca el gráfico ¿if?
    ![image](https://github.com/user-attachments/assets/e419d805-6402-4252-b432-cf312358dcf2)

Once all necessary fields have been edited, save the `.json` file. It is not necessary to close the file before running the script, but it **must** be saved.

## Running the Script

Open the `ANOVA1f.m` script in the main directory using MATLAB and run it by clicking the **RUN** button.

## Retrieving the Results

In the `results` folder, you should find as many Excel files as specified in the `outputFileNames` section of the `.json` file, along with a `.fig` file containing the MATLAB graph.  
This figure is fully editable and can be customized (e.g., axis scaling, labels, appearance, etc.).
