library(readr)
library(readxl)
library(tidyverse)
library(mailR)
library(sqldf)
library(dplyr)

# Carga de datos --------------------------------------------------------
Estudiantes <- read_csv("Est_Riesgo.csv", col_types = cols(...1 = col_skip(), COD_PLAN = col_character(), 
                                                      GRUPO = col_skip(), DOCUMENTO = col_character()))

table(Estudiantes$PLAN, Estudiantes$TRIAGE)

Tutores <- read_excel("lista-tutor trabajo_3.xlsx", sheet = "Hoja1", 
                       col_types = c("text", "text", "text", "text", "text", 
                                     "text", "text", "text"))

name_col <- colnames(Tutores)
colnames(Tutores) <- c(name_col[1:7], "CORREO_TUTOR")

Estudiantes <- sqldf("SELECT E.*, T.TUTOR, T.CORREO_TUTOR
                     FROM Estudiantes E INNER JOIN Tutores T 
                     ON (E.DOCUMENTO=T.DOCUMENTO)")

Estudiantes <- na.omit(Estudiantes)

colnames(Estudiantes)[3] <- "PAPA"

length(levels(as.factor(Estudiantes$CORREO_TUTOR)))

# Redacción correo-------------------------------------------------------

Saludo <- "Saludos profesor(a), el programa Consillium Academica es un proyecto en desarrollo que realiza una clasificación de los estudiantes de pregrado de la facultad de ciencias de acuerdo a su avance y desempeño académico en el programa curricular. El resultado de este programa nos ofrece un Triage Académico de los estudiantes que contiene los siguientes niveles:
  
  - Triage I: Riesgo Alto.
  - Triage II: Riesgo Medio.
  - Triage III: Riesgo Bajo.
  - Triage IV: Consillium Bajo.
  - Triage V: Consillium Medio.
  - Triage VI: Consillium Alto."

razon <- "El objetivo de este correo es informarle que algún o algunos de los estudiantes de los cuáles usted ha sido designado como tutor(a) han sido clasificados en el Triage I, II o III, lo cual quiere decir que presentan algún nivel de riesgo de expulsión o deserción del programa curricular. Por esta razón, le solicitamos contactar lo más pronto posible a estos estudiantes en caso de que ellos no lo hayan contactado ya a usted. La información de contacto, junto con su respectivo Triage, la encontrará en el archivo adjunto a este correo."
  
explicacion <- "Para ayudarle a comprender un poco el rendimiento académico del estudiante y la razón por la que ha sido clasificado en cada Triage a continuación encontrará la caracterización de los 3 primeros niveles del Triage Académico: "

Triage_I <- "- Los estudiantes en el Triage I se caracterizan por presentar un riesgo alto de expulsión o deserción. Aquí se encuentran estudiantes que están empezando sus estudios universitarios y ya registran un alto número de asignaturas reprobadas, por lo cual, su avance por semestre es muy bajo. Acá se pueden encontrar estudiantes con un PAPA incluso inferior a 3.0 pero que al día de hoy aparecen como estudiantes activos en el semestre actual de acuerdo a las bases de registro, por lo cual se considera que deben recibir atención urgente."
                  
Triage_II <- "- Los estudiantes en el Triage II se caracterizan por presentar un riesgo medio de expulsión o de deserción con un bajo porcentaje de avance en su carrera. Aquí se encuentran estudiantes con una distribución baja en sus promedios pero que registran pocas asignaturas reprobadas, sin embargo su avance porcentual en la carrera en cada semestre es bajo. Por esta razón, deben ser los estudiantes a contactar luego de atender a las personas en el Triage I. "

Triage_III <- "- Los estudiantes en el Triage III se caracterizan por presentar un riesgo bajo de deserción contando con un alto porcentaje de avance en su carrera. Aquí se encuentran estudiantes que han cursado varias matrículas pero que su avance porcentual en el programa es bajo, además estos estudiantes reportan un alto número de asignaturas reprobadas. A pesar de que estos estudiantes ya han avanzado en sus estudios, igualmente resulta necesario contactarlos y asesorarlos para garantizar su permanencia en la carrera, por esta razón son el último grupo en el orden de atención. "

asesoria <- "Esperamos que pueda contactar a todos los estudiantes lo más pronto posible y programar una cita bien sea de forma virtual o presencial, todo esto con el fin de llegar a identificar las problemáticas que afronta el estudiante y brindarle cualquier asesoría que les permita mejorar su desempeño académico."

Final <- paste0( "Finalmente, recuerde que 'Consillium Academica' aún se encuentra en desarrollo, por lo que posteriormente se le enviará un formulario para conocer su opinión frente a esta alerta y el resultado de la reunión con los estudiantes.", 
                 "\n \n",
                 "La información sobre el Triage de cada uno de los estudiantes debe ser tratada de forma confidencial. La vicedecanatura académica no atiende estudiantes, solo envía esta información, así que por favor absténgase de responder a este correo.")

cuerpo <- paste(Saludo, razon, explicacion, Triage_I, Triage_II, Triage_III, asesoria, Final, sep = "\n \n")

# Enviar correo ------------------------------------------------------------ 
envio_mail <- function(tutor_correo){
  
  nombre <- "Estudiantes.csv" # Nombre del reporte
  
  Estudiantes %>%
    filter(CORREO_TUTOR == tutor_correo) %>%
    select(NOMBRES, APELLIDO1, APELLIDO2, PLAN, PAPA, CORREO, TRIAGE) %>%
    write.csv(nombre) # Transformar y guardar la data
     
  destinatario <- unique(Estudiantes$CORREO_TUTOR[Estudiantes$CORREO_TUTOR==tutor_correo])
  
  send.mail(from = "correo@gmail.com",
            to = destinatario,
            subject = "Atención a estudiantes en riesgo académico",
            body = cuerpo,
            smtp = list(host.name = "smtp.gmail.com", 
                        port = 465, 
                        user.name = "correo@gmail.com",            
                        passwd = "*******", 
                        ssl = TRUE),
            authenticate = TRUE, 
            send = FALSE, # Autorizar envío de correo
            attach.files = nombre)     # Adjuntar archivo de Excel
}

sapply( unique(Estudiantes$CORREO_TUTOR), envio_mail)

