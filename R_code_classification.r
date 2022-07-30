#CLASSIFICAZIONE 

#librerie
library(raster)
library(RStoolbox)
setwd("C:/lab/") #setting working directory

#importazione dei dati
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
so

#plot dell'immagine
plotRGB(so, 1,2,3, stretch="lin")

#classificazione in 3 classi dell'immagine
soc <- unsuperClass(so, nClasses=3)
plot(soc$map)

#classificazione in 20 classi dell'immagine
soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map,col=cl)

cl <- colorRampPalette(c('yellow','black','red'))(100)
plot(soc20$map,col=cl)

#Download Solar Orbiter data

#Grand Canyon
#https://landsat.visibleearth.nasa.gov/view.php?id=80948

#When John Wesley Powell led an expedition down the Colorado River and through the Grand Canyon in 1869, he was confronted with a daunting landscape. 
#At its highest point, the serpentine gorge plunged 1,829 meters (6,000 feet) from rim to river bottom, making it one of the deepest canyons in the United States. 
#In just 6 million years, water had carved through rock layers that collectively represented more than 2 billion years of geological history, nearly half of the time 
#Earth has existed.

gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")

#plot RGB (con stretch lineare o a istogrammi)
plotRGB(gc, r=1, g=2, b=3, stretch="lin")
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

#classificazione immagine in 2 classi
gcc2 <- unsuperClass(gc, nClasses=2)
gcc2
plot(gcc2$map)

#classificazione immagine in 4 classi
gcc4 <- unsuperClass(gc, nClasses=4)
plot(gcc4$map)
