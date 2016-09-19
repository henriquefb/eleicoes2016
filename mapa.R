
# Escrito por Carlos Góes
# Pesquisador-Chefe, Instituto 

setwd("U:/Research/partidos/basededados/")

library(ggplot2)
library(ggmap)
library(maps)
library(mapproj)

baseline <- read.csv(file="https://raw.githubusercontent.com/omercadopopular/eleicoes2016/master/prefeito.csv",head=TRUE,sep=",")

partidos = 26

brazilmap <-  get_map(
  "Brazil",
  zoom = 4,
  color="bw"
)

lista <- names(baseline[,1:partidos])


for (legenda1 in lista) {
  for (legenda2 in lista) {
#    assign(paste(legenda1,legenda2, sep = "") , 
    assign(
      paste("m",legenda1,legenda2, sep = ""),
      ggmap(brazilmap, extent = "device") +
        geom_point(
               aes(x = longitude, y = latitude),
               color = 'red',
               data = baseline[baseline[,legenda1] == 1 & baseline[,legenda2] == 1,]
               , size = 0.5)
      )
    ggsave(
      paste("m",legenda1,legenda2, sep = ""),
      filename = paste("m",legenda1,legenda2,".png",sep = ""),
      dpi = 600)     
  }
}  


