#CREAZIONE DI FUNZIONI

#ESEMPIO 1: FUNZIONE CHE TI SALUTA :)

#definizione della funzione
cheer_me <- function(your_name){
  cheer_string <- paste("Hello", your_name, sep=" ") #la funzione paste, date due stringhe, le allinea utilizzando il separatore specificato
  print(cheer_string)
}

cheer_me("Chiara")

#ESEMPIO 2: CICLI. creazione di una funzione che saluta n volte
cheer_me_n_times <- function(your_name, n){ #n numero di volte in cui verrà ripetuta la funzione
  cheer_string <- paste("Hello", your_name, sep=" ")
  for(i in seq(1, n)){ #i è la variabile contatore, che varierà dentro al ciclo contando le iterazioni)
      print(cheer_string)
  }
}

cheer_me_n_times("Chiara", 3) #oppure cheer_me_n_times(your_name="Chiara", n=3), cioè specificando l'argomento possono essere dichiarati anche non in ordine

#ESEMPIO 3:

library(raster)

#settare la working directory
setwd("C:/lab/")

#importazione del dato
dato <- raster("sentinel.png")
dato
#RasterLayer, 1 banda (di 4): Ghiacciaio Similaun
plot(dato)

#creazione di una funzione che, dato un file Raster, manda in output il plot con una determinata palette di colori
plot_raster <- function(r, col=NA){ #argomento di default col viene stabilito come NA, in questo modo, se non viene fornita nessuna palette fra gli argomenti, in output viene restituito il plot con i colori predefiniti
  if(!is.na(col)){ #se viene specificato l'argomento di col, cioè viene passata una palette di colori in input (col != NA)
  pal <- colorRampPalette(col)(100)
  plot(r, col=pal)
  } else {
  plot(r)
  }
}
plot_raster(dato, c("brown", "yellow", "green"))
