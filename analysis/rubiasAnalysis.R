#########################################################
#####          Perform RUBIAS GSI analysis          #####
#########################################################

##### Load packages #####
library(tidyverse)
library(rubias)
library(BNTHarvestComposition)
data(BNTHarvestComposition)

#### Import data sets ####
reference.tib <- as_tibble(rubiasReference) %>%
  mutate(repunit = as.character(repunit),
         collection = as.character(collection),
         indiv = as.character(indiv))

mixture.tib <- as_tibble(rubiasMixture)  %>%
  mutate(repunit = as.character(repunit),
         collection = as.character(collection),
         indiv = as.character(indiv))

#### Perform mixture analysis ####
mix_est <- infer_mixture(reference = reference.tib,
                         mixture = mixture.tib,
                         reps = 20000, burn_in = 1000,
                         gen_start_col = 5)

#### Aggregate collections into reporting units ####
rep_mix_ests <- mix_est$mixing_proportions %>%
  group_by(mixture_collection, repunit) %>%
  summarise(repprop = sum(pi))

#### Calculate confidence intervals
CIs <- mix_est$mix_prop_traces %>%
  filter(mixture_collection == "ALL", sweep > 1000) %>%
  group_by(sweep, repunit) %>%
  summarise(repprop = sum(pi)) %>%
  group_by(repunit) %>%
  summarise(loCI = quantile(repprop, probs = 0.025),
            hiCI = quantile(repprop, probs = 0.975))
