library(keras);library(ranger);library(FactoMineR);library(MASS);library(tensorflow);library(sgd)

setwd("E:/project data/70runmod")
input <- read.csv("combined_csv.csv")
output <- read.csv("phenotype_modped.csv")

input <- as.matrix(input[,1:1052])
input <- subset(input, select=-c(2, 7, 101, 102, 105, 274, 277, 279, 280, 281, 282, 296, 300, 305, 308, 339, 477, 625, 626, 628, 629, 630, 637, 658, 668, 669, 713, 715, 719, 721, 726, 743, 745, 747, 748, 765, 768, 769, 856, 888, 911, 915, 929))
output <- as.matrix(output[,3])

data <- as.data.frame(cbind(input,output))
#set the crossvalidation
c.v.idx <- sample(nrow(data), nrow(data))
c.v.results <- matrix(0, nrow = 10, ncol = 2)
for (i in 1:10) {
  #10fold, each time different 10% population are the testing population
  test.idx <- c.v.idx[(1+(i-1)*nrow(data)/10):(i*nrow(data)/10)]
  model2 <- keras_model_sequential()
  model2 <- keras_model_sequential()
  model2 %>% 
    layer_dense(units = 100, activation = 'selu',input_shape = c(1009)) %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 50, activation = 'selu') %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 50, activation = 'selu') %>%
    layer_dropout(0.3) %>%
    layer_dense(units = 1, activation = 'linear') %>% 
    compile(
      optimizer= 'adam',
      loss = 'mean_squared_error',
      metrics = list("mean_absolute_percentage_error")
    )
  model2 %>% fit(input[-test.idx,],output[-test.idx,], batch_size = 32, epochs = 200)
  output.predicted2 <- model2 %>% predict(input[test.idx,], batch_size = 32)
  c.v.results[i,1] <- (cor(output[test.idx,1],output.predicted2))^2
  c.v.results[i,2] <- sqrt(mean((output[test.idx,1]-output.predicted2)^2))
}
c.v.results
mean(c.v.results[,1])
mean(c.v.results[,2])
