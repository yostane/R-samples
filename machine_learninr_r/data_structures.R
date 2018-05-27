# Vecteurs avec c()
subject_name <- c("John Doe", "Jane Doe", "Steve Graves")
temperature <- c(98.1, 98.6, 101.4)
flu_status <- c(FALSE, FALSE, TRUE)

# affichage d'items
temperature
temperature[2]
temperature[2:3]

# on exclut l'item 2
temperature[-2]
# on choisit ce qu'on inclut
temperature[c(TRUE, TRUE, FALSE)]

# Données nominales
gender <- factor(c("MALE", "FEMALE", "MALE"))
blood <- factor(c("O", "AB", "A"), levels = c("A", "B", "AB", "O"))
blood[1:2]

# Donnéees nominales triées
symptoms <- factor(c("SEVERE", "MILD", "MODERATE"), levels = c("MILD", "MODERATE", "SEVERE"), ordered = TRUE)
symptoms
symptoms > "MODERATE"

# Une liste est un vecteur dont les éléments peuvent être de types différents
subject1 <- list(fullname = subject_name[1],
                 temperature = temperature[1],
                 flu_status = flu_status[1],
                 gender = gender[1],
                 blood = blood[1],
                 symptoms = symptoms[1])

# Affiche et accès aux éléments d'une liste

subject1
## Renvoie une nouvelle liste
subject1[2]
## Accès à la valeur de l'élément dans la liste
subject1[[2]]
subject1$temperature
## Sous-liste
subject1[c("temperature", "flu_status")]

# Le data-frame est comme une feuille de caclcul excel. On peut le considérer comme une lsite de vecteurs ou de facteurs

pt_data <- data.frame(subject_name, temperature, flu_status,
                      gender, blood, symptoms, stringsAsFactors = FALSE)
pt_data

# Affichage de colonnes
pt_data$subject_name
pt_data[c("temperature", "flu_status")]

# Affichage de cellules et de plages

## (1ère ligne, deuxième colonne)
pt_data[1, 2]
## (1ère ligne, troisième ligne et deuxièle colonne, 4ème colonne)
pt_data[c(1, 3), c(2, 4)]
## Toues les lignes de la première colonne
pt_data[, 1]
## Toues les colonnes de la première ligne
pt_data[1, ]
## Tout extraire
pt_data[ , ]
## On peut accèder au colonnes par nom
pt_data[c(1, 3), c("temperature", "gender")]
## On peut utiliser des indices négatifs
pt_data[-2, c(-1, -3, -5, -6)]

# Matrices. Données bidimentionnelles
m <- matrix(c(1, 2, 3, 4), nrow = 2)
# Ou
m <- matrix(c(1, 2, 3, 4), ncol = 2)
# L'ordre de création des élémnets est en column-major order (on remplit colonne par colonne)
m
# Trois colonnes car j'ai demandé deux lignes
m <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2)
# Trois ligne car j'ai demandé deux colonnes
m <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 2)
# Mécanisme similaire que les dataframes pour accèder aux données
m[1, ]
m[, 1]
# Il y a aussi les arrays
