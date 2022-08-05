#ESAME TELERILEVAMENTO GEO-ECOLOGICO (A.A- 2021-2022)
#DESERTIFICAZIONE E STAGIONALITà: IL LAGO CHAD COME CASO STUDIO

#librerie:

#install.packages("raster")
#install.packages("RStoolbox")
#install.packages("patchwork")

library(raster)
library(RStoolbox)
library(patchwork)

#setting della cartella di lavoro:
setwd("C:/lab/Lake_Chad_Analysis") 


#le immagini satellitati utilizzate sono state prodotte da LandSat 8, con risoluzione 30 m x 30 m.
#nel caso di LandSat, le bande che saranno considerate in questa analisi:
#banda 2: blu
#banda 3: verde
#banda 4: rosso
#banda 5: NIR


#CONFRONTO Aprile 2013-2022

#importazione delle immagini a partire dai singoli layer.
#2013:
rlist13 <- list.files(pattern="LC08_L2SP_185051_20130412_20200912_02_T1_SR_B") #lista di file (qui bande) relative all'immagine del 2014
rlist13
import13 <- lapply(rlist13, raster) #applicazione della funzione raster alle bande selezionate nella lista precedente, per importarle
import13
lake13 <- stack(import13) #creazione stack: combinazione dei vari layer relativi al 2013
lake13

#plot immagine 2013 (visibile)
plotRGB(lake13, r=4, g=3, b=2, stretch="lin") #stretch lineare
plotRGB(lake13, r=4, g=3, b=2, stretch="hist") #stretch istogrammi, per evidenziare meglio i contrasti

#2022:
rlist22 <- list.files(pattern="LC08_L2SP_185051_20220405_20220412_02_T1_SR_B") #lista di file (qui bande) relative all'immagine del 2022
rlist22
import22 <- lapply(rlist22, raster) #applicazione della funzione raster alle bande selezionate nella lista precedente, per importarle
import22
lake22 <- stack(import22) #creazione stack: combinazione dei vari layer relativi al 2013
lake22

#plot immagine 2022 (visibile)
plotRGB(lake22, r=4, g=3, b=2, stretch="lin") #stretch lineare
plotRGB(lake22, r=4, g=3, b=2, stretch="hist") #stretch istogrammi

#confronto visibile 2013-2022 con stretch a istogrammi
par(mfrow=c(1,2))
plotRGB(lake13, r=4, g=3, b=2, stretch="hist")
plotRGB(lake22, r=4, g=3, b=2, stretch="hist")
#oppure, con patchwork e RStoolbox:
plot13 <- ggRGB(lake13, r=4, g=3, b=2, stretch="hist")
plot22 <- ggRGB(lake22, r=4, g=3, b=2, stretch="hist")
plot13 + plot22

#le immagini del 2013 e del 2021 sono relative alla stessa zona ma hanno dimensioni leggermente diverse (2013: 55136451 px; 2022: 59145081 px).
#per questo motivo verranno fatte analisi e considerazioni di carattere qualitativo (e non quantitativo).

#evidenziamo differenza nella copertura vegetale tra il 2013 e il 2022 (aprile: fine periodo secca).
#NIR nel rosso:
par(mfrow=c(1,2))
plotRGB(lake13, r=5, g=4, b=3, stretch="hist")
plotRGB(lake22, r=5, g=4, b=3, stretch="hist")


