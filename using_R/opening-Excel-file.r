# first I need to set the working directory in R
setwd("/Users/jennylin/files/McGill/Thesis")
# double check that I am in the correct directory
getwd()
library("openxlsx")
# my file has multiple sheets that need to be combined. First, I will read in each sheet and store it as a variable
data1 <- read.xlsx("dummydata.xlsx",sheet=1)
data2 <- read.xlsx("dummydata.xlsx",sheet=2)
data3 <- read.xlsx("dummydata.xlsx",sheet=3)
data4 <- read.xlsx("dummydata.xlsx",sheet=4)
# rbind will merge your data
mydata <- rbind(data1,data2,data3,data4)
# call up mydata and I should get have the entire dataset loaded into R
mydata
