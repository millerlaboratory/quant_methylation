library(readr)
library(dplyr)


args = commandArgs(TRUE)

arg1 <- args[1]
arg2 <- args[2]

setwd(arg1)

# Get the list of file names in the directory
file_names <- list.files(pattern = "\\.tsv$", full.names = TRUE)

# Loop over the file names and read each file
all_data <- list()  # Create a list to store the data from each file
for (file_name in file_names) {
  file_data <- read.delim(file_name)
  all_data <- c(all_data, list(file_data)) 
}

combined_data <- do.call(rbind,all_data)

combined_data <- data.frame(combined_data)

setwd(arg2)

write_tsv(combined_data, "1000g_DSS_DMR.tsv")
