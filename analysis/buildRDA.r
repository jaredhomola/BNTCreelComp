############################################
### Creating the .rda file from raw data ###
############################################

getwd()

### Create genind file with populations specified
library(adegenet)
all.dat <- import2genind("./extData/msat_gt_genepop.gen", ncode=3)

pop <- c(rep("WR_MI",50),rep("SE_MI",51),rep("Sturgeon",50),rep("Gilchrist",50),
         rep("SE_WI",50),rep("WR_WI",50),rep("Creel_Frankfort",43),rep("Creel_Ludington",32),
         rep("Creel_Manistee",44),rep("Creel_Onekama",3))

all.dat@pop <- as.factor(pop)
hatchery.dat <- all.dat[pop=c("WR_MI", "SE_MI", "Sturgeon", "Gilchrist", "SE_WI", "WR_WI")]
creel.dat <- all.dat[pop=c("Creel_Frankfort", "Creel_Ludington", "Creel_Manistee", "Creel_Onekama")]


### Read in stocking records and rbind into one data tibble
bnt2009 <- as.tibble(read.csv("./extData/stockingRecords/2009.csv"))
bnt2010 <- as.tibble(read.csv("./extData/stockingRecords/2010.csv"))
bnt2011 <- as.tibble(read.csv("./extData/stockingRecords/2011.csv"))
bnt2012 <- as.tibble(read.csv("./extData/stockingRecords/2012.csv"))
bnt2013 <- as.tibble(read.csv("./extData/stockingRecords/2013.csv"))

stocking.tib <- rbind(bnt2009, bnt2010, bnt2011, bnt2012, bnt2013)

### Read in linkage disequilibrium results from GenePop
ld <- read.delim("./extData/LD.csv", sep = "", header = TRUE)


### Read in distance to Great Lake matrix
#distToGL <- read.delim("./extData/distToGL.txt", sep="\t", header = FALSE)

### Save as a .rda file
#save(dat.usats, latLongs, ld, distToGL, file = "./data/glHerring.rda")
