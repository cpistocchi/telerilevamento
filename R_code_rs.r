#Questo è il primo script che useremo a lezione

#install.packages("raster")
library(raster)

#settaggio cartella di lavoro (set working directory), fra parentesi e virgolette specificare percorso.
#é un modo per connettere R alla cartella lab (quindi percorso fra parentesi)
setwd("C:/lab/") #per windows

#importare dati su R, in particolare dati raster:
l2011 <- brick("p224r63_2011.grd") #si usano le virgolette perchè si esce da R
#per avercelo sempre su R, lo assegnamo a un oggetto chiamato l2011.
#brick è la funzione per caricare interi pacchetti di dati, cioè un'immagine satellitare.
l2011 #compaiono le informazioni sull'oggetto
#class: classe dell'oggetto. è un RasterBrick perchè abbiamo usato la funzione brick
#1499 (numero di righe nrow), 2967 (numero colonne ncol), 447533 (px totali ncell=nrow x ncol, sono i px tot per ogni banda), 7 (nlayers, cioè il numero di bande)
#quindi i px totali sono 447533x7 (numero layer).
#solitamente i px sono quadrati 30x30 m (resolution, risoluzione).
#extent: sono le coordinate in UTM
#crs: datum (cioè l'ellissoide), in questo caso un WGS84 (World Geodetic System 1984), zona (zone) 22, e proiezione (proj) (qui utm, universale trasversa di Mercatore)
#source: sorgente del dato
#names: B1_sre (spectral reflextion/reflectance), ..., B6_bt (banda del termico) (bande per cui sono rilevate le riflettanze)
#min values : valori minimi per ogni banda (qui sono tutti a 0-cioè la luce viene interamente assorbita-, tranne per la banda dell'infrarosso termico, che non ci interessa)
#max values :valori massimi (potenzialmente fino a 1
#questa immagine deriva dal satellite LandSat
#l'immagine è riferita a una zona nella riserva del Paranà, dove c'è stato un forte disboscamento.

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

#crs significa coordinate reference system, cioè il SR delle coordinate, qui utm e zona 22, e a questo fuso sono riferite le coordinate.

#come output si ottiene il plot delle singole bande, con la legenda che abbiamo definito noi con i comandi sopra.
#nella banda del blu, la banda numero 1 (B1_sre) si hanno le riflettanze (ovvero quanta luce viene riflessa rispetto a quella incidente, e di solito va da 0 a 1). 
#in questo caso, per la banda del blu, la riflettanza più alta è di 0.10
#poi si hanno la riflettanza del verde (B2_sre), del rosso (B3_sre), del vicino infrarosso (B4_sre), ecc
#quindi, per LandSat ETM+ (Enhanced Tematic Mapper)
#B1 = blu
#B2 = verde
#B3 = rosso
#B4 = infrarosso vicino (near infrared)
#ogni pixel avrà un valore di riflettanza per ogni lunghezza d'onda, per ogni banda, per ogni layer

#plottiamo una singola banda. per farlo serve il nome della singola banda o sapere che numero di elemento è.
#es: plot della banda del blu.
#per capire il nome della banda di interesse cerchiamo in "names" chiamando l'oggetto (qui l2011). il nome della banda del blu è B1_sre.
plot(l2011$B1_sre)
#si usa il sinbolo $ per riferirsi alla banda di un'immagine satellitare, o alla colonna di una tabella
#posso plottare la banda del blu indicando che è il primo elemento, senza indicarne il nome
#le varie bande infatti sono da considerare come una lista di dati, e quindi hanno un ordine
#per esprimere un elemento, lo si racchiude fra doppie parentesi quadre [[ ]].
plot(l2011[[1]]) #viene plottato l'elemento numero 1 dell'immagine satellitare
#anche qui ora mettiamo la legenda personalizzata da Black, Gray e Light Grey
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(l2011$B1_sre, col = cl)

#esercizio: plotta B1 da Dark Blue a Blue a Light Blue
clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col = clb)
#tutti gli oggetti che assorbono saranno blu scuro e tutti quelli che riflettono saranno blu chiaro

#esportare immagine come pdf, usando la funzione del file)
pdf("banda1.pdf") #il primo argomento è il nome con cui vogliamo salvare il file nella cartella
#all'inizio del codice avevamo settato la working directory, quindi verrà salvato lì
plot(l2011$B1_sre, col = clb)
dev.off() #chiude il grafico appena aperto nella riga sopra
#se invece voglio salvarlo in una cartella diversa, tipo la cartella Download, devo specificare il percorso file nella funzione pdf.
#il pdf è solitamente preferibile perchè ha la risoluzione migliore

#esportare immagine come png
png("banda1.png") 
plot(l2011$B1_sre, col = clb)
dev.off() 

#per esportare l'intero dataset dell'immagine (bande con le informazioni di georeferenziazione) si usa la funzione writeRaster.

#plottiamo la banda del verde B2 da Dark Green a Green a Light Green
clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col = clg)

#definiamo un multiframe per affiancare la banda del blu e quella del verde.
#consideriamo il multiframe come se avesse una riga e due colonne (perchè i due grafici sono affiancati)

#cioè usiamo la funzione par per costruire il multiframe a partire dalle righe (quindi mfrow, cioè prima indichieremo le righe e poi le colonne)
#riempiemo il multiframe con i due plot, indicandoli in seguito:
plot(l2011$B1_sre, col = clb)
plot(l2011$B2_sre, col = clg)
#per chiudere la funestre possiamo cliccare la X rossa a destra in alto oppure:
dev.off()

#per esportare questo multiframe plot
pdf("multiframe.pdf")
par(mfrow = c(1, 2))
plot(l2011$B1_sre, col = clb)
plot(l2011$B2_sre, col = clg)
dev.off()

#ora facciamo un multiframe con B1 e B2 ma con B1 sopra e B2 sotto
par(mfrow = c(2, 1))
plot(l2011$B1_sre, col = clb)
plot(l2011$B2_sre, col = clg)
dev.off()

#facciamo un plot delle prime 4 bande
par(mfrow = c(2, 2))
#blu
plot(l2011$B1_sre, col = clb)
#verde
plot(l2011$B2_sre, col = clg)
#colorRamPalette per il rosso
clr<- colorRampPalette(c("violet", "red", "pink")) (100)
plot(l2011$B3_sre, col = clr)
#banda NIR (near infrared)
clnir<- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col = clnir)
