#Questo è il primo script che useremo a lezione

#install.packages("raster")
library(raster)

#settaggio cartella di lavoro (set working directory), fra parentesi e virgolette specificare percorso.
#é un modo per connettere R alla cartella lab (quindi percorso fra parentesi)
setwd("C:/lab/") #per windows

#importare dati su R, in particolare dati raster:
l2011 <- brick("p224r63_2011.grd") #si usano le virgolette perchè si esce da R
#per avercelo sempre su R, lo assegnamo a un oggetto chiamato l2011.
l2011 #compaiono le informazioni sull'oggetto
#class: classe dell'oggetto. è un RasterBrick perchè abbiamo usato la funzione brick
#1499 (numero di righe nrow), 2967 (numero colonne ncol), 447533 (px totali ncell=nrow x ncol, sono i px tot per ogni banda), 7 (nlayers, cioè il numero di bande)
#quindi i px totali sono 447533x7 (numero layer).
#solitamente i px sono quadrati 30x30 m (resolution).
#source: sorgente del dato
#names: B1_sre (spectral reflextion), ..., B6_bt (banda del termico)
#min values :
#max values : 

#applichiamo il plot all'immagine
plot(l2011)
#vengono mostrati tanti plot quante sono le bande
#è creata una legenda standard di default per tutte le bande, dal bianco al verde, ma color-blind friendly
#per ogni banda è mostrata la riflettanza.
#ricostruiamo una legenda personalizzata, dallo scuro a 0, min, al chiaro (max riflettanza)
# colorRampPalette
#decidendo una serie di colori, viene adattato il colore dell'immagine al Color Ramp impostato
#è importante scrivere correttamente le lettere maiuscole e minuscole perchè R è case-sensitive (distingue maiuscole e minuscole).
#si specifica nella funzione il set di colori che si vuole usare, dal colore al min e colori corrispondenti al max
#i colori vanno tra virgolette perchè i colori sono salvati su R con le virgolette
colorRampPalette(c("black", "grey", "light grey"))
#così però non sono specificati passaggi da colore a colore. se voglio specificare il numero di tonalità, qui 100:
colorRampPalette(c("black", "grey", "light grey")) (100)
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(l2011, col = cl) #cioè i colori sono presi dalla scala impostata
#la banda 4 è molto intensa (molto bianca, riflettanza molto alta), dell'infrarosso, ed è normale se c'è della vegetazione

#crs significa coordinate reference system, cioè il SR delle coordinate

