### Call up the needed libraries and set your working directory

library(dplyr)

folder="/Users/jennylin/PycharmProjects/new" ### Change this to your working directory 
setwd(folder)

### Read in the simuPOP initial popuation file you saved previously

mypop <- read.table(file="mypop.csv", header=FALSE, sep=",", skip=1)  

strand1 <- mypop %>% dplyr::select(3:1054)
strand2 <- mypop %>% dplyr::select(1055:2106)

marker <- paste0("a", 1:1052)

colnames(strand1) <- marker
colnames(strand2) <- marker

indv <- 1:200 ### In this case, I have 200 individuals (change if necessary)

check <- rep("s1", times=200)
s1 <- cbind(check, indv, strand1)

check <- rep("s2", times=200)
s2 <- cbind(check, indv, strand2)

final <- rbind(s1, s2) %>% arrange(by_group=indv)

final.rm <- final %>% dplyr::select(-1)

### Convert to haplotype

hap <- rowsum(final.rm, group=final.rm$indv, reorder=FALSE) %>% dplyr::select(-1)

hap[hap == 2] <- 0
hap[hap == 3] <- 1
hap[hap == 4] <- 2


##############
### GET THE LD
##############

### Call up the libraries needed 

library(LDcorSV)
library(ggplot2)

ldtest <- LD.Measures(donnees=hap)

avgld <- mean(ldtest$r2)

avgld


### basic simulation (i.e. baseline population), LD is 0.04594353

### with natural selection and 50 generations, LD is 0.1532205

### with natural selection and 75 generations, LD is 0.1677289

### with natural selection and 100 generations, LD is 0.2567022

### with natural selection and 150 generations, LD is 0.2478646

### with natural selection and 200 generations, LD is 0.2440913


### In the end, I will choose the file "mypop100.csv" as the population (LD=0.2384855)

#######################################################################
### RE-FORMAT THE SIMUPOP FILE TO MATCH THE PARENTS.POP FILE IN QU-GENE
#######################################################################

parents <- read.table(file="FYParents.pop", header=FALSE,skip=19, colClasses="character")


library("tidyr")

format <- final %>% dplyr::select(3:1054)

f1 <- unite(format, chr, sep="", a1:a99)
f2 <- unite(format, chr, sep="", a100:a253)
f3 <- unite(format, chr, sep="", a254:a365)
f4 <- unite(format, chr, sep="", a366:a462)
f5 <- unite(format, chr, sep="", a463:a534)
f6 <- unite(format, chr, sep="", a535:a622)
f7 <- unite(format, chr, sep="", a623:a711)
f8 <- unite(format, chr, sep="", a712:a840)
f9 <- unite(format, chr, sep="", a841:a909)
f10 <- unite(format, chr, sep="", a910:a982)
f11 <- unite(format, chr, sep="", a983:a1052)

reformat <- as.data.frame(cbind(f1$chr, f2$chr, f3$chr, f4$chr, f5$chr, f6$chr, f7$chr, f8$chr, f9$chr, f10$chr, f11$chr)) 

write.table(reformat, file="testpopns.pop", quote=FALSE, row.names=FALSE, col.names=FALSE)


### Add spaces after every two rows (each individual)

library(berryFunctions)

spaces <- as.vector(unlist((1:200)*3))

testinsert <- insertRows(reformat, spaces, new=NA)

write.table(testinsert, file="testpop.pop", quote=FALSE, na=" ", row.names=FALSE, col.names=FALSE)

### As a note, QU-GENE is very picky with the format of the pop file
### Make sure each individual genotype has an empty line between them (on that line, there needs to be one space)
### At the end of the file, there should be two empty lines at the end (the first line should have a space, but the second line should not)

###############
### Extra stuff
###############

### Let's verify the LD of the original parent pop files created using QU-GENE


library("stringr")

pop <- read.table("FYParents.pop", blank.lines.skip=TRUE,colClasses="character", skip=15, fill=TRUE)
for (i in 1:dim(pop)[1]) {
    pop.data <- data.frame(matrix(unlist(str_split(slice(pop, i:i),pattern="")), nrow=1, byrow=T), stringsAsFactors=FALSE)       
    write.table(pop.data, file="FYParents.split.csv", 
        append= TRUE, quote=FALSE, sep=,",", 
        row.names=FALSE, col.names=FALSE)
    }

pop.read <- read.table("FYParents.split.csv", header=FALSE, sep=",")
indv <- 1:200
pop.add <- cbind(indv, pop.read)
hap <- rowsum(pop.add, group=pop.add$indv, reorder=FALSE) %>% dplyr::select(-1)

hap[hap == 2] <- 0
hap[hap == 3] <- 1
hap[hap == 4] <- 2

library(LDcorSV)
library(ggplot2)

ldtest <- LD.Measures(donnees=hap)

avgld <- mean(ldtest$r2)

avgld

### the LD was 0.01006738

