#########
FIT FILES
#########

### This code will allow you to create genetic gain graphs with a line that indicates when 90% of the cumulative genetic gain has been achieved
__________________
### SETTING UP TO CODE

setwd("/Users/jennylin/files/McGill/Thesis/QUGENE/SY_out50")

library("openxlsx")
library("plyr") ; library("dplyr")
library("ggplot2")

___________________
### READING IN THE DATA

SYdelta <- read.xlsx("zout_SY50.fit.xlsx", colNames=TRUE,rowNames=FALSE)

SYdelta$ValueAD <- as.numeric(SYdelta$ValueAD)
SYdelta$Strategy <- as.factor(SYdelta$Strategy)
SYdelta$Cycle <- as.factor(SYdelta$Cycle)
SYdelta$Run <- as.factor(SYdelta$Run)

SYfilter <- SYdelta %>% filter(Environment=="Field" & Trait=="SY") %>% select(2,3,4,9)

SYsummary <- SYfilter %>% group_by(Strategy,Cycle) %>% dplyr::summarize(meanSYd= mean(Delta), sdSYd= sd(Delta), nSYd=n(), SE_SYd= sd(Delta)/sqrt(n()))

SY90 <- as.data.frame(SYsummary)

SY90bulk <- SY90 %>% filter(Strategy=="1") %>% select(2,3) 
SY90mass <- SY90 %>% filter(Strategy=="2") %>% select(2,3) 
SY90ssd <- SY90 %>% filter(Strategy=="3") %>% select(2,3) 
SY90ped <- SY90 %>% filter(Strategy=="4") %>% select(2,3)

SY90bulk[,"cum_Delta"] <- cumsum(SY90bulk$meanSYd)
SY90mass[,"cum_Delta"] <- cumsum(SY90mass$meanSYd)
SY90ssd[,"cum_Delta"] <- cumsum(SY90ssd$meanSYd)
SY90ped[,"cum_Delta"] <- cumsum(SY90ped$meanSYd)

###############################################
# FROM THE DATA:
#	 BULK: 2659.6540 ——>  2393.689 (cycle 15.7852)
#	 MASS: 2467.3855 —->  2220.647 (cycle 10.3233)
#	 SSD: 2662.9949  —->  2396.695 (cycle 7.7807)
#	 PED: 2663.3323  —->  2396.999 (cycle 8.1845)
#
# 2404.1489 - 2355.4599 = 48.689
# 2247.8675 - 2207.6406 = 40.2269
# 2422.7711 - 2303.8763 = 118.8948
# 2466.7304 - 2381.2241 = 85.5063
#
# 2393.689 - 2355.4599 = 38.2291 -> 0.7851691
# 2220.647 - 2207.6406 = 13.0064 -> 0.3233259
# 2396.695 - 2303.8763 = 92.8187 -> 0.7806792
# 2396.999 - 2381.2241 = 15.7749 -> 0.1844882
###############################################

__________________
PLOTTING THE GRAPH

delta90plot2 <- ggplot(data=SYsummary,aes(x=Cycle, y=meanSYd, group=Strategy)) + geom_line(aes(color=Strategy)) + 
     geom_point(aes(color=Strategy), size=1) + 
     scale_colour_discrete(name = "Strategy", labels = c("Bulk breeding", "Mass selection", "Single seed descent", "Pedigree method")) + 
     ylab("Genetic gain (kg/hectare)") + 
     geom_errorbar(aes(ymin=meanSYd-SE_SYd, ymax= meanSYd+SE_SYd), color="grey35", size=0.2, width=0.5) + 
     geom_vline(xintercept = 1 + c(15.7852,10.3233,7.7807,8.1845), linetype="dotted") + 
        annotate("text", x=1+15.7852, y=600, label="Bulk breeding", size=3, color="grey35", angle=90, vjust=1.5) + 
        annotate("text", x=1+10.3233, y=600, label="Mass selection", size=3, color="grey35", angle=90, vjust=1.5) + 
        annotate("text", x=1+7.7807, y=600, label="Single seed descent", size=3, color="grey35", angle=90, vjust=-0.8) + 
        annotate("text", x=1+8.1845, y=600, label= "Pedigree method", size=3, color="grey35", angle=90, vjust=1.5) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"))

