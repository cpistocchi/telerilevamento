# TIME SERIES ANALYSIS of Greenland LST data

# Caricamento pacchetti
library(raster)
# Settaggio della cartella di lavoro
setwd("C:/lab/greenland")

# Vogliamo caricare insieme 4 dati diversi: LST del 2000, del 2005, del 2010 e del 2015.
# Ora li importiamo singolarmente usando la funzione raster, che permette di creare un oggetto RasterLayer (un singolo raster, un singolo layer)
lst2000 <- raster("lst_2000.tif")
# Vediamone le informazioni
lst2000
# class: RasterLayer
# dimensions: numero di px
# names: 1 solo elemento, perchè abbiamo importato un solo layer
# values: 0, 65535 (min, max), cioè è un'immagine a 16 bit (2^16=65536)
plot(lst2000) # Plot dell'immagine del 2000
# Le T più basse sono nelle zone in giallo 
# Importazione degli altri dati
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

# Creiamo una colorRampPalette
cl <- colorRampPalette(c("blue", "light blue", "pink", "red"))(100)

# Multiframe dei dati della Groenlandia
par(mfrow=c(2, 2))
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)
# Dal confronto, all'inizio del 2000 si vede che la parte con le T più basse è molto più estesa rispetto alle altre date.

# Per importare i dati tutti insieme, invece di caricarli uno alla volta, è possibile usare una funzione: lapply, che applica una funzione a una lista o un vettore
# In questo caso, la funzione da applicare è raster
# Prima dobbiamo creare una lista con i file da importare: per farlo si usa la funzione list.files, che crea una lista di file
# Fra gli argomenti di list.files vi è pattern, che indica una caratteristica che i file della lista hanno in comune
rlist <- list.files(pattern="lst") # In pattern indichiamo una parte del nome che devono avere in comune e che discrimina gli oggetti della lista
rlist # Vediamo quali oggetti sono stati inseriti nella lista 
import <- lapply(rlist, raster)
import
# Ci sono 4 elementi, indicati con le doppie parentesi quadre [[ ]]

# Creazione di uno stack, cioè si combinano insieme in un'unica immagine, come se fossero più layer di un'unica immagine (come accade per le immagini satellitari)
# Uso della funzione stack
tgr <- stack(import)
tgr 
# class: RasterStack (è come un RasterBrick, creato in modo diverso)
# Tutte le altre informazioni sono come per le immagini satellitari, quindi con le dimensioni, il numero di layers ecc
# Ora non serve fare un multiframe, ma per vedere gli elementi di tgr:
plot(tgr, col=cl) # Sono specificati i nomi, cosa che nel multiframe non accadeva

# Per plottare solo un layer specifico l'elemento
plot(tgr[[1]], col=cl)
# Creazione di un RGB basandosi sui layer dello stack creato, ad esempio:
# red= lst 2000
# green= lst 2005
# blue= lst 2010
# Facciamolo:
plotRGB(tgr, r=1, g=2, b=3, stretch="lin")
# La parte centrale, comune a tutte le immagini, è molto scura. è dove si hanno le T basse per tutti gli anni.
# La parte più chiara in alto, esterna, è probabilmente una T più alta per il primo LST.
# La parte scura diventa sempre meno scura verso l'esterno della Groenlandia quindi nel tempo le zone a T minori sono diminuite




