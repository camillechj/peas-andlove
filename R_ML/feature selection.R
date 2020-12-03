#read libraries, need to store the package Tensorflow on Python first
library(keras);library(ranger);library(FactoMineR);library(MASS);library(tensorflow);library(sgd)
#set working directory
setwd("E:/project data/70runmass")
#read genotypic and phenotypic data
input <- read.csv("combined_csv.csv")
output <- read.csv("phenotype_mass.csv")
input <- as.matrix(input)
#remove those qtls
input <- input[,-c(2, 7, 101, 102, 105, 274, 277, 279, 280, 281, 282, 296, 300, 305, 308, 339, 477, 625, 626, 628, 629, 630, 637, 658, 668, 669, 713, 715, 719, 721, 726, 743, 745, 747, 748, 765, 768, 769, 856, 888, 911, 915, 929)]
#select the column of the phenotypic value in the output file 
output <- as.matrix(output[,3])


#set 80%train, 20% test
data <- as.data.frame(cbind(input,output))

colnames(data)[ncol(data)] <- c("rfout")
data <- as.data.frame(data)
train.idx <- sample(nrow(data), 0.8 * nrow(data))
colnames(data)[-c(1:1000)]

#build a random forest model to select the most important markers, num of trees can be changed here
rfmodel <- ranger(rfout ~ .,data = data[train.idx,],num.trees = 500, mtry = NULL,min.node.size = 10,importance = "impurity")
input.o <- data[,order(importance(rfmodel),decreasing = TRUE)]
#set the top important markers, change the value here to select different
#number of markers
input.o <- input.o[,1:200]
input.o <- as.matrix(input.o)
data <- as.data.frame(cbind(input.o,output))
#create a table to store the cross-validation results
c.v.idx <- sample(nrow(data), nrow(data))
c.v.results <- matrix(0, nrow = 10, ncol = 2)
for (i in 1:10) {
  test.idx <- c.v.idx[(1+(i-1)*nrow(data)/10):(i*nrow(data)/10)]
  model2 <- keras_model_sequential()
  model2 <- keras_model_sequential()
  model2 %>% 
    layer_dense(units = 50, activation = 'selu',input_shape = c(200)) %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 20, activation = 'selu') %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 15, activation = 'selu') %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 15, activation = 'selu') %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 1, activation = 'linear') %>% 
    compile(
      optimizer= 'adam',
      loss = 'mean_squared_error',
      metrics = list("mean_absolute_percentage_error")
    )
  model2 %>% fit(input.o[-test.idx,],output[-test.idx,], batch_size = 32, epochs = 200)
  output.predicted2 <- model2 %>% predict(input.o[test.idx,], batch_size = 32)
  #store the results of each cross-validation trial
  c.v.results[i,1] <- (cor(output[test.idx,1],output.predicted2))^2
  c.v.results[i,2] <- sqrt(mean((output[test.idx,1]-output.predicted2)^2))
}
#show the results and mean value
c.v.results
mean(c.v.results[,1])
mean(c.v.results[,2])


