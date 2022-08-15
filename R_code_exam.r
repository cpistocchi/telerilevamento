#ESAME TELERILEVAMENTO GEO-ECOLOGICO (A.A- 2021-2022)
#DESERTIFICAZIONE E STAGIONALITà: IL LAGO CHAD COME CASO STUDIO

#librerie:

#install.packages("raster")
#install.packages("RStoolbox")
#install.packages("patchwork")
#install.packages("viridis")
#install.packages("ggplot2")

library(raster)
library(RStoolbox)
library(patchwork)
library(viridis)
library(ggplot2)

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
rlist13 <- list.files(pattern="LC08_L2SP_185051_20130412_20200912_02_T1_SR_B") #lista di file (qui bande) relative all'immagine del 2013
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
lake22 <- stack(import22) #creazione stack: combinazione dei vari layer relativi al 2022
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

#frequenze (numero di px) per ogni classe
freq(class413$map) #frequenze 4 classi 2013
#classe 1 (piante): 10064971 px
#classe 2 (acqua): 3870693 px
freq(class422$map) #frequenze 4 classi 2022
#classe 1 (acqua): 4865587 px
#classe 4 (piante): 10225045 px
#per capire quanti px totali
lake13
tot13 <- 55136451
lake22
tot22 <- 59145081
veg13 <- 10064971/tot13*100 #vegetazione % nel 2013
veg13
veg22 <- 10225045/tot22*100 #vegetazione % nel 2022
veg22
acq13 <- 3870693/tot13*100 #acqua % nel 2013
acq13
acq22 <- 4865587/tot22*100 #acqua % nel 2022
acq22
#DATI FINALI
#% vegetazione 2013: 18.25466%
#% acqua 2013: 7.020207%
#% vegetazione 2022: 17.28807%
#% acqua 2022: 8.226529%
#DATAFRAME
classi <- c("Vegetazione%", "Acqua%") #prima colonna
perc13 <- c(18.25466, 7.020207) #seconda colonna
perc22 <- c(17.28807, 8.226529) #terza colonna
multitemporal <- data.frame(classi, perc13, perc22)
View(multitemporal)
#BARCHART 2013
ggplot(multitemporal, aes(x=classi, y=perc13, col=classi))+
geom_bar(stat="identity", fill="white")
#BARCHART
ggplot(multitemporal, aes(x=classi, y=perc22, col=classi))+
geom_bar(stat="identity", fill="white")


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
#in giallo sono evidenziate le zone con vegetazione, ma comunque non ha valori elevati di DVI (non sono giallo intenso), quindi non è molto in salute
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

#MISURE DI ETEROGENEITà: PCA
#per ottenere la PC1
pca13 <- rasterPCA(lake13) #2013
pca22 <- rasterPCA(lake22) #2022
pca13
pca22
summary(pca13$model) #la PC1 (2013) spiega il 93.2% della variabilità del sistema
summary(pca22$model) #la PC1 (2022) spiega il 94.5% della variabilità del sistema
#la PC1 è quindi in grado di rappresentare, in un singolo layer, la maggior parte della variabilità del sistema. 
#verrà quindi impiegata per misurare la variabilità del sistema.
#plottando tutte le componenti, si evidenzia come la PC1 anche graficamente mostri meglio la variabilità, discriminando meglio le componenti:
plot(pca13$map)
plot(pca22$map)
#si associa ciascuna PC1 a un oggetto, per facilitare i passaggi successivi
pc1_13 <- pca13$map$PC1
pc1_22 <- pca22$map$PC1
#plot della PC1 per il 2013 (dx) e per il 2022 (sx), con legenda plasma
par(mfrow=c(1,2))
plot(pc1_13, col=viridis(200, option="C"))
plot(pc1_22, col=viridis(200, option="C")) 
#la variabilità è ben evidenziata da entrambi i plot, specialmente da quello del 2022
#calcolo della variabilità su PC1 (tale calcolo è possibile effettuarlo su un solo layer)
sdpc1_13 <- focal(pc1_13, matrix(1/9, 3, 3), fun=sd)
sdpc1_13
plot(sdpc1_13, col=viridis(200, option="B"))
sdpc1_22 <- focal(pc1_22, matrix(1/9, 3, 3), fun=sd) 
sdpc1_22
plot(sdpc1_22, col=viridis(200, option="B"))
#la moving window è molto piccola (3x3) e la variabilità non è ben evidenziata in questo modo, quindi si ricalcola usando una mving window 7x7 (sovrascrivendo)
sdpc1_13 <- focal(pc1_13, matrix(1/49, 7, 7), fun=sd)
sdpc1_13
plot(sdpc1_13, col=viridis(200, option="B"))
sdpc1_22 <- focal(pc1_22, matrix(1/49, 7, 7), fun=sd) 
sdpc1_22
plot(sdpc1_22, col=viridis(200, option="B"))

#resample, per rendere più veloci le esecuzioni successive
lake13res <- aggregate(lake13, fact=10)
lake22res <- aggregate(lake22, fact=10)
#PC1
pca13 <- rasterPCA(lake13res) #2013
pca22 <- rasterPCA(lake22res) #2022
pca13
pca22
summary(pca13$model) #la PC1 (2013) spiega il 93.9% della variabilità del sistema
summary(pca22$model) #la PC1 (2022) spiega il 95.2% della variabilità del sistema
#la PC1 è quindi in grado di rappresentare, in un singolo layer, la maggior parte della variabilità del sistema. 
#verrà quindi impiegata per misurare la variabilità del sistema.
#plottando tutte le componenti, si evidenzia come la PC1 anche graficamente mostri meglio la variabilità, discriminando meglio le componenti:
plot(pca13$map)
plot(pca22$map)
#si associa ciascuna PC1 a un oggetto, per facilitare i passaggi successivi
pc1_13 <- pca13$map$PC1
pc1_22 <- pca22$map$PC1
#plot della PC1 per il 2013 (dx) e per il 2022 (sx), con legenda plasma
par(mfrow=c(1,2))
plot(pc1_13, col=viridis(200, option="C"))
plot(pc1_22, col=viridis(200, option="C")) 
#la variabilità è ben evidenziata da entrambi i plot
#calcolo della variabilità su PC1 (tale calcolo è possibile effettuarlo su un solo layer)
sdpc1_13 <- focal(pc1_13, matrix(1/9, 3, 3), fun=sd)
sdpc1_13
sdpc1_22 <- focal(pc1_22, matrix(1/9, 3, 3), fun=sd) 
sdpc1_22
par(mfrow=c(1,2))
plot(sdpc1_13, col=viridis(200, option="B"))
plot(sdpc1_22, col=viridis(200, option="B"))
#in entrambi i casi, nella sponda nord del lago si ha una elevata eterogeneità (questo quindi non varia nel tempo).
#considerando anche la classificazione, si vede che tale zona vede aree allagate, umide e vegetate.





#ANDAMENTO STAGIONALE 2021
#Nelle date:
#02/04: fine stagione secca
#24/08: max pioggia
#27/10: fine stagione pioggia
#22/12: stagione secca
#importazione delle immagini a partire dai singoli layer.
#aprile:
rlist04 <- list.files(pattern="LC08_L2SP_185051_20210402_20210409_02_T1_SR_B")
rlist04
import04 <- lapply(rlist04, raster)
import04
lake04 <- stack(import04)
lake04 #immagine a 16 bit    7771, 7611, 59145081
#agosto:
rlist08 <- list.files(pattern="LC08_L2SP_185051_20210824_20210901_02_T1_SR_B")
rlist08
import08 <- lapply(rlist08, raster)
import08
lake08 <- stack(import08)
lake08 #immagine a 16 bit   7771, 7621, 59222791
#ottobre:
rlist10 <- list.files(pattern="LC08_L2SP_185051_20211027_20211104_02_T1_SR_B")
rlist10
import10 <- lapply(rlist10, raster)
import10
lake10 <- stack(import10)
lake10 #immagine a 16 bit    7771, 7611, 59145081
#dicembre:
rlist12 <- list.files(pattern="LC09_L2SP_185051_20211222_20220121_02_T1_SR_B")
rlist12
import12 <- lapply(rlist12, raster)
import12
lake12 <- stack(import12)
lake12 #immagine a 16 bit   7761, 7611, 59068971

#confronto a colori naturali (con stretch lineare) della situazione nei 4 mesi:
par(mfrow=c(2,2))
plotRGB(lake04, r=4, g=3, b=2, stretch="lin")
plotRGB(lake08, r=4, g=3, b=2, stretch="lin")
plotRGB(lake10, r=4, g=3, b=2, stretch="lin")
plotRGB(lake12, r=4, g=3, b=2, stretch="lin")


#evidenziamo differenza nella copertura vegetale.
#NIR nella componente R:
par(mfrow=c(2,2))
plotRGB(lake04, r=5, g=4, b=3, stretch="lin")
plotRGB(lake08, r=5, g=4, b=3, stretch="lin")
plotRGB(lake10, r=5, g=4, b=3, stretch="lin")
plotRGB(lake12, r=5, g=4, b=3, stretch="lin")
#in rosso sono evidenziate le zone con vegetazione
#per renderlo ancora più evidente,
#NIR nella componente G, rosso nella R, e verde nella B:
par(mfrow=c(2,2))
plotRGB(lake04, r=4, g=5, b=3, stretch="lin")
plotRGB(lake08, r=4, g=5, b=3, stretch="lin")
plotRGB(lake10, r=4, g=5, b=3, stretch="lin")
plotRGB(lake12, r=4, g=5, b=3, stretch="lin")
#in verde sono evidenziate le zone con vegetazione, mentre in viola intenso l'acqua del lago, delle pozze e del fiume.


#INDICI SPETTRALI
#DVI e NDVI (indici di vegetazione)
#aprile 2021
dvi04 = lake04[[5]]-lake04[[4]]
dvi04
ndvi04 <- dvi04/(lake04[[5]]+lake04[[4]])
ndvi04
#agosto 2021
dvi08 <- lake08[[5]]-lake08[[4]]
dvi08
ndvi08 =dvi08/(lake08[[5]]+lake08[[4]])
ndvi08
#ottobre 2021
dvi10 <- lake10[[5]]-lake10[[4]]
dvi10
ndvi10 =dvi10/(lake10[[5]]+lake10[[4]])
ndvi10
#dicembre 2021
dvi12 <- lake12[[5]]-lake12[[4]]
dvi12
ndvi12 =dvi12/(lake12[[5]]+lake12[[4]])
ndvi12

#NDVI confrontato per i 4 mesi
par(mfrow=c(2,2))
plot(ndvi04, col=viridis(200, option="B")) #inferno
plot(ndvi08, col=viridis(200, option="B")) #inferno
plot(ndvi10, col=viridis(200, option="B")) #inferno
plot(ndvi12, col=viridis(200, option="B")) #inferno
#in giallo sono evidenziate le zone vegetate. In agosto la vegetazione è più abbondante e più in salute, con poche zone desertiche o aride: il periodo corrisponde all'apice della stagione umida

#NDWI (contenuto di acqua in corpi idrici)
#aprile 2021
ndwi04 <- (lake04[[3]]-lake04[[5]]) / (lake04[[3]]+lake04[[5]])
ndwi04
#agosto 2021
ndwi08 <- (lake08[[3]]-lake08[[5]]) / (lake08[[3]]+lake08[[5]])
ndwi08
#ottobre 2021
ndwi10 <- (lake10[[3]]-lake10[[5]]) / (lake10[[3]]+lake10[[5]])
ndwi10
#dicembre 2021
ndwi12 <- (lake12[[3]]-lake12[[5]]) / (lake12[[3]]+lake12[[5]])
ndwi12

#NDWI confrontato per i 4 mesi
par(mfrow=c(2,2))
plot(ndwi04, col=viridis(200, option="E")) #cividis
plot(ndwi08, col=viridis(200, option="E")) #cividis
plot(ndwi10, col=viridis(200, option="E")) #cividis
plot(ndwi12, col=viridis(200, option="E")) #cividis

#confronto NDVI ed NDWI
par(mfrow=c(2,4))
plot(ndvi04, col=viridis(200, option="B")) #inferno
plot(ndvi08, col=viridis(200, option="B")) #inferno
plot(ndvi10, col=viridis(200, option="B")) #inferno
plot(ndvi12, col=viridis(200, option="B")) #inferno
plot(ndwi04, col=viridis(200, option="E")) #cividis
plot(ndwi08, col=viridis(200, option="E")) #cividis
plot(ndwi10, col=viridis(200, option="E")) #cividis
plot(ndwi12, col=viridis(200, option="E")) #cividis
#dal confronto è visibile come ad aprile vi sia scarsa vegetazione e una moderata presenza di acqua nel lago
#ad agosto, nel pieno della stagione delle piogge, si assiste ad un aumento della vegetazione, che diventa più rigogliosa, occupando anche le zone umide che normalmente verrebbero evidenziate da valori elevati di NDWI
#(per questo motivo potrebbe risultare che la copertura di acqua sia diminuita. Contestualizzando questo risultato in base all'andamento stagionale, questo è un risultato dell'aumento della copertura vegetale)
#ad ottobre, fine della stagione delle piogge, la vegetazione è già diminuita (o comunque in uno stato di salute peggiore rispetto ad agosto)
#per questo motivo la vegetazione espone nuovamente le zone umide, che coprono una buona superficie
#lo stesso avviene anche per dicembre, con la differenza che si assiste a una lieve diminuzione della vegetazione e delle zone umide rispetto ad ottobre
#essendo dicembre ancora all'inizio della stagione secca, si ha un contenuto maggiore di acqua rispetto ad aprile.

#CLASSIFICAZIONE, per disciminare meglio le componenti e valutare numericamente come variano nel tempo la copertura vegetale e il contenuto di acqua nel corpo idrico
#in 4 classi
class404 <- unsuperClass(lake04, nClasses=4) #aprile
class404
class408 <- unsuperClass(lake08, nClasses=4) #agosto
class408
class410 <- unsuperClass(lake10, nClasses=4) #ottobre
class410
class412 <- unsuperClass(lake10, nClasses=4) #dicembre
class412
par(mfrow=c(2, 2))
plot(class404$map, col=viridis(4, option="G")) #mako
plot(class408$map, col=viridis(4, option="G")) #mako
plot(class410$map, col=viridis(4, option="G")) #mako
plot(class412$map, col=viridis(4, option="G")) #mako
#con 4 classi sono ben visibili l'acqua, la vegetazione e le zone con suolo nudo (probabilmente a due livelli diversi di umidità del suolo)

#frequenze (numero di px) per ogni classe
freq(class404$map) #frequenze 4 classi aprile 2021
#classe 2 (piante): 11257685 px
#classe 4 (acqua): 5422670 px
freq(class408$map) #frequenze 4 classi agosto 2021
#classe 3 (piante): 20102683 px
#classe 1 (acqua): 4651143 px
freq(class410$map) #frequenze 4 classi ottobre 2021
#classe 1 (piante): 11422391 px
#classe 2 (acqua): 5242353 px
freq(class412$map) #frequenze 4 classi dicembre 2021
#classe 4 (piante): 11808194 px
#classe 3 (acqua): 5199266 px
#per capire quanti px totali
lake04
tot04 <- 59145081
lake08
tot08 <- 59222791
lake10
tot10 <- 59145081
lake12
tot12 <- 59068971
#% copertura vegetale
veg04 <- 11257685/tot04*100 #vegetazione % aprile
veg04
veg08 <- 20102683/tot08*100 #vegetazione % agosto
veg08
veg10 <- 11422391/tot10*100 #vegetazione % ottobre
veg10
veg12 <- 11808194/tot12*100 #vegetazione % dicembre
veg12
#% acqua
acq04 <- 5422670/tot04*100 #acqua % aprile
acq04
acq08 <- 4651143/tot08*100 #acqua % agosto
acq08
acq10 <- 5242353/tot10*100 #acqua % ottobre
acq10
acq12 <- 5199266/tot12*100 #acqua % dicembre
acq12
#DATI FINALI
#% vegetazione aprile: 19.03402%
#% acqua aprile: 9.168421%
#% vegetazione agosto: 33.94417%
#% acqua agosto: 7.853637%
#% vegetazione ottobre: 19.3125%
#% acqua ottobre: 8.863549%
#% vegetazione dicembre: 19.99052%
#% acqua dicembre: 8.802026%
#DATAFRAME
classi <- c("Vegetazione%", "Acqua%") #prima colonna
perc04 <- c(19.03402, 9.168421) #seconda colonna
perc08 <- c(33.94417, 7.853637) #terza colonna
perc10 <- c(19.3125, 8.863549) #quarta colonna
perc12 <- c(19.99052, 8.802026) #quinta colonna
multitemporal1 <- data.frame(classi, perc04, perc08, perc10, perc12)
View(multitemporal1)
Mesi <- c("04: Aprile", "08: Agosto", "10: Ottobre", "12: Dicembre") #prima colonna
PercVegetazione <- c(19.03402, 33.94417, 19.3125, 19.99052) #seconda colonna
PercAcqua <- c(9.168421, 7.853637, 8.863549, 8.802026) #terza colonna
multitemporal2 <- data.frame(Mesi, PercVegetazione, PercAcqua)
View(multitemporal2)
#BARCHART vegetazione nei 4 mesi
ggplot(multitemporal2, aes(x=Mesi, y=PercVegetazione, col=Mesi))+
geom_bar(stat="identity", fill="white")
#BARCHART acqua nei 4 mesi
ggplot(multitemporal2, aes(x=Mesi, y=PercAcqua, col=Mesi))+
geom_bar(stat="identity", fill="white")
