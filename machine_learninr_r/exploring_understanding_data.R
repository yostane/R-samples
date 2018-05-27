# charger un csv
usedcars <- read.csv("usedcars.csv", stringsAsFactors = FALSE)
usedcars
# Affichage de la structure
str(usedcars)
# chr signifie texte

# Traitement de valeurs numériques

# Affichage de statistique de base
summary(usedcars$year)
summary(usedcars[c("price", "mileage")])

# Moyenne
(36000 + 44000 + 56000) / 3
mean(c(36000, 44000, 56000))
# La médiane est la valeur au centre
median(c(36000, 44000, 56000))
# Intervalle de valeurs
range(usedcars$price)
diff(range(usedcars$price))

# The first and third quartiles—Q1 and Q3—refer to the value below or above which one quarter of the values are found. Along with the (Q2) median, the quartiles divide a dataset into four portions, each with the same number of values.
# The difference between Q1 and Q3 is the Interquartile Range (IQR) 
IQR(usedcars$price)
# QUantiles
quantile(usedcars$price)
quantile(usedcars$price)[4] - quantile(usedcars$price)[2]

# Quartiles are a special case of a type of statistics called quantiles, which are numbers that divide data into equally sized quantities. In addition to quartiles, commonly used quantiles include tertiles (three parts), quintiles (five parts), deciles (10 parts), and percentiles (100 parts).
# Affichage du percentile 1 et 99
quantile(usedcars$price, probs = c(0.01, 0.99))
# seq permet de générer des vecteurs espacés uniformément
quantile(usedcars$price, seq(from = 0, to = 1, by = 0.20))
# box plot de price et mileage
# Il montrent les quartiles
boxplot(usedcars$price, main="Boxplot of Used Car Prices", ylab="Price ($)")
boxplot(usedcars$mileage, main="Boxplot of Used Car Mileage", ylab="Odometer (mi.)")
# Histogrammes
# Permet, entre autre, de voir le skew. mileage est right skew
hist(usedcars$price, main = "Histogram of Used Car Prices", xlab = "Price ($)")
hist(usedcars$mileage, main = "Histogram of Used Car Mileage", xlab = "Odometer (mi.)")

# variance et écrart type = rac(var)
var(usedcars$price)
sd(usedcars$price)
var(usedcars$mileage)
sd(usedcars$mileage)
# The 68-95-99.7 rule states that 68 percent of the values in a normal distribution fall within one standard deviation of the mean, while 95 percent and 99.7 percent of the values fall within two and three standard deviations, respectively

# Les donnéees catégoriques sont examinées à l'aide des tables au lieu des statistiques descriptives
# Affiche le nombre d'occurences de chaque valeur
table(usedcars$year)
table(usedcars$model)
table(usedcars$color)
# Calcul des proportions
model_table <- table(usedcars$model)
prop.table(model_table)
# Affichage arrondi
color_table <- table(usedcars$color)
color_pct <- prop.table(color_table) * 100
round(color_pct, digits = 1)
# Le mode est l'élément qui se répète le plus. ne pas utiliser mode mais regarder le max d'occurences
# on peut avoir du bimodal et du multimodal

# Scatterplot
plot(x = usedcars$mileage, y = usedcars$price,
     main = "Scatterplot of Price vs. Mileage",
     xlab = "Used Car Odometer (mi.)",
     ylab = "Used Car Price ($)")

# cross tab. Statitiques croisées
# Installation
# install.packages("gmodels")
library("gmodels")
# %in% permet de retourner un tableau de booléens
usedcars$conservative <- usedcars$color %in% c("Black", "Gray", "Silver", "White")
table(usedcars$conservative)
# statistiques croisées 
CrossTable(x = usedcars$model, y = usedcars$conservative)
# un proba faible indique qu'il a forte chances que les vars soient liées.
CrossTable(x = usedcars$model, y = usedcars$conservative, chisq = TRUE)
# On a une proba de 93 qui signifie que les variations de couelur conservatices et le model ne sont pas liées à une vraie association mais plutôt à de la chance


