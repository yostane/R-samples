wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors = FALSE)
str(wbcd)
# Enlever l'id car inutile ici
wbcd <- wbcd[-1]
# Infections 
table(wbcd$diagnosis)
# Plusieurs algos de ML en R nécessitent des facotrs. Les autres sont numériques
wbcd$diagnosis<- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))
# Proportions
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])
# Fonction de normalisation entre 0 et 1
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
normalize(c(1, 2, 3, 4, 5))
normalize(c(10, 20, 30, 40, 50))

# lapply applique une fonction à un vecteur, une liste, etc.
x <- list(a = 1:10, beta = exp(-3:3), logic = c(TRUE,FALSE,FALSE,TRUE))
# Les moyennes de a, beta et logic
lapply(x, mean)
# Normalisation. wbcd_n ne contient pas la classe
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))
summary(wbcd_n$area_mean)
# Données d'apprentissage et de test
wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]
# Les différentes classes
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
# méthodes de ML
# Installation
install.packages("class")
# Utilisation
library("class")
# Apprentissage. On peut modifier k pour varier les performances
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Evaluation
library("gmodels")
# En haut à gauche : True Negative. En bas à droite: True Positive. En haut à droite False Positive. En bas à gauche False Negative
# True Negative: Bon diagnostic benin
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq=FALSE)

# Autre méthode de scaling (normalisation). z-score standardization
# La fonction scale de R fait z-score par défaut et supporte les dataframes
wbcd_z <- as.data.frame(scale(wbcd[-1]))
# The mean of a z-score standardized variable should always be zero, and the range should be fairly compact. A z-score greater than 3 or less than -3 indicates an extremely rare value. With this in mind, the transformation seems to have worked
summary(wbcd_z$area_mean)
# training, test et labels
wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
# knn
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)
# evaluation
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)
