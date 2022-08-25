# ESAME TELERILEVAMENTO GEO-ECOLOGICO (A.A- 2021-2022)
# DESERTIFICAZIONE E STAGIONALITà: IL LAGO CHAD COME CASO STUDIO

# Pacchetti:

# install.packages("raster")
# install.packages("RStoolbox")
# install.packages("viridis")
# install.packages(""ggplot2")

library(raster)
library(RStoolbox)
library(viridis)
library(ggplot2)

# Setting della cartella di lavoro:
setwd("C:/lab/Lake_Chad_Analysis") 


# Le immagini satellitati utilizzate sono state prodotte da LandSat 8, con risoluzione 30 m x 30 m.
# Nel caso di LandSat, le bande che saranno considerate in questa analisi:
# Banda 2: blu
# Banda 3: verde
# Banda 4: rosso
# Banda 5: NIR


#ANDAMENTO STAGIONALE 2021
# Nelle date:
# 02/04: fine stagione secca
# 24/08: max pioggia
# 27/10: fine stagione pioggia
# 22/12: stagione secca
# Importazione delle immagini a partire dai singoli layer.
# Aprile:
rlist04 <- list.files(pattern="LC08_L2SP_185051_20210402_20210409_02_T1_SR_B")
rlist04
import04 <- lapply(rlist04, raster)
import04
lake04 <- stack(import04)
lake04 
# Agosto:
rlist08 <- list.files(pattern="LC08_L2SP_185051_20210824_20210901_02_T1_SR_B")
rlist08
import08 <- lapply(rlist08, raster)
import08
lake08 <- stack(import08)
lake08 
# Ottobre:
rlist10 <- list.files(pattern="LC08_L2SP_185051_20211027_20211104_02_T1_SR_B")
rlist10
import10 <- lapply(rlist10, raster)
import10
lake10 <- stack(import10)
lake10 
# Dicembre:
rlist12 <- list.files(pattern="LC09_L2SP_185051_20211222_20220121_02_T1_SR_B")
rlist12
import12 <- lapply(rlist12, raster)
import12
lake12 <- stack(import12)
lake12 
# Sono tutte immagini a 16 bit

# Confronto a colori naturali (con stretch lineare) della situazione nei 4 mesi:
# pdf("4mesi_colnaturali.pdf")
par(mfrow=c(2,2))
plotRGB(lake04, r=4, g=3, b=2, stretch="lin")
plotRGB(lake08, r=4, g=3, b=2, stretch="lin")
plotRGB(lake10, r=4, g=3, b=2, stretch="lin")
plotRGB(lake12, r=4, g=3, b=2, stretch="lin")
# dev.off()


# Evidenziamo differenza nella copertura vegetale.
# NIR nella componente R:
# pdf("4mesi_NIR.pdf")
par(mfrow=c(2,2))
plotRGB(lake04, r=5, g=4, b=3, stretch="lin")
plotRGB(lake08, r=5, g=4, b=3, stretch="lin")
plotRGB(lake10, r=5, g=4, b=3, stretch="lin")
plotRGB(lake12, r=5, g=4, b=3, stretch="lin")
# dev.off()
# In rosso sono evidenziate le zone con vegetazione
# Per renderlo ancora più evidente,
# NIR nella componente G, rosso nella R, e verde nella B:
par(mfrow=c(2,2))
plotRGB(lake04, r=4, g=5, b=3, stretch="lin")
plotRGB(lake08, r=4, g=5, b=3, stretch="lin")
plotRGB(lake10, r=4, g=5, b=3, stretch="lin")
plotRGB(lake12, r=4, g=5, b=3, stretch="lin")
# In verde sono evidenziate le zone con vegetazione, mentre in viola intenso l'acqua del lago, delle pozze e del fiume.


# INDICI SPETTRALI
# DVI e NDVI (indici di vegetazione)
# Aprile 2021
dvi04 = lake04[[5]]-lake04[[4]]
dvi04
ndvi04 <- dvi04/(lake04[[5]]+lake04[[4]])
ndvi04
# Agosto 2021
dvi08 <- lake08[[5]]-lake08[[4]]
dvi08
ndvi08 =dvi08/(lake08[[5]]+lake08[[4]])
ndvi08
# Ottobre 2021
dvi10 <- lake10[[5]]-lake10[[4]]
dvi10
ndvi10 =dvi10/(lake10[[5]]+lake10[[4]])
ndvi10
# Dicembre 2021
dvi12 <- lake12[[5]]-lake12[[4]]
dvi12
ndvi12 =dvi12/(lake12[[5]]+lake12[[4]])
ndvi12

# NDVI confrontato per i 4 mesi
# pdf("4mesi_NDVI.pdf")
par(mfrow=c(2,2))
plot(ndvi04, col=viridis(200, option="B")) #inferno
plot(ndvi08, col=viridis(200, option="B")) #inferno
plot(ndvi10, col=viridis(200, option="B")) #inferno
plot(ndvi12, col=viridis(200, option="B")) #inferno
# dev.off()
# In giallo sono evidenziate le zone vegetate. In agosto la vegetazione è più abbondante e più in salute, con poche zone desertiche o aride: il periodo corrisponde all'apice della stagione umida

# NDWI (contenuto di acqua in corpi idrici)
# Aprile 2021
ndwi04 <- (lake04[[3]]-lake04[[5]]) / (lake04[[3]]+lake04[[5]])
ndwi04
# Agosto 2021
ndwi08 <- (lake08[[3]]-lake08[[5]]) / (lake08[[3]]+lake08[[5]])
ndwi08
# Ottobre 2021
ndwi10 <- (lake10[[3]]-lake10[[5]]) / (lake10[[3]]+lake10[[5]])
ndwi10
# Dicembre 2021
ndwi12 <- (lake12[[3]]-lake12[[5]]) / (lake12[[3]]+lake12[[5]])
ndwi12

# NDWI confrontato per i 4 mesi
# pdf("4mesi_NDWI.pdf")
par(mfrow=c(2,2))
plot(ndwi04, col=viridis(200, option="E")) #cividis
plot(ndwi08, col=viridis(200, option="E")) #cividis
plot(ndwi10, col=viridis(200, option="E")) #cividis
plot(ndwi12, col=viridis(200, option="E")) #cividis
# dev.off()

# Confronto NDVI ed NDWI
# pdf("4mesi_confronto.pdf")
par(mfrow=c(2,4))
plot(ndvi04, col=viridis(200, option="B")) #inferno
plot(ndvi08, col=viridis(200, option="B")) #inferno
plot(ndvi10, col=viridis(200, option="B")) #inferno
plot(ndvi12, col=viridis(200, option="B")) #inferno
plot(ndwi04, col=viridis(200, option="E")) #cividis
plot(ndwi08, col=viridis(200, option="E")) #cividis
plot(ndwi10, col=viridis(200, option="E")) #cividis
plot(ndwi12, col=viridis(200, option="E")) #cividis
# dev.off()
# Dal confronto è visibile come ad aprile vi sia scarsa vegetazione e una moderata presenza di acqua nel lago
# Ad agosto, nel pieno della stagione delle piogge, si assiste ad un aumento della vegetazione, che diventa più rigogliosa, occupando anche le zone umide che normalmente verrebbero evidenziate da valori elevati di NDWI
# (per questo motivo potrebbe risultare che la copertura di acqua sia diminuita. Contestualizzando questo risultato in base all'andamento stagionale, questo è un risultato dell'aumento della copertura vegetale)
# Ad ottobre, fine della stagione delle piogge, la vegetazione è già diminuita (o comunque in uno stato di salute peggiore rispetto ad agosto)
# Per questo motivo la vegetazione espone nuovamente le zone umide, che coprono una buona superficie
# Lo stesso avviene anche per dicembre, con la differenza che si assiste a una lieve diminuzione della vegetazione e delle zone umide rispetto ad ottobre
# Essendo dicembre ancora all'inizio della stagione secca, si ha un contenuto maggiore di acqua rispetto ad aprile.

# CLASSIFICAZIONE, per disciminare meglio le componenti e valutare numericamente come variano nel tempo la copertura vegetale e il contenuto di acqua nel corpo idrico
# In 4 classi
class404 <- unsuperClass(lake04, nClasses=4) # Aprile
class404
class408 <- unsuperClass(lake08, nClasses=4) # Agosto
class408
class410 <- unsuperClass(lake10, nClasses=4) # Ottobre
class410
class412 <- unsuperClass(lake10, nClasses=4) # Dicembre
class412
# pdf("4mesi_classificazione.pdf")
par(mfrow=c(2, 2))
plot(class404$map, col=viridis(4, option="G")) # mako
plot(class408$map, col=viridis(4, option="G")) # mako
plot(class410$map, col=viridis(4, option="G")) # mako
plot(class412$map, col=viridis(4, option="G")) # mako
# dev.off()
# Con 4 classi sono ben visibili l'acqua, la vegetazione e le zone con suolo nudo (probabilmente a due livelli diversi di umidità del suolo)

# Frequenze (numero di px) per ogni classe
freq(class404$map) # Frequenze 4 classi aprile 2021
# Classe 2 (piante): 11257685 px
# Classe 4 (acqua): 5422670 px
freq(class408$map) # Frequenze 4 classi agosto 2021
# Classe 3 (piante): 20102683 px
# Classe 1 (acqua): 4651143 px
freq(class410$map) # Frequenze 4 classi ottobre 2021
# Classe 1 (piante): 11422391 px
# Classe 2 (acqua): 5242353 px
freq(class412$map) # Frequenze 4 classi dicembre 2021
# Classe 4 (piante): 11808194 px
# Classe 3 (acqua): 5199266 px
# Per capire quanti px totali
lake04
tot04 <- 59145081
lake08
tot08 <- 59222791
lake10
tot10 <- 59145081
lake12
tot12 <- 59068971
# % copertura vegetale
veg04 <- 11257685/tot04*100 # Vegetazione % aprile
veg04
veg08 <- 20102683/tot08*100 # Vegetazione % agosto
veg08
veg10 <- 11422391/tot10*100 # Vegetazione % ottobre
veg10
veg12 <- 11808194/tot12*100 # Vegetazione % dicembre
veg12
# % acqua
acq04 <- 5422670/tot04*100 # Acqua % aprile
acq04
acq08 <- 4651143/tot08*100 # Acqua % agosto
acq08
acq10 <- 5242353/tot10*100 # Acqua % ottobre
acq10
acq12 <- 5199266/tot12*100 # Acqua % dicembre
acq12
# DATI FINALI
# % vegetazione aprile: 19.03402%
# % acqua aprile: 9.168421%
# % vegetazione agosto: 33.94417%
# % acqua agosto: 7.853637%
# % vegetazione ottobre: 19.3125%
# % acqua ottobre: 8.863549%
# % vegetazione dicembre: 19.99052%
# % acqua dicembre: 8.802026%
# DATAFRAME
classi <- c("Vegetazione%", "Acqua%") # Prima colonna
perc04 <- c(19.03402, 9.168421) # Seconda colonna
perc08 <- c(33.94417, 7.853637) # Terza colonna
perc10 <- c(19.3125, 8.863549) # Quarta colonna
perc12 <- c(19.99052, 8.802026) # Quinta colonna
multitemporal1 <- data.frame(classi, perc04, perc08, perc10, perc12)
View(multitemporal1)
Mesi <- c("04: Aprile", "08: Agosto", "10: Ottobre", "12: Dicembre") # Prima colonna
PercVegetazione <- c(19.03402, 33.94417, 19.3125, 19.99052) # Seconda colonna
PercAcqua <- c(9.168421, 7.853637, 8.863549, 8.802026) # Terza colonna
multitemporal2 <- data.frame(Mesi, PercVegetazione, PercAcqua)
View(multitemporal2)
# DATAFRAME PER BARCHART combinato
Mese <- c("04: Aprile", "04: Aprile", "08: Agosto", "08: Agosto", "10: Ottobre", "10: Ottobre", "12: Dicembre", "12: Dicembre") # Prima colonna
Percentuali <- c(19.03402, 9.168421, 33.94417, 7.853637, 19.3125, 8.863549, 19.99052, 8.802026) # Seconda colonna
Tipo_copertura <- c("Vegetazione", "Acqua", "Vegetazione", "Acqua", "Vegetazione", "Acqua", "Vegetazione", "Acqua") # Terza colonna
multitemporal3 <- data.frame(Mese, Percentuali, Tipo_copertura)
View(multitemporal3)
# BARCHART vegetazione nei 4 mesi
ggplot(multitemporal2, aes(x=Mesi, y=PercVegetazione, col=Mesi))+
geom_bar(stat="identity", fill="white")
# BARCHART acqua nei 4 mesi
ggplot(multitemporal2, aes(x=Mesi, y=PercAcqua, col=Mesi))+
geom_bar(stat="identity", fill="white")
# BARCHART a colonnne multiple per i 4 mesi 
ggplot(multitemporal3, aes(x=Mese, y=Percentuali, col=Tipo_copertura))+
geom_bar(stat="identity", fill="white") # Colonne sovrapposte
# pdf("4mesi_multitemporal.pdf")
ggplot(multitemporal3, aes(x=Mese, y=Percentuali, col=Tipo_copertura))+
geom_bar(stat="identity", position="dodge", fill="white") # Colonne affiancate
# dev.off()




# CONFRONTO Aprile 2013-2022

# Importazione delle immagini a partire dai singoli layer.
# 2013:
rlist13 <- list.files(pattern="LC08_L2SP_185051_20130412_20200912_02_T1_SR_B") # Lista di file (qui bande) relative all'immagine del 2013
rlist13
import13 <- lapply(rlist13, raster) # Applicazione della funzione raster alle bande selezionate nella lista precedente, per importarle
import13
lake13 <- stack(import13) # Creazione stack: combinazione dei vari layer relativi al 2013
lake13 # min->max : 0->65535, cioè 65536 valori, immagine a 16 bit

# Plot immagine 2013 (visibile)
plotRGB(lake13, r=4, g=3, b=2, stretch="lin") # Stretch lineare
plotRGB(lake13, r=4, g=3, b=2, stretch="hist") # Stretch istogrammi, per evidenziare meglio i contrasti

# 2022:
rlist22 <- list.files(pattern="LC08_L2SP_185051_20220405_20220412_02_T1_SR_B") # Lista di file (qui bande) relative all'immagine del 2022
rlist22
import22 <- lapply(rlist22, raster) # Applicazione della funzione raster alle bande selezionate nella lista precedente, per importarle
import22
lake22 <- stack(import22) # Creazione stack: combinazione dei vari layer relativi al 2022
lake22 # Immagine a 16 bit

# Plot immagine 2022 (visibile)
plotRGB(lake22, r=4, g=3, b=2, stretch="lin") # Stretch lineare
plotRGB(lake22, r=4, g=3, b=2, stretch="hist") # Stretch istogrammi

# Confronto visibile 2013-2022 con stretch a istogrammi
# pdf("confronto_colnaturali.pdf", height=4)
par(mfrow=c(1,2))
plotRGB(lake13, r=4, g=3, b=2, stretch="hist")
plotRGB(lake22, r=4, g=3, b=2, stretch="hist")
# dev.off()
# Oppure, con patchwork e RStoolbox:
# plot13 <- ggRGB(lake13, r=4, g=3, b=2, stretch="hist")
# plot22 <- ggRGB(lake22, r=4, g=3, b=2, stretch="hist")
# plot13 + plot22

# Le immagini del 2013 e del 2021 sono relative alla stessa zona ma hanno dimensioni leggermente diverse (2013: 55136451 px; 2022: 59145081 px).

# CLASSIFICAZIONE, per comprendere meglio di discriminare le componenti
# In 4 classi
class413 <- unsuperClass(lake13, nClasses=4)
class413
class422 <- unsuperClass(lake22, nClasses=4)
class422
# pdf("confronto_classificazione.pdf", height=4)
par(mfrow=c(1, 2))
plot(class413$map, col=viridis(4, option="G")) # mako
plot(class422$map, col=viridis(4, option="G")) # mako
# dev.off()
# Con 4 classi sono ben visibili l'acqua, la vegetazione e le zone con suolo nudo (probabilmente a due livelli diversi di umidità del suolo)

# Frequenze (numero di px) per ogni classe
freq(class413$map) # Frequenze 4 classi 2013
# Classe 1 (piante): 10064971 px
# Classe 2 (acqua): 3870693 px
freq(class422$map) # Frequenze 4 classi 2022
# Classe 1 (acqua): 4865587 px
# Classe 4 (piante): 10225045 px
# Per capire quanti px totali
lake13
tot13 <- 55136451
lake22
tot22 <- 59145081
veg13 <- 10064971/tot13*100 # Vegetazione % nel 2013
veg13
veg22 <- 10225045/tot22*100 # Vegetazione % nel 2022
veg22
acq13 <- 3870693/tot13*100 # Acqua % nel 2013
acq13
acq22 <- 4865587/tot22*100 # Acqua % nel 2022
acq22
# DATI FINALI
# % vegetazione 2013: 18.25466%
# % acqua 2013: 7.020207%
# % vegetazione 2022: 17.28807%
# % acqua 2022: 8.226529%
# DATAFRAME
classi <- c("Vegetazione%", "Acqua%") # Prima colonna
perc13 <- c(18.25466, 7.020207) # Seconda colonna
perc22 <- c(17.28807, 8.226529) # Terza colonna
multitemporal_conf <- data.frame(classi, perc13, perc22)
View(multitemporal_conf)
# DATAFRAME per la costruzione del barchart combinato
Anno <- c("2013", "2013", "2022","2022") # Prima colonna
Percent <- c(18.25466, 7.020207, 17.28807, 8.226529) # Seconda colonna
Copertura <- c("Vegetazione", "Acqua", "Vegetazione", "Acqua") # Terza colonna
multitemporal2_conf <- data.frame(Anno, Percent, Copertura)
View(multitemporal2_conf)
# DATAFRAME
Anni <- c("2013", "2022") # Prima colonna
Perc_Vegetazione <- c(18.25466, 17.28807) # Seconda colonna
Perc_Acqua <- c(7.020207, 8.226529) # Terza colonna
multitemporal3_conf <- data.frame(Anni, Perc_Vegetazione, Perc_Acqua)
View(multitemporal3_conf)
# BARCHART 2013
ggplot(multitemporal_conf, aes(x=classi, y=perc13, col=classi))+
geom_bar(stat="identity", fill="white")
# BARCHART 2022
ggplot(multitemporal_conf, aes(x=classi, y=perc22, col=classi))+
geom_bar(stat="identity", fill="white")
# BARCHART combinato
# pdf("confronto_multitemporal.pdf")
ggplot(multitemporal2_conf, aes(x=Anno, y=Percent, col=Copertura))+
geom_bar(stat="identity", position="dodge", fill="white") # Colonne affiancate
# dev.off()

# Evidenziamo differenza nella copertura vegetale tra il 2013 e il 2022 (aprile: fine periodo secca).
# NIR nella componente R:
# pdf("confronto_NIR.pdf", height=4)
par(mfrow=c(1,2))
plotRGB(lake13, r=5, g=4, b=3, stretch="hist")
plotRGB(lake22, r=5, g=4, b=3, stretch="hist")
# dev.off()
# In rosso sono evidenziate le zone con vegetazione
# Per renderlo ancora più evidente,
# NIR nella componente G, rosso nella R, e verde nella B:
par(mfrow=c(1,2))
plotRGB(lake13, r=4, g=5, b=3, stretch="hist")
plotRGB(lake22, r=4, g=5, b=3, stretch="hist")
# In verde sono evidenziate le zone con vegetazione, mentre in viola intenso l'acqua del lago, delle pozze e del fiume.


# INDICI SPETTRALI
# Indici di vegetazione: DVI e NDVI
# DVI e NDVI 2013 (DVI=NIR-red)
dvi13 = lake13[[5]]-lake13[[4]]
dvi13
# ggplot()+
# geom_tile(dvi13, mapping=aes(x=x, y=y, fill=layer)) +
# scale_fill_viridis() # Palette di default, ma sembra che la risoluzione venga abbassata
# Oppure, sempre usando viridis
plot(dvi13, col=viridis(200, option="B")) # inferno
# In giallo sono evidenziate le zone con vegetazione, ma comunque non ha valori elevati di DVI (non sono giallo intenso), quindi non è molto in salute
# (l'immagine è acquisita ad aprile, fine periodo di secca)
ndvi13 <- dvi13/(lake13[[5]]+lake13[[4]])
ndvi13
plot(ndvi13, col=viridis(200, option="B"))

# DVI e NDVI 2022 
dvi22 <- lake22[[5]]-lake22[[4]]
dvi22
plot(dvi22, col=viridis(200, option="B")) # inferno
ndvi22 =dvi22/(lake22[[5]]+lake22[[4]])
ndvi22
plot(ndvi22, col=viridis(200, option="B"))

# Affiancando i NDVI 2013-2022
# pdf("confronto_NDVI.pdf", height=4)
par(mfrow=c(1,2))
plot(ndvi13, col=viridis(200, option="B"))
plot(ndvi22, col=viridis(200, option="B"))
# dev.off()

# Indici spettrali immagine 2013
si13 <- spectralIndices(lake13, green=3, red=4, nir=5)
plot(si13, col=viridis(200, option="B"))
# Indici spettrali immagine 2022
si22 <- spectralIndices(lake22, green=3, red=4, nir=5)
plot(si22, col=viridis(200, option="B"))

# Contenuto di acqua in corpi idrici
# NDWI (Normalized Difference Water Index) 2013 (NDWI=(Green-NIR)/(Green + NIR)
ndwi13 <- (lake13[[3]]-lake13[[5]]) / (lake13[[3]]+lake13[[5]])
ndwi13
plot(ndwi13, col=viridis(200, option="E")) # cividis
# In giallo (valori elevati, positivi di NDWI) presenza di acqua. in particolare NDWI(0-> +0.2) suolo con presenza di una discreta quantità di acqua (anche se non elevata)
# In blu (valori bassi, negativi di NDWI) assenza di acqua al suolo

# NDWI 2022
ndwi22 <- (lake22[[3]]-lake22[[5]]) / (lake22[[3]]+lake22[[5]])
ndwi22
plot(ndwi22, col=viridis(200, option="E")) # cividis

# Multiframe NDWI
# pdf("confronto_NDWI.pdf", height=4)
par(mfrow=c(1,2))
plot(ndwi13, col=viridis(200, option="E"))
plot(ndwi22, col=viridis(200, option="E"))
# dev.off()

# Multiframe (2013 a dx, 2022 a sx), con NDVI (sopra, legenda inferno) e NDWI (sotto, legenda cividis)
# pdf("confronto_indici.pdf")
par(mfrow=c(2,2))
plot(ndvi13, col=viridis(200, option="B"))
plot(ndvi22, col=viridis(200, option="B"))
plot(ndwi13, col=viridis(200, option="E"))
plot(ndwi22, col=viridis(200, option="E"))
# dev.off()
# Sembra che la vegetazione sia diminuita nel 2022 (o lo stato di salute sia peggiorato), 
# e questo può essere dovuto a fattori climatici ad esempio, come una stagione delle piogge troppo breve ad anticipare quella di secca 
# (alla fine della quale è stata rilevata l'immagine)
# Però, dato che le immagini hanno dimensioni (in px) diverse, è possibile che la legenda sia stata adattata diversamente ai valori, e che questo porti a errori nell'interpretazione
# Evidente è, però, la sostituzione di vegetazione con acqua nella zona nord-est del lago, evidenziabile sia dal NDVI che dal NDWI.
# Per mostrarlo in modo più evidente, viene calcolata in seguito la differenza tra il NDVI fra il 2013 e il 2022, e tra il NDWI fra il 2013 e il 2022:
# La differenza non produce errori, anche se le due immagini hanno dimensioni diverse, grazie alla georeferenziazione.
# è effettuata la sottrazione per i px corrispondenti allo stesso punto sulla mappa (lo si nota perchè la dimensione in px della differenza è minore sia dell'immagine del 2013 che del 2022)

clb <- colorRampPalette(c("blue", "white", "red"))(100)
ndvi_dif=ndvi13-ndvi22
ndwi_dif=ndwi13-ndwi22
par(mfrow=c(1,2))
plot(ndvi_dif, col=clb) # Valori elevati, in rosso, mostrano una avvenuta perdita di vegetazione, mentre le zone blu sono quelle dove vi è stato un aumento di vegetazione
plot(ndwi_dif, col=clb) # Valori elevati, in rosso, mostrano un aumento dell'acqua sulla superficie, mentre in blu, una perdita di zone con acqua in superficie
# Le situazioni sono complementari, soprattutto nella parte alta dell'immagine (dove a un aumento della vegetazione corrisponde una diminuzione delle zone sommerse),
# e nella parte a Nord-Est del lago, dove invece la vegetazione è stata soppiantata dalla presenza dell'acqua.

# MISURE DI ETEROGENEITà: PCA
# Resample, per rendere più veloci le esecuzioni successive
lake13res <- aggregate(lake13, fact=10)
lake22res <- aggregate(lake22, fact=10)
# PCA
pca13 <- rasterPCA(lake13res) # 2013
pca22 <- rasterPCA(lake22res) # 2022
pca13
pca22
summary(pca13$model) # La PC1 (2013) spiega il 93.9% della variabilità del sistema
summary(pca22$model) # La PC1 (2022) spiega il 95.2% della variabilità del sistema
# La PC1 è quindi in grado di rappresentare, in un singolo layer, la maggior parte della variabilità del sistema. 
# Verrà quindi impiegata per misurare la variabilità del sistema.
# Plottando tutte le componenti, si evidenzia come la PC1 anche graficamente mostri meglio la variabilità, discriminando meglio le componenti:
plot(pca13$map)
plot(pca22$map)
# Si associa ciascuna PC1 a un oggetto, per facilitare i passaggi successivi
pc1_13 <- pca13$map$PC1
pc1_22 <- pca22$map$PC1
# Plot della PC1 per il 2013 (dx) e per il 2022 (sx), con palette plasma
par(mfrow=c(1,2))
plot(pc1_13, col=viridis(200, option="C"))
plot(pc1_22, col=viridis(200, option="C")) 
# La variabilità è ben evidenziata da entrambi i plot
# Calcolo della variabilità su PC1 (tale calcolo è possibile effettuarlo su un solo layer), moving window 3x3
sdpc1_13 <- focal(pc1_13, matrix(1/9, 3, 3), fun=sd)
sdpc1_13
sdpc1_22 <- focal(pc1_22, matrix(1/9, 3, 3), fun=sd) 
sdpc1_22
# pdf("confronto_variabilità_PC1.pdf", height=4)
par(mfrow=c(1,2))
plot(sdpc1_13, col=viridis(200, option="B"))
plot(sdpc1_22, col=viridis(200, option="B"))
# dev.off()
# In entrambi i casi, nella sponda nord del lago si ha una elevata eterogeneità (questo quindi non varia nel tempo).
# Considerando anche la classificazione, si vede che tale zona vede aree allagate, umide e vegetate.




