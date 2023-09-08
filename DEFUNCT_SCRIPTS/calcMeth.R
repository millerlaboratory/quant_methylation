library(dplyr)
library(readr)


#This script outputs a mean % methylated per CpG Island for one specified chromosome (for now). The chromosome can be specified in the bedMethyl intersect file. This script can also be run
# on its own with the correct inputs



args = commandArgs(TRUE)

arg1 <- args[1] #working dir
arg2 <- args[2] #chromosome
arg3 <- args[3] #gene file

setwd(arg1)

mod_bam_header <- c("chr", "start", "stop", "mod", "score", "strand", "coverage", "per_mod", "Ncanon", "Nmod", "Nfilt", "cpg", "sample", "Haplotype")
cpgIslands.gene <- read.delim(arg3)

bedfile <- paste0(arg2, ".bed")

bed <- read_delim(bedfile)

names(bed) <- mod_bam_header

coord_resolved <- bed %>%
  dplyr::mutate("new_start" = ifelse(strand == "+", start, start-1)) %>%
  dplyr::mutate("new_stop" = ifelse(strand == "+", stop, stop-1)) %>%
  dplyr::group_by(chr, new_start, new_stop, mod, score, strand, coverage, per_mod, Ncanon, Nmod, Nfilt, cpg, Haplotype, sample) %>%
  reframe()

sites_resolved <- coord_resolved %>%
  dplyr::group_by(chr, new_start, new_stop, cpg, sample, Haplotype) %>%
  dplyr::summarise(coverage = sum(coverage), Ncanon = sum(Ncanon), Nmod = sum(Nmod), Nfilt = sum(Nfilt)) %>%
  dplyr::mutate("per_mod" = (Nmod/(Nmod+Ncanon))*100)

perIsland <- sites_resolved %>%
  dplyr::group_by(chr,cpg,Haplotype,sample) %>%
  dplyr::summarise(start = first(new_start),stop =last(new_stop),mean_per_mod=mean(per_mod, na.rm =TRUE),stderr=plotrix::std.error(per_mod), mean_coverage = mean(coverage))


perIsland <- dplyr::left_join(perIsland, cpgIslands.gene)

outfile <- paste0(arg2, "perIsland.tsv")

write_tsv(perIsland, outfile)






