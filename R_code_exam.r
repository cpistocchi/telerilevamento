#ESAME TELERILEVAMENTO GEO-ECOLOGICO (A.A- 2021-2022)
#DESERTIFICAZIONE E STAGIONALITà: IL LAGO CHAD COME CASO STUDIO

#librerie:

#install.packages("raster")
#install.packages("RStoolbox")
#install.packages("patchwork")
#install.packages("viridis")

library(raster)
library(RStoolbox)
library(patchwork)
library(viridis)

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
lake13 #min->max : 0->65535, cioè 65536 valori, immagine a 16 bit

#plot immagine 2013 (visibile)
plotRGB(lake13, r=4, g=3, b=2, stretch="lin") #stretch lineare
plotRGB(lake13, r=4, g=3, b=2, stretch="hist") #stretch istogrammi, per evidenziare meglio i contrasti

#2022:
rlist22 <- list.files(pattern="LC08_L2SP_185051_20220405_20220412_02_T1_SR_B") #lista di file (qui bande) relative all'immagine del 2022
rlist22
import22 <- lapply(rlist22, raster) #applicazione della funzione raster alle bande selezionate nella lista precedente, per importarle
import22
lake22 <- stack(import22) #creazione stack: combinazione dei vari layer relativi al 2013
lake22 #immagine a 16 bit

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

#CLASSIFICAZIONE, per comprendere meglio di discriminare le componenti
#in 4 classi
class413 <- unsuperClass(lake13, nClasses=4)
class413
class422 <- unsuperClass(lake22, nClasses=4)
class422
par(mfrow=c(1, 2))
plot(class413$map, col=viridis(4, option="G")) #mako
plot(class422$map, col=viridis(4, option="G")) #mako
#con 4 classi sono ben visibili l'acqua, la vegetazione e le zone con suolo nudo (probabilmente a due livelli diversi di umidità del suolo)

#evidenziamo differenza nella copertura vegetale tra il 2013 e il 2022 (aprile: fine periodo secca).
#NIR nella componente R:
par(mfrow=c(1,2))
plotRGB(lake13, r=5, g=4, b=3, stretch="hist")
plotRGB(lake22, r=5, g=4, b=3, stretch="hist")
#in rosso sono evidenziate le zone con vegetazione
#per renderlo ancora più evidente,
#NIR nella componente G, rosso nella R, e verde nella B:
par(mfrow=c(1,2))
plotRGB(lake13, r=4, g=5, b=3, stretch="hist")
plotRGB(lake22, r=4, g=5, b=3, stretch="hist")
#in verde sono evidenziate le zone con vegetazione, mentre in viola intenso l'acqua del lago, delle pozze e del fiume.

#INDICI SPETTRALI
#Indici di vegetazione: DVI e NDVI
#DVI e NDVI 2013 (DVI=NIR-red)
dvi13 = lake13[[5]]-lake13[[4]]
dvi13
ggplot()+
geom_tile(dvi13, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() #palette di default, ma la risoluzione viene bassissima 
#oppure, sempre usando viridis
plot(dvi13, col=viridis(200, option="B")) #palette inferno
#in giallo-verde sono evidenziate le zone con vegetazione, ma comunque non ha valori elevati di DVI (non sono giallo intenso), quindi non è molto in salute
#(l'immagine è acquisita ad aprile, fine periodo di secca)
ndvi13 <- dvi13/(lake13[[5]]+lake13[[4]])
ndvi13
plot(ndvi13, col=viridis(200, option="B"))

#DVI e NDVI 2022 
dvi22 <- lake22[[5]]-lake22[[4]]
dvi22
plot(dvi22, col=viridis(200, option="B")) #palette inferno
ndvi22 =dvi22/(lake22[[5]]+lake22[[4]])
ndvi22
plot(ndvi22, col=viridis(200, option="B"))

#affiancando i NDVI 2013-2022
par(mfrow=c(1,2))
plot(ndvi13, col=viridis(200, option="B"))
plot(ndvi22, col=viridis(200, option="B"))
#ha senso confrontarli se hanno un numero diverso di px?

#indici spettrali immagine 2013
si13 <- spectralIndices(lake13, green=3, red=4, nir=5)
plot(si13, col=viridis(200, option="B"))
#indici spettrali immagine 2022
si13 <- spectralIndices(lake22, green=3, red=4, nir=5)
plot(si22, col=viridis(200, option="B"))

#contenuto di acqua in corpi idrici
#NDWI (Normalized Difference Water Index) 2013 (NDWI=(Green-NIR)/(Green + NIR)
ndwi13 <- (lake13[[3]]-lake13[[5]]) / (lake13[[3]]+lake13[[5]])
ndwi13
plot(ndwi13, col=viridis(200, option="E")) #cividis
#in giallo (valori elevati, positivi di NDWI) presenza di acqua. in particolare NDWI(0-> +0.2) suolo con presenza di una discreta quantità di acqua (anche se non elevata)
#in blu (valori bassi, negativi di NDWI) assenza di acqua al suolo

#NDWI 2022
ndwi22 <- (lake22[[3]]-lake22[[5]]) / (lake22[[3]]+lake22[[5]])
ndwi22
plot(ndwi22, col=viridis(200, option="E")) #cividis

#multiframe (2013 a dx, 2022 a sx), con NDVI (sopra, legenda inferno) e NDWI (sotto, legenda cividis)
par(mfrow=c(2,2))
plot(ndvi13, col=viridis(200, option="B"))
plot(ndvi22, col=viridis(200, option="B"))
plot(ndwi13, col=viridis(200, option="E"))
plot(ndwi22, col=viridis(200, option="E"))
#sembra che la vegetazione sia diminuita nel 2022 (o lo stato di salute sia peggiorato), 
#e questo può essere dovuto a fattori climatici ad esempio, come una stagione delle piogge troppo breve ad anticipare quella di secca 
#(alla fine della quale è stata rilevata l'immagine)
#però, dato che le immagini hanno dimensioni (in px) diverse, è possibile che la legenda sia stata adattata diversamente ai valori, e che questo porti a errori nell'interpretazione
#evidente è, però, la sostituzione di vegetazione con acqua nella zona nord-est del lago, evidenziabile sia dal NDVI che dal NDWI.
#per mostrarlo in modo più evidente, viene calcolata in seguito la differenza tra il NDVI fra il 2013 e il 2022, e tra il NDWI fra il 2013 e il 2022:
#la differenza non produce errori, anche se le due immagini hanno dimensioni diverse, grazie alla georeferenziazione.
#è effettuata la sottrazione per i px corrispondenti allo stesso punto sulla mappa (lo si nota perchè la dimensione in px della differenza è minore sia dell'immagine del 2013 che del 2022)

clb <- colorRampPalette(c("blue", "white", "red"))(100)
ndvi_dif=ndvi13-ndvi22
ndwi_dif=ndwi13-ndwi22
par(mfrow=c(1,2))
plot(ndvi_dif, col=clb) #valori elevati, in rosso, mostrano una avvenuta perdita di vegetazione, mentre le zone blu sono quelle dove vi è stato un aumento di vegetazione
plot(ndwi_dif, col=clb) #valori elevati, in rosso, mostrano un aumento dell'acqua sulla superficie, mentre in blu, una perdita di zone con acqua in superficie
#le situazioni sono complementari, soprattutto nella parte alta dell'immagine (dove a un aumento della vegetazione corrisponde una diminuzione delle zone sommerse),
#e nella parte a Nord-Est del lago, dove invece la vegetazione è stata soppiantata dalla presenza dell'acqua.


