labor_raw <- read.csv("labor.arff.csv", stringsAsFactors = TRUE, na.strings = "?")
str(labor_raw)

set.seed(123)
train_sample <- sample(57, 40)

labor_train <- labor_raw[train_sample, ]
labor_test  <- labor_raw[-train_sample, ]

prop.table(table(labor_train$class))
prop.table(table(labor_test$class))

#install.packages("C50")
library(C50)

# c'est la même colonne
table(labor_train$class)
table(labor_train[17])

# arbre de décision 1
labor_model <- C5.0(labor_train[-17], labor_train$class)

labor_model
summary(labor_model)

labor_c5_pred <- predict(labor_model, newdata = labor_test[-17])

c5_predic_table <- table(labor_c5_pred, labor_test$class, dnn=c("pre", "ref"))
c5_predic_table

install.packages("caret")
library(caret) 
confusionMatrix(c5_predic_table)
#install.packages("gmodels")
library(gmodels)

CrossTable(labor_test$class, labor_c5_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual good', 'predicted good'))
plot(labor_model)


# arbre de décision 2

# install.packages("party")
library(party)
myFormula <- class ~ contribution.to.health.plan + bereavement.assistance + contribution.to.dental.plan 
  + longterm.disability.assistance + vacation + statutory.holidays + education.allowance + shift.differential
  + standby.pay + pension + working.hours + cost.of.living.adjustment + wage.increase.third.year + wage.increase.second.year
  + wage.increase.first.year + duration
labor_ctree <- ctree(myFormula, data=labor_train)
print(labor_ctree)
labor_ctree_pred <- predict(labor_ctree, labor_test)
plot(labor_ctree)
CrossTable(labor_test$class, labor_ctree_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual good', 'predicted good'))


library(rpart)
rpart_tree <- rpart(myFormula, data=labor_train, method = "class", minsplit = 2)
print(rpart_tree)
labor_rpart_pred <- predict(rpart_tree, labor_test)

# install.packages("RGtk2")
# install.packages("rattle")
install.packages("rpart.plot")
install.packages("RColorBrewer")
# library(rattle)
library(rpart.plot)
library(RColorBrewer)

#fancyRpartPlot(mytree)

rpart.plot(rpart_tree)
