#########
FIX FILES
#########

### This code will allow you to create graphs that show the allele fixation rate for both favourable and non-favourable alleles
#######################
### READING IN THE DATA

SYfix <- read.csv("zout_SY50.fix.csv", header=TRUE, stringsAsFactors=FALSE)

SYfix$Strategy <- as.factor(SYfix$Strategy)
SYfix$Cycle <- as.factor(SYfix$Cycle)
SYfix$Run <- as.factor(SYfix$Run)

SYfixsort <- SYfix %>% filter(Traits == "SY") %>% group_by(Strategy, Cycle) 


SYfav <- SYfixsort %>% dplyr::summarize(meanSYf= mean(Favorable), sdSYf= sd(Favorable), nSYf=n(), SE_SYf= sd(Favorable)/sqrt(n()))

SYnonfav <- SYfixsort %>% dplyr::summarize(meanSYf= mean(NonFavorable), sdSYf= sd(NonFavorable), nSYf=n(), SE_SYf= sd(NonFavorable)/sqrt(n()))

########################
### PLOTTING LINE GRAPHS

### For the fixation of favorable alleles 

favgraph <- ggplot(data=SYfav,aes(x=Cycle, y=meanSYf, group=Strategy)) + geom_line(aes(color=Strategy)) + 
     geom_point(aes(color=Strategy), size=1) + 
     scale_colour_discrete(name = "Strategy", labels = c("Bulk breeding", "Mass selection", "Single seed descent", "Pedigree method")) + 
     ylab("Percentage of fixed genes") + 
     geom_errorbar(aes(ymin=meanSYf-SE_SYf, ymax= meanSYf+SE_SYf), color="grey35", size=0.2, width=0.5) +
     theme(panel.grid.major = element_blank(), 
         panel.grid.minor = element_blank(),
         panel.background = element_blank(), 
         axis.line = element_line(colour = "black"))

### For the fixation of nonfavorable alleles

nonfavgraph <- ggplot(data=SYnonfav,aes(x=Cycle, y=meanSYf, group=Strategy)) + geom_line(aes(color=Strategy)) + 
     geom_point(aes(color=Strategy), size=1) + 
     scale_colour_discrete(name = "Strategy", labels = c("Bulk breeding", "Mass selection", "Single seed descent", "Pedigree method")) + 
     ylab("Percentage of fixed genes") + 
     geom_errorbar(aes(ymin=meanSYf-SE_SYf, ymax= meanSYf+SE_SYf), color="grey35", size=0.2, width=0.5) +
     theme(panel.grid.major = element_blank(), 
         panel.grid.minor = element_blank(),
         panel.background = element_blank(), 
         axis.line = element_line(colour = "black"))


