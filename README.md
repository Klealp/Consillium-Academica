# Consillium-Academica
The Consillium Academica initiative, spearheaded by the academic vice-deanship of the Faculty of Sciences of the Universidad Nacional de Colombia, undertakes a comprehensive clustering analysis of undergraduate students.The methodology employed in this initiative serves as a proactive measure to identify and support students at risk, to improve the effectiveness of the intervention strategies of the tutor-teacher program, facilitating direct contact between mentors and identified students to provide personalized guidance and academic advisement.

The contents of the folders are described below:

1. Aplicacion R:
   
- You will find the two RMarkdown scripts for the execution of the Consillium Academica system, in turn, you will find the two resulting HTML files. 
- There are 3 CSV, which are the result of the Consillium Academica system, these correspond to the result obtained with the information of the semesters from 2017-1 to 2023-1 and taking as active students those enrolled in 2023-2, 'BASE_nueva.csv' is the result of the script 'Api_Elaborar_Base.Rmd', while 'Est_Buenos.csv' and 'Est_Risgo.csv' are the result of the script 'Api_Obtener_Triage.Rmd'.
- There are two files necessary for the execution of the system that correspond to pre-programmed R functions, the first one is 'analisis_clusters.RData' that was programmed in the script to obtain the triage and the second one is 'Importacion2.RData' that is used in the two scripts and is programmed in the file 'Funcion Import2.R'.

2. Enviar_Correo:

Contains the 3 R files to send mails automatically for the students at risk, the students with good performance and finally the tutor teachers of the students at risk. These scripts require as input the two csv of the students present in the first folder of this list.
