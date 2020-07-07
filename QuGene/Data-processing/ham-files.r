################
HAMMING DISTANCE
################

### This code allows you to create graphs that show the Hamming distance 
###################
READING IN THE DATA

SYham <- read.csv("zout_SY50.ham.csv", header=TRUE, stringsAsFactors=FALSE)

SYham$Strategy <- as.factor(SYham$Strategy)
SYham$Cycle <- as.factor(SYham$Cycle)
SYham$Run <- as.factor(SYham$Run)

library("dplyr")

hamsort <- SYham %>% filter(Environment == "Field" & Trait == "SY") %>% group_by(Strategy, Cycle)

SYhamsum <- hamsort %>% dplyr::summarize(meanSYh= mean(Value), sdSYh= sd(Value), nSYh=n(), SE_SYh= sd(Value)/sqrt(n()))

##################
PLOTTING THE GRAPH

hamgraph <- ggplot(data=SYhamsum,aes(x=Cycle, y=meanSYh, group=Strategy)) + geom_line(aes(color=Strategy)) + 
     geom_point(aes(color=Strategy), size=1) + 
     scale_colour_discrete(name = "Strategy", labels = c("Bulk breeding", "Mass selection", "Single seed descent", "Pedigree method")) + 
     ylab("Hamming distance") + 
     geom_errorbar(aes(ymin=meanSYh-SE_SYh, ymax= meanSYh+SE_SYh), color="grey35", size=0.2, width=0.5) +
     theme(panel.grid.major = element_blank(), 
         panel.grid.minor = element_blank(),
         panel.background = element_blank(), 
         axis.line = element_line(colour = "black"))
