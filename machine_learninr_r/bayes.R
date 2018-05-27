# Naive Bayes utilise les tables de fréquence. Donc, les caractéristiques doivent être discrètes
# Il faut exprimer les valeurs numériques en catégories (par exemple en discrétisant avec des bins)
# On peut par exemple diviser l'heure en périodes de la journée. Sinon, on fait des quartiles
# L'essentiel est de trouver un bon équilibre

sms_raw <- read.csv("sms_spam.csv", stringsAsFactors = FALSE)
str(sms_raw)
# Conversion en facteurs du type
sms_raw$type <- factor(sms_raw$type)
str(sms_raw$type)
table(sms_raw$type)

# On va collecter les informations dans un bag-of-words
# permet de préparer le texte pour son traitement (suppression des ponctuation, des pronomons, etc.)
## Prérequis ptet inutile si on utilise la dernière version de R
## install.packages('devtools')
## library(devtools)
## slam_url <- "https://cran.r-project.org/src/contrib/Archive/slam/slam_0.1-37.tar.gz"
## install_url(slam_url)
## package tm
## install.packages("tm")
library(tm)

# On va d'abord créer un corpus qui est une collection de documents, SMS ,mails, aticles, etc.
## PCorpus et persisté VCorpus est en RAM. La source peut être une bdd, un fichier, ou un vecteur, etc.
sms_corpus <- VCorpus(VectorSource(sms_raw$text))
## Le paramètre readerControl permete de variaer la source
print(sms_corpus)
# inspect permet de donner des infos détaillées
inspect(sms_corpus[1:3])
# Pour visualiser un message
as.character(sms_corpus[[1]])
as.character(sms_corpus[[2]])
# Pour visualiser plusieurs SMS à la fois, on utilise lapply
lapply(sms_corpus[2:4], as.character)
# Nettoyage du corpus avec tm_map. On commence par convertir en minuscules.
# content_trasformer et la fonction de transormation
sms_corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))
as.character(sms_corpus[[1]])
as.character(sms_corpus_clean[[1]])
# removeNumbers n'a pas besoin de content_transformer car il est inclus dans tm
sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)
# Suppression des stop words. La liste des stop words par défaut est en anglais
stopwords()
# Pour voir comment choisir la langue et autres
?stopwords
# On applique avec tm_map un removeWorlds sur les stopwords
sms_corpus_clean <- tm_map(sms_corpus_clean, removeWords, stopwords())
# Suppression des poctuations
sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)
as.character(sms_corpus_clean[[1]])
# Attention, dans ce cas, les deux mote sont collés
removePunctuation("hello...world")
# On peut éventuellement utiliser cette fonction
replacePunctuation <- function(x) {
  gsub("[[:punct:]]+", " ", x)
}
# Prochaine étape, conversion en racine (stemming) avec un nouveau package
#install.packages("SnowballC")
library(SnowballC)
# Un petit test
wordStem(c("learn", "learned", "learning", "learns"))
# On applique ça sur notre corpus
sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)
# Suppression des white spaces en trop
sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)
# Avant
as.character(sms_corpus[[1]])
# Après
as.character(sms_corpus_clean[[1]])

# Data preparation

# Tokenisation: dans notre cas un token est un mot. 
## DocumentTermMatrix() de tm prend un corpus et construit un Document Term Matrix (DTM). Les lignes sont les SMS et les colonnes sont les termes (mots)
sms_dtm <- DocumentTermMatrix(sms_corpus_clean)
## On peut aussi spécifier les traitements lors de la création du DTM avec le paramètre control
sms_dtm2 <- DocumentTermMatrix(sms_corpus, control = list(tolower = TRUE,removeNumbers = TRUE,
  stopwords = TRUE,  removePunctuation = TRUE,  stemming = TRUE))
# Il y a une petite nuance car l'order des opérations n'est pas le même. 
## On peur passer ça au lieu de TRUE pour les stopwords: stopwords = function(x) { removeWords(x, stopwords()) }
inspect(sms_dtm)
inspect(sms_dtm2)

# Données d'apprentissage et de test
sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test  <- sms_dtm[4170:5559, ]
# classes
sms_train_labels <- sms_raw[1:4169, ]$type
sms_test_labels  <- sms_raw[4170:5559, ]$type
# On vérifie qu'on a séparé de façon représentatives
prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))
# Visualisation des données textuelles. Nuage de mots
# install.packages("wordcloud")
library(wordcloud)
# wordcloud(sms_corpus_clean)
# random.order = false veut dire qu'on trie par fréquence
wordcloud(sms_corpus_clean, min.freq = 50, random.order = FALSE)
# On va comparer les nuages des spams et des hams
spam <- subset(sms_raw, type == "spam")
ham <- subset(sms_raw, type == "ham")
# Cette fois on affiche les 40 mots plus fréquence avec ajustement de la taille de la police
# On utilise la colonne text cette fois
wordcloud(spam$text, max.words = 40, scale = c(3, 0.5))
wordcloud(ham$text, max.words = 40, scale = c(3, 0.5))
# On nettoie une peu. On garde les mots qui apparaissent dans au moins 5 sms
sms_freq_words <- findFreqTerms(sms_dtm_train, 5)
str(sms_freq_words)
# On prend toutes les lignes mais que les colonnes avec les mots fréquents
sms_dtm_freq_train<- sms_dtm_train[ , sms_freq_words]
sms_dtm_freq_test <- sms_dtm_test[ , sms_freq_words]
# Le classificateur bayes travaille sur des données catégoriques. On convertit donc la fréquence d'un mot dans un SMS par un booléen indiquand sa présence
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}
# apply permet de spécifier les lignes ou colonnes. Margin = 2 veut dire qu'on s'intéresse aux colonnes
sms_train <- apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)
sms_test <- apply(sms_dtm_freq_test, MARGIN = 2,convert_counts)
# Librairie utilisée pour le classificateur Bayesien
# install.packages("e1071")
library(e1071)
# 1ere étape: construire le classificateur (modèle)
sms_classifier <- naiveBayes(sms_train, sms_train_labels)
# 2eme étape prédictions
sms_test_pred <- predict(sms_classifier, sms_test)
# Analyse des résultats
# install.packages("gmodels")
library(gmodels)
# dnn: dimension names
CrossTable(sms_test_pred, sms_test_labels, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))
# la en bas à gauche + haut à droite = erreur

# Amélioration des performances
sms_classifier2 <- naiveBayes(sms_train, sms_train_labels, laplace = 1)
sms_test_pred2 <- predict(sms_classifier2, sms_test)
CrossTable(sms_test_pred2, sms_test_labels, prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE, dnn = c('predicted', 'actual'))
# On a améliora les performances avec laplace (c'est semble paraitre peu mais c'est énorme vu la quantité de SMS traités)
