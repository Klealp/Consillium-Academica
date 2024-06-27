# librerías--------
library(readxl)
library(ggplot2)
library(readr)
library(FactoClass)   #ACP
library(gridExtra)    # Grilla ggplot
library(ppclust)      # fuzzy


# Importación de la BASE_6_años
BASE_nueva <- read_csv("BASE.csv", 
                         col_types = cols(...1 = col_skip(), COD_PLAN = col_character(), 
                         ACTIVO = col_character()))
# ------------------------------- ACP --------------
library(factoextra)
library(FactoMineR)

# Selección de las variables numéricas
Agrupar <- BASE_nueva[,3:9]
PCAestud=PCA(Agrupar)
get_eigenvalue(PCAestud)
fviz_eig(PCAestud, addlabels=T)
fviz_pca_biplot(PCAestud, geom = "point", col.ind = "gray", col.var = "blue")

# Guardamos las coordenadas de los estudiantes en los 3 ejes
coord <- as.data.frame(PCAestud$ind$coord[,1:3])
coord[,2] <- -coord[,2]

# ------------------------------Fuzzy c-Means  FCM ---------------------------------
# https://cran.r-project.org/web/packages/ppclust/vignettes/fcm.html#1_preparing_for_the_analysis

# Inicialización con centros del kmeans normal
set.seed(21)
k_means <- kmeans(coord, 6, nstart = 40) 

ggplot() + geom_point(aes(x = Dim.1, y = Dim.2, color = k_means$cluster), data = coord, size = 2) +
  scale_colour_gradientn(colours=rainbow(6)) +
  geom_point(aes(x = k_means$centers[, 1], y = k_means$centers[, 2]), color = 'black', size = 3) + 
  ggtitle('Clusters de Datos con k = 6 / K-Medios') + 
  xlab('Avance en la carrera') + ylab('Desempeño Académico')+
  labs(color="Cluster")

# Ejecución Fuzzy C-Means
tictoc::tic()
ini.fcm <- fcm(coord, centers = k_means$centers, numseed = 21, m=2)
tictoc::toc()

ini.fcm$comp.time # 6 años: 1:30 min
ini.fcm$iter

head(as.data.frame(ini.fcm$u), 10)

Cluster <- ini.fcm$cluster
ggplot() + geom_point(aes(x = Dim.1, y = Dim.2, color = Cluster), data = coord, size = 2) +
  scale_colour_gradientn(colours=rainbow(6)) +
  ggtitle('Clusters de Datos con k = 6 / Fuzzy ') + 
  xlab('Avance en la carrera') + ylab('Desempeño Académico')+
  labs(color="Cluster")

#write.csv(Cluster, "Fuzzy.csv")

# Bootstrap librería -------------------------------------------------
library(fpc)

fuzzy_CBI <- function(X, k=6){
  k_means_boot <- kmeans(X, k, nstart=40)
  c1 <- fcm(X, centers = k_means_boot$centers, m=2 )
  result <- partition <- c1$cluster
  nc <- k
  cl=list()
  for (i in 1:nc){
    cl[[i]] <- partition==i
  }
  out <- list(result=c1, nc=nc, clusterlist=cl, partition=partition,
              clustermethod="FuzzyCmeans")
  out
}


tictoc::tic()
boot <- clusterboot(coord, B=100, clustermethod = fuzzy_CBI, bootmethod = "boot", seed = 50)
tictoc::toc()
  
print(boot)
windows(1000,1200)
plot(boot)

AvgJaccard <- boot$bootmean
stdJaccard <- apply(boot[["bootresult"]], 1, sd)
Instability <- boot$bootbrd/100
Clusters <- c(1:6)

# Tabla de estadísticas del Índice de Jaccard
Eval <- cbind(Clusters, AvgJaccard, stdJaccard, Instability)
library(xtable)
xtable::xtable(Eval, digits = c(0,0,3,3,0))

# Histogramas de la distribución del índice
par(mfrow=c(2,3))
for (i in 1:6) {
  hist(boot$bootresult[i,], xlim = c(0.8,1), ylim = c(0,40), breaks = seq(0.80,1,0.01),
       col = "#7CCD7C", main = paste("Grupo", i), ylab = "Frecuencia",
       xlab = "Índice de Jaccard")
}

library(gridExtra)

windows(8,5.5)
Graficos <- list()
for (i in 1:6) {
  Datos <- data.frame(Jaccard=boot$bootresult[i,])
  
  Graficos[[i]] <- ggplot(Datos, aes(x=Jaccard, ))+
                    geom_histogram(alpha=0.8, fill="#7CCD7C" , colour="#7CCD7C", binwidth=0.005 )+
                    geom_vline(xintercept = AvgJaccard[i], color="#2F4F4F", lwd=1.15)+
                    ggtitle(paste0("Group ",i))+
                    ylim(0,18)+ xlim(0.85,1)+
                    xlab("Jaccard Index") + ylab("Frecuency")+
                    theme_minimal()+
                    theme(plot.title = element_text(color="#548B54", size=15))
}

grid.arrange(Graficos[[1]], Graficos[[2]], Graficos[[3]], Graficos[[4]], Graficos[[5]], Graficos[[6]], ncol=3)

# Guardar Resultado de Bootstrap
save(boot, file = "Resul_boot_Final.RData")

# Cargar Resultado de Bootstrap
load(file = "Resul_boot_Final.RData")