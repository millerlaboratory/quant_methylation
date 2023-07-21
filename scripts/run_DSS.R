#Run DSS on each haplotype for each X chromosome

suppressPackageStartupMessages(library("DSS"))
require(bsseq)
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("readr"))


args = commandArgs(TRUE)

arg1 <- args[1]
arg2 <- args[2]

setwd(arg1)

file_list <- list.files(full.names = TRUE)

data_tables <- list()

# Loop through each file and read the data into separate data tables
for (file in file_list) {
  # Read the data from the file and store it in a data table
  data <- read.table(file)  # Replace read.csv with the appropriate function for your file format
  # Store the data table in the list using the file name as the list name
  data_tables[[basename(file)]] <- data
}

name <- substr(file_list[[1]], 3,9)

H1 <- data_tables[[1]]
H2 <- data_tables[[2]]

header <- c("chr", "pos", "N", "X")

names(H1) <- header
names(H2) <- header

BSobj <- makeBSseqData( list(H1, H2),
                        c("H1","H2") )

dmlTest <- DMLtest(BSobj, group1 = c("H1"), group2 = c("H2"), equal.disp = TRUE, smoothing=TRUE)

dmrs <- callDMR(dmlTest, delta=0.5, p.threshold = 0.01, dis.merge=100) %>%
  dplyr::mutate(sample = name)

#out_dml <- paste0(name,"_DMLtest.tsv")

#write_tsv(dmlTest, out_dml)

setwd(arg2)

out_dmr <- paste0(name, "_DMR.tsv")

write_tsv(dmrs, out_dmr)

