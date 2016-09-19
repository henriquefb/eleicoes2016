
# Escrito por Carlos Góes
# Pesquisador-Chefe, Instituto 

setwd("U:/Research/partidos/basededados/")

library(ggplot2)
library(ggmap)
library(maps)
library(mapproj)

baseline <- read.csv(file="https://raw.githubusercontent.com/omercadopopular/eleicoes2016/master/prefeito.csv",head=TRUE,sep=",")

partidos = 26

lista <- names(baseline[,1:partidos])

for (legenda1 in lista) {
  for (legenda2 in lista) {
    assign(paste(legenda1,legenda2, sep = "") , subset(baseline, legenda1 == 1 & legenda2 == 1) )
      }
}


brazilmap <-  get_map(
    "Brazil",
    zoom = 4,
    color="bw"
    )
  
sample1 <- subset(baseline, PMDB == 1 & PT == 1)

ggmap(brazilmap, extent = "device") + geom_point(aes(x = longitude, y = latitude), size = 1 , color = 'red' , data = sample1, size = 0.5)

ggsave("map.png", dpi = 600) 

