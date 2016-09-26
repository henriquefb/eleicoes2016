#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////// ESCRITO POR /////////////////////////////////
#///////////////////////////////// CARLOS GÓES /////////////////////////////////
#////////////////////////////////////// E //////////////////////////////////////
#//////////////////////////////// RADUAN MEIRA /////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////// INSTITUTO MERCADO POPULAR ///////////////////////////
#/////////////////////////// www.mercadopopular.org ////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////////////////////
#////////////////////////////////// LEIA-ME ////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
  
  
#  Descrição do projeto

# Usa dados do arquivo prefeito.csv e o conjunto de coordenadas
# geo-espaciais para criar um mapa das alianças entre os partidos.

#

setwd("U:/Research/partidos/basededados/")

library(ggplot2)
library(ggmap)
library(maps)
library(mapproj)

baseline <- read.csv(file="U:/Research/partidos/basededados/prefeito.csv",head=TRUE,sep=",")


brazilmap <-  get_map(
  "Brazil",
  zoom = 4,
  color="bw",
  maptype ="hybrid"
)

lista <- names(baseline[,1:partidos])


pmdbmapa <- ggmap(brazilmap, extent = "device") + 
 geom_point(
    aes(x = longitude, y = latitude),
    color = 'blue',
    data = baseline[baseline[,"PMDB"] == 1 & baseline[,"PSDB"] == 1,],
    size = 1,
    alpha = 1) +
  geom_point(
    aes(x = longitude, y = latitude),
    color = 'red',
    data = baseline[baseline[,"PMDB"] == 1 & baseline[,"PT"] == 1,],
    size = 1,
    alpha = 1) +
geom_point(
  aes(x = longitude, y = latitude),
  color = 'white',
  data = baseline[baseline[,"PMDB"] == 1 & baseline[,"PSDB"] == 1 & baseline[,"PT"] == 1,],
  size = 1,
  alpha = 1)
  
ggsave(pmdbmapa,   filename = "pmdbmapa.pdf")       
