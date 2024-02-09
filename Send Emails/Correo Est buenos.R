library(readr)
library(readxl)
library(tidyverse)
library(mailR)

Estudiantes <- read_csv("Est_Buenos.csv", col_types = cols(...1 = col_skip(), COD_PLAN = col_character(), 
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
  IV = "Los estudiantes en el Triage IV se caracterizan por presentar un buen rendimiento académico. Aquí se encuentran estudiantes que están empezando sus estudios universitarios y registran un PAPA alto, además de que no tienden a reprobar asignaturas y por lo tanto su porcentaje de avance por semestre es aceptable.",
  
  V = "Los estudiantes en el Triage V se caracterizan por presentar un buen rendimiento académico. Aquí se encuentran estudiantes que se encuentran alrededor de la mitad de avance en sus estudios universitarios y registran un PAPA alto. Estos estudiantes han desarrollado sus estudios de forma óptima pues no tienden a reprobar asignaturas o por mucho registran dos asignaturas perdidas en su historia académica por lo tanto su porcentaje de avance por semestre es aceptable.",
  
  VI = "Los estudiantes en el Triage VI se caracterizan por presentar un buen rendimiento académico. Aquí se encuentran estudiantes que se encuentran cerca de finalizar sus estudios universitarios y registran un PAPA alto, en su historia académica se registra que reprobaron muy pocas materias o ninguna, por lo que su porcentaje de avance suele coincidir con el semestre en el que se encuentra."

 )

Final <- paste0( "Por esta razón, queremos extender nuestras felicitaciones por su destacado desempeño en sus estudios. Es de resaltar su dedicación y esfuerzo, por lo cual queremos motivarle a seguir avanzando con determinación y enfoque, sabiendo que está bien encaminado a culminar sus estudios y obtener un título profesional. ", 
                 "\n \n",
                 "La información sobre su triage es confidencial. La vicedecanatura académica no atiende estudiantes, solo envía esta información, así que por favor absténgase de responder a este correo.")


envio_mail <- function(Triage){
  
 for (j in 1:length(Triage)) {
   
   Grupo <- Estudiantes[which(Estudiantes$TRIAGE==Triage[j]),]
   
   mensaje_triage <- which(names(Comentarios)==Triage[j])
   Nudo <- Comentarios[[mensaje_triage]]
   
   for (i in length(carreras)) {
     
     Subgrupo <- Grupo[which(Grupo$PLAN==i),]
     
     destinatario <- as.vector(Subgrupo$CORREO)
     
     Clasificacion <- paste0("El sistema ha determinado que usted se encuentra clasificado en el Triage ",Triage[j],
                      " por su rendimiento académico en el programa de ",i,".",
                      " Tenga en cuenta que este Triage fue calculado con la información de asignaturas cursadas únicamente entre los semestres de 2017-1 y 2023-1 en donde se obtuvo una calificación numérica." )
     
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
carreras <- levels(as.factor(Estudiantes$PLAN))

envio_mail(Triage)

