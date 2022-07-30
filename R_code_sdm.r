#MODELLI DI DISTRIBUZIONE DI SPECIE

library(sdm) #per modellizzare la distribuzione delle specie
library(raster) #per gestire dati geografici, spaziali, sotto forma di matrice
library(rgdal) #permette di considerare anche delle coordinate nello spazio (i punti nello spazio che indicano presenza di specie)
#gdal (Geospatial Data Abstraction Library) è stata sviluppata dalla Open Source Geospatial Foundation

#non si usa setwd (non verrà settata una cartella di lavoro) ma verrà usato un file di sistema (cioè un file di esempio "estratto" dal pacchetto sdm).
#usiamo un file di sistema chiamando la funzione system.file. Questa funzione carica un file, specificando da quale pacchetto questo file verrà caricato.
file <- system.file("external/species.shp", package="sdm") #la cartella in questione si chiama "external" e viene scaricata insieme a sdm ma risulta ad esso esterna, per questo motivo si mettono le virgolette
#all'interno della cartella "external" è presente il file "species.shp", che viene caricato nel file di sistema 
#il file è stato letto, ma non è ancora stato caricato
file #mostra il path, il percorso file, in cui il file di interesse si trova
#per produrre uno shapefile si usa la funzione shapefile (del pacchetto raster):
species <- shapefile(file)
species
# il tipo di dato (class) è uno Spatial Point Data Frame, cioè sono punti nello spazio, ciascuno con le sue coordinate
# features indica il numero di punti (qui 200)
# names indica il nome delle colonne della tabella che costituisce il file: qui compare una colonna "Occurrence" (presenza/assenza di una determinata specie)

#per vedere come sono distribuiti i punti nello spazio:
plot(species, pch=19) #pch (point character permette di specificare il simbolo associato a ogni punto. il default è una crocetta e il 19 è un cerchio pieno)
#rappresentano i punti a terra, a indicare la presenza/assenza di una specie.

#per vedere le occorrenze associate ai punti (come elenco di 0-assenza e 1-presenza):
species$Occurrence
#plottiamo in modo diverso fra loro i punti che hanno come occorrenza 0 o 1, facendo una selezione, un subset (usando le []). PEr interrompere il subset si mette una , prima di ]
#per plottare solo le presenze:
#plot(species[species$Occurrence == 1, ], col="blue", pch=19) ma così è più pesante.
#per avere un codice più pulito si crea una variabile con l'occurrance:
occ <- species$Occurrence
plot(species[occ == 1, ], col="blue", pch=19)

#per mostrare insieme, ma con aspetto diverso, i punti con occurrence 0 e 1
#non si usa la funzione plot perchè sovrascriverebbe il plot precedente, mentre in questo caso l'obiettivo non è sovrascrivere, ma aggiungere dei punti (aggiungere i punti con occurrence 0 a quelli con occurrence 1)
#la funzione da usare è points:
plot(species[occ == 1, ], col="blue", pch=19)
points(species[occ == 0, ], col="red", pch=19)

#consideriamo ora i predittori (le mappe con le variabili ambientali, es fattori climatici)
#creazione di una variabile path (per rendere più pulito l'argomento della funzione list.files (che verrà usata dopo)
path <- system.file("external", package="sdm")
#questo sarà il percorso in cui si troveranno i 4 file predittori che andremo a listare e stackare
#per selezionare i file predittori di interesse: consideriamo tutti i file che hanno estenzione asc (ASCII).
#questi file predittori selezionati sono elevation.asc (quota), precipitation.asc (precipitazioni), temperature.asc (temperatura), vegetation.asc (NDVI, biomassa vegetale)
#creazione della lista dei vari predittori:
lst <- list.files(path=path, pattern="asc$", full.names="T") #full.names true perchè ci serve considerare il nome completo, costituito anche dal path del file
 #per assicurarsi che abbiano estensione asc, si mette il $ (altrimenti verranno selezionati anche i file che presentano asc non nell'estensione)
lst #controllare che la lista sia corretta nei suoi elementi

#questi file sono già dentro al pacchetto sdm quindi non serve usare brick per importarli

#stack dei 4 file predittori presenti nella lista lst
preds <- stack(lst)
preds
#class è RasterStack
#names (i nomi dei 4 file dello stack): elevation, precipitation, temperature, vegetation

#plot dei predittori usando una colorRampPalette
cl <- colorRampPalette(c("blue", "orange", "red", "yellow"))(100)
plot(preds, col=cl)
#da elevation vediamo una zona di valle (blu) e un picco montano (giallo chiaro)
#da precipitation vediamo che le maggiori precipitazioni avvengono in corrispondenza del picco, ma comunque un buon livello di precipitazione è presente anche in valle, mentre l'area più secca è quella blu
#da temperature si mostra come le T più basse siano nella parte montana
#da vegetation si nota che nella parte montana vi è pochissima vegetazione (sopra a 2000 m), presente invece nella valle

#creiamo variabili riferite ai predittori
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

#plottiamo ogni predittore con la presenza della specie:

plot(elev, col=cl)
points(species[occ == 1, ], pch=19)
#vediamo che questo animale non abita zone elevate (le presenze sono solo in valle o a quote medio-basse)

plot(prec, col=cl)
points(species[occ == 1, ], pch=19)
#la specie abita in zone con una quantità di precipitazioni medio-alta

plot(temp, col=cl)
points(species[occ == 1, ], pch=19)
#la specie si distribuisce in zone con T medio alte (non al freddo, a T basse)

plot(vege, col=cl)
points(species[occ == 1, ], pch=19)
#la specie si trova dove è presente vegetazione, ambienti protetti e non esposti

#si può ipotizzare che la specie sia un anfibio: non vive a quote troppo elevate dove le T sono molto basse, ma ama zone a media-bassa quota, T intermedia ed elevate precipitazioni

#creazione del modello
#le funzioni usate sono presenti nel pacchetto sdm 
#sdmData è la funzione che permette di dichiarare i dati da usare per la creazione del modello: in questo caso sono i dati di presenza/assenza delle specie (train, dato a terra) e i predittori (predictors)
datasdm <- sdmData(train=species, predictors=preds)
#compare un warning perchè non è dichiarato il crs, ovvero il Coordinate Reference System (il sistema di riferimento non è dichiarato) ma non è un problema
datasdm
#class: sdmdata (oggetto di natura sdm)

m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, method="glm")
# ~ può essere sostituita da =
# Occurrence: y, predittori (elevation, precipitation, temperature, vegetation): x1, x2, x3, x4
# l'intercetta e i coefficienti di ognuna delle variabili/predittori sono stimati e restituiti dalla funzione sdm che crea il modello
# i methods possono essere tantissimi e dipendono dal tipo di modello che si vuole fare. qui va bene glm
m1

#previsione, sulla base del modello m1 appena creato, dove è più probabile trovare la specie
#si usa la funzione predict
p1 <- predict(m1, newdata=preds) #newdata=preds indica che la spazializzazione della mappa creata è determinata dai predittori
p1
#class: RasterLayer (è un oggetto raster)
#plottiamo la previsione
plot(p1, col=cl) #mappa di previsione della distribuzione della specie
points(species[occ == 1, ], pch=19) #per controllo, sovrapponiamo anche i punti a indicare la presenza della specie (dato a terra)
#la maggior parte dei punti neri (dove la specie era stata rilevata come presente) è collocata in zone in cui la previsione ha una probabilità di presenza maggiore (giallo chiaro)
#tranne in alcuni casi in cui i punti neri sono in zone a minore probabilità di presenza (blu) (nelle situazioni reali può succedere).
#per verificare la bontà del modello non si usano i dati di presenza usati per costruire il modello (dati train, come abbiamo fatto qui), ma dei dati di presenza "terzi", "esterni" (dati di test).
#di solito infatti, dei dati disponibili rilevati, una metà è usato come dati train per costruire il modello e l'altra metà è usato come dati test per verificarne la bontà.
#(un modo alternativo per risparmiare dati è una cross validation, secondo un metodo che si chiama Live One Out, oppure il Bootstrap)

#mostriamo il plot con la previsione affiancandolo ai plot con i predittori
par(mfrow=c(2, 3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(temp, col=cl)
plot(prec, col=cl)
plot(vege, col=cl)
#oppure creo uno stack aggiungendo a quello fatto precedentemente con i predittori il file raster con la previsione
final <- stack(preds, p1)
plot(final, col=cl)
#codice più veloce da scrivere e in più compaiono i nomi associati ai plot
    
    
