#time series analysis of Greenland LST data
#carichiamo i pacchetti
library(raster)
#settaggio della cartella di lavoro
setwd("C:/lab/greenland")

#vogliamo caricare insieme 4 dati diversi: LST del 2000, del 2005, del 2010 e del 2015.
#adesso importiamoli singolarmente usando la funzione raster, che permette di crare un oggetto RasterLayer, un singolo raster, un singolo layer.
lst2000 <- raster("lst_2000.tif")
#vediamone le informazioni
lst2000
#class: RasterLayer
#dimensions: numero di px
#names: 1 solo elemento, perchè abbiamo importato un solo layer
#values: 0, 65535 (min, max), cioè è un'immagine a 16 bit (2^16=65536)
plot(lst2000) #plot dell'immagine del 2000
#le T più basse sono nelle zone in giallo 
#importiamo gli altri dati
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

#creiamo una color ramp palette
cl <- colorRampPalette(c("blue", "light blue", "pink", "red"))(100)

#multiframe dei dati della Groenlandia
par(mfrow=c(2, 2))
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)
#dal confronto, all'inizio del 2000 si vede che la parte con le T più basse è molto più estesa rispetto alle altre date.

#per importare i dati tutti insieme, invece di caricarli uno alla volta, è possibile usare una funzione: lapply, che applica una funzione a una lista o un vettore
#in questo caso, la funzione da applicare è raster
#prima dobbiamo creare una lista con i file da importare: per farlo si usa la funzione list.files, che crea una lista di file
#fra gli argomenti di list.files vi è pattern, che indica una caratteristica che i file della lista hanno in comune
rlist <- list.files(pattern="lst") #in pattern indichiamo una parte del nome che devono avere in comune e che discrimina gli oggetti della lista
rlist #vediamo quali oggetti sono stati inseriti nella lista 
import <- lapply(rlist, raster)
import
#ci sono 4 elementi, indicati con le doppie parentesi quadre [[ ]]
#possiamo decidere di voler fare uno stack, cioè combinarli insieme in un'unica immagine, come se fossero più layer di un'unica immagine (come accade per le immagini satellitari)
#usiamo la funzione stack
tgr <- stack(import)
tgr 
#class: RasterStack (è come un RasterBrick, creato in modo diverso)
#tutte le altre informazioni sono come per le immagini satellitari, quindi con le dimensioni, il numero di layers ecc
#ora non serve fare un multiframe, ma per vedere gli elementi di tgr posso fare
plot(tgr, col=cl) #e in più mette i nomi, cosa che nel multiframe non accadeva
#per plottare solo un layer specifico l'elemento
plot(tgr[[1]], col=cl)
#possiamo anche fare un RGB basandosi sui layer dello stack creato, ad esempio:
#red= lst 2000
#green= lst 2005
#blue= lst 2010
#facciamolo:
plotRGB(tgr, r=1, g=2, b=3, stretch="lin")
#la parte centrale, comune a tutte le immagini, è molto scura. è dove si hanno le T basse per tutti gli anni.
#la parte più chiara in alto, esterna, è probabilmente una T più alta per il primo LST.
#la parte scura diventa sempre meno scura verso l'esterno della Groenlandia quindi nel tempo le zone a T minori sono diminuite




