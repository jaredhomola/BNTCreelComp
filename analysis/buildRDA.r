############################################
### Creating the .rda file from raw data ###
############################################

getwd()

### Create genind file with populations specified ###
library(adegenet)
library(tidyverse)
allGeno.dat <- import2genind("./extData/msat_gt_genepop.gen", ncode=3)

pop <- c(rep("WR_MI",50),rep("SE_MI",50),rep("Sturgeon",50),rep("Gilchrist",50),
         rep("SE_WI",50),rep("WR_WI",50),rep("Creel_Frankfort",43),rep("Creel_Ludington",32),
         rep("Creel_Manistee",44),rep("Creel_Onekama",3))

allGeno.dat@pop <- as.factor(pop)
hatcheryGeno.dat <- allGeno.dat[pop=c("WR_MI", "SE_MI", "Sturgeon", "Gilchrist", "SE_WI", "WR_WI")]
creelGeno.dat <- allGeno.dat[pop=c("Creel_Frankfort", "Creel_Ludington", "Creel_Manistee", "Creel_Onekama")]


### Read in stocking records and rbind into one data tibble ###
bnt2009 <- as_tibble(read.csv("./extData/stockingRecords/2009.csv"))
bnt2010 <- as_tibble(read.csv("./extData/stockingRecords/2010.csv"))
bnt2011 <- as_tibble(read.csv("./extData/stockingRecords/2011.csv"))
bnt2012 <- as_tibble(read.csv("./extData/stockingRecords/2012.csv"))
bnt2013 <- as_tibble(read.csv("./extData/stockingRecords/2013.csv"))

stocking.tib <- rbind(bnt2009, bnt2010, bnt2011, bnt2012, bnt2013)


### Read in linkage disequilibrium results from GenePop ###
ld <- read.delim("./extData/LD.csv", sep = "", header = TRUE)

### Read in RUBIAS input files ###
rubiasReference <- read.csv("./extData/rubiasReference.csv")
rubiasMixture <- read.csv("./extData/rubiasMixture.csv")

### Save as a .rda file ###
save(creelGeno.dat, hatcheryGeno.dat, allGeno.dat, stocking.tib, ld, rubiasReference, rubiasMixture, file = "./data/BNTCreelComp.rda")
