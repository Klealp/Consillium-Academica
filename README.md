# Consilium-Academica
The Consillium Academica initiative, spearheaded by the academic vice-deanship of the Faculty of Sciences of the Universidad Nacional de Colombia, undertakes a comprehensive clustering analysis of undergraduate students. The methodology employed in this initiative serves as a proactive measure to identify and support students at risk, to improve the effectiveness of the intervention strategies of the tutor-teacher program, facilitating direct contact between mentors and identified students to provide personalized guidance and academic advisement. This repository was created to share the codes and results from the article [Analysis of Academic Data to Group Students According to Their Academic Risk](https://revistas.unal.edu.co/index.php/estad/article/view/112870) published at the Colombian Journal of Statistics.

The contents of the folders are described below:

1. R Application:
   
- You will find the two RMarkdown scripts for the execution of the Consilium Academica system, in turn, you will find the two resulting HTML files. 
- There are 3 CSV files, which are the result of the Consillium Academica system, these correspond to the result obtained with the information of the semesters from 2017-1 to 2023-1 and considering as active students those enrolled in 2023-2, 'BASE_nueva.csv' is the result of the script 'Api_Elaborar_Base.Rmd', meanwhile 'Est_Buenos.csv' and 'Est_Risgo.csv' are the result of the script 'Api_Obtener_Triage.Rmd'.
- There are two additional necessary files for the execution of the system, these correspond to pre-programmed R functions, the first one is 'analisis_clusters.RData' that was programmed in the script to obtain the triage and the second one is 'Importacion2.RData' which is used for both scripts and it is programmed in the file 'Funcion Import2.R'.

2. Send Emails:

Contains the three R files to send emails automatically for the students at risk, the students with good performance and finally the tutor teachers of the students at risk. These scripts require as input the two csv files of the students present in the first folder of this list.

3. Bootstrap Analysis:
   
This folder contains a unique R script file, "Fuzzy - Bootstrap.R", where you can find the code to execute the bootstrap analysis, it only requires the same file 'BASE_nueva.csv' to import the database with the information of the academic histories. Its time of execution is around 3 hours.
