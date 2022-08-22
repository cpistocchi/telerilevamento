# STUDIO DELLA BIODIVERSITà CON IL PACCHETTO COLORIST

# install.packages("colorist")
# install.packages("ggplot2")

# Carichiamo i pacchetti
library(colorist)
library(ggplot2)

# ESEMPIO 1: MAPPA DELLA DISTRIBUZIONE DI UNA SPECIE (CICLO ANNUALE 01/01 --> 31/12) - uccello

# Carichiamo i dati
data("fiespa_occ")
fiespa_occ
# è un RasterStack (colorist lavora solo con RasterStack, pile di Raster, non con altre tipologie di file)

# Creazione delle metriche
met1 <- metrics_pull(fiespa_occ) # metrics_pull è la funzione usata nel caso di dati a ciclo annuale
# La funzione trasforma i valori del RasterStack nelle distribuzioni individuali, preparando il raster alla visualizzazione

# Creazione della palette: per i cicli annuali si preferisce usare la funzione palette_timecycle:
pal <- palette_timecycle(fiespa_occ)

# Creazione della mappa multipla con la funzione map_multiples (ha come argomenti la metrica, la palette e il numero di colonne in cui vogliamo vedere rappresentate le distribuzioni):
map_multiples(met1, pal, ncol=3, labels=names(fiespa_occ))
# Con l'argomento labels si specifica che a ogni mappa multipla vogliamo che venga assegnato i nomi presenti nel dato, qui i nomi dei mesi dell'anno)

# Per estrarre la mappa singola di un solo mese dell'anno
map_single(met1, pal, layer=6) # In output la mappa del 6° mese (giugno)

# Per modificare i colori delle mappe nel 12 mesi, creiamo una palette personalizzata:
p1_custom <- palette_timecycle(12, start_hue = 60) # start_hue permette di cambiare la tonalità delle 12 mappe relative ai mesi dell'anno
# start_hue è una funzione che di default parte con un valore di 240 (tendente al blu)
# Cambiando questo valore di partenza (es specificando 60) possiamo far partire le mappe con un colore diverso dal blu.
# In questo caso si modifica il colore di partenza delle rappresentazioni grafiche

# Creazione di una mappa distillata
# Creazione della metrica "distillata"
met1_distill <- metrics_distill(fiespa_occ)
# La mappa distillata è una mappa singola:
map_single(met1_distill, pal)

# Legenda
legend_timecycle(pal, origin_label="1 jan") # L'argomento origin_label permette di definire il punto di partenza della legenda (in questo caso il 01/01)


# ESEMPIO 2: MAPPARE IL COMPORTAMENTO INDIVIDUALE DI UN INDIVIDUO di Pekania pennanti NEL TEMPO (LINEARE, in 9 notti)

# Dato
data("fisher_ud")
fisher_ud

# Metrica
m2 <- metrics_pull(fisher_ud) # Anche qui si usa metrics_pull

# Palette
pal2 <- palette_timeline(fisher_ud) # Si usa palette_timeline perchè il tempo è lineare
head(pal2) # Vedo i primi valori della palette

# Mappa multipla
map_multiples(m2, pal2, ncol=3)
# Aumentando l'opacità dell'immagine per renderla più visibile (diminuiamo il valore di lambda_i):
map_multiples(m2, pal2, ncol=3, lambda_i=-12) # Opacità 100%, l'immagine ottenuta è molto più satura

# Mappa distillata
m2_distill <- metrics_distill(fisher_ud) # Metrica distillata
map_single(m2_distill, pal2, lambda_i=-10)

# Legenda (per un tempo lineare si usa legend_timeline)
legend_timeline(pal2)
