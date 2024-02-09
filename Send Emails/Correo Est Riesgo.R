library(readr)
library(readxl)
library(tidyverse)
library(mailR)

Estudiantes <- read_csv("Est_Riesgo.csv", col_types = cols(...1 = col_skip(), COD_PLAN = col_character(), 
                                                      GRUPO = col_skip(), DOCUMENTO = col_character()))

table(Estudiantes$PLAN, Estudiantes$TRIAGE)

Saludo <- "Saludos, el programa Consillium Academica es un proyecto en desarrollo que realiza una clasificación de los estudiantes de pregrado de la facultad de ciencias de acuerdo a su avance y desempeño académico en el programa curricular. El resultado de este programa nos ofrece un Triage Académico de los estudiantes que contiene los siguientes niveles:
  
  - Triage I: Riesgo Alto.
  - Triage II: Riesgo Medio.
  - Triage III: Riesgo Bajo.
  - Triage IV: Consillium Bajo.
  - Triage V: Consillium Medio.
  - Triage VI: Consillium Alto."

Comentarios <- list(
  Triage_I = paste0("Los estudiantes en el Triage I se caracterizan por presentar un riesgo alto de expulsión o deserción. Aquí se encuentran estudiantes que están empezando sus estudios universitarios y ya registran un alto número de asignaturas reprobadas, por lo cual su avance por semestre es muy bajo.",
                    " Por esta razón, hemos diseñado Consillium Academica para propiciar un encuentro con su profesor(a) tutor(a) para brindarle toda la asesoría posible.", 
                    " Si su tutor(a) no lo contacta en los próximos días le sugerimos solicitarle una cita prioritaria y/o buscar apoyo en bienestar de su departamento o de la Facultad de Ciencias."),
  
  Triage_II = paste0("Los estudiantes en el Triage II se caracterizan por presentar un riesgo medio de expulsión o de deserción con un bajo porcentaje de avance en su carrera. Aquí se encuentran estudiantes con una distribución baja en sus promedios pero que registran pocas asignaturas reprobadas, sin embargo su avance porcentual en la carrera en cada semestre es bajo.",
                     " Por esta razón, hemos diseñado Consillium Academica para propiciar un encuentro con su profesor(a) tutor(a) para brindarle toda la asesoría posible.", 
                     " Si su tutor(a) no lo contacta en un plazo máximo de 5 días le sugerimos solicitarle una cita prioritaria y/o buscar apoyo en bienestar de su departamento o de la Facultad de Ciencias."),
  
  Triage_III = paste0("Los estudiantes en el Triage III se caracterizan por presentar un riesgo bajo de deserción contando con un alto porcentaje de avance en su carrera. Aquí se encuentran estudiantes que han cursado varias matrículas pero que su avance porcentual en el programa es bajo, además estos estudiantes reportan un alto número de asignaturas reprobadas.",
                      " Por esta razón, hemos diseñado Consillium Academica para propiciar un encuentro con su profesor(a) tutor(a) para brindarle toda la asesoría posible.", 
                      " Si su tutor(a) no lo contacta en un plazo máximo de 7 días le sugerimos solicitarle una cita prioritaria y/o buscar apoyo en bienestar de su departamento o de la Facultad de Ciencias.")
 )

Final <- paste0( "Finalmente, recuerde que 'Consillium Academica' aún se encuentra en desarrollo, por lo que posteriormente se le enviará un formulario para conocer su opinión frente a esta alerta y el resultado de la reunión con su tutor(a). Por otro lado, si considera que la información contenida en este correo no es acorde a la realidad le agradecemos también informarnos en dicho formulario.", 
                 "\n \n",
                 "La información sobre su triage es confidencial. La vicedecanatura académica no atiende estudiantes, solo envía esta información, así que por favor absténgase de responder a este correo.")


envio_mail <- function(Triage){
  
 for (j in 1:length(Triage)) {
   
   Grupo <- Estudiantes[which(Estudiantes$TRIAGE==Triage[j]),]
   
   Nudo <- Comentarios[[j]]
   
   for (i in 1:nrow(Grupo)) {
     
     destinatario <- Grupo$CORREO[i]
     Prog <- Grupo$PLAN[i]
     PAPA <- Grupo$PAPA_tot[i]
     
     Clasificacion <- paste0("El sistema ha determinado que usted se encuentra clasificado en el Triage ",Triage[j],
                      " por su rendimiento académico en el programa de ",Prog,".",
                      " Tenga en cuenta que este Triage fue calculado con la información de asignaturas cursadas únicamente entre los semestres de 2017-1 y 2023-1, así que el PAPA que se tuvo en cuenta para su clasificación fue ",
                      PAPA,". Es posible que este promedio no coincida con su PAPA oficial en el SIA, por lo cual no se tiene que alarmar." )
     
     union <- paste(Saludo, Clasificacion, Nudo, Final, sep = "\n \n")
     
     send.mail(from = "correo@gmail.com",
               to = destinatario,
               subject = "Reporte de Consillium Academica",
               body = union,
               smtp = list(host.name = "smtp.gmail.com", 
                           port = 465, 
                           user.name = "correo@gmail.com",            
                           passwd = "*******", 
                           ssl = TRUE),
               authenticate = TRUE, 
               send = FALSE)     # Autorizar envío de correo
    }
  } 
}

Triage <- levels(as.factor(Estudiantes$TRIAGE))
envio_mail(Triage)

    