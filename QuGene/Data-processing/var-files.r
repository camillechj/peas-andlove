#########
VAR FILES
#########

###################
READING IN THE DATA

setwd("/Users/jennylin/files/McGill/Thesis/QUGENE/3run_output")

library("readr")

SWvar <- read_table("z_out2.var", col_names=TRUE, locale=default_locale(), skip=1,)

library("dplyr")

varsort <- SWvar %>% filter(Trait == "SW") %>% dplyr::select(2, 3, 4, 12, 13, 14)

varsort$Strategy <-as.factor(varsort$Strategy)
varsort$Run <-as.factor(varsort$Run)
varsort$Cycle <-as.factor(varsort$Cycle)


##########
LINE GRAPH

vargrp <- varsort %>% group_by(Strategy, Cycle) %>% summarize(VarADD_1=mean(VarADD_1,na.rm=TRUE))


varline <- ggplot(data=vargrp,aes(x=Cycle, y=VarADD_1, group=Strategy)) + 
   geom_line(aes(color=Strategy)) + 
   scale_colour_discrete(name = "Strategy", labels = c("Bulk", "Mass", "SSD", "Pedigree")) + 
      ylab("Variance") + 
      ggtitle("Genetic variance")

############################
ALTERNATIVELY (NO AVERAGING)

vargrp2 <- varsort %>% group_by(Strategy, Cycle) 


varpoint2 <- ggplot(data=vargrp2,aes(x=Cycle, y=VarADD_1, group=Strategy)) + 
   geom_point(aes(color=Strategy)) + 
   scale_colour_discrete(name = "Strategy", labels = c("Bulk", "Mass", "SSD", "Pedigree")) + 
      ylab("Variance") + 
      ggtitle("Genetic variance")


#######
BOXPLOT

library("ggplot2")

varplot <- ggplot(varsort, aes(x=Cycle, y=VarADD_1, fill=Strategy)) + 
   geom_boxplot() +
   labs(fill="Strategy") + 
      ylab("Variance") + 
      ggtitle("Genetic variance")

### Separated

var5 <- varsort %>% filter(Cycle == "5")
var10 <- varsort %>% filter(Cycle == "10")
var15 <- varsort %>% filter(Cycle == "15")
var20 <- varsort %>% filter(Cycle == "20")

varplot5 <- ggplot(var5, aes(x=Cycle, y=VarADD_1, fill=Strategy)) + 
   geom_boxplot() +
   labs(fill="Strategy") + 
   ylab("Variance") + 
   ggtitle("Genetic variance at cycle 5")

varplot10 <- ggplot(var10, aes(x=Cycle, y=VarADD_1, fill=Strategy)) + 
   geom_boxplot() +
   labs(fill="Strategy") + 
   ylab("Variance") + 
   ggtitle("Genetic variance at cycle 10")

varplot15 <- ggplot(var15, aes(x=Cycle, y=VarADD_1, fill=Strategy)) + 
   geom_boxplot() +
   labs(fill="Strategy") + 
   ylab("Variance") + 
   ggtitle("Genetic variance at cycle 15")

varplot20 <- ggplot(var20, aes(x=Cycle, y=VarADD_1, fill=Strategy)) + 
   geom_boxplot() +
   labs(fill="Strategy") + 
   ylab("Variance") + 
   ggtitle("Genetic variance at cycle 20")
