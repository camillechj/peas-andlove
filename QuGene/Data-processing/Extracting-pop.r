###########
MARKER DATA
###########

########
GES FILE


setwd("/Users/jennylin/files/McGill/Thesis/QUGENE/3run_output")

library("readr")
library("dplyr")
library("stringr")

ges <-read.table("whitemold.ges", blank.lines.skip=TRUE, colClasses="character", skip=105, fill=TRUE)

filter <- ges %>% select(V1) %>% filter(grepl('[A-Za-z]', ges$V1))

marker <- as.vector(unlist(filter$V1))


#############
GENOTYPE DATA
#############

########
POP FILE

setwd("/Volumes/Seagate drive/bulk_SY50")

library("readr")
library("dplyr")
library("stringr")
library("openxlsx")
library("tidyverse")


#####################
FOR A SINGLE POP FILE

pop <-read.table("zout_SY50_001_001_001_001.pop", blank.lines.skip=TRUE, colClasses="character", skip=15, fill=TRUE)


#######################################
APPLYING FOR LOOP TO MULTIPLE POP FILES

### Select the cycle to process

mypopfiles <- list.files(path="/Volumes/Seagate drive/bulk_SY50", pattern="*001.pop")

lapply(X=mypopfiles, function(path) {
    pop <- read.table(path, blank.lines.skip=TRUE, 
        colClasses="character", skip=15, fill=TRUE)
    for (i in 1:dim(pop)[1]) {
        pop.data <- data.frame(matrix(unlist(str_split(slice(pop, i:i),pattern="")), 
            nrow=1, byrow=T), stringsAsFactors=FALSE)
    write.table(pop.data, file="cycle_001", 
        append= TRUE, quote=FALSE, sep=,",", 
        row.names=FALSE, col.names=FALSE)
    }
})


####################
SORTING OUT THE DATA 

### Read in the pop file or files that you generated

cycle_001 <- read.csv(file="cycle_001", header=FALSE,sep=",",fill=TRUE)

colnames(cycle_001) <- marker


####################
CONVERT TO HAPLOTYPE

### After extracting the pop files for cycle 1, there will be 500000 individuals 

a <- 500000
b <- rep(seq_len(a), each=2)
cycle_001hap <- rowsum(cycle_001, group=b, reorder=FALSE)
cycle_001hap[cycle_001hap == 2] <- 0
cycle_001hap[cycle_001hap == 3] <- 1
cycle_001hap[cycle_001hap == 4] <- 2

########
RES FILE

### Before you continue, you need to verify how many individuals there are for each run in a cycle (they may vary)

res <-read.table("zout_SY50.res", header=TRUE, blank.lines.skip=TRUE, colClasses="character", skip=42, fill=TRUE)

res.sort <- res %>% select(2,3,4,38) %>% filter(Strategy=="1",Cycle=="1")

print(res.sort)

#######################
SEQUENCE OF INDIVIDUALS

### You need a column to distinguish the individuals
### To do this, make a sequence of numbers 
### Check the res file to see if there are the same number of individuals after each cycle
### Since bulk has 10000 individuals, n is 10000
### Finally, since you have 50 files for cycle 1, use the code rep(m,50)

n <- 10000
m <- rep(seq_len(n), each=1)
group <- rep(m,50)

cycle_001_grp <- cbind(grp=group, cycle_001)

cycle_001.rm <- cycle_001_grp[!is.na(names(cycle_001_grp))]

cycle_001sort <- cycle_001.rm %>% group_by(group)

########################################################
COLLAPSING EACH INDIVIDUAL BASED ON THE MODE (FREQUENCY)

### Write a function that will determine the mode

MyMode <- function(x) {
   ux <- unique(x)
   ux[which.max(tabulate(match(x, ux)))]
 }

### Now collapse the data by taking the mode for each group

cycle_001mode <- aggregate(cycle_001sort[, 2:1053], list(cycle_001sort$individual), MyMode)

write.table(cycle_001mode, file="cycle_001_call3", sep=",", row.names=FALSE, col.names=TRUE)

################################
ADDITIONAL STUFF (NOT NECESSARY)
################################
______________________________
RENAME AS GROUP COLUMN AS TAXA

cycle_001modenew <- cycle_001mode %>% rename(taxa=Group.1)

write.table(cycle_001modenew, file="cycle_001_call4", sep=",", row.names=FALSE, col.names=TRUE)

____________________
GD FILE (FOR GAPIT)

gdfile <- read.table("cycle_001_call2", header=TRUE, sep=",")

d <- 1
colum <- c(d, marker)
colnames(gdfile) <- colum

gdfile <- gdfile %>% rename(taxa=1)

write.table(gdfile, file="GDfile", sep=",", row.names=FALSE, col.names=TRUE)


