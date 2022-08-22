# IL MIO PRIMO SCRIPT

# install.packages("raster")
library(raster)

# Setting della cartella di lavoro (set working directory): fra parentesi e virgolette specificare percorso.
# é un modo per connettere R alla cartella lab (percorso fra parentesi e virgolette)
setwd("C:/lab/") # Per windows

# Importare dati su R, in particolare dati raster:
l2011 <- brick("p224r63_2011.grd") # Usare le virgolette perchè si esce da R
# Assegnazione a un oggetto chiamato l2011, per averlo sempre su R.
# brick è la funzione per caricare interi pacchetti di dati (quindi anche un'immagine satellitare).
l2011 # Informazioni sull'oggetto
# class: classe dell'oggetto. è un RasterBrick perchè è stata usata la funzione brick
# 1499 (numero di righe nrow), 2967 (numero colonne ncol), 447533 (px totali ncell=nrow x ncol, sono i px tot per ogni banda), 7 (nlayers, cioè il numero di bande)
# quindi i px totali sono 447533x7 (numero layer).
# Solitamente i px rappresentano quadrati 30x30 m (resolution, risoluzione), per Landsat.
# extent: sono le coordinate in UTM
# crs: datum (cioè l'ellissoide), in questo caso un WGS84 (World Geodetic System 1984), zona (zone) 22, e proiezione (proj) (qui UTM, Universale Trasversa di Mercatore)
# crs significa Coordinate Reference System, cioè il SR delle coordinate, qui UTM e zona 22, e a questo fuso sono riferite le coordinate.
# source: sorgente del dato
# names: B1_sre (spectral reflextion/reflectance), ..., B6_bt (banda del termico) (bande per cui sono rilevate le riflettanze)
# min values : valori minimi per ogni banda (qui sono tutti a 0-cioè la luce viene interamente assorbita-, tranne per la banda dell'infrarosso termico, che non ci interessa)
# max values :valori massimi (potenzialmente fino a 1)
# Questa immagine deriva dal satellite LandSat
# L'immagine è riferita a una zona nella riserva del Paranà, dove c'è stato un forte disboscamento.

# Applicazione della funzione plot all'immagine
plot(l2011)
# Vengono mostrati tanti plot quante sono le bande
# è creata una legenda standard di default per tutte le bande
# Per ogni banda è mostrata la riflettanza

# Ricostruiamo una legenda personalizzata, dallo scuro a 0 (min) al chiaro (max riflettanza)
# Uso di colorRampPalette:
# Decidendo una serie di colori, viene adattato il colore dell'immagine al Color Ramp impostato
# Si specifica nella funzione il set di colori che si vuole usare, dal colore al min e colori corrispondenti al max
# I colori vanno tra virgolette perchè sono salvati su R con le virgolette
colorRampPalette(c("black", "grey", "light grey"))
# Così però non sono specificati passaggi da colore a colore. se voglio specificare il numero di tonalità, qui 100:
colorRampPalette(c("black", "grey", "light grey")) (100)
cl <- colorRampPalette(c("black", "grey", "light grey")) (100) #  Associazione della palette creata ad un oggetto
plot(l2011, col = cl) # I colori sono presi dalla scala impostata
# Come output si ottiene il plot delle singole bande (ciascuna con i loro valori di riflettanza), con la legenda sopra definita.
# La banda 4 è molto intensa (molto bianca, riflettanza molto alta), dell'infrarosso, ed è normale se c'è della vegetazione
# Per la banda del blu, la riflettanza più alta è di 0.10
# Poi si hanno la riflettanza del verde (B2_sre), del rosso (B3_sre), del vicino infrarosso (B4_sre), ecc

# Per LandSat ETM+ (Enhanced Tematic Mapper)
# B1 = blu
# B2 = verde
# B3 = rosso
# B4 = infrarosso vicino (near infrared)
# Ogni pixel avrà un valore di riflettanza per ogni lunghezza d'onda, per ogni banda, per ogni layer

# Plot di una singola banda (serve il nome della singola banda o sapere che numero di elemento è)
# es: plot della banda del blu.
# Per capire il nome della banda di interesse si legge la voce "names" chiamando l'oggetto (qui l2011). Il nome della banda del blu è B1_sre.
plot(l2011$B1_sre)
# Si usa il simbolo $ per riferirsi al singolo elemento: alla banda di un'immagine satellitare, o alla colonna di una tabella ecc.
# è possibile plottare la banda del blu indicando che è il primo elemento, senza specificarne il nome
# (le varie bande infatti sono da considerare come una lista di dati, e quindi hanno un ordine)
# Per specificare un elemento, lo si racchiude fra doppie parentesi quadre [[ ]].
plot(l2011[[1]]) # Viene plottato l'elemento numero 1 dell'immagine satellitare
# Applicazione della legenda personalizzata da Black, Gray e Light Grey
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(l2011$B1_sre, col = cl)

# Plot di B1 da Dark Blue a Blue a Light Blue
clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col = clb)
# Tutti gli oggetti che assorbono saranno blu scuro (valori bassi di riflettanza) e tutti quelli che riflettono (valori alti di riflettanza) saranno blu chiaro

# Esportare immagine come pdf
pdf("banda1.pdf") # Il primo argomento è il nome con cui vogliamo salvare il file nella cartella
# All'inizio del codice è stata settata la working directory, quindi il file verrà salvato lì
plot(l2011$B1_sre, col = clb)
dev.off() # Chiude il grafico appena aperto nella riga sopra
# Se si vuole salvare il file in una cartella diversa da quella settata (es. la cartella Download) è necessario specificare il percorso file nella funzione pdf
# (il pdf è solitamente preferibile perchè ha la risoluzione migliore)

# Esportare immagine come png
png("banda1.png") 
plot(l2011$B1_sre, col = clb)
dev.off() 

# Per esportare l'intero dataset dell'immagine (bande con le informazioni di georeferenziazione) si usa la funzione writeRaster.

# Plot della banda del verde B2 da Dark Green a Green a Light Green
clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col = clg)

# Definizione di un multiframe per affiancare la banda del blu e quella del verde.
# Costruzione del multiframe in modo che abbia una riga e due colonne (perchè i due grafici siano affiancati)
# Utilizzo della funzione par per costruire il multiframe a partire dalle righe (quindi mfrow, cioè prima indichieremo le righe e poi le colonne)
# Riempiamo il multiframe con i due plot, indicandoli in seguito:
par(mfrow = c(1, 2))
plot(l2011$B1_sre, col = clb)
plot(l2011$B2_sre, col = clg)
# Per chiudere la finestre si clicca la X rossa a destra in alto oppure:
dev.off()

# Per esportare questo multiframe plot (con B1 e B2 affiancati)
pdf("multiframe.pdf")
par(mfrow = c(1, 2))
plot(l2011$B1_sre, col = clb)
plot(l2011$B2_sre, col = clg)
dev.off()

# Multiframe con B1 e B2 (con B1 sopra e B2 sotto)
par(mfrow = c(2, 1))
plot(l2011$B1_sre, col = clb)
plot(l2011$B2_sre, col = clg)
dev.off()

# Multiframe plot delle prime 4 bande
par(mfrow = c(2, 2))
plot(l2011$B1_sre, col = clb) #blu
plot(l2011$B2_sre, col = clg) #verde
# colorRamPalette per il rosso
clr<- colorRampPalette(c("violet", "red", "pink")) (100)
plot(l2011$B3_sre, col = clr) #rosso
# colorRampPalette per la banda NIR (near infrared)
clnir<- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col = clnir) #NIR

# Combinazione di più bande per formare un'immagine a colori
# Caricamento del pacchetto raster con: library(raster)
# Setting della working directory (perchè i file raster sarebbero salvati in maniera estemporanea 
# e rischierebbero di andare persi se avvenissero problemi al computer oppure se volessimo inviarli a qualcuno)
# setwd("C:/lab/") #per windowns
# Importare dati su R, in particolare dati raster:
l2011 <- brick("p224r63_2011.grd")
# Riserva di Parakana in Brasile: qui la deforestazione della foresta tropicale è stata pesantissima

# Plot dell'immagine solo nell'infrarosso vicino (NIR)
plot(l2011$B4_sre) # Plot delle riflettanze nella banda del NIR
# Oppure
plot(l2011$[[4]])
# Per cambiare i colori della legenda: 
clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col = clnir)

# Plot dei layer RGB
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
# Il primo argomento è il nome dell'immagine
# I successivi 3 argomenti associano alle componenti RGB le corrispondenti bande:
# R <- banda 3 (rosso)
# G <- banda 2 (verde)
# B <- banda 1 (blu)
# L'argomento successivo è "stretch", che stretcha, amplia i valori per far sì che si vedano meglio i contrasti.
# Può essere lineare ("lin") o a istogrammi ("hist")
# Si ottiene l'immagine a colori "naturali". Nella parte sinistra rimangono dei punti in cui non sono registrati valori, e si vedono come delle zone nere ("maschera").
# L'immagine che si ottiene è quella della riserva naturale, da 800 km di distanza, così come la vedrebbe l'occhio umano.

# Per vedere il NIR mediante schema RGB facciamo "scorrere" le bande, in modo da plottare insieme NIR, rosso e verde (escludendo la banda del blu, la più lontana)
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")
# La banda dell'infrarosso viene associata alla componente red di RGB, quindi nell'immagine riflettanza elevata nell'infrarosso viene percepito come rosso intenso
# Tutti gli elementi che riflettono nel NIR saranno molto rossi (ad esempio la vegetazione).
# La presenza di vegetazione è meglio evidenziabile dalla riflettanza del NIR rispetto a quella nel verde.
# Nella parte centrale-sinistra dell'immagine si vede quindi molta vegetazione, foresta tropicale.

# Visualizzazione del NIR come verde, invertendo l'assegnazione della bande del NIR e del rosso fra R e G
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")
# Tutto quello che rifletterà nel NIR diventerà verde nell'immagine

# Per evidenziare le parti a suolo nudo:
plotRGB(l2011, r=3, g=2, b=4, stretch="lin")
# Dunque la vegetazione (che riflette nel NIR) sarà blu, mentre il suolo nudo sarà giallo

# Proviamo a vedere il risultato visibile nella gamma dei colori usando l'argomento hist in stretch
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

# Multiframe con immagini in "visibile RGB" (colori naturali, stretch lineare) in cima a falsi colori (usando il NIR, stretch a istogrammi)
par(mfrow = c(2, 1))
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

# Caricamento dell'immagine dello stesso sito nel 1988 e assegnazione a un oggetto di nome l1988
l1988 <- brick("p224r63_1988.grd")
l1988

# In un multiframe, confronto fra l'immagine nel 1988 e nel 2011, con il NIR nella componente R e stretch lineare:
par(mfrow = c(2, 1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")
# L'immagine del 1988 ha un po' più di foschia nel sensore, perchè è usato un sensore diverso.
# Nel 1988 l'uomo aveva appena iniziato ad aprire le prime strade e campi coltivati nella foresta, non troppo degradata
# Nel 2011 invece si ha una delimitazione netta fra suolo nudo e foresta (perchè c'è un limite definito fra foresta e sistema agricolo dato dall'istituzione della foresta)

