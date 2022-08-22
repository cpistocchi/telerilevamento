# MODELLI DI DISTRIBUZIONE DI SPECIE

library(sdm) # Per modellizzare la distribuzione delle specie
library(raster) # Per gestire dati geografici, spaziali, sotto forma di matrice
library(rgdal) # Permette di considerare anche delle coordinate nello spazio (i punti nello spazio che indicano presenza di specie)
# gdal (Geospatial Data Abstraction Library) è stata sviluppata dalla Open Source Geospatial Foundation

# Non si usa setwd (non verrà settata una cartella di lavoro) ma verrà usato un file di sistema (cioè un file di esempio "estratto" dal pacchetto sdm).
# Usiamo un file di sistema chiamando la funzione system.file. Questa funzione carica un file, specificando da quale pacchetto questo file verrà caricato.
file <- system.file("external/species.shp", package="sdm") # La cartella in questione si chiama "external" e viene scaricata insieme a sdm ma risulta ad esso esterna, per questo motivo si mettono le virgolette
# All'interno della cartella "external" è presente il file "species.shp", che viene caricato nel file di sistema 
# Ul file è stato letto, ma non è ancora stato caricato
file # Mostra il path, il percorso file, in cui il file di interesse si trova
# Per produrre uno shapefile si usa la funzione shapefile (del pacchetto raster):
species <- shapefile(file)
species
# Il tipo di dato (class) è uno Spatial Point Data Frame, cioè sono punti nello spazio, ciascuno con le sue coordinate
# features indica il numero di punti (qui 200)
# names indica il nome delle colonne della tabella che costituisce il file: qui compare una colonna "Occurrence" (presenza/assenza di una determinata specie)

# Per vedere come sono distribuiti i punti nello spazio:
plot(species, pch=19) # pch (point character permette di specificare il simbolo associato a ogni punto. il default è una crocetta e il 19 è un cerchio pieno)
# Rappresentano i punti a terra, a indicare la presenza/assenza di una specie.

# Per vedere le occorrenze associate ai punti (come elenco di 0-assenza e 1-presenza):
species$Occurrence
# Plottiamo in modo diverso fra loro i punti che hanno come occorrenza 0 o 1, facendo una selezione, un subset (usando le []). PEr interrompere il subset si mette una , prima di ]
# Per plottare solo le presenze:
# plot(species[species$Occurrence == 1, ], col="blue", pch=19) ma così è più pesante.
# Per avere un codice più pulito si crea una variabile con l'occurrance:
occ <- species$Occurrence
plot(species[occ == 1, ], col="blue", pch=19)

# Per mostrare insieme, ma con aspetto diverso, i punti con occurrence 0 e 1
# Non si usa la funzione plot perchè sovrascriverebbe il plot precedente, mentre in questo caso l'obiettivo non è sovrascrivere, ma aggiungere dei punti (aggiungere i punti con occurrence 0 a quelli con occurrence 1)
# La funzione da usare è points:
plot(species[occ == 1, ], col="blue", pch=19)
points(species[occ == 0, ], col="red", pch=19)

# Consideriamo ora i predittori (le mappe con le variabili ambientali, es fattori climatici)
# Creazione di una variabile path (per rendere più pulito l'argomento della funzione list.files (che verrà usata dopo)
path <- system.file("external", package="sdm")
# Questo sarà il percorso in cui si troveranno i 4 file predittori che andremo a listare e stackare
# Per selezionare i file predittori di interesse: consideriamo tutti i file che hanno estenzione asc (ASCII).
# Questi file predittori selezionati sono elevation.asc (quota), precipitation.asc (precipitazioni), temperature.asc (temperatura), vegetation.asc (NDVI, biomassa vegetale)
# Creazione della lista dei vari predittori:
lst <- list.files(path=path, pattern="asc$", full.names="T") #full.names true perchè ci serve considerare il nome completo, costituito anche dal path del file
# Per assicurarsi che abbiano estensione asc, si mette il $ (altrimenti verranno selezionati anche i file che presentano asc non nell'estensione)
lst # Controllare che la lista sia corretta nei suoi elementi

# Questi file sono già dentro al pacchetto sdm quindi non serve usare brick per importarli

# Stack dei 4 file predittori presenti nella lista lst
preds <- stack(lst)
preds
# class è RasterStack
# names (i nomi dei 4 file dello stack): elevation, precipitation, temperature, vegetation

# Plot dei predittori usando una colorRampPalette
cl <- colorRampPalette(c("blue", "orange", "red", "yellow"))(100)
plot(preds, col=cl)
# Da elevation vediamo una zona di valle (blu) e un picco montano (giallo chiaro)
# Da precipitation vediamo che le maggiori precipitazioni avvengono in corrispondenza del picco, ma comunque un buon livello di precipitazione è presente anche in valle, mentre l'area più secca è quella blu
# Da temperature si mostra come le T più basse siano nella parte montana
# Da vegetation si nota che nella parte montana vi è pochissima vegetazione (sopra a 2000 m), presente invece nella valle

# Creiamo variabili riferite ai predittori
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

# Plottiamo ogni predittore con la presenza della specie:

plot(elev, col=cl)
points(species[occ == 1, ], pch=19)
# Vediamo che questo animale non abita zone elevate (le presenze sono solo in valle o a quote medio-basse)

plot(prec, col=cl)
points(species[occ == 1, ], pch=19)
# La specie abita in zone con una quantità di precipitazioni medio-alta

plot(temp, col=cl)
points(species[occ == 1, ], pch=19)
# La specie si distribuisce in zone con T medio alte (non al freddo, a T basse)

plot(vege, col=cl)
points(species[occ == 1, ], pch=19)
# La specie si trova dove è presente vegetazione, ambienti protetti e non esposti

# Si può ipotizzare che la specie sia un anfibio: non vive a quote troppo elevate dove le T sono molto basse, ma ama zone a media-bassa quota, T intermedia ed elevate precipitazioni

# Creazione del modello
# Le funzioni usate sono presenti nel pacchetto sdm 
# sdmData è la funzione che permette di dichiarare i dati da usare per la creazione del modello: in questo caso sono i dati di presenza/assenza delle specie (train, dato a terra) e i predittori (predictors)
datasdm <- sdmData(train=species, predictors=preds)
# Compare un warning perchè non è dichiarato il crs, ovvero il Coordinate Reference System (il sistema di riferimento non è dichiarato) ma non è un problema
datasdm
# class: sdmdata (oggetto di natura sdm)

m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, method="glm")
# ~ può essere sostituita da =
# Occurrence: y, predittori (elevation, precipitation, temperature, vegetation): x1, x2, x3, x4
#  L'intercetta e i coefficienti di ognuna delle variabili/predittori sono stimati e restituiti dalla funzione sdm che crea il modello
# I methods possono essere tantissimi e dipendono dal tipo di modello che si vuole fare. qui va bene glm
m1

# Previsione, sulla base del modello m1 appena creato, dove è più probabile trovare la specie
# Si usa la funzione predict
p1 <- predict(m1, newdata=preds) # newdata=preds indica che la spazializzazione della mappa creata è determinata dai predittori
p1
# class: RasterLayer (è un oggetto raster)
# Plottiamo la previsione
plot(p1, col=cl) # Mappa di previsione della distribuzione della specie
points(species[occ == 1, ], pch=19) # Per controllo, sovrapponiamo anche i punti a indicare la presenza della specie (dato a terra)
# La maggior parte dei punti neri (dove la specie era stata rilevata come presente) è collocata in zone in cui la previsione ha una probabilità di presenza maggiore (giallo chiaro)
# Tranne in alcuni casi in cui i punti neri sono in zone a minore probabilità di presenza (blu) (nelle situazioni reali può succedere).
# Per verificare la bontà del modello non si usano i dati di presenza usati per costruire il modello (dati train, come abbiamo fatto qui), ma dei dati di presenza "terzi", "esterni" (dati di test).
# Di solito infatti, dei dati disponibili rilevati, una metà è usato come dati train per costruire il modello e l'altra metà è usato come dati test per verificarne la bontà.
# (un modo alternativo per risparmiare dati è una cross validation, secondo un metodo che si chiama Live One Out, oppure il Bootstrap)

# Mostriamo il plot con la previsione affiancandolo ai plot con i predittori
par(mfrow=c(2, 3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(temp, col=cl)
plot(prec, col=cl)
plot(vege, col=cl)
# Oppure creo uno stack aggiungendo a quello fatto precedentemente con i predittori il file raster con la previsione
final <- stack(preds, p1)
plot(final, col=cl)
# Codice più veloce da scrivere e in più compaiono i nomi associati ai plot
    
    
