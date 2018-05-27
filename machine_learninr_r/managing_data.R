x <- 10
y <- c(TRUE, FALSE, FALSE)
z <- factor(c("DAY", "DAY", "NIGHT", "NIGHT"))
# Sauvegarde de variables dans un fichier
save(x, y, z, file = "mydata.RData")
# Chargement du fichier sauvegardé
load("mydata.RData")
# Affichage de variables
ls()
# SUppression de variables
rm(m, subject1)
# Tout envlever
rm(list=ls())

# Lecture d'un CSV dans un data frame
pt_data <- read.csv("pt_data.csv", stringsAsFactors = FALSE)
# La première ligne n'est pas un header
mydata <- read.csv("mydata.csv", stringsAsFactors = FALSE, header = FALSE)
# Enregistrer un data frame dans un csv
write.csv(pt_data, file = "pt_data.csv", row.names = FALSE)

# Changer le dossier de travail
setwd("chemin dossier")
