###### Función de Importación 2

Importacion2 <- function(año){
  
  library(readxl)
  # Leer las hojas de excel con la historia académica y las asignaturas inscritas
  Hist_Aca <- read_excel(paste0("Bases/",año,".xlsx"), sheet = "Historia Academica", 
                         col_types = c("text", "text", "text", "text", "skip", "text", 
                                       "text", "text", "text", "numeric", "text"))
  
  colnames(Hist_Aca) <- c("IDG_RIUU","FACULTAD","COD_PLAN","PLAN","CONVOCATORIA","APERTURA",
                          "ACCESO","SUBACCESO","PBM","NODO_INICIO")
  
  Personal <- read_excel(paste0("Bases/",año,".xlsx"), sheet = "Anonimizado", 
                         col_types = c("text", "numeric", "text", "text", "text", "text"))
  
  
  # Seleccionar solo pregrado 
  Incorr <- which(Hist_Aca$SUBACCESO=="SUBACCESO") 
  Hist_Aca <- Hist_Aca[-Incorr,]
  
  Posgrado <- which(Hist_Aca$SUBACCESO=="REGULAR DE POSGRADO")
  Hist_Aca <- Hist_Aca[-Posgrado,] 
  
  Hist_Aca <- sqldf("SELECT B.*, C.DOCUMENTO, C.NOMBRES, C.APELLIDO1, C.APELLIDO2, C.CORREO
                     FROM Hist_Aca B INNER JOIN Personal C 
                          ON (B.IDG_RIUU=C.IDG_RIUU)")
  
  return(Hist_Aca)
}

save(Importacion2, file="Importacion2.RData")

Importacion2("2023-2")
