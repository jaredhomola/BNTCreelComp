#########################################################
#####         Install packages required for         #####
#####             BNTCreelComp analyses             #####
#########################################################

list.of.packages <- c("PopGenReport", "tidyverse", "rubias",
                      "adegenet", "mmod", "hierfstat")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) install.packages(new.packages)

#### Install qvalue from BioConductor
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("qvalue", version = "3.8")
