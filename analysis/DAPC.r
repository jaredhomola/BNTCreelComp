############################################################
#####  Discriminant Analysis of Principal Components   #####
############################################################

##### Load libraries and data

library(adegenet)
library(tidyverse)
library(ggrepel)
library(BNTCreelComp)
data(BNTCreelComp)

hatchery.dat <- allGeno.dat[pop=c("WR_MI", "SE_MI", "Sturgeon", "Gilchrist", "SE_WI", "WR_WI")]
creel.dat <- allGeno.dat[pop=c("Creel_Frankfort", "Creel_Ludington", "Creel_Manistee", "Creel_Onekama")]

##### Perform DAPC #####
# Hatchery only
dapc.hatchery <- dapc(hatchery.dat, var.contrib = TRUE, scale = FALSE, n.pca = 25, n.da = nPop(hatchery.dat) - 1)
summary(dapc.hatchery)$assign.per.pop*100 #Reassignment probability

# Add harvested
pred.supp <- predict.dapc(dapc.hatchery, newdata = creel.dat)
posterior.probs.creel <- round(pred.supp$posterior[1:118, 1:6],3)

##### Plot DAPC #####
# Hatchery data frame #
dapc.df <- cbind(as.data.frame(dapc.hatchery$ind.coord)[1:2], as.factor(hatchery.dat@pop))
dapc.df$labelNames <- c(rep("Wild Rose-MI",50),rep("Seeforellen-MI",50),rep("Sturgeon River",50),rep("Gilchrist Creek",50), rep("Seeforellen-WI",50),rep("Wild Rose-WI",50))
names(dapc.df) <- c("A1", "A2", "pop", "labelNames")

# Harvest data frame #
harvest.df <- as.data.frame(pred.supp$ind.scores[,1:2])
names(harvest.df) <- c("A1", "A2")

# Plot DAPC with harvested individuals overlayed #
dapc.plot <- ggplot(dapc.df, aes(x = A1, y = A2, color = labelNames)) +
  geom_point(alpha = 0.25, size = 4) +
  ylab("Discriminant function 2") +
  xlab("Discriminant function 1") +
  labs(color = "labelNames") +
  geom_point(data = harvest.df, pch=17, col=transp("black", .7), cex=2.5) +
  theme_classic(base_size = 18) +
  theme(
    legend.position = "bottom") +
  NULL
