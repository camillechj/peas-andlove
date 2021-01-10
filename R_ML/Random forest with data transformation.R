 library(keras);library(ranger);library(FactoMineR);library(MASS)
#this is one-hot-encoding, as our input is 0,1,2. This part
 #makes the model avoid treating the input as ordinal value
one.hot.encoding <- function(data){
  nr <- nrow(data)
  nc <- ncol(data)
  output <- matrix(0,nrow = nr, ncol = 3*nc)
  for (i in 1:nr) {
    for (j in 1:nc) {
      if(data[i,j] == 0){
        output[i,3*(j-1)+1] <- 1
      }
      else if(data[i,j] == 1){
        output[i,3*(j-1)+2] <- 1
      }
      else{
        output[i,3*j] <- 1
      }
    }
  }
  return(output)
}

#this part transform the ordinal value into categorical value
split.cate <- function(M,d){
  output <- matrix(0, nrow = nrow(M), ncol = ncol(M))
  fr <- floor(min(M)/d)
  cl <- ceiling(max(M)/d)
  n <- cl - fr
  for (i in 1:n){
    for (j in 1:nrow(M)) {
      if(M[j,]>= (i-1+fr)*d & M[j,]< (i+fr)*d){
        output[j,] <- i
      }
    }
  }
  output <- output+1-min(output)
  return(output)
}


#read input and output

setwd("E:/project data/70runmass")
input <- read.csv("merge.csv")
input <- subset(input, select=-c(2, 7, 101, 102, 105, 274, 277, 279, 280, 281, 282, 296, 300, 305, 308, 339, 477, 625, 626, 628, 629, 630, 637, 658, 668, 669, 713, 715, 719, 721, 726, 743, 745, 747, 748, 765, 768, 769, 856, 888, 911, 915, 929))
output <- read.csv("phenotype_mass.csv")

input <- as.matrix(input[,1:1009])
output <- as.matrix(output[,3])

# the value after output is the scale of transformation
output.c <- split.cate(output,1500)
data <- as.data.frame(cbind(input,output.c))
#set the random training population as 90% of the whole population
train.idx <- sample(nrow(data), 0.9 * nrow(data))
colnames(data)[1010]
#train the random forest model, with the number of trees equal to 1000. You can modify
# the number of trees here, usually it is set to the number of input dimensions
rf.c<- ranger(V1010~.,data = data[train.idx,], num.trees = 1000, mtry = NULL, min.node.size = 1, classification = TRUE)
rf.predicted <- predict(rf.c,data[-train.idx,-1010])$prediction
#check how many individuals in the testing population are predicted with the 
#correct group
sum((rf.predicted-output.c[-train.idx,])==0)/(length(rf.predicted))

