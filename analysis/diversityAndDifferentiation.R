############################################################
#####      Genetic diversity and differentiation       #####
############################################################

##### Load packages #####
library(hierfstat)
library(adegenet)
library(tidyverse)
library(mmod)
library(BNTHarvestComposition)
data(BNTHarvestComposition)


##### Calculate diversity measures #####
gd <- basic.stats(hatcheryGeno.dat)

he <- as.data.frame.matrix(gd$Hs)
he.strain <- colMeans(he)

ho <- as.data.frame.matrix(gd$Ho)
ho.strain <- colMeans(ho)

fis <- as.data.frame(gd$Fis)
fis.strain <- colMeans(fis)

ar <- as.data.frame(allelic.richness(hatcheryGeno.dat))
ar.strain <- colMeans(ar)

##### Calculate pairwise genetic differentiation of hatchery strains #####
gst.nei.paired <- pairwise_Gst_Nei(hatcheryGeno.dat)
gst.hedrick.paired <- pairwise_Gst_Hedrick(hatcheryGeno.dat)

Gst_Nei(hatcheryGeno.dat)
Gst_Hedrick(hatcheryGeno.dat)

##### Per individual observed heterozygosity #####
## Only hatchery individuals
tab.df <- as.data.frame(hatcheryGeno.dat@tab)
tab.df$ind <- rownames(tab.df)
tab.df$pop <- hatcheryGeno.dat@pop
tab.tib <- as_tibble(tab.df) %>%
  gather(key = locus, value = count,-ind,-pop) %>%
  separate(locus, c("locus", "allele")) %>%
  mutate(
    locus = as.factor(locus),
    ind = as.factor(ind),
    allele = as.factor(allele),
    pop = as.factor(pop)
  ) %>%
  group_by(ind, pop, locus) %>%
  summarize(max.allele.count = max(count)) %>%
  mutate(Ho.count = if_else(max.allele.count == 1, 1, 0)) %>%
  group_by(ind, pop) %>%
  summarize(Ho = mean(Ho.count))

## Plot differences
tab.tib %>% ggplot(aes(pop, Ho)) +
  geom_boxplot()

## Test for statistical differences
aov.test <- aov(Ho ~ pop, tab.tib)
summary(aov.test)
TukeyHSD(aov.test)
