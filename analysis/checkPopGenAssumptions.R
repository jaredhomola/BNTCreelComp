#######################################################################
#####   Checking common population genetic analysis assumptions   #####
#######################################################################

##### Load libraries and data #####

library(PopGenReport)
library(adegenet)
library(tidyverse)
library(qvalue)
library(BNTCreelComp)
data(BNTCreelComp)

######            Run PopGenReport to obtain allele counts, Hardy-Weinberg tests,                 ######
######  allele distributions by population, null allele frequencies, allelic richness estimates   ######

popgenreport(hatcheryGeno.dat, mk.counts = TRUE, mk.map = FALSE, mk.locihz = TRUE,
             mk.hwe = TRUE, mk.fst = FALSE, mk.gd.smouse = FALSE,
             mk.gd.kosman = FALSE, mk.pcoa = FALSE, mk.spautocor = FALSE,
             mk.allele.dist = TRUE, mk.null.all = TRUE, mk.allel.rich = FALSE,
             mk.differ.stats = FALSE, mk.custom = FALSE, fname = "PopGenReport_Hatchery",
             foldername = "PopGenReport_Hatchery", path.pgr = getwd(), mk.Rcode = FALSE,
             mk.complete = FALSE, mk.pdf = FALSE)


##### FDR evaluation of Hardy-Weinberg proportions ######
hwe <- read.csv("./PopGenReport_Hatchery/PopGenReport_Hatchery-HWE_by_locus_location.csv")
hwe.vector <- c(hwe$Gilchrist, hwe$SE_MI, hwe$SE_WI, hwe$Sturgeon, hwe$WR_MI, hwe$WR_WI)

hwe.p.corr <- p.adjust(hwe.vector, method = "fdr")
hwe.sig <- hwe.p.corr[hwe.p.corr < 0.05] # Number of outlier loci
length(hwe.sig) / length(hwe.p.corr) # Proportion of outliers

##### FDR evaluation of linkage disequilibrium results imported from Genepop #####
qval <- qvalue(ld$P.Value)$qvalues
ld$qval <- qval
alpha <- 0.05
outliers <- filter(ld, qval < alpha)
nrow(outliers) # Number of outlier loci
nrow(outliers) / nrow(ld) # Proportion of outliers
