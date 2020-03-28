#start by setting your working directory
setwd("/Users/jennylin/files/McGill/Thesis/QUGENE/10run_output")

#Now, read in your data using the read.csv function
SWdata<-read.csv("output.fit.csv", header=TRUE, stringsAsFactors=FALSE)

#Use the str() function to check the structure of your data. 
#Note that chr is character, int is integer, num is number, etc.
str(SWdata)

#Based on the structure, ValueAD has been read in as a character, but it should be numeric, so change it
SWdata$ValueAD <- as.numeric(SWdata$ValueAD)

#Load the dplyr package
library("dplyr")

#You are only concerned with Field and SW, so filter the data to remove the other factors
filtered <-SWdata %>% filter(Environment == "Field" & Trait == "SW")

#Separate the data by strategy
bulk <-filtered %>% filter(Strategy == "1")
mass <-filtered %>% filter(Strategy == "2")
ssd <-filtered %>% filter(Strategy == "3")
pedigree <-filtered %>% filter(Strategy == "4")

#Group by cycles and average the Value and ValueAD for each cycle
bulk.cycle <- bulk %>% group_by(Cycle) %>% summarize(Value=mean(Value,na.rm=TRUE), ValueAD=mean(ValueAD,na.rm=TRUE))

mass.cycle <- mass %>% group_by(Cycle) %>% summarize(Value=mean(Value,na.rm=TRUE), ValueAD=mean(ValueAD,na.rm=TRUE))

ssd.cycle <- ssd %>% group_by(Cycle) %>% summarize(Value=mean(Value,na.rm=TRUE), ValueAD=mean(ValueAD,na.rm=TRUE))

pedigree.cycle <- pedigree %>% group_by(Cycle) %>% summarize(Value=mean(Value,na.rm=TRUE), ValueAD=mean(ValueAD,na.rm=TRUE))
