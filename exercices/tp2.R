soybean <- read.csv("soybean.csv", stringsAsFactors = TRUE, na.strings = "?")
str(soybean)

set.seed(123)
sample_ind <- sample(2, nrow(soybean), replace = TRUE, prob = c(0.8, 0.2))

soybean_train <- soybean[sample_ind == 1, ]
soybean_test  <- soybean[sample_ind ==  2, ]

prop.table(table(soybean_train$class))
prop.table(table(soybean_test$class))

table(soybean_train$class)

library(C50)
soybean_c5_model <- C5.0(soybean_train[-36], soybean_train$class)
plot(soybean_c5_model)

library(party)
myFormula <- class ~ .
soybean_ctree <- ctree(myFormula, data=soybean_train)
plot(soybean_ctree)

t <- table(predict(soybean_ctree, newdata = soybean_test), soybean_test$class)

install.packages("caret")
library(caret) 
confusionMatrix(t)
