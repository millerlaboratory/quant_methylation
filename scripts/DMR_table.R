library(readr)
library(dplyr)


args = commandArgs(TRUE)

arg1 <- args[1]
arg2 <- args[2]

setwd(arg1)

bed <- read_delim(arg2)


DMR_header <- c("chr", "start", "stop", "mod", "score", "strand", "Nvalid_cov", 
                    "per_mod", "Nmod", "Ncanon", "Nother_mod", "Ndelete", "Nfail", 
                    "Ndiff", "Nnocall", "DMR", "sample","Haplotype")

names(bed) <- DMR_header

bed <- bed %>%
  dplyr::mutate(Haplotype=ifelse(Haplotype == 1, "hp1", "hp2"))

write_tsv(bed, "DMR_table.tsv")