install.packages ("e1071", dependencies = TRUE)
install.packages ("kernlab", dependencies = TRUE)

library(e1071)
library(kernlab)

soybean_raw <- read.csv("soybean.csv", stringsAsFactors = TRUE, na.strings = c("?", "dna"))
str(soybean_raw)

soybean <- na.omit(soybean_raw)
str(soybean)
set.seed(123)
sample_ind <- sample(2, nrow(soybean), replace = TRUE, prob = c(0.8, 0.2))

soybean_train <- soybean[sample_ind == 1, ]
soybean_test  <- soybean[sample_ind ==  2, ]

myFormula <- class ~ .
svmModel <-svm(myFormula, data=soybean_train)
prediction <- predict (svmModel, soybean_test[-36])
Tab <- table(pred=prediction, true=soybean_test$class)
library(caret) 
confusionMatrix(Tab)

plot(svmModel, formula = class ~ area.damaged, data=soybean_train)

