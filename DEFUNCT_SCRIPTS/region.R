library(dplyr)
library(readr)

#combine chrX data for a specific region for anyalysis

args = commandArgs(TRUE)

arg1 <- args[1]
arg2 <- args[2]

setwd(arg1)

wd <- arg1

subdir <- list.dirs(wd, recursive = FALSE)

file_name <- "merged_chrX.bed"

data_frames <- list()

for (s in subdir) {
  file_path <- file.path(s, file_name)
  
  data <- read.table(file_path, header=FALSE, quote="\"", comment.char="")
  
  data_frames <- c(data_frames, list(data)) 
  
  
}

combined_data <- do.call(rbind, data_frames)


header <- c("chr", "start", "stop", "mod", "score", "strand", "start2", "stop2", "color", "Nvalid_cov", "per_mod", "Nmod", "Ncannon", "Nother_mod", "Ndelete", "Nfail", "Ndiff", "Nnocall", "sample", "Haplotype")


names(combined_data) <- header


region <- combined_data %>%
  dplyr::select("chr", "start", "stop", "per_mod", "sample", "Haplotype") %>%
  dplyr::mutate(Haplotype=ifelse(Haplotype == 1, "hp1", "hp2")) %>%
  dplyr::filter(start > 53314147)%>%
  dplyr::filter(stop < 53423209)

setwd(arg2)

write_tsv(region, "chrX_region.bed")







