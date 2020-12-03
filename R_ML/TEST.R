#this is to tune hyperparameters
library(keras);library(ranger);library(FactoMineR);library(MASS);library(tensorflow);library(sgd)

#read the input data and output data
setwd("E:/project data/flowerbulk")
input <- read.csv("combined_csv.csv")
output <- read.csv("phenotype_bulk.csv")
#here is the number of columns of input dataset
input <- as.matrix(input[,1:1027])
#remove qtls
input <- subset(input, select=-c(6, 14, 22, 25, 29, 31, 107, 439, 474, 483, 503, 526, 619, 622, 623, 957, 1006, 1015))
#read phenotypic value
output <- as.matrix(output[,3])

#set 80%train, 20% test
data <- as.data.frame(cbind(input,output))
train.idx <- sample(nrow(data), 0.8 * nrow(data))

#build model
model2 <- keras_model_sequential()
model2 %>% 
  #activation function and neurons in each layer can be changed
  #input shape is the number of markers
  layer_dense(units = 250, activation = 'selu',input_shape = c(1009)) %>%
  #set dropout rate as 0.3
  layer_dropout(0.3) %>%
  layer_dense(units = 200, activation = 'selu') %>%
  layer_dropout(0.3) %>%
  layer_dense(units = 150, activation = 'selu') %>%
  layer_dropout(0.3) %>%
  layer_dense(units = 1, activation = 'linear') %>% 
  compile(
    #you can modify loss funcion here
    optimizer= 'adam',
    loss = 'mean_squared_error',
    metrics = list("mean_absolute_percentage_error")
  )
#train the model here, you can change the number of epochs here
model2 %>% fit(input[train.idx,],output[train.idx,], batch_size = 128, epochs = 200)
#find the predicted value of the testing set
output.predicted2 <- model2 %>% predict(input[-train.idx,], batch_size = 128)
#calculate the R^2 value
(cor(output[-train.idx,1],output.predicted2))^2
#root mean square value
sqrt(mean((output[-train.idx,1]-output.predicted2)^2))

